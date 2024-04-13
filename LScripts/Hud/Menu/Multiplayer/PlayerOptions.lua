PlayerOptions =
{
	bgStartFrame = { 120, 243, 268 },
	bgEndFrame   = { 180, 267, 291 },


	fontBigSize = 36,
	
	backAction = "PainMenu:ApplySettings(); PainMenu:ActivateScreen(MultiplayerMenu)",
	applyAction = "PainMenu:ApplySettings(); PainMenu:ActivateScreen(MultiplayerMenu)",

	items =
	{
		PlayerBorder = 
		{
			type = MenuItemTypes.Border,
			x = 60,
			y = 60,
			width = 554,
			height = 415,
		},

		PlayerName =
		{
			type = MenuItemTypes.TextEdit,
			text = TXT.Menu.Name..":",
			desc = TXT.MenuDesc.Name,
			option = "PlayerName",
			x	 = 80,
			y	 = 100,
			action = "",
			maxLength = 16,
		},
		
		Team =
		{
			type = MenuItemTypes.TextButtonEx,
			text = TXT.Menu.TeamName,
			desc = TXT.MenuDesc.TeamName,
			option = "Team",
			values = { 0, 1 },
			visible = { TXT.Menu.Blue, TXT.Menu.Red },
			x	 = 80,
			y	 = 160,
			action = "",
		},
		
		ConnectionSpeed =
		{
			type = MenuItemTypes.TextButtonEx,
			text = TXT.Menu.ConnectionSpeed,
			desc = TXT.MenuDesc.ConnectionSpeed,
			option = "ConnectionSpeed",
			values = { 1, 2, 3, 4, 5 },
			visible = { TXT.Menu.Modem, TXT.Menu.ISDN, TXT.Menu.CableADSL, TXT.Menu.LANT1, TXT.Menu.Custom },
			x	 = 80,
			y	 = 220,
			action = "",
		},

--[[		CDKey =
		{
			type = MenuItemTypes.TextEdit,
			text = TXT.Menu.CDKey..":",
			desc = TXT.MenuDesc.CDKey,
			option = "CDKey",
			x	 = 80,
			y	 = 280,
			action = "",
			maxLength = 20,
		},
		--]]
		ModelBorder = 
		{
			type = MenuItemTypes.Border,
			x = 630,
			y = 60,
			width = 330,
			height = 415,
		},
		
		ModelSelect =
		{
			type = MenuItemTypes.TextButtonEx,
			text = TXT.Menu.PlayerModel,
			desc = TXT.MenuDesc.PlayerModel,
			option = "PlayerModel",
			values = { 1, 2, 3, 4, 5, 6, 7 },
			visible = { TXT.Menu.Model1, TXT.Menu.Model2, TXT.Menu.Model3, TXT.Menu.Model4, TXT.Menu.Model7, TXT.Menu.Model5, TXT.Menu.Model6 },
			x	 = 80,
			y	 = 280,
			action = "",
		},
		
--		NewPrediction =
--		{
--			type = MenuItemTypes.Checkbox,
--			text = TXT.Menu.NewPrediction,
--			desc = TXT.MenuDesc.NewPrediction,
--			option = "NewPrediction",
--			valueOn = true,
--			valueOff = false,
--			x	 = 70,
--			y	 = 394,
--			action = "",
--			warning = true,
--			descColor	= R3D.RGB( 255, 0, 0 ),
--		},
		
		PlayerModel =
		{
			type = MenuItemTypes.PlayerModel,
			text = "",
			desc = "",
			option = "",
			x	 = -1,
			y	 = 500,
			action = "",
		},
		
		LPickerBorder = 
		{
			type = MenuItemTypes.Border,
			x = 60,
			y = 495,
			width = 904,
			height = 100,
		},
		
		CharPicker =
		{
			type = MenuItemTypes.CharPicker,
			text = "",
			desc = "",
			option = "",
			x	 = 78,
			y	 = 513,
			action = "",
			fontBigSize = 24,
		},
		
		CPickerBorder = 
		{
			type = MenuItemTypes.Border,
			x = 320,
			y = 615,
			width = 640,
			height = 60,
		},

		DelButton =
		{
			text = TXT.Menu.Delete,
			desc = "",
			x	 = 890,
			y	 = 525,
			align = MenuAlign.Center,
			action = "",
			fontBigSize = 26,
		},
		
		EnterButton =
		{
			text = TXT.Menu.Enter,
			desc = "",
			x	 = 890,
			y	 = 555,
			align = MenuAlign.Center,
			action = "",
			fontBigSize = 26,
			sndAccept   = "menu/menu/key-set",
		},
		
		ColorPicker =
		{
			type = MenuItemTypes.ColorPicker,
			text = "",
			desc = "",
			option = "",
			x	 = 338,
			y	 = 633,
			action = "",
		}
	}
}
