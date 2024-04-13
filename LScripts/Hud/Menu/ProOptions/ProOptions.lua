ProOptions =
{
	bgStartFrame = { 120, 243, 268 },
	bgEndFrame   = { 180, 267, 291 },

	fontBigSize = 26, -- CHG: PrimeviL 
	sliderWidth = 340,
	descColor	= R3D.RGB( 255, 255, 255 ), -- CHG: PrimeviL 

	backAction = "PainMenu:AdjustFov(); PainMenu:ActivateScreen(MainMenu)",
	applyAction = "PainMenu:weaponsicons(); PainMenu:ApplySettings(true); Hud.CrossScale = Cfg.PROD_CrosshairSize; PMENU.SetItemVisibility('ApplyButton',false)",

	items =
	{
		GeneralTab =
		{
			type = MenuItemTypes.TabGroup,
			x = 122,
			y = 70,
			width = 776,
			height = 440,
			visible = true,
			align = MenuAlign.Left,
			
			items =
			{
				showfps =
				{
					type = MenuItemTypes.Checkbox,
					text = "Fps",
					desc = "Show the framerate (frame per second)",
					option = "PROD_ShowFPS",
					valueOn = true,
					valueOff = false,
					x	 = 140,
					y	 = 132,
					action = "",
					align = MenuAlign.None,
					applyRequired = true,
				},
				showping =
				{
					type = MenuItemTypes.Checkbox,
					text = "Ping",
					desc = "Show the ping",
					option = "PROD_ShowPing",
					valueOn = true,
					valueOff = false,
					x	 = 140,
					y	 = 172,
					action = "",
					align = MenuAlign.None,
					applyRequired = true,
				},
				showtimer =
				{
					type = MenuItemTypes.Checkbox,
					text = "Timer",
					desc = "Show the timer",
					option = "ShowTimer",
					valueOn = true,
					valueOff = false,
					x	 = 140,
					y	 = 212,
					action = "",
					align = MenuAlign.None,
					applyRequired = true,
				},
				timercountup =
				{
					type = MenuItemTypes.Checkbox,
					text = "Timer count up",
					desc = "Show the timer with count up",
					option = "ShowTimerCountUp",
					valueOn = true,
					valueOff = false,
					x	 = 140,
					y	 = 252,
					action = "",
					align = MenuAlign.None,
					applyRequired = true,
				},	
				currentweapon =
				{
					type = MenuItemTypes.Checkbox,
					text = "Current weapon",
					desc = "Show a current weapon icon",
					option = "PROD_CurrentWeapon",
					valueOn = true,
					valueOff = false,
					x	 = 140,
					y	 = 292,
					action = "",
					align = MenuAlign.None,
					applyRequired = true,
				},
				simpleicons =
				{
					type = MenuItemTypes.Checkbox,
					text = "Simple pro HUD",
					desc = "Show a simple HUD gfx",
					option = "PROD_SimpleIcons",
					valueOn = true,
					valueOff = false,
					x	 = 140,
					y	 = 332,
					action = "",
					align = MenuAlign.None,
					applyRequired = true,
				},
				coloreditems =
				{
					type = MenuItemTypes.Checkbox,
					text = "Brightskins ammo",
					desc = "Show brightskins for ammopak",
					option = "PROD_Colored_Items",
					valueOn = true,
					valueOff = false,
					x	 = 140,
					y	 = 372,
					action = "PainMenu:ApplySettings(true); PainMenu:coloreditems()",
					align = MenuAlign.None,
					applyRequired = false,
				},
				teammateicon =
				{
					type = MenuItemTypes.Checkbox,
					text = "Teammate's icon",
					desc = "Show a icon above the teammate's head",
					option = "PROD_Teammate_Icon",
					valueOn = true,
					valueOff = false,
					x	 = 140,
					y	 = 412,
					action = "",
					align = MenuAlign.NONE,
					applyRequired = true,
				},
				thinshaft =
				{
					type = MenuItemTypes.Checkbox,
					text = "Thin shaft",
					desc = "Show a Thin shaft fx",
					option = "PROD_ThinShaft",
					valueOn = true,
					valueOff = false,
					x	 = 140,
					y	 = 452,
					action = "",
					align = MenuAlign.None,
					applyRequired = true,
				},
				speedmeter =
				{
					type = MenuItemTypes.TextButtonEx,
					text = "Speedmeter",
					desc = "Show the player's speed in game",
					option = "PROD_ShowSpeedmeter",
					values = { 0, 1, 2 },
					visible = { "None", "Classic", "Bar" },
					x	 = -1,
					y	 = 147,
					action = "",
					align = MenuAlign.Right,
					applyRequired = true,
				},
				HUDSize =
				{
					type = MenuItemTypes.TextButtonEx,
					text = TXT.Menu.HUDSize,
					desc = TXT.MenuDesc.HUDSize,
					option = "PROD_HUDSize",
					values = { 0.8, 1.0 },
					visible = { TXT.Menu.Small, TXT.Menu.Normal },
					x	 = -1,
					y	 = 187,
					action = "",
					align = MenuAlign.Right,
					applyRequired = true,
				},
				timersize =
				{
					type = MenuItemTypes.TextButtonEx,
					text = "Timer size",
					desc = "Set the timer size",
					option = "PROD_HUD_Fontsize_2",
					values = { 0, 1, 2 },
					visible = { "Small", "Normal", "Large" },
					x	 = -1,
					y	 = 227,
					action = "",
					align = MenuAlign.Right,
					applyRequired = true,
				},
				infosposix =
				{
					type = MenuItemTypes.TextButtonEx,
					text = "Infos position",
					desc = "Set the infos position",
					option = "PROD_Infos_Posx",
					values = { 0, 1 },
					visible = { "Right", "Left" },
					x	 = -1,
					y	 = 267,
					action = "",
					align = MenuAlign.Right,
					applyRequired = true,
				},
				fpssize =
				{
					type = MenuItemTypes.TextButtonEx,
					text = "Infos size",
					desc = "Set the infos size (fps/ping/pl/ups)",
					option = "PROD_HUD_Fontsize_1",
					values = { 0, 1 },
					visible = { "Small", "Normal" },
					x	 = -1,
					y	 = 307,
					action = "",
					align = MenuAlign.Right,
					applyRequired = true,
				},
				ammolistposix =
				{
					type = MenuItemTypes.TextButtonEx,
					text = "Ammolist",
					desc = "Set the HUD ammolist",
					option = "PROD_AmmoList_Posix",
					values = { 0, 1, 2 },
					visible = { "None", "Right", "Left" },
					x	 = -1,
					y	 = 347,
					action = "",
					align = MenuAlign.Right,
					applyRequired = true,
				},
				crosshairsize =
				{
					type = MenuItemTypes.TextButtonEx,
					text = "Crosshair size",
					desc = "Set the crosshair size",
					option = "PROD_CrosshairSize",
					values = { 0.5, 1, 1.5 },
					visible = { TXT.Menu.Small, TXT.Menu.Normal, TXT.Menu.Large },
					x	 = -1,
					y	 = 387,
					action = "",
					align = MenuAlign.Right,
					applyRequired = true,
				},
				weaponsicons =
				{
					type = MenuItemTypes.TextButtonEx,
					text = "Weapons icons",
					desc = "Set the icon above the weapons",
					option = "PROD_Weapons_Icons",
					values = { 0, 1, 2 },
					visible = { "None", "Classic", "Simple" },
					x	 = -1,
					y	 = 427,
					action = "",
					align = MenuAlign.Right,
					applyRequired = true,
				},
				zoomfx =
				{
					type = MenuItemTypes.TextButtonEx,
					text = "Zoom fx",
					desc = "Set the Zoom fx",
					option = "PROD_Zoom_FX",
					values = { 0, 1 },
					visible = { "None", "Classic" },
					x	 = -1,
					y	 = 467,
					action = "",
					align = MenuAlign.Right,
					applyRequired = true,
				},	
			},
		},
		
		AdvancedTab =
		{
			type = MenuItemTypes.TabGroup,
			x = 122,
			y = 70,
			width = 776,
			height = 350,
			visible = false,
			align = MenuAlign.Right,

			items = 
			{
				killsound =
				{
					type = MenuItemTypes.Checkbox,
					text = "KillSound",
					desc = "KillSound",
					option = "PROD_KillSound",
					valueOn = true,
					valueOff = false,
					x	 = 140,
					y	 = 132,
					action = "",
					align = MenuAlign.None,
					applyRequired = true,
				},
				hitsound =
				{
					type = MenuItemTypes.Checkbox,
					text = "HitSound",
					desc = "HitSound",
					option = "PROD_HitSound",
					valueOn = true,
					valueOff = false,
					x	 = 140,
					y	 = 172,
					action = "",
					align = MenuAlign.None,
					applyRequired = true,
				},
				fragmessage =
				{
					type = MenuItemTypes.Checkbox,
					text = "FragMessage",
					desc = "FragMessage",
					option = "PROD_FragMessage",
					valueOn = true,
					valueOff = false,
					x	 = 140,
					y	 = 212,
					action = "",
					align = MenuAlign.None,
					applyRequired = true,
				},
				fov =
				{
					type = MenuItemTypes.Slider,
					text = "Fov",
					desc = "Set the field of view",
					option = "FOV",
					minValue = 95,
					maxValue = 150,
					x	 = 150,
					y	 = 292,
					action = "",
					applyRequired = true,
				},
				zoomfov =
				{
					type = MenuItemTypes.Slider,
					text = "Zoom Fov",
					desc = "Set the fiel d of view for zoom",
					option = "ZoomFOV",
					minValue = 0,
					maxValue = 95,
					x	 = 150,
					y	 = 332,
					action = "",
					applyRequired = true,
				},		
				maxfps =
				{
					type = MenuItemTypes.Slider,
					text = "Max Fps",
					desc = "Set the maximum framerate in game",
					option = "MaxFpsMP",
					minValue = 0,
					maxValue = 125,
					x	 = 150,
					y	 = 372,
					action = "",
					applyRequired = true,
				},
			},
		},

		GeneralSettings =
		{
			text = TXT.Menu.General,
			desc = TXT.MenuDesc.General,
			x	 = 212,
			y	 = 96,
			align = MenuAlign.Center,
			action = "PainMenu:HideTabGroup(PainMenu.currScreen.items.AdvancedTab, 'AdvancedTab'); PainMenu:ShowTabGroup(PainMenu.currScreen.items.GeneralTab, 'GeneralTab')",
			sndAccept   = "menu/magicboard/card-take",
			fontBigSize = 26,
		},
		
		AdvancedSettings =
		{
			text = TXT.Menu.Advanced,
			desc = TXT.MenuDesc.Advanced,
			x	 = 392,
			y	 = 96,
			align = MenuAlign.Center,
			action = "PainMenu:HideTabGroup(PainMenu.currScreen.items.GeneralTab, 'GeneralTab'); PainMenu:ShowTabGroup(PainMenu.currScreen.items.AdvancedTab, 'AdvancedTab')",
			sndAccept   = "menu/magicboard/card-take",
			fontBigSize = 26,
		},
	}
}
