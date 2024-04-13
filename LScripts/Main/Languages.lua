Languages =
{
	Encoding = "iso-8859-1",
	Texts = {}
}

--=======================================================================================

function Languages_ParseLangLine( line )
	line = string.gsub( line, "%s+", " " )
	local hash = string.find( line, "#" )
	if hash ~= nil then line = string.sub( line, 0, hash - 1 ) end
	line = string.gsub( line, "^%s+", "" )
	line = string.gsub( line, "%s+$", "" )
	if line == "" then return end

	local str = nil
	local num = nil

	for n,s in string.gfind( line, "(%d+):%s*(.+)" ) do
		num = n
		str = s
	end

	if num ~= nil and str ~= nil then
		Languages.Texts[tonumber(num)] = str
	else
		Languages.Encoding = line
	end
end

--=======================================================================================

Cfg:Load()

if Cfg.Language == "french" then
	LANG.ParseLangFile( "../Data/LScripts/Main/Lang_French.txt" )
elseif Cfg.Language == "german" then
	LANG.ParseLangFile( "../Data/LScripts/Main/Lang_German.txt" )
elseif Cfg.Language == "italian" then
	LANG.ParseLangFile( "../Data/LScripts/Main/Lang_Italian.txt" )
elseif Cfg.Language == "spanish" then
	LANG.ParseLangFile( "../Data/LScripts/Main/Lang_Spanish.txt" )
elseif Cfg.Language == "polish" then
	LANG.ParseLangFile( "../Data/LScripts/Main/Lang_Polish.txt" )
elseif Cfg.Language == "russian" then
	LANG.ParseLangFile( "../Data/LScripts/Main/Lang_Russian.txt" )
elseif Cfg.Language == "czech" then
	LANG.ParseLangFile( "../Data/LScripts/Main/Lang_Czech.txt" )
else
	LANG.ParseLangFile( "../Data/LScripts/Main/Lang_English.txt" )
end

--=======================================================================================

