DemoEnd =
{
	firstTimeShowItems = 80,

	bgStartFrame = { 120, 243, 267 },
	bgEndFrame   = { 180, 266, 291 },

	background = "HUD/termination_logo_demo1",

	wait = 0,
	hideCursor = true,

	items =
	{
		QuitButton =
		{
			type = MenuItemTypes.ImageButton,
			text = "",
			desc = "",
			x = 0,
			y = 0,
			action = "PainMenu:ActivateScreen(DemoEnd2)",
			image = "HUD/termination_logo_demo1",
			imageUnder = "HUD/termination_logo_demo1",
			imagePressed = "HUD/termination_logo_demo1",
		},
	}
}

DemoEnd2 =
{
	firstTimeShowItems = 80,

	bgStartFrame = { 120, 243, 267 },
	bgEndFrame   = { 180, 266, 291 },

	background = "HUD/termination_logo_demo2",

	wait = 0,
	hideCursor = true,

	items =
	{
		QuitButton =
		{
			type = MenuItemTypes.ImageButton,
			text = "",
			desc = "",
			x = 0,
			y = 0,
			action = "Exit()",
			image = "HUD/termination_logo_demo2",
			imageUnder = "HUD/termination_logo_demo2",
			imagePressed = "HUD/termination_logo_demo2",
		},
	}
}

