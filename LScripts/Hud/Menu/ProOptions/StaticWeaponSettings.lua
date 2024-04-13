StaticWeaponSettings =
{
	bgStartFrame = { 120, 243, 268 },
	bgEndFrame   = { 180, 267, 291 },

	fontBigSize = 26, -- CHG: PrimeviL 
	--sliderWidth = 340,
	descColor	= R3D.RGB( 255, 255, 255 ), -- CHG: PrimeviL 
	disabledColor = R3D.RGBA( 125, 125, 125, 255 ),

	backAction = "PainMenu:AdjustFov(); PainMenu:ActivateScreen(MainMenu)",
	applyAction = "PainMenu:ApplySettings(true); EnablePositionOptions(); PMENU.SetItemVisibility('ApplyButton',false)",

	items =
	{
		Bordera =
		{
			type = MenuItemTypes.Border,
			x = 122,
			y = 117,
			width = 776,
			height = 390,
		},
		staticweapon =
		{
			type = MenuItemTypes.Checkbox,
			text = "Static Weapon",
			desc = "Static Weapon",
			option = "PROD_Static_Weapon",
			valueOn = true,
			valueOff = false,
			x	 = 140,
			y	 = 132,
			action = "PainMenu:staticweapon()",
			align = MenuAlign.None,
			applyRequired = true,
		},
		defaultvalue =
		{
			text = "Default Value",
			desc = "Set Default Value",
			x	 = 150,
			y	 = 187,
			--align = MenuAlign.Center,
			action = "DefaultValueW(); PainMenu:ActivateScreen( StaticWeaponSettings )",
			sndAccept   = "menu/magicboard/card-take",
			fontBigSize = 26,
		},
		wposition =
		{
			type = MenuItemTypes.TextButtonEx,
			text = "Weapon Position",
			desc = "Set Weapons Position",
			option = "PROD_Weapon_Pos",
			values = { 0, 1, 2, 3 },
			visible = { "Left", "Right", "Center", "Custom" },
			x	 = -1,
			y	 = 147,
			action = "",
			align = MenuAlign.Right,
			applyRequired = false,
		},
		selectweapon =
		{
			type = MenuItemTypes.TextButtonEx,
			text = "Select Weapon",
			desc = "Select Weapon to Position",
			option = "PROD_Select_Weapon",
			values = { 0, 1, 2, 3 },
			visible = { "BoneGun", "CannoGun", "MagicCrossbow", "Ectoplasmer" },
			x	 = -1,
			y	 = 187,
			action = "",
			align = MenuAlign.Right,
			applyRequired = false,
		},
		positionx =
		{
			type = MenuItemTypes.Slider,
			text = "Position x",
			desc = "Set position for axis x",
			option = "PROD_Weapon2_Posx",
			minValue = -1,
			maxValue = 1,
			isFloat = true,
			x	 = 150,
			y	 = 262,
			action = "",
			applyRequired = true,
		},
		positiony =
		{
			type = MenuItemTypes.Slider,
			text = "Position y",
			desc = "Set position for axis y",
			option = "PROD_Weapon2_Posy",
			minValue = -1.5,
			maxValue = 0,
			isFloat = true,
			x	 = 150,
			y	 = 302,
			action = "",
			applyRequired = true,
		},
		positionz =
		{
			type = MenuItemTypes.Slider,
			text = "Position z",
			desc = "Set position for axis z",
			option = "PROD_Weapon2_Posz",
			minValue = -1.5,
			maxValue = 0,
			isFloat = true,
			x	 = 150,
			y	 = 342,
			action = "",
			applyRequired = true,
		},
		anglex =
		{
			type = MenuItemTypes.Slider,
			text = "Angle x",
			desc = "Set angle for axis x",
			option = "PROD_Weapon2_Angx",
			minValue = -0.5,
			maxValue = 0.5,
			isFloat = true,
			x	 = 150,
			y	 = 382,
			action = "",
			applyRequired = true,
		},		
		angley =
		{
			type = MenuItemTypes.Slider,
			text = "Angle y",
			desc = "Set angle for axis y",
			option = "PROD_Weapon2_Angy",
			minValue = -3.14,
			maxValue = 3.14,
			isFloat = true,
			x	 = 150,
			y	 = 422,
			action = "",
			applyRequired = true,
		},
		anglez =
		{
			type = MenuItemTypes.Slider,
			text = "Angle z",
			desc = "Set angle for axis z",
			option = "PROD_Weapon2_Angz",
			minValue = -1,
			maxValue = 1,
			isFloat = true,
			x	 = 150,
			y	 = 462,
			action = "",
			applyRequired = true,
		},
		GeneralSettings =
		{
			text = TXT.Menu.General,
			desc = TXT.MenuDesc.General,
			x	 = 212,
			y	 = 96,
			align = MenuAlign.Center,
			action = "PainMenu:ActivateScreen(ProOptions); EnableLowAmmoOptions(); PainMenu:HideTabGroup(PainMenu.currScreen.items.AdvancedTab, 'AdvancedTab'); PainMenu:ShowTabGroup(PainMenu.currScreen.items.GeneralTab, 'GeneralTab')",
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
			action = "PainMenu:ActivateScreen(ProOptions); PainMenu:HideTabGroup(PainMenu.currScreen.items.GeneralTab, 'GeneralTab'); PainMenu:ShowTabGroup(PainMenu.currScreen.items.AdvancedTab, 'AdvancedTab')",
			sndAccept   = "menu/magicboard/card-take",
			fontBigSize = 26,
		},
		GeneralSettingsBorder =
		{
			type = MenuItemTypes.Border,
			x = 122,
			y = 80,
			width = 185,
			height = 44,
		},
		
		AdvancedSettingsBorder =
		{
			type = MenuItemTypes.Border,
			x = 302,
			y = 80,
			width = 180,
			height = 44,
		},
		StaticWeaponSettingsBorder =
		{
			type = MenuItemTypes.Border,
			x = 478,
			y = 70,
			width = 255,
			height = 53,
			dark = true,
		},
		StaticWeaponSettings =
		{
			text = "Weapon View",
			desc = "Static Weapon Settings",
			x	 = 605,
			y	 = 89,
			align = MenuAlign.Center,
			action = "",
			sndAccept   = "menu/magicboard/card-take",
			fontBigSize = 26,
		},
		
	}
}
