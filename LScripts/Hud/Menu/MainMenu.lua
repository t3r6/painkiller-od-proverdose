MainMenu =
{
	firstTimeShowItems = 80,

	bgStartFrame = { 120, 243, 267 },
	bgEndFrame   = { 180, 266, 291 },

	textColor	= R3D.RGBA( 100, 100, 100, 255 ),
	disabledColor = R3D.RGBA( 155, 155, 155, 255 ),
	
	fontBigTex  = "HUD/font_texturka_alpha",
	fontSmallTex  = "HUD/font_texturka_alpha",
	descColor	= R3D.RGB( 255, 255, 255 ),

	useItemBG = true,

	items		=
	{
--MODIFIED=##################################################################################################
		--[[SignAPact =
		{
			text = TXT.Menu.SignAPact,
			desc = TXT.MenuDesc.SignAPact,
			x	 = -1,
			y	 = 210,
			action = "PainMenu:SignAPact(1,true)",
			sndLightOn = "menu/menu/option-light-on_main",
--			disabled = 1,
		},
		
		LoadGame =
		{
			text = TXT.Menu.LoadGame,
			desc = TXT.MenuDesc.LoadGame,
			x	 = -1,
			y	 = 290,
			action = "PainMenu:ActivateScreen(LoadSaveMenu)",
--			disabled = 1,
			sndLightOn = "menu/menu/option-light-on_main2",
		},]]--
--MODIFIED=end################################################################################################

--ADDED=####################################################################################################
--PROverdose Menu====================================================================================================
		ProOptions=
		{
			text = "Mod settings",
			desc = "Set your PROverdose options",
			x	 = -1,
			y	 = 230,
			action = "PainMenu:ActivateScreen(ProOptions); EnableLowAmmoOptions()",
--			disabled = 1,
			sndLightOn = "menu/menu/option-light-on_main2",
		},
--PROverdose Menu=end==========================================================================================================
--ADDED=end##################################################################################################
		Multiplayer =
		{
			text = TXT.Menu.Multiplayer,
			desc = TXT.MenuDesc.Multiplayer,
			x	 = -1,
			y	 = 310,
			action = "PainMenu:ActivateScreen(MultiplayerMenu)",
			sndLightOn = "menu/menu/option-light-on_main3",
--			disabled = 1,
		},

		Options =
		{
			text = TXT.Menu.Options,
			desc = TXT.MenuDesc.Options,
			x	 = -1,
			y	 = 390,
			action = "PainMenu:ActivateScreen(OptionsMenu)",
			sndLightOn = "menu/menu/option-light-on_main4",
		},
		
		Quit =
		{
			text = TXT.Menu.Quit,
			desc = TXT.MenuDesc.Quit,
			x	 = -1,
			y	 = 470,
			--action = "PainMenu:AskYesNo( Languages.Texts[469], 'Exit()', 'PainMenu:ActivateScreen(MainMenu)' )",
			action = "Exit()", --MODIFIED=###################################################################
			--sndLightOn = "menu/menu/option-light-on_main5",
		},
		
		BackButton =
		{
			text = TXT.Menu.Return,
			desc = TXT.MenuDesc.Return,
			textColor	= R3D.RGBA( 255, 255, 255, 255 ),
			x	 = 72,
			y	 = 640,
			fontBigSize = 36,
			align = MenuAlign.Left,
			inGameOnly = 1,
			action = "PMENU.ResumeSounds(); PMENU.ReturnToGame(); PainMenu:ReloadBrightskins()",
			useItemBG = false,
		},
		
		BackToMap =
		{
			text = TXT.Menu.ReturnToMap,
			desc = TXT.MenuDesc.ReturnToMap,
			textColor	= R3D.RGBA( 255, 255, 255, 255 ),
			x	 = 952,
			y	 = 640,
			fontBigSize = 36,
			align = MenuAlign.Right,
			inGameOnly = 1,
			action = "PainMenu:AskReturnToMap()",
			useItemBG = false,
		},
		
		Disconnect =
		{
			text = TXT.Menu.Disconnect,
			desc = TXT.MenuDesc.Disconnect,
			textColor = R3D.RGBA( 255, 255, 255, 255 ),
			x	 = 952,
			y	 = 640,
			fontBigSize = 36,
			align = MenuAlign.Right,
			inGameOnly = 1,
			action = "PainMenu:Disconnect()",
			useItemBG = false,
		},

		--[[Credits =
		{
			text = TXT.Menu.Credits,
			desc = TXT.MenuDesc.Credits,
			textColor	= R3D.RGBA( 255, 255, 255, 255 ),
			x	 = -1,
			y	 = 640,
			fontBigSize = 36,
			action = "PainMenu:Disconnect(); PMENU.ShowCredits()",
			useItemBG = false,
		},]]--  CHG: PrimeviL

	}
}
