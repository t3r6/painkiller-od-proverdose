SoundOptions =
{
	bgStartFrame = { 120, 243, 268 },
	bgEndFrame   = { 180, 267, 291 },

	fontBigSize = 36,
	sliderWidth = 340,

--	backAction = "PainMenu:ActivateScreen(OptionsMenu)",
	backAction = "PainMenu:ApplySettings(); PainMenu:ApplyAudioSettings(true); PainMenu:ActivateScreen(OptionsMenu)",
	applyAction = "PainMenu:ApplySettings(); PainMenu:ApplyAudioSettings(true); PainMenu:ActivateScreen(OptionsMenu)",

	items =
	{
		VolumeBorder =
		{
			type = MenuItemTypes.Border,
			x = 100,
			y = 100,
			width = 824,
			height = 260,
		},

		MasterVolume =
		{
			type = MenuItemTypes.Slider,
			text = TXT.Menu.MasterVolume,
			desc = TXT.MenuDesc.MasterVolume,
			option = "MasterVolume",
			minValue = 0,
			maxValue = 100,
			x	 = 160,
			y	 = 140,
                        sliderWidth = 310,
			action = "PainMenu:ApplyAudioSettings(false)",
		},

		MusicVolume =
		{
			type = MenuItemTypes.Slider,
			text = TXT.Menu.MusicVolume,
			desc = TXT.MenuDesc.MusicVolume,
			option = "MusicVolume",
			minValue = 0,
			maxValue = 100,
			x	 = 160,
			y	 = 190,
                        sliderWidth = 310,
			action = "PainMenu:ApplyAudioSettings(false)",
		},
		
		AmbientVolume =
		{
			type = MenuItemTypes.Slider,
			text = TXT.Menu.AmbientVolume,
			desc = TXT.MenuDesc.AmbientVolume,
			option = "AmbientVolume",
			minValue = 0,
			maxValue = 100,
			x	 = 160,
			y	 = 240,
                        sliderWidth = 310,
			action = "PainMenu:ApplyAudioSettings(false)",
		},

		SfxVolume =
		{
			type = MenuItemTypes.Slider,
			text = TXT.Menu.SoundVolume,
			desc = TXT.MenuDesc.SoundVolume,
			option = "SfxVolume",
			minValue = 0,
			maxValue = 100,
			x	 = 160,
			y	 = 290,
                        sliderWidth = 310,
			action = "PainMenu:ApplyAudioSettings(false)",
		},

		SoundBorder =
		{
			type = MenuItemTypes.Border,
			x = 100,
			y = 410,
			width = 824,
			height = 200,
		},
--[[
		ReverseStereo =
		{
			type = MenuItemTypes.Checkbox,
			text = TXT.Menu.ReverseStereo,
			desc = TXT.MenuDesc.ReverseStereo,
			option = "ReverseStereo",
			valueOn = true,
			valueOff = false,
			x	 = -1,
			y	 = 445,
			action = "",
			fontBigSize = 26,
		},
]]--		

		SoundChannelsConfiguration =
		{
			type = MenuItemTypes.TextButtonEx,
			text = TXT.Menu.SoundChannelsConfiguration,
			desc = TXT.MenuDesc.SoundChannelsConfiguration,
			option = "SoundChannelsConfiguration",
			values = { "Autodetect", "Software Mono", "Software Two Speakers", "Software Headphones", "Software Surround", "Software SRS Circle Surround", "Software Four Speakers", "Software 5.1", "Software 6.1", "Software 7.1", "Software 8.1", "Creative Labs EAX 2", "Creative Labs EAX 3", "Creative Labs EAX 4"  },
			visible = { TXT.Menu.Autodetect, TXT.Menu.Mono, TXT.Menu.TwoSpeakers, TXT.Menu.Headphones, TXT.Menu.Surround, TXT.Menu.SRSCircleSurround, TXT.Menu.FourSpeakers, TXT.Menu.FiveOne, TXT.Menu.SixOne, TXT.Menu.SevenOne, TXT.Menu.EightOne, TXT.Menu.EAX2, TXT.Menu.EAX3, TXT.Menu.EAX4 },
			x	 = -1,
			y	 = 440,
			action = "",
			fontBigSize = 26,
		},
		
		EAXAcoustics =
		{
			type = MenuItemTypes.Checkbox,
			text = TXT.Menu.EAXAcoustics,
			desc = TXT.MenuDesc.EAXAcoustics,
			option = "EAXAcoustics",
			valueOn = true,
			valueOff = false,
			x	 = -1,
			y	 = 490,
			action = "",
			fontBigSize = 26,
		},
		
		AmbientSounds =
		{
			type = MenuItemTypes.Checkbox,
			text = TXT.Menu.AmbientSounds,
			desc = TXT.MenuDesc.AmbientSounds,
			option = "AmbientSounds",
			valueOn = true,
			valueOff = false,
			x	 = -1,
			y	 = 540,
			action = "",
			fontBigSize = 26,
		},
	}
}
