--[[
	Copyright © 2023, Tylas
	All rights reserved.

	Redistribution and use in source and binary forms, with or without
	modification, are permitted provided that the following conditions are met:

		* Redistributions of source code must retain the above copyright
		  notice, this list of conditions and the following disclaimer.
		* Redistributions in binary form must reproduce the above copyright
		  notice, this list of conditions and the following disclaimer in the
		  documentation and/or other materials provided with the distribution.
		* Neither the name of XivParty nor the
		  names of its contributors may be used to endorse or promote products
		  derived from this software without specific prior written permission.

	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
	ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
	DISCLAIMED. IN NO EVENT SHALL <your name> BE LIABLE FOR ANY
	DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
	ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
]]

addon.name = 'XIVParty'
addon.author = 'Tirem, Tylas (Original Creator)'
addon.version = '2.1.1'

-- windower library imports
gStatusLib = require('status.status');
require('common')
local socket = require('socket')

-- imports
local const = require('const')
local utils = require('utils')
local uiView = require('uiView')
local model = require('model').new()
settingsLib = require('settings')

-- local and global variables
local isInitialized = false
local isZoning = false
local lastFrameTimeMsec = 0

local view = nil

local setupModel = nil
local isSetupEnabled = false

math.randomseed(os.time())

-- debugging

RefCountImage = 0
RefCountText = 0

-- initialization / events
local function setSetupEnabled(enabled)
	if (not isInitialized) then return end;
	isSetupEnabled = enabled

	if not setupModel then
		setupModel = model.new()
		setupModel:createSetupData()
	end

	view:setModel(isSetupEnabled and setupModel or model) -- lua style ternary operator

	view:setUiLocked(not isSetupEnabled)

end

local function init()
	if not isInitialized then
		view = uiView.new(model) -- depends on settings, always create view after loading settings
		isInitialized = true
	end
end

local function dispose()
	if isInitialized then
		if view then
			view:dispose()
		end
		view = nil
		isInitialized = false
	end
end

local default_settings = require('defaults');
Settings = settingsLib.load(default_settings);

local resX = AshitaCore:GetConfigurationManager():GetFloat('boot', 'ffxi.registry', '0001', 1024)
local resY = AshitaCore:GetConfigurationManager():GetFloat('boot', 'ffxi.registry', '0002', 768)

function getPartySettings(partyIndex)
	if partyIndex == 0 then return Settings.party end
	if partyIndex == 1 then return Settings.alliance1 end
	if partyIndex == 2 then return Settings.alliance2 end
end

function partyIndexToName(partyIndex)
	if partyIndex == 0 then return 'main party' end
	if partyIndex == 1 then return 'alliance 1' end
	if partyIndex == 2 then return 'alliance 2' end
end

-- gets the UI position in screen coordinates
-- @param partyIndex 0 = main party, 1 = alliance1, 2 = alliance2
function getUiPosition(partyIndex)
	local partySettings = getPartySettings(partyIndex)

	local pos = utils:coord(partySettings.pos)
	return { x = utils:round(pos.x * resX), y = utils:round(pos.y * resY) }
end

-- sets the UI position and stores them as relative coordinates
-- @param posX horizontal position in screen coordinates
-- @param posY vertical position in screen coordinates
-- @param partyIndex 0 = main party, 1 = alliance1, 2 = alliance2
function setUiPosition(posX, posY, partyIndex)
	local partySettings = getPartySettings(partyIndex)

	partySettings.pos = T{ posX / resX, posY / resY }
end

-- gets the UI scale
-- @param partyIndex 0 = main party, 1 = alliance1, 2 = alliance2
function getUiScale(partyIndex)
	local partySettings = getPartySettings(partyIndex)

	return utils:coord(partySettings.scale)
end

-- sets the UI scale
-- @param scaleX horizontal scale
-- @param scaleY vertical scale
-- @param partyIndex 0 = main party, 1 = alliance1, 2 = alliance2
function setUiScale(scaleX, scaleY, partyIndex)
	local partySettings = getPartySettings(partyIndex)

	partySettings.scale = T{ scaleX, scaleY }
end


settingsLib.register('settings', 'settings_update', function (s)
    if (s ~= nil) then
        Settings = s;
		dispose();
		init();
    end
	settingsLib.Save();
end);



