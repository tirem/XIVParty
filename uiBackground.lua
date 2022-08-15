--[[
	Copyright © 2022, Tylas
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

-- imports
local classes = require('classes')
local uiBase = require('uiBase')
local uiImage = require('uiImage')

-- create the class, derive from uiBase
local uiBackground = classes.class(uiBase)

local isDebug = false

function uiBackground:init(bgLayout, partySettings, scale)
	if self.super.init(self, bgLayout) then
		self.bgLayout = bgLayout
		self.partySettings = partySettings
		self.scale = scale

		self.hidden = true
		self.rowCount = 0
		self.contentHeight = 0 -- height of the content area (excludes top and bottom tiles)

		self.size = {}
		self.size.width = 0
		self.size.height = 0

		self.sizeMid = utils:coord(bgLayout.imgMid.size)

		self.top = self:addChild(uiImage.new(bgLayout.imgTop, scale))
		self.mid = self:addChild(uiImage.new(bgLayout.imgMid, scale))
		self.bottom = self:addChild(uiImage.new(bgLayout.imgBottom, scale))

		if isDebug then -- debug background
			self.top:path('')
			self.mid:path('')
			self.bottom:path('')
			
			self.top:color(255,0,0)
			self.mid:color(0,255,0)
			self.bottom:color(0,0,255)
		end
	end
end

-- TODO: consider making itemSpacing a parameter or just let the whole contentHeight be set from outside
function uiBackground:update(rowCount, itemHeight)
	if not self.enabled then return end

	utils:log('BG setting row count: ' .. rowCount, 1)

	self.rowCount = rowCount
	self.contentHeight = (rowCount * itemHeight + (rowCount - 1) * self.partySettings.itemSpacing) / self.scale

	self.mid:size(self.sizeMid.x, self.contentHeight)
	self.mid:repeat_xy(1, math.floor(self.contentHeight / self.sizeMid.y))

	self.bottom:offset(self.bottom.offsetX, self.mid.offsetY + self.mid.scaledHeight)
	
	-- visible size of the whole background area
	self.size.width = math.max(math.max(self.top.scaledWidth, self.bottom.scaledWidth), self.mid.scaledWidth)
	self.size.height = self.top.scaledHeight + self.mid.scaledHeight + self.bottom.scaledHeight

	self:updateVisibility()
end

function uiBackground:updateVisibility()
	if not self.hidden and self.rowCount > 0 then
		self.super.show(self)
	else
		self.super.hide(self)
	end
end

function uiBackground:show()
	if not self.enabled then return end

	self.hidden = false
	self:updateVisibility()
end

function uiBackground:hide()
	if not self.enabled then return end

	self.hidden = true
	self:updateVisibility()
end

return uiBackground