Languages.English = 
{
    -- globals
    Yes = Languages.Texts[1],
    No  = Languages.Texts[2],
    OK  = Languages.Texts[3],
    On  = Languages.Texts[4],
    Off = Languages.Texts[5],
    None = Languages.Texts[6],
    GameOver = Languages.Texts[7],

    Menu = 
    {
        SignAPact         = Languages.Texts[10],
        LoadGame          = Languages.Texts[11],
        Multiplayer       = Languages.Texts[12],
        Options           = Languages.Texts[13],
        Secrets           = Languages.Texts[14],
        Return            = Languages.Texts[420],
        ReturnToMap       = Languages.Texts[421],
        Disconnect		  = Languages.Texts[721],
        Quit              = Languages.Texts[16],
        AreYouSure		  = Languages.Texts[17],
        Back              = Languages.Texts[8],
        Apply             = Languages.Texts[9],
        Credits           = Languages.Texts[850],
        Videos			  = Languages.Texts[851],
        MakingOf		  = Languages.Texts[853],
        XBoxTrailer		  = Languages.Texts[854],
        Mech			  = Languages.Texts[855],
        SelectVideo		  = Languages.Texts[856],
        
        SelectGame		  = Languages.Texts[762],
        Painkiller        = Languages.Texts[763],
        BattleOutOfHell   = Languages.Texts[764],
        
        SelectDiffLevel   = Languages.Texts[18],
        Daydream          = Languages.Texts[19],
		Insomnia          = Languages.Texts[20],
		Nightmare         = Languages.Texts[21],
		Trauma            = Languages.Texts[22],

        Controls          = Languages.Texts[23],
        HUD               = Languages.Texts[24],
        Sound             = Languages.Texts[25],
        Video             = Languages.Texts[26],
        AdvancedVideo     = Languages.Texts[27],
        
        Weapons           = Languages.Texts[28],
		Action            = Languages.Texts[29],
		Primary           = Languages.Texts[30],
		Alternative       = Languages.Texts[31],
		
		Messages		  = Languages.Texts[541],
		Key               = Languages.Texts[543],
		SA                = Languages.Texts[544],
		Message           = Languages.Texts[545],

        MoveForward       = Languages.Texts[32],
        MoveBackward      = Languages.Texts[33],
        StrafeLeft        = Languages.Texts[34],
        StrafeRight       = Languages.Texts[35],
        Jump              = Languages.Texts[36],
        Fire              = Languages.Texts[37],
		AlternativeFire   = Languages.Texts[38],
		NextWeapon        = Languages.Texts[39],
		PreviousWeapon    = Languages.Texts[40],
		Weapon1           = Languages.Texts[41],
		Weapon2           = Languages.Texts[42],
		Weapon3           = Languages.Texts[43],
		Weapon4           = Languages.Texts[44],
		Weapon5           = Languages.Texts[45],
		Weapon6           = Languages.Texts[736],
		Weapon7           = Languages.Texts[737],
		Weapon8           = Languages.Texts[738],
		Weapon9           = Languages.Texts[739],
		Weapon10          = Languages.Texts[740],
		Weapon11          = Languages.Texts[826],
		Weapon12          = Languages.Texts[827],
		Weapon13          = Languages.Texts[832],
		Weapon14          = Languages.Texts[833],
		Zoom			  = Languages.Texts[767],
		BulletTime        = Languages.Texts[46],
		UseCards          = Languages.Texts[449],
		Flashlight        = Languages.Texts[450],
		Pause             = Languages.Texts[47],
		Screenshot        = Languages.Texts[48],
		Menu              = Languages.Texts[49],
		Scoreboard        = Languages.Texts[50],
		SayToAll          = Languages.Texts[51],
		SayToTeam         = Languages.Texts[52],
		RocketJump        = Languages.Texts[53],
		ForwardRocketJump = Languages.Texts[54],
		FireSwitch        = Languages.Texts[55],
		FireSwitchToggle  = Languages.Texts[56],
		SelectBestCustom1 = Languages.Texts[535],
		SelectBestCustom2 = Languages.Texts[536],
		FireBestCustom1   = Languages.Texts[537],
		FireBestCustom2   = Languages.Texts[538],
		QuickLoad         = Languages.Texts[539],
		QuickSave         = Languages.Texts[540],
		
		InvertMouse       = Languages.Texts[63],
		SmoothMouse       = Languages.Texts[64],
		MouseSensitivity  = Languages.Texts[65],
		WheelSensitivity  = Languages.Texts[66],

		Secondary         = Languages.Texts[67],
		Switch            = Languages.Texts[68],
		Pickup            = Languages.Texts[532],
		Explosives        = Languages.Texts[70],
		NonExplosives     = Languages.Texts[71],
		AutoChangeWeapon  = Languages.Texts[72],
		Custom            = Languages.Texts[73],
		Custom1           = Languages.Texts[533],
		Custom2           = Languages.Texts[534],
		Up                = Languages.Texts[74],
		Down              = Languages.Texts[75],

		HeadBob           = Languages.Texts[631],
		HUDTransparency   = Languages.Texts[76],
		HUDSize           = Languages.Texts[77],
		Small             = Languages.Texts[78],
		Normal            = Languages.Texts[79],
		Large             = Languages.Texts[80],
		Ultra			  = Languages.Texts[776],
		Crosshair         = Languages.Texts[81],
		CrosshairTrans    = Languages.Texts[82],
		CrosshairR        = Languages.Texts[83],
		CrosshairG        = Languages.Texts[84],
		CrosshairB        = Languages.Texts[85],
		
		MasterVolume      = Languages.Texts[86],
		MusicVolume       = Languages.Texts[444],
		AmbientVolume     = Languages.Texts[445],
		SoundVolume       = Languages.Texts[88],
		ReverseStereo     = Languages.Texts[89],
		SoundChannelsConfiguration = Languages.Texts[933],
                Autodetect        = Languages.Texts[925],
                Mono              = Languages.Texts[926],
		TwoSpeakers       = Languages.Texts[92],
		Headphones        = Languages.Texts[93],
		Surround          = Languages.Texts[94],
		SRSCircleSurround = Languages.Texts[927],
		FourSpeakers      = Languages.Texts[95],
		FiveOne           = Languages.Texts[96],
		SixOne            = Languages.Texts[928],
		SevenOne          = Languages.Texts[97],
		EightOne          = Languages.Texts[929],
		EAX2              = Languages.Texts[930],
		EAX3              = Languages.Texts[931],
		EAX4              = Languages.Texts[932],
		EAXAcoustics      = Languages.Texts[442],
		AmbientSounds     = Languages.Texts[633],
		
		Resolution        = Languages.Texts[98],
		TextureQuality    = Languages.Texts[99],
		Fullscreen        = Languages.Texts[100],
		Gamma             = Languages.Texts[101],
		Brightness        = Languages.Texts[102],
		Contrast          = Languages.Texts[103],
		VeryLow           = Languages.Texts[104],
		Low               = Languages.Texts[105],
		Medium            = Languages.Texts[106],
		High              = Languages.Texts[107],
		Architecture      = Languages.Texts[108],
		Characters        = Languages.Texts[109],
		Skies             = Languages.Texts[110],
		Particles         = Languages.Texts[448],
		TextureQualityBig = Languages.Texts[471],
		Low2              = Languages.Texts[530],
		High2             = Languages.Texts[531],
		GraphicsQuality   = Languages.Texts[564],
		Custom			  = Languages.Texts[566],
		Fastest			  = Languages.Texts[567],
		Fast			  = Languages.Texts[568],
		Standard		  = Languages.Texts[569],
		VeryHigh		  = Languages.Texts[570],
		Insane			  = Languages.Texts[571],
		
		Shadows           = Languages.Texts[111],
		WeatherEffects    = Languages.Texts[112],
		Sky               = Languages.Texts[113],
		ViewWeapon        = Languages.Texts[114],
		WeaponSpecular    = Languages.Texts[115],
		WeaponNormalMap   = Languages.Texts[116],
		HiResWeapon		  = Languages.Texts[836],
		WaterFX			  = Languages.Texts[837],
		TextureFiltering  = Languages.Texts[117],
		Multisample       = Languages.Texts[118],
		DecalsStay        = Languages.Texts[119],
		DynamicLights     = Languages.Texts[120],
		Projectors        = Languages.Texts[121],
		Coronas           = Languages.Texts[122],
		Decals            = Languages.Texts[123],
		DetailTextures    = Languages.Texts[124],
		Bilinear          = Languages.Texts[125],
		Trilinear         = Languages.Texts[126],
		Anisotropic       = Languages.Texts[127],
		ClipPlane		  = Languages.Texts[575],
		Bloom			  = Languages.Texts[760],
		WarpEffects		  = Languages.Texts[765],
		LowQualityMultiplayerSFX = Languages.Texts[757],
		
		Password          = Languages.Texts[128],
		JoinGame          = Languages.Texts[129],
		StartGame         = Languages.Texts[130],
		PlayerSettings    = Languages.Texts[131],

		Internet          = Languages.Texts[132],
		LAN               = Languages.Texts[133],
		Favorites         = Languages.Texts[134],
		AddToFavorites    = Languages.Texts[135],
		RemoveFromFavorites = Languages.Texts[136],
		Refresh           = Languages.Texts[137],
		Stop              = Languages.Texts[138],
		Join              = Languages.Texts[139],
		Spectate          = Languages.Texts[719],
		ServerName        = Languages.Texts[140],
		Servers           = Languages.Texts[141],
		Players           = Languages.Texts[142],
		Map               = Languages.Texts[143],
		Game              = Languages.Texts[144],
		Ping              = Languages.Texts[145],
		EnterIP           = Languages.Texts[146],
		CouldntFindAnyServer = Languages.Texts[147],
		ClickToSelect     = Languages.Texts[148],
		UpdatingServerList = Languages.Texts[149],
		UpdateFinished    = Languages.Texts[150],
		NoName            = Languages.Texts[151],
		NoMap             = Languages.Texts[152],
		Unknown           = Languages.Texts[153],
		
		ServerPassword    = Languages.Texts[154],
		ServerPort        = Languages.Texts[155],
		Mode              = Languages.Texts[156],
		FreeForAll	 	  = Languages.Texts[157],
		TeamDeathmatch    = Languages.Texts[158],
		Voosh			  = Languages.Texts[159],
		TheLightBearer    = Languages.Texts[160],
		PeopleCanFly	  = Languages.Texts[161],
		CaptureTheFlag    = Languages.Texts[759],
		Duel			  = Languages.Texts[778],
		LastManStanding   = Languages.Texts[779],
		MaxPlayers        = Languages.Texts[162],
		MaxSpectators     = Languages.Texts[163],
		FragLimit         = Languages.Texts[164],
		TimeLimit         = Languages.Texts[165],
		CaptureLimit      = Languages.Texts[780],
		LMSLives		  = Languages.Texts[803],
		PublicServer      = Languages.Texts[166],
		WeaponRespawnTime = Languages.Texts[741],
		ServerFPS		  = Languages.Texts[755],
		TeamDamage        = Languages.Texts[167],
		ConsoleLock       = Languages.Texts[857],
		WeaponsStay       = Languages.Texts[168],
		Powerups          = Languages.Texts[169],
		PowerupDrop       = Languages.Texts[170],
		AllowBunnyhopping = Languages.Texts[171],
		AllowBrightskins  = Languages.Texts[172],
		AllowForwardRocketJump = Languages.Texts[173],
		BrightskinTeam    = Languages.Texts[174],
		BrightskinEnemy   = Languages.Texts[175],
		General           = Languages.Texts[176],
		Advanced          = Languages.Texts[177],
		Start             = Languages.Texts[178],
		Add				  = Languages.Texts[179],
		AddAll            = Languages.Texts[180],
		Remove            = Languages.Texts[181],
		RemoveAll         = Languages.Texts[182],
		AvailableMaps     = Languages.Texts[475],
		ServerMaps        = Languages.Texts[476],
		White             = Languages.Texts[707],
		Red               = Languages.Texts[83],
		RedBSkin          = Languages.Texts[708],
		Green			  = Languages.Texts[84],
		Blue			  = Languages.Texts[85],

		Name              = Languages.Texts[183],
		TeamName          = Languages.Texts[184],
                TeamColorRed      = Languages.Texts[83],
                TeamColorBlue     = Languages.Texts[85],
		ConnectionSpeed   = Languages.Texts[185],
		CDKey             = Languages.Texts[186],
		Delete            = Languages.Texts[187],
		Enter             = Languages.Texts[188],
		PlayerModel       = Languages.Texts[690],
		Model1			  = Languages.Texts[692],
		Model2			  = Languages.Texts[693],
		Model3			  = Languages.Texts[694],
		Model4			  = Languages.Texts[695],
		Model5			  = Languages.Texts[696],
		Model6			  = Languages.Texts[839],
		Model7			  = Languages.Texts[840],
		FramerateLock	  = Languages.Texts[749],
		FramerateLock0	  = Languages.Texts[751],
		FramerateLock1	  = Languages.Texts[752],
		FramerateLock2	  = Languages.Texts[753],
		FramerateLock3	  = Languages.Texts[754],
		Modem             = Languages.Texts[674],
		ISDN              = Languages.Texts[675],
		CableADSL         = Languages.Texts[676],
		LANT1             = Languages.Texts[677],
		NewPrediction     = Languages.Texts[746],
		PredictionWarning = Languages.Texts[748],
		
		Chapter			  = Languages.Texts[423],
		Level             = Languages.Texts[424],
		
		GoToBlackBoard    = Languages.Texts[429],
		GoToMainMenu      = Languages.Texts[430],
		PlayLevel         = Languages.Texts[431],
		SelectLevel       = Languages.Texts[427],
		SelectChapter     = Languages.Texts[428],
		LevelNotAvailable = Languages.Texts[635],

		WantDelete		  = Languages.Texts[636],
		
		SaveTime          = Languages.Texts[637],
		NewSave			  = Languages.Texts[638],
		Save			  = Languages.Texts[639],
		Load			  = Languages.Texts[640],
		
		QuickPrefix		  = Languages.Texts[643],
		AutoPrefix        = Languages.Texts[644],
		CheckptPrefix     = Languages.Texts[680],
		GameSaved         = Languages.Texts[641],
		GameLoaded        = Languages.Texts[642],
		
		Saves             = Languages.Texts[678],
		AutoSaves         = Languages.Texts[679],
		
		InsertCD		  = Languages.Texts[745],

		SoulReaper	= 	   Languages.Texts[859],
    },

    MenuDesc =
    {
		Back              = Languages.Texts[189],
		Apply             = Languages.Texts[190],

		SignAPact         = Languages.Texts[191],
		LoadGame          = Languages.Texts[192],
		Multiplayer       = Languages.Texts[193],
		Options           = Languages.Texts[194],
		Secrets           = Languages.Texts[195],
		Return            = Languages.Texts[196],
		ReturnToMap       = Languages.Texts[421],
		Disconnect		  = Languages.Texts[722],
		Quit              = Languages.Texts[197],
		Credits           = Languages.Texts[706],
		Videos			  = Languages.Texts[852],
		
		Daydream          = Languages.Texts[198],
		Insomnia          = Languages.Texts[199],
		Nightmare         = Languages.Texts[200],
		Trauma            = Languages.Texts[201],
		TraumaLocked      = Languages.Texts[689],

		Controls          = Languages.Texts[202],
		HUD               = Languages.Texts[203],
		Sound             = Languages.Texts[204],
		Video             = Languages.Texts[205],
		AdvancedVideo     = Languages.Texts[206],

		Messages		  = Languages.Texts[542],
		WeaponsConfig     = Languages.Texts[207],
		Keys              = Languages.Texts[208],
		
		SA				  = Languages.Texts[572],
		SAOn			  = Languages.Texts[573],
		SAOff			  = Languages.Texts[574],

		InvertMouse       = Languages.Texts[209],
		SmoothMouse       = Languages.Texts[210],
		MouseSensitivity  = Languages.Texts[211],
		WheelSensitivity  = Languages.Texts[212],

		HeadBob           = Languages.Texts[631],
		HUDTransparency   = Languages.Texts[213],
		HUDSize           = Languages.Texts[214],
		Crosshair         = Languages.Texts[215],
		CrosshairTrans    = Languages.Texts[216],
		CrosshairR        = Languages.Texts[217],
		CrosshairG        = Languages.Texts[217],
		CrosshairB        = Languages.Texts[217],

		AutoChangeWeapon  = Languages.Texts[218],
		
		MasterVolume      = Languages.Texts[219],
		MusicVolume       = Languages.Texts[446],
		AmbientVolume     = Languages.Texts[447],
		SoundVolume       = Languages.Texts[221],
		ReverseStereo     = Languages.Texts[222],
                SoundChannelsConfiguration = Languages.Texts[934],
		SoundProvider     = Languages.Texts[224],
		EAXAcoustics      = Languages.Texts[443],
		AmbientSounds     = Languages.Texts[634],
		
		Resolution        = Languages.Texts[225],
		TextureQuality    = Languages.Texts[226],
		Fullscreen        = Languages.Texts[227],
		Gamma             = Languages.Texts[228],
		Brightness        = Languages.Texts[229],
		Contrast          = Languages.Texts[230],
		Weapons           = Languages.Texts[231],
		Architecture      = Languages.Texts[232],
		Characters        = Languages.Texts[233],
		Skies             = Languages.Texts[234],
		Particles         = Languages.Texts[226],
		GraphicsQuality   = Languages.Texts[565],
		
		Shadows           = Languages.Texts[235],
		WeatherEffects    = Languages.Texts[235],
		Sky               = Languages.Texts[235],
		ViewWeapon        = Languages.Texts[235],
		WeaponSpecular    = Languages.Texts[235],
		WeaponNormalMap   = Languages.Texts[235],
		HiResWeapon		  = Languages.Texts[235],
		WaterFX			  = Languages.Texts[226],
		TextureFiltering  = Languages.Texts[236],
		Multisample       = Languages.Texts[237],
		DecalsStay        = Languages.Texts[238],
		DynamicLights     = Languages.Texts[235],
		Projectors        = Languages.Texts[235],
		Coronas           = Languages.Texts[235],
		Decals            = Languages.Texts[235],
		DetailTextures    = Languages.Texts[235],
		ClipPlane		  = Languages.Texts[576],
		Bloom			  = Languages.Texts[761],
		WarpEffects		  = Languages.Texts[766],
		LowQualityMultiplayerSFX = Languages.Texts[758],
		
		Password          = Languages.Texts[239],
		JoinGame          = Languages.Texts[240],
		StartGame         = Languages.Texts[241],
		PlayerSettings    = Languages.Texts[242],

		Internet          = Languages.Texts[243],
		LAN               = Languages.Texts[244],
		Favorites         = Languages.Texts[245],
		AddToFavorites    = Languages.Texts[246],
		RemoveFromFavorites = Languages.Texts[247],
		Refresh           = Languages.Texts[248],
		Stop              = Languages.Texts[249],
		Join              = Languages.Texts[250],
		Spectate          = Languages.Texts[720],
		EnterIP           = Languages.Texts[251],
		
		ServerName        = Languages.Texts[252],
		ServerPassword    = Languages.Texts[253],
		ServerPort        = Languages.Texts[254],
		Mode              = Languages.Texts[255],
		MaxPlayers        = Languages.Texts[256],
		MaxSpectators     = Languages.Texts[257],
		FragLimit         = Languages.Texts[258],
		TimeLimit         = Languages.Texts[259],
		CaptureLimit      = Languages.Texts[781],
		LMSLives		  = Languages.Texts[804],
		PublicServer      = Languages.Texts[260],
		WeaponRespawnTime = Languages.Texts[742],
		ServerFPS		  = Languages.Texts[756],
		TeamDamage        = Languages.Texts[261],
		ConsoleLock       = Languages.Texts[858],
		WeaponsStay       = Languages.Texts[262],
		Powerups          = Languages.Texts[263],
		PowerupDrop       = Languages.Texts[264],
		AllowBunnyhopping = Languages.Texts[265],
		AllowBrightskins  = Languages.Texts[266],
		AllowForwardRocketJump    = Languages.Texts[267],
		BrightskinTeam    = Languages.Texts[268],
		BrightskinEnemy   = Languages.Texts[269],
		General           = Languages.Texts[270],
		Advanced          = Languages.Texts[271],
		Start             = Languages.Texts[272],
		Up				  = Languages.Texts[273],
		Down              = Languages.Texts[274],
		Add               = Languages.Texts[275],
		AddAll            = Languages.Texts[276],
		Remove            = Languages.Texts[277],
		RemoveAll         = Languages.Texts[278],

		Name              = Languages.Texts[279],
		TeamName          = Languages.Texts[280],
		ConnectionSpeed   = Languages.Texts[281],
		CDKey             = Languages.Texts[282],
		PlayerModel       = Languages.Texts[691],
		FramerateLock	  = Languages.Texts[750],
		NewPrediction     = Languages.Texts[747],
		
		BlackBoardInactive = Languages.Texts[432],
		BlackBoardNotDaydream = Languages.Texts[433],
		BlackBoardNotDemo  = Languages.Texts[425],
    },

	Map =
	{
		CardsFound        = Languages.Texts[307],
		GoldFound         = Languages.Texts[308],
	},
	
	Board =
	{
		Cost              = Languages.Texts[434],
		Withdrawal        = Languages.Texts[435],
		AfterWithdrawal   = Languages.Texts[436],
		GoldenUsage       = Languages.Texts[437],
		SilverUsage       = Languages.Texts[438],
		NotEnoughGold     = Languages.Texts[439],
		YourGold          = Languages.Texts[440],
		GoldRequired      = Languages.Texts[441],
		ExitToTheMap      = Languages.Texts[472],
	},

    Weapons =
    {
		Pain              = Languages.Texts[458],
		Killer            = Languages.Texts[459],
		Shotgun           = Languages.Texts[460],
		Freezer           = Languages.Texts[461],
		Stakegun          = Languages.Texts[462],
		GranadeLauncher   = Languages.Texts[463],
		RocketLauncher    = Languages.Texts[464],
		Minigun           = Languages.Texts[465],
		Shurikens         = Languages.Texts[466],
		Electro           = Languages.Texts[467],
		Rifle			  = Languages.Texts[830],
		FlameThrower	  = Languages.Texts[831],
		BoltGun			  = Languages.Texts[828],
		Heater			  = Languages.Texts[829],
		
		Razor		  = Languages.Texts[889],
		Cube		  = Languages.Texts[890],
		Bonegun		  = Languages.Texts[891],
		Petrify		  = Languages.Texts[892],
		Cannongun	  = Languages.Texts[893],
		Cannon		  = Languages.Texts[894],
		Crossbow	  = Languages.Texts[895],
		Heads		  = Languages.Texts[896],
		Evileye		  = Languages.Texts[897],
		Scream	  	  = Languages.Texts[898],
		Skulls	  	  = Languages.Texts[899],
		Blade	  	  = Languages.Texts[900],
		Ectoplasm  	  = Languages.Texts[901],
		GreenGoo  	  = Languages.Texts[902],
		Eggbomb  	  = Languages.Texts[903],
		EggThrow  	  = Languages.Texts[904],
    },
    
    SPStats =
    {
		YourScore         = Languages.Texts[309],
		BestScore         = Languages.Texts[630],
		GameplayTime      = Languages.Texts[310],
		Playtime          = Languages.Texts[688],
		MonstersKilled    = Languages.Texts[311],
		SoulsCollected    = Languages.Texts[312],
		ArmorFound        = Languages.Texts[452],
		GoldFound         = Languages.Texts[313],
		HolyItemsFound    = Languages.Texts[314],
		AmmoFound         = Languages.Texts[315],
		ObjectsDestroyed  = Languages.Texts[316],
		SecretsFound      = Languages.Texts[317],
		CardCondition     = Languages.Texts[318],
		Status            = Languages.Texts[319],
		Locked            = Languages.Texts[320],
		Unlocked          = Languages.Texts[321],
		Failed            = Languages.Texts[453],
		NA				  = Languages.Texts[454],
		PressEnter        = Languages.Texts[394],
		PressFire         = Languages.Texts[395],
		PressFireRestart  = Languages.Texts[451],
		PressFireCheckpt  = Languages.Texts[681],
		PressAltFire      = Languages.Texts[682],
		PressEscape		  = Languages.Texts[683],
		Difficulty        = Languages.Texts[474],
    },
    
    MPStats =
    {
		Player            = Languages.Texts[386],
		Frags             = Languages.Texts[387],
		Score             = Languages.Texts[777],
		Kills             = Languages.Texts[388],
		Deaths            = Languages.Texts[389],
		Ping              = Languages.Texts[390],
		Time              = Languages.Texts[391],
		PacketLoss        = Languages.Texts[392],
		PressFire         = Languages.Texts[710],
		PressFireReady    = Languages.Texts[716],
		PressAltFireSwitch = Languages.Texts[717],
		FinalResults      = Languages.Texts[711],
		Ready             = Languages.Texts[714],
		Break             = Languages.Texts[715],
		SpecShort         = Languages.Texts[728],
		FragLimit         = Languages.Texts[164],
		TimeLimit         = Languages.Texts[165],
		CaptureLimit      = Languages.Texts[780],
		TimeLeft          = Languages.Texts[393],
		LMSLives		  = Languages.Texts[803],
    },
    
    Multiplayer =
    {
        PlayerJoined        = Languages.Texts[322],
        PlayerLeft          = Languages.Texts[323],
        PlayerDeathComments = 
        {
            [AttackTypes.Bonegun]    = {Languages.Texts[324],
                                        Languages.Texts[325]},
            [AttackTypes.Shotgun]    = {Languages.Texts[324],
                                        Languages.Texts[325]},
            [AttackTypes.MiniGun]    = {Languages.Texts[326]},
            [AttackTypes.Grenade]    = {Languages.Texts[327]},
            [AttackTypes.Rocket]     = {Languages.Texts[328],
                                        Languages.Texts[329]},
            [AttackTypes.Stake]      = {Languages.Texts[330]},
            [AttackTypes.Painkiller] = {Languages.Texts[331]},
            [AttackTypes.PainkillerRotor] = {Languages.Texts[331]},
            [AttackTypes.Shuriken]   = {Languages.Texts[713]},
            [AttackTypes.Electro]    = {Languages.Texts[712]},
            [AttackTypes.TeleFrag]   = {Languages.Texts[332]},
            [AttackTypes.HitGround]  = {Languages.Texts[333]},
            [AttackTypes.OutOfLevel] = {Languages.Texts[334]},
            [AttackTypes.Suicide]    = {Languages.Texts[335],
                                        Languages.Texts[336]},
            [AttackTypes.Explosion]  = {Languages.Texts[337]},
            [AttackTypes.Lava]       = {Languages.Texts[718]},
            [AttackTypes.Rifle]      = {Languages.Texts[847]},
            [AttackTypes.BoltStick]  = {Languages.Texts[848]},
            [AttackTypes.HeaterBomb] = {Languages.Texts[849]},
            [AttackTypes.Heads] = {Languages.Texts[327]},
            [AttackTypes.Ectoplasm] = {Languages.Texts[326]},
            [AttackTypes.Scream] = {Languages.Texts[712]},
        },
        MatchBegins = Languages.Texts[935],
        CantChangeClientMode = Languages.Texts[936],
        Renamed = Languages.Texts[937],
        ChangedTeam = Languages.Texts[938],
        IsReady = Languages.Texts[939],
        IsNotReady = Languages.Texts[940],
        WantsBreak = Languages.Texts[941],
        MatchBeginsIn5 = Languages.Texts[942],
        WaitingForTeam = Languages.Texts[943],
        WaitingForPlayers = Languages.Texts[944],
        BrightskinsOn = Languages.Texts[953],
        BrightskinsOff = Languages.Texts[954],
        BunnyOn = Languages.Texts[955],
        BunnyOff = Languages.Texts[956],

        EnterPasswordRequester = Languages.Texts[958],
        PasswordIncorrect = Languages.Texts[959],
    },
    
    Keys =
    {
		UnknownKey			= Languages.Texts[477],
		CursorUp			= Languages.Texts[478],
		CursorDown			= Languages.Texts[479],
		CursorLeft			= Languages.Texts[480],
		CursorRight			= Languages.Texts[481],
		Space				= Languages.Texts[482],
		Tab					= Languages.Texts[483],
		Backspace			= Languages.Texts[484],
		Return				= Languages.Texts[485],
		Pause				= Languages.Texts[486],
		Shift				= Languages.Texts[487],
		Control				= Languages.Texts[488],
		Escape				= Languages.Texts[489],
		PageUp				= Languages.Texts[490],
		PageDown			= Languages.Texts[491],
		End					= Languages.Texts[492],
		Home				= Languages.Texts[493],
		Insert				= Languages.Texts[494],
		Delete				= Languages.Texts[495],
		Numpad0				= Languages.Texts[496],
		Numpad1				= Languages.Texts[497],
		Numpad2				= Languages.Texts[498],
		Numpad3				= Languages.Texts[499],
		Numpad4				= Languages.Texts[500],
		Numpad5				= Languages.Texts[501],
		Numpad6				= Languages.Texts[502],
		Numpad7				= Languages.Texts[503],
		Numpad8				= Languages.Texts[504],
		Numpad9				= Languages.Texts[505],
		NumpadMultiply		= Languages.Texts[506],
		NumpadAdd			= Languages.Texts[507],
		NumpadMinus			= Languages.Texts[508],
		NumpadDecimal		= Languages.Texts[509],
		NumpadDivide		= Languages.Texts[510],
		NumLock				= Languages.Texts[511],
		ScrollLock			= Languages.Texts[512],
		LeftShift			= Languages.Texts[513],
		RightShift			= Languages.Texts[514],
		LeftCtrl            = Languages.Texts[528],
		RightCtrl           = Languages.Texts[529],
		LeftAlt				= Languages.Texts[515],
		RightAlt			= Languages.Texts[516],
		LeftMenu			= Languages.Texts[517],
		RightMenu			= Languages.Texts[518],
		FarRightMenu		= Languages.Texts[519],
		PrintScreen			= Languages.Texts[520],
		CapsLock			= Languages.Texts[521],
		NumpadEnter			= Languages.Texts[522],
		LeftMouseButton		= Languages.Texts[523],
		RightMouseButton	= Languages.Texts[524],
		MiddleMouseButton	= Languages.Texts[525],
		MouseWheelForward	= Languages.Texts[526],
		MouseWheelBack		= Languages.Texts[527],
    },

    MPMessages = 
    {
		Languages.Texts[546],
		Languages.Texts[547],
		Languages.Texts[548],
		Languages.Texts[549],
		Languages.Texts[550],
		Languages.Texts[551],
		Languages.Texts[552],
		Languages.Texts[553],
		Languages.Texts[554],
		Languages.Texts[555],
		Languages.Texts[556],
		Languages.Texts[557],
		Languages.Texts[558],
		Languages.Texts[559],
		Languages.Texts[560],
		Languages.Texts[561],
		Languages.Texts[562],
		Languages.Texts[563],
		Languages.Texts[847],
		Languages.Texts[848],
		Languages.Texts[849],
    },

    Messages =
    {
		GameSaved = Languages.Texts[641],
		GameLoaded = Languages.Texts[642],
    },
    
    Cheats =
    {
		LowLevelOnly	= Languages.Texts[649],
		PKAmmo			= Languages.Texts[650],
		PKWeapons		= Languages.Texts[651],
		PKHealth		= Languages.Texts[652],
		PKPower			= Languages.Texts[653],
		PKGodOn			= Languages.Texts[654],
		PKGodOff		= Languages.Texts[655],
		PKGibOn			= Languages.Texts[656],
		PKGibOff		= Languages.Texts[657],
		PKKeepBodiesOn	= Languages.Texts[658],
		PKKeepBodiesOff	= Languages.Texts[659],
		PKKeepDecalsOn	= Languages.Texts[660],
		PKKeepDecalsOff	= Languages.Texts[661],
		PKWeakOn		= Languages.Texts[662],
		PKWeakOff		= Languages.Texts[663],
		PKGold			= Languages.Texts[664],
		PKHasteOn		= Languages.Texts[665],
		PKHasteOff		= Languages.Texts[666],
		PKDemonOn		= Languages.Texts[667],
		PKDemonOff		= Languages.Texts[668],
		PKWeapModOn		= Languages.Texts[669],
		PKWeapModOff	= Languages.Texts[670],
		PKCards			= Languages.Texts[671],
		PKAllLevels		= Languages.Texts[672],
		PKAllCards		= Languages.Texts[673],
    },

    Actions = 
    {
        AI = "AI:true/false\nWlacza/wylacza inteligencje przeciwnika.",
        Damage = "Damage:obj[,dmg]\nZadaje obrazenia obiektowi. Przy braku parametru 'dmg' zadaje obrazenie usmiercajace obiekt.",
        Kill = "Kill:obj\nNatychmiastowo kasuje obiekt ze swiata gry. Bez zadnych dodatkowych efektow."
    },

    MPErrors =
    {
	DisconnectedTimeout	= Languages.Texts[579], -- : Disconnected on timeout: %d ms
        GameSpyTimeout 		= Languages.Texts[580], -- : GameSpy timeout error!!!\nDescription: %s
        NATAck 			= Languages.Texts[581], -- : NAT Negotiation: NN server acknowledged your connection request
        NATDirectStart 		= Languages.Texts[582], -- : NAT Negotiation: direct negotiation with the other client has started
        NATUnknownState 	= Languages.Texts[583], -- : NAT Negotiation: unknown negotiate state returned by GameSpy!! State: %d
        NATCompleteOut 		= Languages.Texts[584], -- : NAT Negotiation complete! Connecting to %s
        NATNotRegistered 	= Languages.Texts[585], -- : NAT Negotiation error: Partner did not register with the NAT Negotiation Server
        NATNoServer 		= Languages.Texts[586], -- : NAT Negotiation error: Unable to communicate with NAT Negotiation Server
        NATServerError 		= Languages.Texts[587], -- : NAT Negotiation error: NAT Negotiation server indicated an unknown error condition
        NATCompleteIn 		= Languages.Texts[588], -- : NAT Negotiation succesfull!: Client connecting from %s
        NATCookie 		= Languages.Texts[589], -- : NAT Negotiation: Received client cookie: %d
        InitStartupFailed 	= Languages.Texts[590], -- : Net Init Error: WSAStartup() failed!! Returned %s
        InitOldSockets 		= Languages.Texts[591], -- : Net Init Error: Windows Sockets implementation too old!
        InitInterfaceFailed 	= Languages.Texts[592], -- : Net Init Error: tried to resolve given interface and failed!
        InitHostnameFailed 	= Languages.Texts[593], -- : Net Init Error: gethostname() call failed!! Can't find this computer's name! Returned: %s
        InitIPUnresolved 	= Languages.Texts[594], -- : Net Init Error: failed to resolve our IP with gethostbyname()!!
        InitOpenFailed 		= Languages.Texts[595], -- : Net Init Error: Couldn't open listening socket: %s
        InitNonblockingFailed 	= Languages.Texts[596], -- : Net Init Error: Couldn't make socket non-blocking: %s
        InitSocketBindFailed 	= Languages.Texts[597], -- : Net Init Error: Failed to bind socket on port %d: %s
        InitSocknameFailed	= Languages.Texts[598], -- : Net Init Error: getsockname on bound socket failed!! Returned: %s
        GameSpyDNSError		= Languages.Texts[599], -- : GameSpy Init Error: a DNS lookup (for the master server) failed\nGameSpy inactive!
        GameSpyNoChallenge	= Languages.Texts[600], -- : GameSpy Init Error: no challenge was received from the master - either the master is down, or a firewall is blocking UDP\nGameSpy inactive!
        GameSpyUnknownError	= Languages.Texts[601], -- : GameSpy Init Error: unknown error value given by GameSpy: %d\nGameSpy inactive!
        PortUnreachable		= Languages.Texts[602], -- : Net Error: Connection refused by server (port unreachable)
        AddressDoesNotReply	= Languages.Texts[603], -- : Net Error: Given address does not reply
        ConnectionClosed	= Languages.Texts[604], -- : Net Error: Connection closed from other side (probably other side is down right now)
        RejectedDevelVersion	= Languages.Texts[605], -- : Net Info: Rejected connect from '%s': using early development client version!
        RejectedDifferentClient	= Languages.Texts[606], -- : Net Info: Rejected connect from '%s': different client version: %s
        RejectedDifferentScript	= Languages.Texts[607], -- : Net Info: Rejected connect from '%s': different client scripts
        RejectedUnexpectedChallenge	= Languages.Texts[608], -- : Net Info: Rejected connect from '%s': it tried to answer a challenge I didn't issue
        RejectedTooManyConnections = Languages.Texts[609], -- : Net Info: Rejected connect from '%s': too many clients trying to connect
        RejectedBadPassword	= Languages.Texts[610], -- : Net Info: Rejected connect from '%s': bad password given
        RejectedMaxClients	= Languages.Texts[611], -- : Net Info: Rejected connect from '%s': maximal number of clients achieved
        RejectedInvalidChallenge = Languages.Texts[612], -- : Net Info: Rejected connect from '%s': invalid challenge given
        RejectedInvalidResponse	= Languages.Texts[613], -- : Net Info: Rejected connect from '%s': invalid challenge response given
        RejectedBadCDKey	= Languages.Texts[614], -- : Net Info: Rejected connect from '%s': GameSpy says it has a bad CD key
        RejectedOpenWithoutConnect	= Languages.Texts[615], -- : Net Info: Rejected net open from '%s': it tried to do it without a prior connect
        NoPKServer		= Languages.Texts[616], -- : Net Error: trying to connect to host that is not a Painkiller server!!
        BadVersion		= Languages.Texts[617], -- : Net Error: the server is version '%s', we are '%s'.\nCan't connect!! Please upgrade the game.
        BadScripts		= Languages.Texts[618], -- : Net Error: we have different scripts than the server, but the same game version.\nPlease upgrade or reinstall the game.
        BadPassword		= Languages.Texts[619], -- : Net Error: we gave bad password to passworded server!!
        FailedChallenge		= Languages.Texts[620], -- : Net Error: failed challenge authentication!! A hack job, perhaps?
        ChallengeTimeout	= Languages.Texts[621], -- : Network: server challenge timeout...reconnecting
        MaxPlayers		= Languages.Texts[622], -- : Net Error: No more players allowed on this server
        IncorrectCDKey 		= Languages.Texts[623], -- : Net Error: the CD Key you entered is incorrect, or there's another player with the same CD Key presently on the Net!\nServer said: %s
        UnexpectedChallenge	= Languages.Texts[624], -- : Net Error: the client tried to answer a challenge that the server didn't provide!\nServer said: %s
        OpenWithoutConnect	= Languages.Texts[625], -- : Net Error: the client tried to issue a Net Open command without connecting first!\nServer said: %s
        UnknownErrorReport	= Languages.Texts[626], -- : Net Error: unknown error report received!!
        WriteError		= Languages.Texts[627], -- : Net Error: Write: error in sendto(): %s
        ReadError		= Languages.Texts[628], -- : Net Error: Read: error in recvfrom(): %s
        ResolveError		= Languages.Texts[629], -- : Net Error: Couldn't resolve address: %s

        EnterPassword           = Languages.Texts[958],
        PasswordTooLong         = Languages.Texts[960], --: Net Error: password given was too long.\n
        PureScripts             = Languages.Texts[961], --: Net Error: failed connection due to pure server and different checksum of our scripts\n
        ChallengeTooLong        = Languages.Texts[962], --: Net Error: Challenge response too long!!\n
        MaximalFrameSizeEx      = Languages.Texts[963], --: Net Error: Maximal frame size exceeded! Try lowering your fps or getting server frames more frequently\n
        DifferentMap            = Languages.Texts[964], --: Net Error: the map we are trying to load is different than the map on the server!
        RejectedTooLongPassword = Languages.Texts[965], --: Net Info: Rejected connect from '%s': gave too long password\n
        RejectedDifferentChecksum = Languages.Texts[966], --: Net Info: Rejected connect from '%s': different scripts checksum\n
    }    
}

--=======================================================================================

-- current language
TXT = Languages.English


if not Cfg.MessagesTexts then
	Cfg.MessagesTexts = {}
	for i=1,table.getn(TXT.MPMessages) do
		Cfg.MessagesTexts[i] = TXT.MPMessages[i]
	end
end