--[[
windower.register_event('load', function()
	-- settings must only be loaded when logged in, as they are separate for every character
	if windower.ffxi.get_info().logged_in then
		init()
	end
end)

windower.register_event('login', function()
	init()
end)

windower.register_event('logout', function()
	dispose()
end)

windower.register_event('status change', function(status)
	if isInitialized then
		view:visible(not Settings.hideCutscene or status ~= 4, const.visCutscene) -- hide UI during cutscenes
	end
end)
]]--

local function isSolo()
	local party = AshitaCore:GetMemoryManager():GetParty();
	if (party == nil) then
		return true
	else
		return not party:GetMemberIsActive(1);
	end
end

local function CheckState()
	if (gStatusLib.helpers.bLoggedIn) then
		init();
	else
		dispose();
	end
end

-- per frame updating
ashita.events.register('d3d_present', 'present_cb', function ()
	CheckState();

	if isZoning or not isInitialized then return end

	local timeMsec = socket.gettime() * 1000
	if timeMsec - lastFrameTimeMsec < Settings.updateIntervalMsec then return end
	lastFrameTimeMsec = timeMsec

--	Settings:update()
	model:updatePlayers()

	view:visible(isSetupEnabled or not Settings.hideSolo or not isSolo(), const.visSolo)
	view:update()
end)

ashita.events.register('command', 'command_cb', function (e)
	-- Parse the command arguments
	local command_args = e.command:lower():args()
    if table.contains({'/xivparty'}, command_args[1]) then
		-- Toggle the config menu
		setSetupEnabled(not isSetupEnabled);
		e.blocked = true;
	end
end);

