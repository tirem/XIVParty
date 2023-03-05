local settings = {
        partyList = {
            columnWidth = 410,
            columns = 1,
            rowHeight = 46,
            rows = 6,
            background = {
                enabled = true,
                imgBottom = {
                    color = '#FFFFFFDD',
                    enabled = true,
                    path = 'assets/ffxi/BgBottom.png',
                    pos = {0,0},
                    size = {420,8},
                },
                imgMid = {
                    color = '#FFFFFFDD',
                    enabled = true,
                    path = 'assets/ffxi/BgMid.png',
                    pos = {0,10},
                    size = {420,4},
                },
                imgTop = {
                    color = '#FFFFFFDD',
                    enabled = true,
                    path = 'assets/ffxi/BgTop.png',
                    pos = {0,0},
                    size = {420,10},
                },
                pos = {7,-11},
            },
            listItem = {
                enabled = true,
                hp = {
                    bar = {
                        animSpeed = 0.1,
                        enabled = true,
                        imgBar = {
                            color = '#FF9597FF',
                            enabled = true,
                            path = 'assets/ffxi/Bar.png',
                            pos = {13,0},
                            size = {102,64},
                        },
                        imgBg = {
                            color = '#FF9597FF',
                            enabled = true,
                            path = 'assets/ffxi/BarBg.png',
                            pos = {0,0},
                            size = {128,64},
                        },
                        imgFg = {
                            color = '#FF9597FF',
                            enabled = true,
                            path = 'assets/ffxi/BarFg.png',
                            pos = {0,0},
                            size = {128,64},
                        },
                        imgGlow = {
                            color = '#FFF2F2FF',
                            enabled = true,
                            path = 'assets/ffxi/BarGlow.png',
                            pos = {13,0},
                            size = {6,64},
                        },
                        imgGlowSides = {
                            color = '#FFF2F2FF',
                            enabled = true,
                            path = 'assets/ffxi/BarGlowSides.png',
                            pos = {11,0},
                            size = {2,64},
                        },
                        pos = {0,0},
                    },
                    enabled = true,
                    hpOrangeColor = '#F8BA80FF',
                    hpRedColor = '#FC8182FF',
                    hpYellowColor = '#F3F37CFF',
                    pos = {19,-7},
                    snapToRaster = true,
                    txtValue = {
                        alignRight = true,
                        color = '#F0FFFFFF',
                        enabled = true,
                        font = 'Grammara',
                        pos = {120,35},
                        size = 11,
                        snapToRaster = true,
                        stroke = '#062D54C8',
                        strokeWidth = 2,
                    },
                    zOrder = 1,
                },
                mp = {
                    bar = {
                        animSpeed = 0.1,
                        enabled = true,
                        imgBar = {
                            color = '#FFFF9CFF',
                            enabled = true,
                            path = 'assets/ffxi/Bar.png',
                            pos = {13,0},
                            size = {102,64},
                        },
                        imgBg = {
                            color = '#FFFF9CFF',
                            enabled = true,
                            path = 'assets/ffxi/BarBg.png',
                            pos = {0,0},
                            size = {128,64},
                        },
                        imgFg = {
                            color = '#FFFF9CFF',
                            enabled = true,
                            path = 'assets/ffxi/BarFg.png',
                            pos = {0,0},
                            size = {128,64},
                        },
                        imgGlow = {
                            color = '#FFFFF2FF',
                            enabled = true,
                            path = 'assets/ffxi/BarGlow.png',
                            pos = {13,0},
                            size = {6,64},
                        },
                        imgGlowSides = {
                            color = '#FFFFF2FF',
                            enabled = true,
                            path = 'assets/ffxi/BarGlowSides.png',
                            pos = {11,0},
                            size = {2,64},
                        },
                        pos = {0,0},
                    },
                    enabled = true,
                    pos = {150,-7},
                    snapToRaster = true,
                    txtValue = {
                        alignRight = true,
                        color = '#F0FFFFFF',
                        enabled = true,
                        font = 'Grammara',
                        pos = {120,35},
                        size = 11,
                        snapToRaster = true,
                        stroke = '#062D54C8',
                        strokeWidth = 2,
                    },
                    zOrder = 2,
                },
                tp = {
                    bar = {
                        animSpeed = 0.1,
                        enabled = true,
                        imgBar = {
                            color = '#8EB4F9FF',
                            enabled = true,
                            path = 'assets/ffxi/Bar.png',
                            pos = {13,0},
                            size = {102,64},
                        },
                        imgBg = {
                            color = '#8EB4F9FF',
                            enabled = true,
                            path = 'assets/ffxi/BarBg.png',
                            pos = {0,0},
                            size = {128,64},
                        },
                        imgFg = {
                            color = '#8EB4F9FF',
                            enabled = true,
                            path = 'assets/ffxi/BarFg.png',
                            pos = {0,0},
                            size = {128,64},
                        },
                        imgGlow = {
                            color = '#EDF1F9FF',
                            enabled = true,
                            path = 'assets/ffxi/BarGlow.png',
                            pos = {13,0},
                            size = {6,64},
                        },
                        imgGlowSides = {
                            color = '#EDF1F9FF',
                            enabled = true,
                            path = 'assets/ffxi/BarGlowSides.png',
                            pos = {11,0},
                            size = {2,64},
                        },
                        pos = {0,0},
                    },
                    enabled = true,
                    pos = {281,-7},
                    snapToRaster = true,
                    txtValue = {
                        alignRight = true,
                        color = '#F0FFFFFF',
                        enabled = true,
                        font = 'Grammara',
                        pos = {120,35},
                        size = 11,
                        snapToRaster = true,
                        stroke = '#062D54C8',
                        strokeWidth = 2,
                    },
                    tpFullColor = '#50B4FAFF',
                    zOrder = 3,
                },
                jobIcon = {
                    colors = {
                        dd = '#663535FF',
                        healer = '#3B6529FF',
                        special = '#FF9700FF',
                        support = '#DAB200FF',
                        tank = '#364597FF',
                    },
                    enabled = true,
                    imgBg = {
                        color = '#FFFFFFFF',
                        enabled = true,
                        path = 'assets/jobIcons/bg.png',
                        pos = {0,0},
                        size = {36,36},
                    },
                    imgFrame = {
                        color = '#FFFFFFFF',
                        enabled = true,
                        path = 'assets/jobIcons/frame.png',
                        pos = {0,0},
                        size = {36,36},
                    },
                    imgGradient = {
                        color = '#FFFFFFFF',
                        enabled = true,
                        path = 'assets/jobIcons/gradient.png',
                        pos = {0,0},
                        size = {36,36},
                    },
                    imgHighlight = {
                        color = '#FFFFFFFF',
                        enabled = true,
                        path = 'assets/jobIcons/highlight.png',
                        pos = {-13,-13},
                        size = {62,62},
                    },
                    imgIcon = {
                        color = '#FFFFFFFF',
                        enabled = true,
                        pos = {0,0},
                        size = {36,36},
                    },
                    path = 'assets/jobIcons/',
                    pos = {-11,-2},
                    scale = {1,1},
                    snapToRaster = true,
                    zOrder = 4,
                },
                leader = {
                    enabled = true,
                    imgAlliance = {
                        color = '#FFFFFFFF',
                        enabled = true,
                        path = 'assets/ffxi/Leader.png',
                        pos = {0,5},
                        size = {7,5},
                    },
                    imgParty = {
                        color = '#E6E159FF',
                        enabled = true,
                        path = 'assets/ffxi/Leader.png',
                        pos = {0,10},
                        size = {7,5},
                    },
                    imgQuarterMaster = {
                        color = '#66E659FF',
                        enabled = true,
                        path = 'assets/ffxi/Leader.png',
                        pos = {0,0},
                        size = {7,5},
                    },
                    pos = {88,5},
                    scale = {1,1},
                    zOrder = 10,
                },
                range = {
                    enabled = true,
                    imgFar = {
                        color = '#FFFFFFFF',
                        enabled = true,
                        path = 'assets/ffxi/RangeFar.png',
                        pos = {0,0},
                        size = {10,10},
                    },
                    imgNear = {
                        color = '#FFFFFFFF',
                        enabled = true,
                        path = 'assets/ffxi/Range.png',
                        pos = {0,0},
                        size = {10,10},
                    },
                    txtDistance = {
                        color = '#F0FFFFFF',
                        enabled = true,
                        font = 'Grammara',
                        pos = {0,0},
                        size = 6,
                        snapToRaster = true,
                        stroke = '#062D54C8',
                        strokeWidth = 1,
                    },
                    pos = {30,30},
                    zOrder = 11,
                },
                hover = {
                    color = '#9C94E8AA',
                    enabled = true,
                    path = 'assets/ffxi/Hover.png',
                    pos = {20,-8},
                    size = {390,60},
                    zOrder = 0,
                },
                cursor = {
                    color = '#FFFFFFFF',
                    enabled = true,
                    path = 'assets/ffxi/Cursor.png',
                    pos = {-38,4},
                    size = {37,24},
                    zOrder = 5,
                },
                buffIcons = {
                    alignRight = false,
                    color = '#FFFFFFFF',
                    enabled = true,
                    numIconsByRow = {19,13},
                    offsetByRow = {0,6},
                    path = 'assets/buffIcons/',
                    pos = {293,0},
                    size = {20,20},
                    spacing = {0,1},
                    zOrder = 12,
                },
                txtName = {
                    color = '#F0FFFFFF',
                    enabled = true,
                    font = 'Arial',
                    pos = {95,1},
                    size = 15,
                    snapToRaster = true,
                    stroke = '#062D54C8',
                    strokeWidth = 2,
                    maxChars = 17,
                    zOrder = 6,
                },
                txtZone = {
                    alignRight = false,
                    color = '#F0FFFFFF',
                    enabled = true,
                    font = 'Arial',
                    pos = {292,1},
                    short = false,
                    size = 13,
                    snapToRaster = true,
                    stroke = '#062D54C8',
                    strokeWidth = 2,
                    zOrder = 7,
                },
                txtJob = {
                    color = '#F0FFFFFF',
                    enabled = true,
                    font = 'Arial',
                    pos = {30,0},
                    size = 8,
                    snapToRaster = true,
                    stroke = '#062D54C8',
                    strokeWidth = 1,
                    zOrder = 8,
                },
                txtSubJob = {
                    color = '#F0FFFFFF',
                    enabled = true,
                    font = 'Arial',
                    pos = {39,9},
                    size = 8,
                    snapToRaster = true,
                    stroke = '#062D54C8',
                    strokeWidth = 1,
                    zOrder = 9,
                },
            },
        },
}

return settings;