-- packets
--[[
windower.register_event('incoming chunk',function(id,original,modified,injected,blocked)
	if id == 0xC8 then -- alliance update
		local packet = packets.parse('incoming', original)
		if packet then
			for i = 1, 18 do
				local playerId = packet['ID ' .. tostring(i)]
				local flags = packet['Flags ' .. tostring(i)]
				if flags and playerId and playerId > 0 then
					local foundPlayer = model:getPlayer(nil, playerId, 'alliance')
					foundPlayer:updateLeaderFromFlags(flags)
				end
			end
		end
	end

	if id == 0xDF then -- char update
		local packet = packets.parse('incoming', original)
		if packet then
			local playerId = packet['ID']
			if playerId and playerId > 0 then
				utils:print('PACKET: Char update for player ID: '..playerId, 0)

				local foundPlayer = model:getPlayer(nil, playerId, 'char')
				foundPlayer:updateJobFromPacket(packet)
			else
				utils:print('Char update: ID not found.', 1)
			end
		end
	end

	if id == 0xDD then -- party member update
		local packet = packets.parse('incoming', original)
		if packet then
			local name = packet['Name']
			local playerId = packet['ID']
			if name and playerId and playerId > 0 then
				utils:print('PACKET: Party member update for '..name, 0)

				local foundPlayer = model:getPlayer(name, playerId, 'party')
				foundPlayer:updateJobFromPacket(packet)
			else
				utils:print('Party update: name and/or ID not found.', 1)
			end
		end
	end

	if id == 0x076 then -- party buffs (Credit: Kenshi, PartyBuffs)
		for k = 0, 4 do
			local playerId = original:unpack('I', k*48+5)

			if playerId ~= 0 then -- NOTE: main player buffs are not available here
				local buffsList = {}

				for i = 1, const.maxBuffs do -- starting at 1 to match the offset in windower.ffxi.get_player().buffs
					local buff = original:byte(k*48+5+16+i-1) + 256*( math.floor( original:byte(k*48+5+8+ math.floor((i-1)/4)) / 4^((i-1)%4) )%4) -- Credit: Byrth, GearSwap

					if buff == 255 then -- empty buff
						buff = nil
					end
					buffsList[i] = buff
				end

				local foundPlayer = model:getPlayer(nil, playerId, 'buffs')
				foundPlayer:updateBuffs(buffsList)
				utils:print('Updated buffs for player with ID ' .. tostring(playerId), 1)
			end
		end
	end

	if id == 0xB then -- zoning, also happens on log out
		utils:print('Zoning...')
		isZoning = true
		model:clear() -- clear model only when zoning, this allows reloading the UI (for layout changes, etc) without losing party data
		if isInitialized then
			view:hide(const.visZoning)
		end
	elseif id == 0xA and isZoning then -- also happens on login
		utils:print('Zoning done.')
		isZoning = false
		coroutine.schedule(function()
			if isInitialized then
				view:show(const.visZoning)
			end
		end, 3) -- delay showing UI for 3 sec to hide pre-zoning party lists
	end
end)

-- commands / help

local function showHelp()
	print('Commands: //xivparty or //xp')
	print('filter - hides specified buffs in party list. Use command \"buffs\" to find out IDs.')
	print('   add <ID> - adds filter for a buff (e.g. //xp filter add 123)')
	print('   remove <ID> - removes filter for a buff')
	print('   clear - removes all filters')
	print('   list - shows list of currently set filters')
	print('   mode - switches between blacklist and whitelist mode (both use same filter list)')
	print('buffs <name> - shows list of currently active buffs and their IDs for a party member')
	print('range - display party member distances as icons or numeric values')
	print('   <near> <far> - shows a marker for each party member closer than the set distances (off or 0 to disable)')
	print('   num - numeric display mode, disables near/far markers.')
	print('customOrder - toggles custom buff order (customize in bufforder.lua)')
	print('hideSolo - hides the UI while solo')
	print('hideAlliance - hides alliance party lists')
	print('hideCutscene - hides the UI during cutscenes')
	print('mouseTargeting - toggles targeting party members using the mouse')
	print('swapSingleAlliance - shows single alliance in the 2nd alliance list')
	print('alignBottom - expands the party list from bottom to top')
	print('showEmptyRows - show empty rows in partially filled parties')
	print('job - toggles job specific settings for current job')
	print('setup - move the UI using drag and drop, hold CTRL for grid snap, mouse wheel to scale the UI')
	print('layout <file> - loads a UI layout file')
end

local function handleCommand(currentValue, argsString, text, option1String, option1Value, option2String, option2Value, isNowText)
	local setValue
	if not isNowText then
		isNowText = 'is now'
	end

	if argsString and string.lower(argsString) == option1String then
		setValue = option1Value
	elseif argsString and string.lower(argsString) == option2String then
		setValue = option2Value
	elseif not argsString or argsString == '' then
		if currentValue == option1Value then
			setValue = option2Value
		else
			setValue = option1Value
		end
	else
		error('Unknown parameter \'' .. argsString .. '\'.')
		return currentValue
	end

	local setString = option1String
	if setValue == option2Value then
		setString = option2String
	end
	print(text .. ' ' .. isNowText .. ' ' .. setString .. '.')

	return setValue
end

local function handleCommandOnOff(currentValue, argsString, text, plural)
	local isNowText = nil
	if plural then
		isNowText = 'are now'
	end
	return handleCommand(currentValue, argsString, text, 'on', true, 'off', false, isNowText)
end

local function handlePartySettingsOnOff(settingsName, argsString1, argsString2, text)
	local partyIndex = tonumber(argsString1)
	if partyIndex ~= nil then
		if partyIndex < 0 or partyIndex > 2 then
			error('Invalid party index \'' .. argsString1 .. '\'. Valid values are 0 (main party), 1 (alliance 1), 2 (alliance 2).')
		else
			local partySettings = Settings:getPartySettings(partyIndex)
			local ret = handleCommandOnOff(partySettings[settingsName], argsString2, text .. ' (' .. Settings:partyIndexToName(partyIndex) .. ')')
			partySettings[settingsName] = ret
			Settings:save()
		end
	else
		local ret = handleCommandOnOff(Settings.party[settingsName], argsString1, text)
		for i = 0, 2 do
			Settings:getPartySettings(i)[settingsName] = ret
		end
		Settings:save()
	end
end

local function checkBuff(buffId)
	if buffId and res.buffs[buffId] then
		return true
	elseif not buffId then
		error('Invalid buff ID.')
	else
		error('Buff with ID ' .. buffId .. ' not found.')
	end

	return false
end

local function getBuffText(buffId)
	local buffData = res.buffs[buffId]
	if buffData then
		return buffData.en .. ' (' .. buffData.id .. ')'
	else
		return tostring(buffId)
	end
end

local function getRange(arg)
	if not arg then return nil end

	local range = string.lower(arg)
	if range == 'off' then
		range = 0
	else
		range = tonumber(range)
	end

	if not range then
		error('Invalid range \'' .. arg .. '\'.')
	end

	return range
end

--[[ TODO: Turn into config window
windower.register_event('addon command', function(...)
	local args = T{...}
	local command
	if args[1] then
		command = string.lower(args[1])
	end

	if command == 'setup' then
		local ret = handleCommandOnOff(isSetupEnabled, args[2], 'Setup mode')
		setSetupEnabled(ret)
	elseif command == 'hidesolo' then
		local ret = handleCommandOnOff(Settings.hideSolo, args[2], 'Party list hiding while solo')
		Settings.hideSolo = ret
		Settings:save()
	elseif command == 'hidealliance' then
		local ret = handleCommandOnOff(Settings.hideAlliance, args[2], 'Alliance list hiding')
		Settings.hideAlliance = ret
		Settings:save()
		view:reload()
	elseif command == 'hidecutscene' then
		local ret = handleCommandOnOff(Settings.hideCutscene, args[2], 'Party list hiding during cutscenes')
		Settings.hideCutscene = ret
		Settings:save()
	elseif command == 'mousetargeting' then
		local ret = handleCommandOnOff(Settings.mouseTargeting, args[2], 'Targeting party members using the mouse')
		Settings.mouseTargeting = ret
		Settings:save()
	elseif command == 'swapsinglealliance' then
		local ret = handleCommandOnOff(Settings.swapSingleAlliance, args[2], 'Swapping UI for single alliance')
		Settings.swapSingleAlliance = ret
		Settings:save()
	elseif command == 'alignbottom' then
		handlePartySettingsOnOff("alignBottom", args[2], args[3], 'Bottom alignment')
	elseif command == 'showemptyrows' then
		handlePartySettingsOnOff("showEmptyRows", args[2], args[3], 'Display of empty rows')
	elseif command == 'customorder' then
		local ret = handleCommandOnOff(Settings.buffs.customOrder, args[2], 'Custom buff order')
		Settings.buffs.customOrder = ret
		Settings:save()
		if setupModel then setupModel:refreshFilteredBuffs() end
		model:refreshFilteredBuffs()
	elseif command == 'range' then
		if args[2] then
			if args[2] == 'num' or args[2] == 'numeric' then
				Settings.rangeNumeric = true
				Settings.rangeIndicator = 0
				Settings.rangeIndicatorFar = 0
				Settings:save()
				print('Range numeric display mode enabled.')
			else
				local range1 = getRange(args[2])
				local range2 = getRange(args[3])
				if range1 then
					Settings.rangeNumeric = false
					Settings.rangeIndicator = range1
					if range2 then
						Settings.rangeIndicatorFar = range2
						if Settings.rangeIndicator > Settings.rangeIndicatorFar then -- fix when swapped
							Settings.rangeIndicator = range2
							Settings.rangeIndicatorFar = range1
						end
						print('Range indicators set to near ' .. tostring(Settings.rangeIndicator) .. ', far ' .. tostring(Settings.rangeIndicatorFar) .. '.')
					else
						Settings.rangeIndicatorFar = 0
						if range1 > 0 then
							print('Range indicator set to ' .. tostring(Settings.rangeIndicator) .. '.')
						else
							print('Range indicator disabled.')
						end
					end
					Settings:save()
				end
			end
		else
			showHelp()
		end
	elseif command == 'filter' or command == 'filters' then
		local subCommand = string.lower(args[2])
		if subCommand == 'add' then
			local buffId = tonumber(args[3])
			if checkBuff(buffId) then
				Settings.buffFilters[buffId] = true
				Settings:save()
				if setupModel then setupModel:refreshFilteredBuffs() end
				model:refreshFilteredBuffs()
				print('Added buff filter for ' .. getBuffText(buffId))
			end
		elseif subCommand == 'remove' then
			local buffId = tonumber(args[3])
			if checkBuff(buffId) then
				Settings.buffFilters[buffId] = nil
				Settings:save()
				if setupModel then setupModel:refreshFilteredBuffs() end
				model:refreshFilteredBuffs()
				print('Removed buff filter for ' .. getBuffText(buffId))
			end
		elseif subCommand == 'clear' then
			Settings.buffFilters = T{}
			Settings:save()
			if setupModel then setupModel:refreshFilteredBuffs() end
			model:refreshFilteredBuffs()
			print('All buff filters cleared.')
		elseif subCommand == 'list' then
			print('Currently active buff filters (' .. Settings.buffs.filterMode .. '):')
			for buffId, doFilter in pairs(Settings.buffFilters) do
				if doFilter then
					print(getBuffText(buffId))
				end
			end
		elseif subCommand == 'mode' then
			local ret = handleCommand(Settings.buffs.filterMode, args[3], 'Filter mode', 'blacklist', 'blacklist', 'whitelist', 'whitelist')
			Settings.buffs.filterMode = ret
			Settings:save()
			if setupModel then setupModel:refreshFilteredBuffs() end
			model:refreshFilteredBuffs()
		else
			showHelp()
		end
	elseif command == 'buffs' then
		local playerName = args[2]
		local buffs
		if playerName then
			playerName = playerName:ucfirst()
			local foundPlayer = model:findPlayer(playerName)
			if foundPlayer then
				buffs = foundPlayer.buffs
				print(playerName .. '\'s active buffs:')
			else
				error('Player ' .. playerName .. ' not found.')
				return
			end
		else
			buffs = windower.ffxi.get_player().buffs
			print('Your active buffs:')
		end
		for i = 1, const.maxBuffs do
			if buffs[i] then
				print(getBuffText(buffs[i]))
			end
		end
	elseif command == 'layout' then
		if args[2] then
			if args[2]:endswith(const.xmlExtension) then
				args[2] = args[2]:slice(1, #args[2] - #const.xmlExtension) -- trim the file extension
			end

			local filename = const.layoutDir .. args[2] .. const.xmlExtension

			if windower.file_exists(windower.addon_path .. filename) then
				print('Loading layout \'' .. args[2] .. '\'.')

				Settings.layout = args[2]
				Settings:save()

				view:reload()
			else
				error('The layout file \'' .. filename .. '\' does not exist!')
			end
		else
			showHelp()
		end
	elseif command == 'job' then
		local job = windower.ffxi.get_player().main_job
		local ret = handleCommandOnOff(Settings.jobEnabled, args[2], 'Job specific settings for ' .. job, true)

		if ret then
			if not Settings.jobEnabled then
				Settings:load(true, true)
				print('Settings changes to range and buffs will now only affect this job.')
			end
		elseif Settings.jobEnabled then
			Settings.jobEnabled = false
			Settings:save()
			Settings:load()
			print('Global settings applied. The job specific settings for ' .. job .. ' will remain saved for later use.')
		end
	elseif command == 'debug' then
		local subCommand = string.lower(args[2])
		if subCommand == 'savelayout' then
			view:debugSaveLayout()
		elseif subCommand == 'refcount' then
			print('Images: ' .. RefCountImage .. ', Texts: ' .. RefCountText)
		elseif subCommand == 'setbar' and args[3] ~= nil and setupModel then -- example: //xp debug setbar hpp 50 0 2
			setupModel:debugSetBarValue(args[3], tonumber(args[4]), tonumber(args[5]), tonumber(args[6]))
		elseif subCommand == 'addplayer' and setupModel then
			setupModel:debugAddSetupPlayer(tonumber(args[3]))
		elseif subCommand == 'testbuffs' then
			setupModel:debugTestBuffs()
			setupModel:refreshFilteredBuffs()
		end
	else
		showHelp()
	end
end)

-- @param key DirectInput keyboard (DIK) code as integer. see: https://community.bistudio.com/wiki/DIK_KeyCodes
-- @param down true when the key is pressed, false when it is released
-- @returns true to mark the keyboard event handled (will not be passed on to the game)
windower.register_event('keyboard', function(key, down)
	if Settings and Settings.hideKeyCode > 0 and key == Settings.hideKeyCode then
		view:visible(not down, const.visKeyboard)
	end
end)
]]--