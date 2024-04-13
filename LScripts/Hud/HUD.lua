--============================================================================
Hud = 
{
    Enabled = true,
    DrawEyes = false,
    TickCount = 0,
    _matCrosshair = -1,
    _matAmmo = -1,
    _matGameOver = -1,
    _matHealth = -1,
    _matArmor = -1,
    _matArmorNormal = -1,
    _matArmorRed = -1,
    _matArmorGreen = -1,
    _matArmorYellow = -1,
    _matHead = -1,
    _matEyes = -1,
    _matDemons = -1,
    _matNumbers = -1,
    _matLifeIcon = -1,
    _matShieldIcon = -1,

	_matHUDTop = -1,
	_matHUDLeft = -1,
	_matHUDRight = -1,

	_matMoney = -1,
	_matPentagram = -1,
	_matStar = -1,

	_matBossFace = -1,
	_matBossAlastor = -1,
	_matBossGiant = -1,
	_matBossSwamp = -1,
	_matBossThor = -1,
	_matBossAlastor2 = -1,
	_matBossSpider = -1,
	_matBossKerb1 = -1,
	_matBossKerb2 = -1,
	_matBossKerb3 = -1,
	_matBossGuardian = -1,
	_matBossTank = -1,
	_matBossSamael = -1,
	_matCompassArrow = -1,
	_matCompassArrShadow = -1,
	_matCompassArrGlow = -1,
	_matCompassDown = -1,
	_matCompassDownOn = -1,
	_matCompassUp = -1,
	_matCompassUpOn = -1,
	_glowTime = 0.0,
	_glowDir = 0,
	_glowTrans = 0,
	_glowStart = 0.0,
	_glowTime2 = 0.0,
	_glowDir2 = 0,
	_glowTrans2 = 0,
	_glowStart2 = 0.0,
	showCompassArrow = true,
	r_closestEnemy = nil,
	_nearestCheckPoint = nil,
	_nearestIsCheckpoint = false,
	_lastTime = 0.0,

	_matDigits = {},
	_matDigitsT = {}, --ADDED=####################################################
	_matDigitsRed = {},
	_matDigitsTRed = {}, --ADDED=####################################################
	
--    _matShotgunIcon = -1,
--    _matGrenadeIcon = -1,

	_lastCross = -1,
    CrossScale = 1,

	_matModifier = -1,
	
	_showSPStats = false,

	-- MP messages
--	mpMsgColor = { 255, 255, 255 },
	mpMsgColor = { 255, 186, 122 },
	mpMsgPosition = { 0, 565 },
	mpMsgFont = "courbd",
--	mpMsgFontTex = "HUD/font_texturka",
	mpMsgFontTex = "",
	mpMsgFontSize = 20, -- default size 20 PrimeviL 
	
	_matDemonCross = nil,

	_crosshairs = {	"HUD/crosshair", "HUD/crossy/cross1", "HUD/crossy/cross2", "HUD/crossy/cross3",
				"HUD/crossy/cross4", "HUD/crossy/cross5", "HUD/crossy/cross6", "HUD/crossy/cross7",
				"HUD/crossy/cross8", "HUD/crossy/cross9", "HUD/crossy/cross91", "HUD/crossy/cross92",
				"HUD/crossy/cross93", "HUD/crossy/cross94", "HUD/crossy/cross95", "HUD/crossy/cross96",
				"HUD/crossy/cross97", "HUD/crossy/cross98", "HUD/crossy/cross99", "HUD/crossy/cross991",
				"HUD/crossy/cross992", "HUD/crossy/cross993", "HUD/crossy/cross994", "HUD/crossy/cross995",
				"HUD/crossy/cross996", "HUD/crossy/cross997", "HUD/crossy/cross998", "HUD/crossy/cross999",
				"HUD/crossy/cross9991", "HUD/crossy/cross9992", "HUD/crossy/cross9993", "HUD/crossy/cross9994" },

	_colors = { R3D.RGB(0,0,255) },
	
	_showCheckPointInfo = false,
	_showFPS = false,
	
	_showPacketLoss = false,
	_matPacketLoss = nil,

	_mpStatsDrawFunc = MPSTATS.Draw,
	
	_overlayMessage = "",
	_overlayMsgStart = 0,
	_splat ={},

	
}
--============================================================================
function Hud:LoadAlternateHud()
	self._matHUDTop = MATERIAL.Create("HUD/Mw_hud/hud_top_black", TextureFlags.NoLOD + TextureFlags.NoMipMaps)
		self._matHUDLeft = MATERIAL.Create("HUD/Mw_hud/hud_left_black", TextureFlags.NoLOD + TextureFlags.NoMipMaps)
		self._matHUDRight = MATERIAL.Create("HUD/Mw_hud/hud_right_black", TextureFlags.NoLOD + TextureFlags.NoMipMaps)
	self._matCompassArrow = MATERIAL.Create("HUD/Mw_kompas/strzalka_kompas", TextureFlags.NoLOD + TextureFlags.NoMipMaps)
	self._matCompassArrShadow = MATERIAL.Create("HUD/Mw_kompas/strzalka_kompas_cien", TextureFlags.NoLOD + TextureFlags.NoMipMaps)
	self._matCompassArrGlow = MATERIAL.Create("HUD/Mw_kompas/strzalka_glow_next", TextureFlags.NoLOD + TextureFlags.NoMipMaps)
end
--============================================================================
function Hud:LoadNormalHud()
	self._matHUDTop = MATERIAL.Create("HUD/Mw_hud/hud_top_black", TextureFlags.NoLOD + TextureFlags.NoMipMaps)
		self._matHUDLeft = MATERIAL.Create("HUD/Mw_hud/hud_left_black", TextureFlags.NoLOD + TextureFlags.NoMipMaps)
		self._matHUDRight = MATERIAL.Create("HUD/Mw_hud/hud_right_black", TextureFlags.NoLOD + TextureFlags.NoMipMaps)
	self._matCompassArrow = MATERIAL.Create("HUD/Mw_kompas/strzalka_kompas", TextureFlags.NoLOD + TextureFlags.NoMipMaps)
	self._matCompassArrShadow = MATERIAL.Create("HUD/Mw_kompas/strzalka_kompas_cien", TextureFlags.NoLOD + TextureFlags.NoMipMaps)
	self._matCompassArrGlow = MATERIAL.Create("HUD/Mw_kompas/strzalka_glow_next", TextureFlags.NoLOD + TextureFlags.NoMipMaps)
end
--============================================================================
function Hud:Loadsplats()
	for i = 1,6 do
		self._splat[i]={}
		self._splat[i][1] = MATERIAL.Create("HUD/splat/splat_red_0"..i, TextureFlags.NoLOD + TextureFlags.NoMipMaps)
		for y = 1,3 do
			self._splat[i][y+1]=MATERIAL.Create("HUD/splat/splat_red_0"..i.."_0"..y, TextureFlags.NoLOD + TextureFlags.NoMipMaps)
		end
		self._splat[i+6]={}
		self._splat[i+6][1] = MATERIAL.Create("HUD/splat/splat_purple_0"..i, TextureFlags.NoLOD + TextureFlags.NoMipMaps)
		for y = 1,3 do
			self._splat[i+6][y+1]=MATERIAL.Create("HUD/splat/splat_purple_0"..i.."_0"..y, TextureFlags.NoLOD + TextureFlags.NoMipMaps)
		end
		self._splat[i+12]={}
		self._splat[i+12][1] = MATERIAL.Create("HUD/splat/splat_green_0"..i, TextureFlags.NoLOD + TextureFlags.NoMipMaps)
		for y = 1,3 do
			self._splat[i+12][y+1]=MATERIAL.Create("HUD/splat/splat_green_0"..i.."_0"..y, TextureFlags.NoLOD + TextureFlags.NoMipMaps)
		end
	end

	for r=1, Game._Splatn do
		 Game._Splattimeouts[r] = 0
	end
end

--============================================================================
function Hud:LoadData()
--    self._matAmmo = MATERIAL.Create("HUD/waz_P 75 %transp", TextureFlags.NoLOD + TextureFlags.NoMipMaps)
--    self._matHealth = MATERIAL.Create("HUD/waz_L 75 %transp", TextureFlags.NoLOD + TextureFlags.NoMipMaps)


	self:Loadsplats()
---	

--ADDED=####################################################################################################
--Colored Icones=début==============================================================================================================================================
--weapon
	Hud._matCubew      	  = MATERIAL.Create("../ProOptions/Weapon/kostka_open", TextureFlags.NoLOD + TextureFlags.NoMipMaps)
	Hud._matBoneGunw      = MATERIAL.Create("../ProOptions/Weapon/i_bones", TextureFlags.NoLOD + TextureFlags.NoMipMaps)
	Hud._matCannonGunw    = MATERIAL.Create("../ProOptions/Weapon/kulomet_koule", TextureFlags.NoLOD + TextureFlags.NoMipMaps)	
	Hud._matCrossBoww     = MATERIAL.Create("../ProOptions/Weapon/i_arrows", TextureFlags.NoLOD + TextureFlags.NoMipMaps)
	Hud._matScreamerw     = MATERIAL.Create("../ProOptions/Weapon/i_Brain_worms", TextureFlags.NoLOD + TextureFlags.NoMipMaps)
	Hud._matHellBladew    = MATERIAL.Create("../ProOptions/Weapon/i_skulls", TextureFlags.NoLOD + TextureFlags.NoMipMaps)
	Hud._matEctoplasmerw  = MATERIAL.Create("../ProOptions/Weapon/i_Ectoplasm", TextureFlags.NoLOD + TextureFlags.NoMipMaps)
	Hud._matEggBombw      = MATERIAL.Create("../ProOptions/Weapon/i_eggbombs", TextureFlags.NoLOD + TextureFlags.NoMipMaps)	
--Ammo
	Hud._matCube1      	  = MATERIAL.Create("../ProOptions/Ammo/kostka_close", TextureFlags.NoLOD + TextureFlags.NoMipMaps)
	Hud._matCube1a        = MATERIAL.Create("../ProOptions/Ammo/kostka_open", TextureFlags.NoLOD + TextureFlags.NoMipMaps)	
	Hud._matInfinity 	  = MATERIAL.Create("../ProOptions/Ammo/infinity", TextureFlags.NoLOD + TextureFlags.NoMipMaps)
	Hud._matBoneGun1      = MATERIAL.Create("../ProOptions/Ammo/i_bones", TextureFlags.NoLOD + TextureFlags.NoMipMaps)
	Hud._matBoneGun1a     = MATERIAL.Create("../ProOptions/Ammo/i_petrify", TextureFlags.NoLOD + TextureFlags.NoMipMaps)
	Hud._matCannonGun1    = MATERIAL.Create("../ProOptions/Ammo/kulomet_koule", TextureFlags.NoLOD + TextureFlags.NoMipMaps)	
	Hud._matCannonGun1a   = MATERIAL.Create("../ProOptions/Ammo/minigun", TextureFlags.NoLOD + TextureFlags.NoMipMaps)
	Hud._matCrossBow1     = MATERIAL.Create("../ProOptions/Ammo/i_arrows", TextureFlags.NoLOD + TextureFlags.NoMipMaps)
	Hud._matCrossBow1a    = MATERIAL.Create("../ProOptions/Ammo/i_heads", TextureFlags.NoLOD + TextureFlags.NoMipMaps)
	Hud._matZoom1         = MATERIAL.Create("../ProOptions/Ammo/zoom", TextureFlags.NoLOD + TextureFlags.NoMipMaps)
	Hud._matScreamer1     = MATERIAL.Create("../ProOptions/Ammo/i_Brain_worms", TextureFlags.NoLOD + TextureFlags.NoMipMaps)
	Hud._matScreamer1a    = MATERIAL.Create("../ProOptions/Ammo/i_broken_souls", TextureFlags.NoLOD + TextureFlags.NoMipMaps)
	Hud._matHellBlade1    = MATERIAL.Create("../ProOptions/Ammo/i_skulls", TextureFlags.NoLOD + TextureFlags.NoMipMaps)
	Hud._matHellBlade1a   = MATERIAL.Create("../ProOptions/Ammo/i_Dark_energy", TextureFlags.NoLOD + TextureFlags.NoMipMaps)
	Hud._matEctoplasmer1  = MATERIAL.Create("../ProOptions/Ammo/i_Ectoplasm", TextureFlags.NoLOD + TextureFlags.NoMipMaps)
	Hud._matEctoplasmer1a = MATERIAL.Create("../ProOptions/Ammo/i_GreenGoo", TextureFlags.NoLOD + TextureFlags.NoMipMaps)
	Hud._matEggBomb1      = MATERIAL.Create("../ProOptions/Ammo/i_eggbombs", TextureFlags.NoLOD + TextureFlags.NoMipMaps)
	Hud._Unallowable      = MATERIAL.Create("../ProOptions/Ammo/unallowable", TextureFlags.NoLOD + TextureFlags.NoMipMaps)
	Hud._matammoselectl   = MATERIAL.Create("../ProOptions/Ammo/pix_1", TextureFlags.NoLOD + TextureFlags.NoMipMaps)
	Hud._matammoselect2   = MATERIAL.Create("../ProOptions/Ammo/pix_2", TextureFlags.NoLOD + TextureFlags.NoMipMaps)
--Health	
	Hud._matHealth1      = MATERIAL.Create("../ProOptions/Health/energia", TextureFlags.NoLOD + TextureFlags.NoMipMaps)
--Armor	
	Hud._matArmorNormal1 = MATERIAL.Create("../ProOptions/Armor/armor", TextureFlags.NoLOD + TextureFlags.NoMipMaps)
	Hud._matArmorRed1    = MATERIAL.Create("../ProOptions/Armor/armor_czerwony", TextureFlags.NoLOD + TextureFlags.NoMipMaps)
	Hud._matArmorGreen1  = MATERIAL.Create("../ProOptions/Armor/armor_zielony", TextureFlags.NoLOD + TextureFlags.NoMipMaps)
	Hud._matArmorYellow1 = MATERIAL.Create("../ProOptions/Armor/armor_zolty", TextureFlags.NoLOD + TextureFlags.NoMipMaps)
--Colored Icones=fin===============================================================================================================================================

--###################

--Normal Icones (CurrentWeapons/Ammo)=début=============================================================================================================================
	Hud._matCube2      	  = MATERIAL.Create("HUD/kostka_open", TextureFlags.NoLOD + TextureFlags.NoMipMaps)
	Hud._matInfinity1 	  = MATERIAL.Create("HUD/infinity", TextureFlags.NoLOD + TextureFlags.NoMipMaps)
	Hud._matBoneGun2      = MATERIAL.Create("HUD/Mw_hud/i_bones", TextureFlags.NoLOD + TextureFlags.NoMipMaps)
	Hud._matBoneGun2a     = MATERIAL.Create("HUD/Mw_hud/i_petrify", TextureFlags.NoLOD + TextureFlags.NoMipMaps)
	Hud._matCannonGun2    = MATERIAL.Create("HUD/Mw_hud/i_cannonball", TextureFlags.NoLOD + TextureFlags.NoMipMaps)
	Hud._matCannonGun2a   = MATERIAL.Create("HUD/minigun", TextureFlags.NoLOD + TextureFlags.NoMipMaps)
	Hud._matCrossBow2     = MATERIAL.Create("HUD/Mw_hud/i_arrows", TextureFlags.NoLOD + TextureFlags.NoMipMaps)
	Hud._matCrossBow2a    = MATERIAL.Create("HUD/Mw_hud/i_heads", TextureFlags.NoLOD + TextureFlags.NoMipMaps)
	Hud._matZoom2         = MATERIAL.Create("HUD/zoom", TextureFlags.NoLOD + TextureFlags.NoMipMaps)
	Hud._matScreamer2     = MATERIAL.Create("HUD/Mw_hud/i_Brain_worms", TextureFlags.NoLOD + TextureFlags.NoMipMaps)
	Hud._matScreamer2a    = MATERIAL.Create("HUD/Mw_hud/i_broken_souls", TextureFlags.NoLOD + TextureFlags.NoMipMaps)
	Hud._matHellBlade2    = MATERIAL.Create("HUD/Mw_hud/i_skulls", TextureFlags.NoLOD + TextureFlags.NoMipMaps)
	Hud._matHellBlade2a   = MATERIAL.Create("HUD/Mw_hud/i_Dark_energy", TextureFlags.NoLOD + TextureFlags.NoMipMaps)
	Hud._matEctoplasmer2  = MATERIAL.Create("HUD/Mw_hud/i_Ectoplasm", TextureFlags.NoLOD + TextureFlags.NoMipMaps)
	Hud._matEggBomb2      = MATERIAL.Create("HUD/Mw_hud/i_eggbombs", TextureFlags.NoLOD + TextureFlags.NoMipMaps)
	
--Normal Icones=fin==============================================================================================================================================
--ADDED=end####################################################################################################

	self._matHealth = MATERIAL.Create("HUD/energia", TextureFlags.NoLOD + TextureFlags.NoMipMaps)
	self._matArmorNormal = MATERIAL.Create("HUD/armor", TextureFlags.NoLOD + TextureFlags.NoMipMaps)
	self._matArmorRed = MATERIAL.Create("HUD/armor_czerwony", TextureFlags.NoLOD + TextureFlags.NoMipMaps)
	self._matArmorGreen = MATERIAL.Create("HUD/armor_zielony", TextureFlags.NoLOD + TextureFlags.NoMipMaps)
	self._matArmorYellow = MATERIAL.Create("HUD/armor_zolty", TextureFlags.NoLOD + TextureFlags.NoMipMaps)
	
	self._matArmor = self._matArmorNormal
	
	if Cfg.Crosshair then
		if Cfg.Crosshair == 0 then Cfg.Crosshair = 1 end
		self._matCrosshair = MATERIAL.Create(self._crosshairs[Cfg.Crosshair], TextureFlags.NoLOD + TextureFlags.NoMipMaps)
		self._lastCross = self._crosshairs[Cfg.Crosshair]
	else
		self._matCrosshair = MATERIAL.Create("HUD/crosshair", TextureFlags.NoLOD + TextureFlags.NoMipMaps)
		self._lastCross = "HUD/crosshair"
	end
    self._matHead = MATERIAL.Create("HUD/czaszka sama", TextureFlags.NoLOD + TextureFlags.NoMipMaps)
    self._matEyes = MATERIAL.Create("HUD/oczy_do_czachy copy", TextureFlags.NoLOD + TextureFlags.NoMipMaps)
    self._matDemons = MATERIAL.Create("HUD/demon count 64 % transp", TextureFlags.NoLOD + TextureFlags.NoMipMaps)
    self._matDemonsGrey = MATERIAL.Create("HUD/demon count szary30 % transp", TextureFlags.NoLOD + TextureFlags.NoMipMaps)
    self._matNumbers = MATERIAL.Create("HUD/cyfry", TextureFlags.NoLOD + TextureFlags.NoMipMaps)
    self._matLifeIcon = MATERIAL.Create("HUD/eskulap", TextureFlags.NoLOD + TextureFlags.NoMipMaps)
    self._matShieldIcon = MATERIAL.Create("HUD/tarcza", TextureFlags.NoLOD + TextureFlags.NoMipMaps)
    self._matGameOver = MATERIAL.Create("HUD/gejm_ouwer", TextureFlags.NoLOD + TextureFlags.NoMipMaps)

		self._matHUDTop = MATERIAL.Create("HUD/Mw_hud/hud_top_black", TextureFlags.NoLOD + TextureFlags.NoMipMaps)
		self._matHUDLeft = MATERIAL.Create("HUD/Mw_hud/hud_left_black", TextureFlags.NoLOD + TextureFlags.NoMipMaps)
		self._matHUDRight = MATERIAL.Create("HUD/Mw_hud/hud_right_black", TextureFlags.NoLOD + TextureFlags.NoMipMaps)

	self._matMoney = MATERIAL.Create("HUD/ikona_dusze_zlota", TextureFlags.NoLOD + TextureFlags.NoMipMaps)
	self._matPentagram = MATERIAL.Create("HUD/pentagram", TextureFlags.NoLOD + TextureFlags.NoMipMaps)
	self._matStar = MATERIAL.Create("HUD/gwiazdka", TextureFlags.NoLOD + TextureFlags.NoMipMaps)

	for i=0,9 do
		self._matDigits[i+1] = MATERIAL.Create("HUD/numbers/"..i, TextureFlags.NoLOD + TextureFlags.NoMipMaps)
		self._matDigitsRed[i+1] = MATERIAL.Create("HUD/numbers/"..i.."_cz", TextureFlags.NoLOD + TextureFlags.NoMipMaps)
--ADDED=#########################################################################################	
		self._matDigitsT[i+1] = MATERIAL.Create("../ProOptions/numbers/"..i, TextureFlags.NoLOD + TextureFlags.NoMipMaps)
		self._matDigitsTRed[i+1] = MATERIAL.Create("../ProOptions/numbers/"..i.."_cz", TextureFlags.NoLOD + TextureFlags.NoMipMaps)
--ADDED=end##########################################################################################
	end

	self._matBossFace = MATERIAL.Create("HUD/hud_boss", TextureFlags.NoLOD + TextureFlags.NoMipMaps)
	self._matBossAlastor = MATERIAL.Create("HUD/kompas/icon_alastor", TextureFlags.NoLOD + TextureFlags.NoMipMaps)
	self._matBossGiant = MATERIAL.Create("HUD/kompas/icon_giant", TextureFlags.NoLOD + TextureFlags.NoMipMaps)
	self._matBossSwamp = MATERIAL.Create("HUD/kompas/icon_swamp", TextureFlags.NoLOD + TextureFlags.NoMipMaps)
	self._matBossThor = MATERIAL.Create("HUD/kompas/icon_thor", TextureFlags.NoLOD + TextureFlags.NoMipMaps)
	self._matBossAlastor2 = MATERIAL.Create("HUD/kompas/icon_alastor2", TextureFlags.NoLOD + TextureFlags.NoMipMaps)
	self._matBossSpider = MATERIAL.Create("HUD/kompas/icon_spider", TextureFlags.NoLOD + TextureFlags.NoMipMaps)
	self._matBossKerb1 = MATERIAL.Create("HUD/kompas/icon_kerb1", TextureFlags.NoLOD + TextureFlags.NoMipMaps)
	self._matBossKerb2 = MATERIAL.Create("HUD/kompas/icon_kerb2", TextureFlags.NoLOD + TextureFlags.NoMipMaps)
	self._matBossKerb3 = MATERIAL.Create("HUD/kompas/icon_kerb3", TextureFlags.NoLOD + TextureFlags.NoMipMaps)
	self._matBossGuardian = MATERIAL.Create("HUD/kompas/icon_guardian", TextureFlags.NoLOD + TextureFlags.NoMipMaps)
	self._matBossTank = MATERIAL.Create("HUD/kompas/icon_tank", TextureFlags.NoLOD + TextureFlags.NoMipMaps)
	self._matBossSamael = MATERIAL.Create("HUD/kompas/icon_sammael", TextureFlags.NoLOD + TextureFlags.NoMipMaps)
	self._matCompassArrow = MATERIAL.Create("HUD/kompas/strzalka_kompas", TextureFlags.NoLOD + TextureFlags.NoMipMaps)
	self._matCompassArrShadow = MATERIAL.Create("HUD/kompas/strzalka_kompas_cien", TextureFlags.NoLOD + TextureFlags.NoMipMaps)
	self._matCompassArrGlow = MATERIAL.Create("HUD/kompas/strzalka_glow_next", TextureFlags.NoLOD + TextureFlags.NoMipMaps)
	self._matCompassDown = MATERIAL.Create("HUD/kompas/wsk_dol_wyl", TextureFlags.NoLOD + TextureFlags.NoMipMaps)
	self._matCompassDownOn = MATERIAL.Create("HUD/kompas/wsk_dol_wl", TextureFlags.NoLOD + TextureFlags.NoMipMaps)
	self._matCompassUp = MATERIAL.Create("HUD/kompas/wsk_gora_wyl", TextureFlags.NoLOD + TextureFlags.NoMipMaps)
	self._matCompassUpOn = MATERIAL.Create("HUD/kompas/wsk_gora_wl", TextureFlags.NoLOD + TextureFlags.NoMipMaps)
	self._arrowRot = 0.0
	
	self._matPacketLoss = MATERIAL.Create("HUD/packet_loss", TextureFlags.NoLOD + TextureFlags.NoMipMaps)

	self._matDemonCross = MATERIAL.Create("HUD/crossy/crosshair_demon_morph", TextureFlags.NoLOD + TextureFlags.NoMipMaps)

	self._matModifier = MATERIAL.Create("HUD/modifier", TextureFlags.NoLOD + TextureFlags.NoMipMaps)

--    self._matShotgunIcon = MATERIAL.Create("HUD/kulka_szotganowa", TextureFlags.NoLOD + TextureFlags.NoMipMaps)
--    self._matGrenadeIcon = MATERIAL.Create("HUD/raketa", TextureFlags.NoLOD + TextureFlags.NoMipMaps)

	CONSOLE.SetMPMsgColor( self.mpMsgColor[1], self.mpMsgColor[2], self.mpMsgColor[3] )
	CONSOLE.SetMPMsgPosition( self.mpMsgPosition[1], self.mpMsgPosition[2] )
	CONSOLE.SetMPMsgFont( self.mpMsgFont, self.mpMsgFontTex, self.mpMsgFontSize )

	self.CrossScale = Cfg.CrosshairSize

	HUD.SetTransparency( Cfg.HUDTransparency )
--ADDED=#########################################################################################	
	tmfmessageend = 0
	youarekilled = ""
--ADDED=end#########################################################################################	

end
--============================================================================
function Hud:Clear()
    if self._ShotGun then MDL.Release(self._ShotGun) end
    self.r_closestEnemy = nil
	self._nearestCheckPoint = nil
	self._lastTime = 0.0
end
--============================================================================
function Hud:Tick(delta)
    self.TickCount = self.TickCount + delta * 10
--    self.CrossScale = 0.85 +  (1 + math.sin(self.TickCount))/2 * 0.15       
end
--============================================================================
function Hud:Render(delta)
	if CONSOLE.DemoIsPlaying() then self:DrawForDemo(); return end

	local w,h = R3D.ScreenSize()
	HUD.SetFont("timesbd",26)

--ADDED=#########################################################################################
	if MPCfg.GameMode == "Duel" then
		Hud:VsPlayer()
	end
--ADDED=end#######################################################################################
	
--MODFIED=####################################################################################################
	if Cfg.PROD_HUD_Fontsize_1 == 0 then
		if not Cfg.PROD_SimpleIcons then
			fontsizes = 20
			fontcolortxt = { 230, 161, 97 }
			fonttypo = "timesbd"
			posxy = { 1.09, 3, 20, 37, 54, 71 }
		else
			fontsizes = 17
			fontcolortxt = { 255, 255, 255 }
			fonttypo = "../ProOptions/Fonts/impact"
			posxy = { 1.07, 3, 20, 37, 54, 71 }
		end
	else
		if not Cfg.PROD_SimpleIcons then
			fontsizes = 26
			fontcolortxt = { 230, 161, 97 }
			fonttypo = "timesbd"
			posxy = { 1.12, 3, 25, 47, 69, 91 }
		else
			fontsizes = 22
			fontcolortxt = { 255, 255, 255 }
			fonttypo = "../ProOptions/Fonts/impact"
			posxy = { 1.095, 3, 25, 47, 69, 91 }
		end
	end
	--[[if self._showFPS or (Cfg.ShowFPS and Game.GMode ~= GModes.SingleGame) then
		local fps = string.format("FPS: %d",R3D.GetFPS())
		HUD.SetFont("timesbd",26)
		HUD.PrintXY(w-HUD.GetTextWidth(fps)+1,1,fps,"timesbd",15,15,15,26)
		HUD.PrintXY(w-HUD.GetTextWidth(fps),0,fps,"timesbd",230,161,97,26)
		if Game.GMode ~= GModes.SingleGame then
			local ploss = TXT.MPStats.PacketLoss..": "..NET.GetClientPacketLoss(NET.GetClientID()).."%"
			HUD.PrintXY(w-HUD.GetTextWidth(ploss)+1,HUD.GetTextHeight()+1,ploss,"timesbd",15,15,15,26)
			HUD.PrintXY(w-HUD.GetTextWidth(ploss),HUD.GetTextHeight(),ploss,"timesbd",230,161,97,26)
		end
	 end ]]--
--ShowFPS and ShowPing=début============================================================================
	if self._showFPS or Cfg.PROD_ShowFPS then
		local fps = string.format("FPS: %d",R3D.GetFPS())
		--HUD.SetFont("timesbd",26)	
		if not Cfg.PROD_SimpleIcons then
			HUD.SetFont("timesbd",26)
		else
			HUD.SetFont("../ProOptions/Fonts/impact",22)
		end
		if Cfg.PROD_Infos_Posx == 0 then
			HUD.PrintXY(w/posxy[1]+1,((768+1*posxy[2]+1)-1*768)*h/768,fps,fonttypo,15,15,15,fontsizes)
			HUD.PrintXY(w/posxy[1],((768+1*posxy[2])-1*768)*h/768,fps,fonttypo,fontcolortxt[1],fontcolortxt[2],fontcolortxt[3],fontsizes)
		else
			HUD.PrintXY(11,((768+1*posxy[2]+1)-1*768)*h/768,fps,fonttypo,15,15,15,fontsizes)
			HUD.PrintXY(10,((768+1*posxy[2])-1*768)*h/768,fps,fonttypo,fontcolortxt[1],fontcolortxt[2],fontcolortxt[3],fontsizes)
		end
    end 

    if Cfg.PROD_ShowPing then 
        local ploss = "PL: "..NET.GetClientPacketLoss(NET.GetClientID()).."%"        
        local ping = TXT.MPStats.Ping..": "..NET.GetClientPing(NET.GetClientID()) 
		
		if not Cfg.PROD_SimpleIcons then
			HUD.SetFont("timesbd",26)
		else
			HUD.SetFont("../ProOptions/Fonts/impact",22)
		end
		 
		if Cfg.PROD_ShowFPS == true then
			if Cfg.PROD_Infos_Posx == 0 then
				HUD.PrintXY(w/posxy[1]+1,((768+1*posxy[3]+1)-1*768)*h/768,ploss,fonttypo,15,15,15,fontsizes)
				HUD.PrintXY(w/posxy[1],((768+1*posxy[3])-1*768)*h/768,ploss,fonttypo,fontcolortxt[1],fontcolortxt[2],fontcolortxt[3],fontsizes) 
				HUD.PrintXY(w/posxy[1]+1,((768+1*posxy[4]+1)-1*768)*h/768,ping,fonttypo,15,15,15,fontsizes)
				HUD.PrintXY(w/posxy[1],((768+1*posxy[4])-1*768)*h/768,ping,fonttypo,fontcolortxt[1],fontcolortxt[2],fontcolortxt[3],fontsizes)
			else
				HUD.PrintXY(11,((768+1*posxy[3]+1)-1*768)*h/768,ploss,fonttypo,15,15,15,fontsizes)
				HUD.PrintXY(10,((768+1*posxy[3])-1*768)*h/768,ploss,fonttypo,fontcolortxt[1],fontcolortxt[2],fontcolortxt[3],fontsizes) 
				HUD.PrintXY(11,((768+1*posxy[4]+1)-1*768)*h/768,ping,fonttypo,15,15,15,fontsizes)
				HUD.PrintXY(10,((768+1*posxy[4])-1*768)*h/768,ping,fonttypo,fontcolortxt[1],fontcolortxt[2],fontcolortxt[3],fontsizes)
			end
		else
			if Cfg.PROD_Infos_Posx == 0 then
				HUD.PrintXY(w/posxy[1]+1,((768+1*posxy[2]+1)-1*768)*h/768,ploss,fonttypo,15,15,15,fontsizes)
				HUD.PrintXY(w/posxy[1],((768+1*posxy[2])-1*768)*h/768,ploss,fonttypo,fontcolortxt[1],fontcolortxt[2],fontcolortxt[3],fontsizes)  
				HUD.PrintXY(w/posxy[1]+1,((768+1*posxy[3]+1)-1*768)*h/768,ping,fonttypo,15,15,15,fontsizes) 
				HUD.PrintXY(w/posxy[1],((768+1*posxy[3])-1*768)*h/768,ping,fonttypo,fontcolortxt[1],fontcolortxt[2],fontcolortxt[3],fontsizes) 
			else
				HUD.PrintXY(11,((768+1*posxy[2]+1)-1*768)*h/768,ploss,fonttypo,15,15,15,fontsizes)
				HUD.PrintXY(10,((768+1*posxy[2])-1*768)*h/768,ploss,fonttypo,fontcolortxt[1],fontcolortxt[2],fontcolortxt[3],fontsizes)  
				HUD.PrintXY(11,((768+1*posxy[3]+1)-1*768)*h/768,ping,fonttypo,15,15,15,fontsizes) 
				HUD.PrintXY(10,((768+1*posxy[3])-1*768)*h/768,ping,fonttypo,fontcolortxt[1],fontcolortxt[2],fontcolortxt[3],fontsizes)
			end
		end        
    end         
--ShowFPS and ShowPing=fin============================================================================
--MODIFIED=end####################################################################################################	 
 
	if Game and Game.GMode ~= GModes.SingleGame and (self._showtimer or Cfg.ShowTimer) and Game._TimeLimitOut then
		local tm = (MPCfg.TimeLimit*60 - Game._TimeLimitOut) / 60
		if Cfg.ShowTimerCountUp == true then
			tm = (Game._TimeLimitOut) / 60
		end
        if Game._TimeLimitOut < 0 then tm = 0 end
		local m = math.floor(tm)
		local s = math.floor((tm - m) * 60)
		local red = false
		if(m <= 0.0) and Cfg.ShowTimerCountUp == false then
			red = true
		else if (m >= MPCfg.TimeLimit - 1) and Cfg.ShowTimerCountUp then
			red = true
			end
		end
		local time = string.format(m..":"..string.format("%02d",s))
--MODIFIED=####################################################################################################
--ShowTimer=début===================================================================================	
		if not Cfg.PROD_SimpleIcons then
			HUD.SetFont("timesbd",35)
		else
			HUD.SetFont("../ProOptions/Fonts/impact",fontime)
		end
		
		--[[if (self._showtimer or Cfg.ShowTimer) and Game.GMode ~= GModes.SingleGame then
			HUD.PrintXY(w-HUD.GetTextWidth(time)+1,HUD.GetTextHeight()*2+1,time,"timesbd",15,15,15,26)
			if red then
				HUD.PrintXY(w-HUD.GetTextWidth(time),HUD.GetTextHeight()*2,time,"timesbd",230,0,0,26)
			else
				HUD.PrintXY(w-HUD.GetTextWidth(time),HUD.GetTextHeight()*2,time,"timesbd",230,161,97,26)
			end 
		else if Game.GMode ~= GModes.SingleGame then
			HUD.PrintXY(w-HUD.GetTextWidth(time)+1,1,time,"timesbd",15,15,15,26)
			if red then
				HUD.PrintXY(w-HUD.GetTextWidth(time),0,time,"timesbd",230,0,0,26)
			else
				HUD.PrintXY(w-HUD.GetTextWidth(time),0,time,"timesbd",230,161,97,26)
			end 
			end
	  	end ]]--
		if Cfg.PROD_HUD_Fontsize_2 == 0 then
			fontime = 30
		elseif Cfg.PROD_HUD_Fontsize_2 == 1 then
			fontime = 35
		elseif Cfg.PROD_HUD_Fontsize_2 == 2 then
			fontime = 40
		end
		if (self._showtimer or Cfg.ShowTimer) then 
			if MPCfg.GameState ~= GameStates.WarmUp and MPCfg.GameState ~= GameStates.Counting then 
				--local text = HUD.GetTextWidth((w-HUD.GetTextWidth(time))/2)
				if not Cfg.PROD_SimpleIcons then
					--HUD.PrintXY((w-HUD.GetTextWidth(time))/2+0.5,50+1,time,"timesbd",15,15,15,26)
					HUD.PrintXY(((1024-50)/2+1)*w/1024,51,time,"timesbd",15,15,15,35)
					if red then
						HUD.PrintXY(((1024-50)/2)*w/1024,50,time,"timesbd",230,0,0,35)
					else
						--HUD.PrintXY((w-HUD.GetTextWidth(time))/2,50,time,"timesbd",230,161,97,26)
						HUD.PrintXY(((1024-50)/2)*w/1024,50,time,"timesbd",230,161,97,35)
					end
				else
					HUD.PrintXY(((1024-50)/2+1)*w/1024,51,time,"../ProOptions/Fonts/impact",15,15,15,fontime)
					if red then
						HUD.PrintXY(((1024-50)/2)*w/1024,50,time,"../ProOptions/Fonts/impact",204,0,0,fontime)
					else
						HUD.PrintXY(((1024-50)/2)*w/1024,50,time,"../ProOptions/Fonts/impact",255,255,255,fontime)	
					end
				end
			end
		end
	 end	
--ShowTimer=fin=================================================================================== 

	if not Cfg.PROD_SimpleIcons then
			bvfontcolortxt = { 230, 161, 97 }
			bvfontsizes = 26
			bvfonttypo = "timesbd"
		else
			bvfontcolortxt = { 255, 255, 255 }
			bvfontsizes = 22
			bvfonttypo = "../ProOptions/Fonts/impact"
	end
	
 	if Game and MPCfg.GameState == GameStates.Counting and Game._countTimer and Game._countTimer > 0.99 then
		if not Cfg.PROD_SimpleIcons then
			HUD.SetFont("timesbd",26)
		else
			HUD.SetFont("../ProOptions/Fonts/impact",22)
		end
		local countdown = TXT.Multiplayer.MatchBegins .. string.format("%02d",Game._countTimer)
		HUD.PrintXY((w-HUD.GetTextWidth(countdown))/2+1,24+1,countdown,bvfonttypo,15,15,15,bvfontsizes)
		HUD.PrintXY((w-HUD.GetTextWidth(countdown))/2,24,countdown,bvfonttypo,bvfontcolortxt[1],bvfontcolortxt[2],bvfontcolortxt[3],bvfontsizes)
	 end
	 
	if Game and Game._voteTimeLeft > 0 then
		local yesVotes = 0
		local noVotes = 0
		for i,o in Game.PlayerStats do
			if o._vote and o.Spectator == 0 then
				if o._vote == 1 then
					yesVotes = yesVotes + 1
				elseif o._vote == 0 then
					noVotes = noVotes + 1
				end
			end
		end
		if not Cfg.PROD_SimpleIcons then
			HUD.SetFont("timesbd",26)
		else
			HUD.SetFont("../ProOptions/Fonts/impact",22)
		end
		local currentvote = "Vote("..string.format("%02d",Game._voteTimeLeft).."): '"..Game._voteCmd.." "..Game._voteParams.."'  yes("..yesVotes..") no("..noVotes..")"
		HUD.PrintXY((w-HUD.GetTextWidth(currentvote))/2+1,h/6+1,currentvote,bvfonttypo,15,15,15,bvfontsizes)
		HUD.PrintXY((w-HUD.GetTextWidth(currentvote))/2,h/6,currentvote,bvfonttypo,200,200,200,bvfontsizes)
	end
--MODIFIED=end####################################################################################################    
    if not self.Enabled then return end

	if Player then
        if not Player._died and Game.IsDemon then
			self:QuadRGBA(self._matDemonCross,w/2,h/2,self.CrossScale,true,255,255,255,Cfg.CrosshairTrans/100.0*96)
        end
        
        if Player.HasWeaponModifier then
			HUD.DrawQuad(self._matModifier,0,0,w,h)
        end
    end

    if Game.IsDemon and not Lucifer_001 then return end

	if Cfg.Crosshair and not Game.IsDemon then
		if self._crosshairs[Cfg.Crosshair] ~= self._lastCross then
			MATERIAL.Release(self._matCrosshair)
			self._matCrosshair = MATERIAL.Create(self._crosshairs[Cfg.Crosshair], TextureFlags.NoLOD + TextureFlags.NoMipMaps)
			self._lastCross = self._crosshairs[Cfg.Crosshair]
		end
	end

	local trans = HUD.GetTransparency()
	if Game.GMode == GModes.SingleGame then
		self:QuadTrans(self._matHUDTop,(512-Cfg.HUDSize*230)*w/1024,0,Cfg.HUDSize,false,trans)
	end
	
	
	local sizex, sizey = MATERIAL.Size(self._matHUDLeft)
--MODIFIED=####################################################################################################
--Simple HUD =début=============================================================================================================================================
	if not Cfg.PROD_SimpleIcons then	
		self:QuadTrans(self._matHUDLeft,0,(768-Cfg.HUDSize*sizey)*h/768,Cfg.HUDSize,false,trans)
		self:QuadTrans(self._matHUDRight,(1024-Cfg.HUDSize*sizex)*w/1024,(768-Cfg.HUDSize*sizey)*h/768,Cfg.HUDSize,false,trans)
	end
--Simple HUD =fin=============================================================================================================================================
--MODIFIED=end####################################################################################################
	if Game.GMode == GModes.SingleGame then
		self:Quad(self._matPentagram,(512-Cfg.HUDSize*105)*w/1024,Cfg.HUDSize*14*h/768,Cfg.HUDSize,false)
		self:Quad(self._matMoney,(512+Cfg.HUDSize*55)*w/1024,Cfg.HUDSize*4*h/768,Cfg.HUDSize,false)
	end

--MODIFIED=####################################################################################################	
--Simple HUD =début=============================================================================================================================================
	if not Cfg.PROD_SimpleIcons then	
		self:Quad(self._matHealth,Cfg.HUDSize*17*w/1024,((768+Cfg.HUDSize*14)-Cfg.HUDSize*sizey)*h/768,Cfg.HUDSize,false)
	else
		self:Quad(Hud._matHealth1,Cfg.PROD_HUDSize*13*w/1024,((768+Cfg.PROD_HUDSize*23)-Cfg.PROD_HUDSize*sizey)*h/768,Cfg.PROD_HUDSize,false)
	end
--Simple HUD =fin=============================================================================================================================================
--MODIFIED=end####################################################################################################

	local y=Game._Splatn
	for i=1, y do
		if Game._Splattimeouts[i] > 0 then
			Game._Splattimeouts[i] =  Game._Splattimeouts[i] - 1
				if Game._Splattimeouts[i] > 3*Game.Splatdf/4 then
					self:QuadTrans(self._splat[Game._Splats[i].Z][1],Game._Splats[i].X,Game._Splats[i].Y,Cfg.HUDSize,false)
				else
					if Game._Splattimeouts[i] > Game.Splatdf/2 then
						self:QuadTrans(self._splat[Game._Splats[i].Z][2],Game._Splats[i].X,Game._Splats[i].Y,Cfg.HUDSize,false)
					else
						if Game._Splattimeouts[i] > Game.Splatdf/4 then
							self:QuadTrans(self._splat[Game._Splats[i].Z][3],Game._Splats[i].X,Game._Splats[i].Y,Cfg.HUDSize,false)
						else
							self:QuadTrans(self._splat[Game._Splats[i].Z][4],Game._Splats[i].X,Game._Splats[i].Y,Cfg.HUDSize,false)
						end
					end
				end

		else 
		Game._Splats[i] = Vector:New(math.random(w)-20,math.random(h)-20,1)
		end
	end
    
    if Player then
        if not Player._died and not Hud.NoCrosshair then
			self:QuadRGBA(self._matCrosshair,w/2,h/2,self.CrossScale,true,Cfg.CrosshairR,Cfg.CrosshairG,Cfg.CrosshairB,Cfg.CrosshairTrans/100.0*255)
        end
		
--ADDED=##########################################################################################	
	local tmfmessage = tonumber(string.format("%.02f",Game.currentTime/60))
	if Cfg.PROD_FragMessage then
		if tmfmessage <= tmfmessageend then
			self:FMessage()
		end
	end
--ADDED=end########################################################################################
	
--MODFIED=####################################################################################################
--Simple HUD =début=============================================================================================================================================
		if not Cfg.PROD_SimpleIcons then
			if Player.ArmorType == 0 then
				self:Quad(self._matArmorNormal,Cfg.HUDSize*17*w/1024,((768+Cfg.HUDSize*49)-Cfg.HUDSize*sizey)*h/768,Cfg.HUDSize,false)
			elseif Player.ArmorType == 1 then
				self:Quad(self._matArmorGreen,Cfg.HUDSize*17*w/1024,((768+Cfg.HUDSize*49)-Cfg.HUDSize*sizey)*h/768,Cfg.HUDSize,false)
			elseif Player.ArmorType == 2 then
				self:Quad(self._matArmorYellow,Cfg.HUDSize*17*w/1024,((768+Cfg.HUDSize*49)-Cfg.HUDSize*sizey)*h/768,Cfg.HUDSize,false)
			elseif Player.ArmorType == 3 then
				self:Quad(self._matArmorRed,Cfg.HUDSize*17*w/1024,((768+Cfg.HUDSize*49)-Cfg.HUDSize*sizey)*h/768,Cfg.HUDSize,false)
			end
		else
			if Player.ArmorType == 0 then
				self:Quad(Hud._matArmorNormal1,Cfg.PROD_HUDSize*13*w/1024,((768+Cfg.PROD_HUDSize*65)-Cfg.PROD_HUDSize*sizey)*h/768,Cfg.PROD_HUDSize,false)
			elseif Player.ArmorType == 1 then
				self:Quad(Hud._matArmorGreen1,Cfg.PROD_HUDSize*13*w/1024,((768+Cfg.PROD_HUDSize*65)-Cfg.PROD_HUDSize*sizey)*h/768,Cfg.PROD_HUDSize,false)
			elseif Player.ArmorType == 2 then
				self:Quad(Hud._matArmorYellow1,Cfg.PROD_HUDSize*13*w/1024,((768+Cfg.PROD_HUDSize*65)-Cfg.PROD_HUDSize*sizey)*h/768,Cfg.PROD_HUDSize,false)
			elseif Player.ArmorType == 3 then
				self:Quad(Hud._matArmorRed1,Cfg.PROD_HUDSize*13*w/1024,((768+Cfg.PROD_HUDSize*65)-Cfg.PROD_HUDSize*sizey)*h/768,Cfg.PROD_HUDSize,false)
			end
		end

		if not Cfg.PROD_SimpleIcons then
			if Player:GetCurWeapon() then
				Player:GetCurWeapon():DrawHUD(delta)
			end
		else
			self:CurrentAmmo()
		end
		if Cfg.PROD_AmmoList_Posix ~= 0 then
		self:AmmoList()
		end
--Simple HUD =fin=============================================================================================================================================
--MODFIED=end####################################################################################################

--ADDED=####################################################################################################		
--CurrentWeapon=début============================================================================        
		if Cfg.PROD_CurrentWeapon then
			self:CurrentWeapon()
		end	
--CurrentWeapon=fin============================================================================		
--ADDED=end####################################################################################################		
        if Game.GMode == GModes.SingleGame then
			self:DrawDigitsText((512-Cfg.HUDSize*202)*w/1024,Cfg.HUDSize*14*h/768,string.format("%05d",Game.BodyCountTotal),0.8 * Cfg.HUDSize)
			self:DrawDigitsText((512+Cfg.HUDSize*105)*w/1024,Cfg.HUDSize*14*h/768,string.format("%05d",Player.SoulsCount),0.8 * Cfg.HUDSize,5-Game.Demon_HowManyCorpses)
		end
        local he = Player.Health
        if he < 1 and he > 0 then
            he = 1
        end	
--MODFIED=####################################################################################################
--Simple HUD =début=============================================================================================================================================	
			if not Cfg.PROD_SimpleIcons then
				self:DrawDigitsText(Cfg.HUDSize*60*w/1024,((768+Cfg.HUDSize*16)-Cfg.HUDSize*sizey)*h/768,string.sub(string.format("%03d",he),-3),0.9 * Cfg.HUDSize,Player.HealthWarning)

				local armor = Player.Armor
				if Player.FrozenArmor then armor = 0 end		
					self:DrawDigitsText(Cfg.HUDSize*60*w/1024,((768+Cfg.HUDSize*50)-Cfg.HUDSize*sizey)*h/768,string.sub(string.format("%03d",armor),-3),0.9 * Cfg.HUDSize,Player.ArmorWarning)
			else
				self:DrawDigitsText(Cfg.PROD_HUDSize*56*w/1024,((768+Cfg.PROD_HUDSize*26)-Cfg.PROD_HUDSize*sizey)*h/768,string.sub(string.format("%03d",he),-3),0.9 * Cfg.PROD_HUDSize,Player.HealthWarning)

				local armor = Player.Armor
				if Player.FrozenArmor then armor = 0 end		
				self:DrawDigitsText(Cfg.PROD_HUDSize*56*w/1024,((768+Cfg.PROD_HUDSize*68)-Cfg.PROD_HUDSize*sizey)*h/768,string.sub(string.format("%03d",armor),-3),0.9 * Cfg.PROD_HUDSize,Player.ArmorWarning)
			end

--Simple HUD =end=============================================================================================================================================
--MODFIED=end####################################################################################################

    end

	if Game.GMode == GModes.SingleGame then
		local time = INP.GetTime()
		if( time - self._lastTime ) >= 1.0 then
--			Game:Print( "Update" )
			self:UpdateCompass()
			self._lastTime = time
		end

		if self.showCompassArrow == true then
			self:RenderCompass()
		end

		if Game.MegaBossHealth and Game.MegaBossHealthMax then
			local size = Game.MegaBossHealth / Game.MegaBossHealthMax
			if Game.Kerberosface == 1 then
				self:Quad(self._matBossKerb1,(512-Cfg.HUDSize*48)*w/1024,Cfg.HUDSize*10*h/768,Cfg.HUDSize,false)
			elseif Game.Kerberosface == 2 then
				self:Quad(self._matBossKerb2,(512-Cfg.HUDSize*48)*w/1024,Cfg.HUDSize*10*h/768,Cfg.HUDSize,false)
			elseif Game.Kerberosface == 3 then
				self:Quad(self._matBossKerb3,(512-Cfg.HUDSize*48)*w/1024,Cfg.HUDSize*10*h/768,Cfg.HUDSize,false)
			elseif Game.Guardian then
				self:Quad(self._matBossGuardian,(512-Cfg.HUDSize*48)*w/1024,Cfg.HUDSize*10*h/768,Cfg.HUDSize,false)
			elseif Game.TankFA then
				self:Quad(self._matBossTank,(512-Cfg.HUDSize*48)*w/1024,Cfg.HUDSize*10*h/768,Cfg.HUDSize,false)
			elseif Game.Samael then
				self:Quad(self._matBossSamael,(512-Cfg.HUDSize*48)*w/1024,Cfg.HUDSize*10*h/768,Cfg.HUDSize,false)
			else
				self:Quad(self._matBossFace,(512-Cfg.HUDSize*48)*w/1024,Cfg.HUDSize*10*h/768,Cfg.HUDSize,false)
			end
			if size < 0.01 and Game.MegaBossHealth > 0 then size = 0.01 end
			HUD.DrawBossHealth( size * 100 )
		else
			self:RenderUpDown()
		end

		if self._showSPStats then
			self:RenderSPStats()
		end

		if self._showCheckPointInfo then
			local w,h = R3D.ScreenSize()
			HUD.DrawBorder(312,200,400,140)
			HUD.PrintXY(-1,240*h/768,Languages.Texts[647],"timesbd",230,161,97,26)
			HUD.PrintXY(-1,280*h/768,Languages.Texts[648].."...","timesbd",230,161,97,26)
		end

		if self._overlayMessage ~= "" and self._overlayMsgStart == 0 then
			self._overlayMsgStart = INP.GetTime()
		end

		if self._overlayMessage ~= "" and ( INP.GetTime() - self._overlayMsgStart ) < 5 then
			local w,h = R3D.ScreenSize()
			HUD.SetFont("timesbd",26)
			local tw = HUD.GetTextWidth(self._overlayMessage)
			local th = HUD.GetTextHeight(self._overlayMessage)
			HUD.DrawBorder(((w-tw)/2)*1024/w-20,198,tw*1024/w+40,th*768/h+40)
			HUD.PrintXY(-1,220*h/768,self._overlayMessage,"timesbd",230,161,97,26)
		else
			self._overlayMessage = ""
			self._overlayMsgStart = 0
		end
	end

	if Game.Paused then
		local w,h = R3D.ScreenSize()
		HUD.DrawQuadRGBA(nil,0,0,w,h,0,0,0,90)
		HUD.DrawBorder(332,220,360,100)
		HUD.PrintXY(-1,260*h/768,Languages.Texts[709],"timesbd",230,161,97,26)
	end

    if Game.IsDemon then return end
	
--MODFIED=####################################################################################################
--Simple HUD =début=============================================================================================================================================	    
    --[[  speedmeter
    if  Tweak.PlayerMove.ShowSpeedmeter and Player and Player._Entity then
        local vx,vy,vz,vl = ENTITY.GetVelocity(Player._Entity)
        local hl = Dist2D(0,0,vx,vz) 
        HUD.DrawQuadRGBA(nil,w/2-50,h-17,100,13,100,100,100)
        HUD.DrawQuadRGBA(nil,w/2-50,h-17,hl*2,13,255,0,0)
        HUD.PrintXY(w/2-10,h-15,string.format("%.02f",hl))
    end ]]--
	
  if Cfg.PROD_ShowSpeedmeter == 1 or Cfg.PROD_ShowSpeedmeter == 2 then
	if Player and Player._Entity then
		local w,h = R3D.ScreenSize()
		local vx,vy,vz,vl = ENTITY.GetVelocity(Player._Entity)
		local hl = Dist2D(0,0,vx,vz)
		if Cfg.PROD_ShowSpeedmeter == 2 then
			hll = Dist2D(0,0,vx,vz)
		else
			hll = 0
		end
		local ups = string.format("Ups: %.01f",hl)
		
		if not Cfg.PROD_SimpleIcons then
			HUD.SetFont("timesbd",26)
		else
			HUD.SetFont("../ProOptions/Fonts/impact",22)
		end
	
			if Cfg.PROD_ShowFPS == true and Cfg.PROD_ShowPing == false then
				if Cfg.PROD_Infos_Posx == 0 then
					HUD.DrawQuadRGBA(nil,w/posxy[1],((768+1*posxy[4])-1*768)*h/768,hll*1.6,3*h/768,0,255,0)
					HUD.PrintXY(w/posxy[1]+1,((768+1*posxy[3]+1)-1*768)*h/768,ups,fonttypo,15,15,15,fontsizes)
					HUD.PrintXY(w/posxy[1],((768+1*posxy[3])-1*768)*h/768,ups,fonttypo,fontcolortxt[1],fontcolortxt[2],fontcolortxt[3],fontsizes)
				else
					HUD.DrawQuadRGBA(nil,10,((768+1*posxy[4])-1*768)*h/768,hll*1.6,3*h/768,0,255,0)
					HUD.PrintXY(11,((768+1*posxy[3]+1)-1*768)*h/768,ups,fonttypo,15,15,15,fontsizes)
					HUD.PrintXY(10,((768+1*posxy[3])-1*768)*h/768,ups,fonttypo,fontcolortxt[1],fontcolortxt[2],fontcolortxt[3],fontsizes)
				end
				
			elseif Cfg.PROD_ShowPing == true and Cfg.PROD_ShowFPS == false then
				if Cfg.PROD_Infos_Posx == 0 then
					HUD.DrawQuadRGBA(nil,w/posxy[1],((768+1*posxy[5])-1*768)*h/768,hll*1.6,3*h/768,0,255,0)
					HUD.PrintXY(w/posxy[1]+1,((768+1*posxy[4]+1)-1*768)*h/768,ups,fonttypo,15,15,15,fontsizes)
					HUD.PrintXY(w/posxy[1],((768+1*posxy[4])-1*768)*h/768,ups,fonttypo,fontcolortxt[1],fontcolortxt[2],fontcolortxt[3],fontsizes)
				else
					HUD.DrawQuadRGBA(nil,10,((768+1*posxy[5])-1*768)*h/768,hll*1.6,3*h/768,0,255,0)
					HUD.PrintXY(11,((768+1*posxy[4]+1)-1*768)*h/768,ups,fonttypo,15,15,15,fontsizes)
					HUD.PrintXY(10,((768+1*posxy[4])-1*768)*h/768,ups,fonttypo,fontcolortxt[1],fontcolortxt[2],fontcolortxt[3],fontsizes)
				end
				
        	elseif Cfg.PROD_ShowFPS == true and Cfg.PROD_ShowPing == true then
				if Cfg.PROD_Infos_Posx == 0 then
					HUD.DrawQuadRGBA(nil,w/posxy[1],((768+1*posxy[6])-1*768)*h/768,hll*1.6,3*h/768,0,255,0)
					HUD.PrintXY(w/posxy[1]+1,((768+1*posxy[5]+1)-1*768)*h/768,ups,fonttypo,15,15,15,fontsizes)
					HUD.PrintXY(w/posxy[1],((768+1*posxy[5])-1*768)*h/768,ups,fonttypo,fontcolortxt[1],fontcolortxt[2],fontcolortxt[3],fontsizes)
				else
					HUD.DrawQuadRGBA(nil,10,((768+1*posxy[6])-1*768)*h/768,hll*1.6,3*h/768,0,255,0)
					HUD.PrintXY(11,((768+1*posxy[5]+1)-1*768)*h/768,ups,fonttypo,15,15,15,fontsizes)
					HUD.PrintXY(10,((768+1*posxy[5])-1*768)*h/768,ups,fonttypo,fontcolortxt[1],fontcolortxt[2],fontcolortxt[3],fontsizes)
				end
				
			else
				if Cfg.PROD_Infos_Posx == 0 then
					HUD.DrawQuadRGBA(nil,w/posxy[1],((768+1*posxy[3])-1*768)*h/768,hll*1.6,3*h/768,0,255,0)
					HUD.PrintXY(w/posxy[1]+1,((768+1*posxy[2]+1)-1*768)*h/768,ups,fonttypo,15,15,15,fontsizes)
					HUD.PrintXY(w/posxy[1],((768+1*posxy[2])-1*768)*h/768,ups,fonttypo,fontcolortxt[1],fontcolortxt[2],fontcolortxt[3],fontsizes)
				else
					HUD.DrawQuadRGBA(nil,10,((768+1*posxy[3])-1*768)*h/768,hll*1.6,3*h/768,0,255,0)
					HUD.PrintXY(11,((768+1*posxy[2]+1)-1*768)*h/768,ups,fonttypo,15,15,15,fontsizes)
					HUD.PrintXY(10,((768+1*posxy[2])-1*768)*h/768,ups,fonttypo,fontcolortxt[1],fontcolortxt[2],fontcolortxt[3],fontsizes)
				end
			end

	end
  end
--Simple HUD =fin=============================================================================================================================================	
--MODFIED=end####################################################################################################

    
    if self._showPacketLoss and Game.GMode ~= GModes.SingleGame then
		local w,h = R3D.ScreenSize()
		local mw,mh = MATERIAL.Size(self._matPacketLoss)
		HUD.DrawQuad(self._matPacketLoss,w-(mw+8)*w/1024,8*h/768,mw*w/1024,mh*h/768)
    end


end
--============================================================================
function Hud:DrawForDemo()
	local w,h = R3D.ScreenSize()
	
	if self._showFPS or (Cfg.ShowFPS and Game.GMode ~= GModes.SingleGame) then
		local fps = string.format("FPS: %d",R3D.GetFPS())
		HUD.SetFont("timesbd",26)
		HUD.PrintXY(w-HUD.GetTextWidth(fps)+1,1,fps,"timesbd",15,15,15,26)
		HUD.PrintXY(w-HUD.GetTextWidth(fps),0,fps,"timesbd",230,161,97,26)
	 end
end
--============================================================================
function Hud:DrawSingleStat(index,name,val,total,bonus,show_star)
	local w,h = R3D.ScreenSize()

	HUD.SetFont("timesbd",26)
	local fh = HUD.GetTextHeight() + 8 * h/768

	local sepPos = w/2 + 50*w/1024
	local spos = 0
	local sepWidth = HUD.GetTextWidth( ": " )
	local slashWidth = HUD.GetTextWidth( "/" )
	local numWidth = HUD.GetTextWidth( "000" )
	local minPos = sepPos + sepWidth
	local slashPos = minPos + numWidth
	local maxPos = slashPos + slashWidth

	local y = h/2-fh*5+index*fh

	local colorTxt = { 230, 161, 97 }
	local colorMin = { 214, 0, 23 }
	local colorMax = { 189, 0, 0 }

	spos = sepPos - HUD.GetTextWidth( name )
	HUD.PrintXY(spos,y,name..": ","timesbd",colorTxt[1],colorTxt[2],colorTxt[3],26)

	local star_pos = maxPos

	if val < 1000 then
		HUD.PrintXY(minPos,y,string.format("%03d",val),"timesbd",colorMin[1],colorMin[2],colorMin[3],26)
		HUD.PrintXY(slashPos,y,"/","timesbd",colorTxt[1],colorTxt[2],colorTxt[3],26)
		HUD.PrintXY(maxPos,y,string.format("%03d",total),"timesbd",colorMax[1],colorMax[2],colorMax[3],26)
		if bonus and bonus > 0 then
			HUD.PrintXY(maxPos+HUD.GetTextWidth(string.format("%03d",total)),y,string.format("+%d",bonus),"timesbd",120,120,120,26)
			star_pos = maxPos+HUD.GetTextWidth(string.format("%03d+%d",total,bonus))
		else
			star_pos = maxPos+HUD.GetTextWidth(string.format("%03d",total))
		end
	else
		local len = HUD.GetTextWidth(string.format("%d",val))
		local diff = len - HUD.GetTextWidth("000")
		HUD.PrintXY(minPos,y,string.format("%03d",val),"timesbd",colorMin[1],colorMin[2],colorMin[3],26)
		HUD.PrintXY(slashPos+diff,y,"/","timesbd",colorTxt[1],colorTxt[2],colorTxt[3],26)
		HUD.PrintXY(maxPos+diff,y,string.format("%03d",total),"timesbd",colorMax[1],colorMax[2],colorMax[3],26)
		if bonus and bonus > 0 then
			HUD.PrintXY(maxPos+diff+HUD.GetTextWidth(string.format("%03d",total)),y,string.format("+%d",bonus),"timesbd",120,120,120,26)
			star_pos = maxPos+HUD.GetTextWidth(string.format("%03d+%d",total,bonus))
		else
			star_pos = maxPos+HUD.GetTextWidth(string.format("%03d",total))
		end
	end

	if show_star and val >= total then
		self:Quad(self._matStar,star_pos,y+HUD.GetTextHeight()/2-18*h/768,1)
	end
end
--============================================================================
function Hud:RenderSPStats()
	local colorTxt = { 230, 161, 97 }
	local colorMin = { 214, 0, 23 }
	local colorMax = { 189, 0, 0 }

	HUD.DrawBorder(100,128,824,560)

	local w,h = R3D.ScreenSize()

	HUD.SetFont("timesbd",26)
	local fh = HUD.GetTextHeight() + 8 * h/768

	HUD.PrintXY(-1,h/2-fh*7,TXT.SPStats.YourScore,"timesbd",colorTxt[1],colorTxt[2],colorTxt[3],26)

	local min = math.abs(Game.LevelTime / 60)
	local sec = math.mod(Game.LevelTime, 60)

	local sepPos = w/2 + 50*w/1024
	local spos = 0
	local sepWidth = HUD.GetTextWidth( ": " )
	local slashWidth = HUD.GetTextWidth( "/" )
	local numWidth = HUD.GetTextWidth( "000" )
	local minPos = sepPos + sepWidth
	local slashPos = minPos + numWidth
	local maxPos = slashPos + slashWidth

	spos = sepPos - HUD.GetTextWidth( TXT.SPStats.GameplayTime )
	HUD.PrintXY(spos,h/2-fh*5,TXT.SPStats.GameplayTime..": ","timesbd",colorTxt[1],colorTxt[2],colorTxt[3],26)
	if min < 60 then
		HUD.PrintXY(minPos,h/2-fh*5,string.format("%02d",min)..":"..string.format("%02d",sec),"timesbd",colorMin[1],colorMin[2],colorMin[3],26)
	else
		local hour = math.floor(min/60)
		min = min - hour * 60
		HUD.PrintXY(minPos,h/2-fh*5,string.format("%02d",hour)..":"..string.format("%02d",min)..":"..string.format("%02d",sec),"timesbd",colorMin[1],colorMin[2],colorMin[3],26)
	end

	local diff = { TXT.Menu.Daydream, TXT.Menu.Insomnia, TXT.Menu.Nightmare, TXT.Menu.Trauma }

	spos = sepPos - HUD.GetTextWidth( TXT.SPStats.Difficulty )
	HUD.PrintXY(spos,h/2-fh*4,TXT.SPStats.Difficulty..": ","timesbd",colorTxt[1],colorTxt[2],colorTxt[3],26)
	HUD.PrintXY(minPos,h/2-fh*4,diff[Game.Difficulty+1],"timesbd",colorMin[1],colorMin[2],colorMin[3],26)

    if not Player then return end
	self:DrawSingleStat(2,TXT.SPStats.MonstersKilled,Game.BodyCountTotal,Game.TotalActors)
	self:DrawSingleStat(3,TXT.SPStats.SoulsCollected,Player.TotalSoulsCount,Game.TotalSouls)
	self:DrawSingleStat(4,TXT.SPStats.GoldFound,Game.PlayerMoneyFound-Player.BonusItems,Game.TotalMoney,Player.BonusItems)
	HUD.DrawQuadRGBA(nil,300*w/1024,h/2-5*h/768,440*w/1024,1,230,161,97,255)
	self:DrawSingleStat(5,TXT.SPStats.ArmorFound,Player.ArmorFound,Game.TotalArmor,nil,true)
	self:DrawSingleStat(6,TXT.SPStats.HolyItemsFound,Player.HolyItems,Game.TotalHolyItems,nil,true)
	self:DrawSingleStat(7,TXT.SPStats.AmmoFound,Game.PlayerAmmoFound,Game.TotalAmmo,nil,true)
	self:DrawSingleStat(8,TXT.SPStats.ObjectsDestroyed,Game.PlayerDestroyedItems,Game.TotalDestroyed,nil,true)
	self:DrawSingleStat(9,TXT.SPStats.SecretsFound,Player.SecretsFound,Game.TotalSecrets,nil,true)

	HUD.PrintXY(-1,h/2+fh*6-8*w/768,TXT.SPStats.CardCondition..":","timesbd",colorTxt[1],colorTxt[2],colorTxt[3],26)
	HUD.PrintXY(-1,h/2+fh*7-8*w/768,Lev._CardTask,"timesbd",colorMax[1],colorMax[2],colorMax[3],26)

	local cardStatus = Lev:GetCardStatus()
	local cardText = TXT.SPStats.Locked
	if cardStatus == 0 then
		cardText = TXT.SPStats.Failed
	elseif cardStatus == 1 then
		cardText = TXT.SPStats.Unlocked
	end

	if Game.Difficulty == 0 or Lev._Name == "C6L0_PCFHQ" then
		cardText = TXT.SPStats.NA
	end

	local statLen = HUD.GetTextWidth(TXT.SPStats.Status..": "..cardText)
	HUD.PrintXY(w/2-statLen/2,h/2+fh*8-8*w/768,TXT.SPStats.Status..": ","timesbd",colorTxt[1],colorTxt[2],colorTxt[3],26)
	HUD.PrintXY(w/2+statLen/2-HUD.GetTextWidth(cardText),h/2+fh*8-8*w/768,cardText,"timesbd",colorMin[1],colorMin[2],colorMin[3],26)
end
--============================================================================
function Hud:DrawSingleStat2(index,name,val,total,bonus,show_star,diff)
	local w,h = R3D.ScreenSize()

	HUD.SetFont("timesbd",26)
	local fh = HUD.GetTextHeight() + 8 * h/768

	local sepPos = w/2 - 80*w/1024
	local spos = 0
	local sepWidth = HUD.GetTextWidth( ": " )
	local slashWidth = HUD.GetTextWidth( "/" )
	local numWidth = HUD.GetTextWidth( "000" )
	local minPos = sepPos + sepWidth
	local slashPos = minPos + numWidth
	local maxPos = slashPos + slashWidth

	local y = h/2-fh*5+index*fh

	local colorTxt = { 230, 161, 97 }
	local colorMin = { 214, 0, 23 }
	local colorMax = { 189, 0, 0 }

	spos = sepPos - HUD.GetTextWidth( name )
	HUD.PrintXY(spos,y,name..": ","timesbd",colorTxt[1],colorTxt[2],colorTxt[3],26)

	local star_pos = maxPos

	if val < 1000 then
		HUD.PrintXY(minPos,y,string.format("%03d",val),"timesbd",colorMin[1],colorMin[2],colorMin[3],26)
		HUD.PrintXY(slashPos,y,"/","timesbd",colorTxt[1],colorTxt[2],colorTxt[3],26)
		HUD.PrintXY(maxPos,y,string.format("%03d",total),"timesbd",colorMax[1],colorMax[2],colorMax[3],26)
		if bonus and bonus > 0 then
			HUD.PrintXY(maxPos+HUD.GetTextWidth(string.format("%03d",total)),y,string.format("+%d",bonus),"timesbd",120,120,120,26)
			star_pos = maxPos+HUD.GetTextWidth(string.format("%03d+%d",total,bonus))
		else
			star_pos = maxPos+HUD.GetTextWidth(string.format("%03d",total))
		end
	else
		local len = HUD.GetTextWidth(string.format("%d",val))
		local diff = len - HUD.GetTextWidth("000")
		HUD.PrintXY(minPos,y,string.format("%03d",val),"timesbd",colorMin[1],colorMin[2],colorMin[3],26)
		HUD.PrintXY(slashPos+diff,y,"/","timesbd",colorTxt[1],colorTxt[2],colorTxt[3],26)
		HUD.PrintXY(maxPos+diff,y,string.format("%03d",total),"timesbd",colorMax[1],colorMax[2],colorMax[3],26)
		if bonus and bonus > 0 then
			HUD.PrintXY(maxPos+diff+HUD.GetTextWidth(string.format("%03d",total)),y,string.format("+%d",bonus),"timesbd",120,120,120,26)
			star_pos = maxPos+HUD.GetTextWidth(string.format("%03d+%d",total,bonus))
		else
			star_pos = maxPos+HUD.GetTextWidth(string.format("%03d",total))
		end
	end

	if show_star and val >= total then
		self:Quad(self._matStar,star_pos,y+HUD.GetTextHeight()/2-18*h/768,1)
	end
	
	if diff then
		HUD.PrintXY(maxPos + HUD.GetTextWidth("000000000"),y,string.format("(%s)",diff),"timesbd",colorTxt[1],colorTxt[2],colorTxt[3],26)
	end
end
--============================================================================
function Hud_RenderLevelStats()
	if not Game then return end

	local name = PMENU.MapGetCurrLevelName()
	Game:MakeEmptyLevelStats(name)

	local stats = Game.LevelsStats[name]
	if not stats then return end
	
--	if stats.GameplayTime < 1 then return end

	local colorTxt = { 230, 161, 97 }
	local colorMin = { 214, 0, 23 }
	local colorMax = { 189, 0, 0 }

	HUD.DrawBorder(65,128,894,560)

	local w,h = R3D.ScreenSize()

	HUD.SetFont("timesbd",26)
	local fh = HUD.GetTextHeight() + 8 * h/768

	HUD.PrintXY(-1,h/2-fh*7,TXT.SPStats.BestScore,"timesbd",colorTxt[1],colorTxt[2],colorTxt[3],26)

	local min = math.abs(stats.GameplayTime / 60)
	local sec = math.mod(stats.GameplayTime, 60)

	local sepPos = w/2 - 80*w/1024
	local spos = 0
	local sepWidth = HUD.GetTextWidth( ": " )
	local slashWidth = HUD.GetTextWidth( "/" )
	local numWidth = HUD.GetTextWidth( "000" )
	local minPos = sepPos + sepWidth
	local slashPos = minPos + numWidth
	local maxPos = slashPos + slashWidth

	local diff = { TXT.Menu.Daydream, TXT.Menu.Insomnia, TXT.Menu.Nightmare, TXT.Menu.Trauma }

	spos = sepPos - HUD.GetTextWidth( TXT.SPStats.GameplayTime )
	HUD.PrintXY(spos,h/2-fh*5,TXT.SPStats.GameplayTime..": ","timesbd",colorTxt[1],colorTxt[2],colorTxt[3],26)
	if min < 60 then
		HUD.PrintXY(minPos,h/2-fh*5,string.format("%02d",min)..":"..string.format("%02d",sec),"timesbd",colorMin[1],colorMin[2],colorMin[3],26)
	else
		local hour = math.floor(min/60)
		min = min - hour * 60
		HUD.PrintXY(minPos,h/2-fh*5,string.format("%02d",hour)..":"..string.format("%02d",min)..":"..string.format("%02d",sec),"timesbd",colorMin[1],colorMin[2],colorMin[3],26)
	end

	if diff[stats.TimeDiff+1] then
		HUD.PrintXY(maxPos + HUD.GetTextWidth("000000000"),h/2-fh*5,string.format("(%s)",diff[stats.TimeDiff+1]),"timesbd",colorTxt[1],colorTxt[2],colorTxt[3],26)
	end

	local show_stars = true
	if stats.GameplayTime == 0 then show_stars = false end

	Hud:DrawSingleStat2(1,TXT.SPStats.MonstersKilled,stats.MonstersKilled,stats.TotalMonsters,nil,false,diff[stats.MonstersDiff+1])
	Hud:DrawSingleStat2(2,TXT.SPStats.SoulsCollected,stats.SoulsCollected,stats.TotalSouls,nil,false,diff[stats.SoulsDiff+1])
	Hud:DrawSingleStat2(3,TXT.SPStats.GoldFound,stats.GoldFound,stats.TotalGold,stats.BonusItems,false,diff[stats.GoldDiff+1])
	HUD.DrawQuadRGBA(nil,300*w/1024,h/2-5*h/768-fh/2,440*w/1024,1,230,161,97,255)
	Hud:DrawSingleStat2(5,TXT.SPStats.ArmorFound,stats.ArmorsFound,stats.TotalArmors,nil,show_stars,diff[stats.ArmorsDiff+1])
	Hud:DrawSingleStat2(6,TXT.SPStats.HolyItemsFound,stats.HolyItemsFound,stats.TotalHolyItems,nil,show_stars,diff[stats.HolyDiff+1])
	Hud:DrawSingleStat2(7,TXT.SPStats.AmmoFound,stats.AmmoFound,stats.TotalAmmo,nil,show_stars,diff[stats.AmmoDiff+1])
	Hud:DrawSingleStat2(8,TXT.SPStats.ObjectsDestroyed,stats.ObjectsDestroyed,stats.TotalObjects,nil,show_stars,diff[stats.ObjectsDiff+1])
	Hud:DrawSingleStat2(9,TXT.SPStats.SecretsFound,stats.SecretsFound,stats.TotalSecrets,nil,show_stars,diff[stats.SecretsDiff+1])

	HUD.PrintXY(-1,h/2+fh*6-8*w/768,TXT.SPStats.CardCondition..":","timesbd",colorTxt[1],colorTxt[2],colorTxt[3],26)
	HUD.PrintXY(-1,h/2+fh*7-8*w/768,PMENU.MapGetCurrLevelCardCondition(),"timesbd",colorMax[1],colorMax[2],colorMax[3],26)

	local cardStatus = Game.CardsAvailable[PMENU.MapGetCurrLevelCardIndex()]
	local cardText = TXT.SPStats.Locked
	if cardStatus == true then
		cardText = TXT.SPStats.Unlocked
	end

	local statLen = HUD.GetTextWidth(TXT.SPStats.Status..": "..cardText)
	HUD.PrintXY(w/2-statLen/2,h/2+fh*8-8*w/768,TXT.SPStats.Status..": ","timesbd",colorTxt[1],colorTxt[2],colorTxt[3],26)
	HUD.PrintXY(w/2+statLen/2-HUD.GetTextWidth(cardText),h/2+fh*8-8*w/768,cardText,"timesbd",colorMin[1],colorMin[2],colorMin[3],26)
end
--============================================================================
function Hud:RenderCompass()
	if not Player then return end
	local check = false
	self.upDown = 0
	local vert = 0
	if self.r_closestEnemy then
		local tx = self.r_closestEnemy._groundx - Player._groundx
		local tz = self.r_closestEnemy._groundz - Player._groundz

		local angle = math.atan2( tx, tz )
		self._arrowRot = AngDist( Player.angle, angle )
		
		vert = self.r_closestEnemy._groundy - Player._groundy
	elseif self._nearestCheckPoint then
		local tx = self._nearestCheckPoint.Pos.X - Player._groundx
		local tz = self._nearestCheckPoint.Pos.Z - Player._groundz

		local angle = math.atan2( tx, tz )
		self._arrowRot = AngDist( Player.angle, angle )
		
		vert = self._nearestCheckPoint.Pos.Y - Player._groundy

		check = true
	else
		self._arrowRot = 0.0
	end

	if vert < -2.0 then
		self.upDown = 1
	elseif vert > 2.0 then
		self.upDown = 2
	else
		self.upDown = 0
	end

	local time = INP.GetTime()
	if check and self._nearestIsCheckpoint then
		if self._glowTrans <= 0 and time - self._glowStart > 1.5 then
			local dist = Dist3D(self._nearestCheckPoint.Pos.X,self._nearestCheckPoint.Pos.Y,self._nearestCheckPoint.Pos.Z,Player._groundx,Player._groundy,Player._groundz)
			local vol = 120 - 4 * dist
			if vol > 0 then
				if vol > 100 then vol = 100 end
				PlaySound2D("pickup_health_minisphere",vol,true,false)
			end
			self._glowDir = 1
			self._glowTrans = 0
		end
		if self._glowTrans >= 255 then
			self._glowDir = -1
			self._glowTrans = 255
			self._glowStart = time
		end

		if ( time - self._glowTime ) > 0.001 then
			if self._glowDir == 1 then
				self._glowTrans = self._glowTrans + self._glowDir * 18
			else
				self._glowTrans = self._glowTrans + self._glowDir * 6
			end
			if self._glowTrans <= 0 then
				self._glowTrans = 0
			end
			if self._glowTrans >= 255 then
				self._glowTrans = 255
			end
			self._glowTime = time
		end
	else
		self._glowTrans = 0;
	end

	if self._glowTrans2 <= Tweak.HUD.CompassUpDownStrength then
		self._glowDir2 = 1
		self._glowTrans2 = Tweak.HUD.CompassUpDownStrength
	end
	if self._glowTrans2 >= 255 then
		self._glowDir2 = -1
		self._glowTrans2 = 255
		self._glowStart2 = time
	end

	if ( time - self._glowTime2 ) > 0.001 then
		self._glowTrans2 = self._glowTrans2 + self._glowDir2 * Tweak.HUD.CompassUpDownSpeed * ( time - self._glowTime2 )
		if self._glowTrans2 <= Tweak.HUD.CompassUpDownStrength then
			self._glowTrans2 = Tweak.HUD.CompassUpDownStrength
		end
		if self._glowTrans2 >= 255 then
			self._glowTrans2 = 255
		end
		self._glowTime2 = time
	end

	local w,h = R3D.ScreenSize()
	if not check then
		self:QuadRot(self._matCompassArrShadow,500*w/1024,Cfg.HUDSize*62*h/768,Cfg.HUDSize,self._arrowRot,516*w/1024,Cfg.HUDSize*58*h/768)
		self:QuadRot(self._matCompassArrow,495*w/1024,Cfg.HUDSize*58*h/768,Cfg.HUDSize,self._arrowRot,511*w/1024,Cfg.HUDSize*54*h/768)
	else
		self:QuadRot(self._matCompassArrShadow,500*w/1024,Cfg.HUDSize*62*h/768,Cfg.HUDSize,self._arrowRot,516*w/1024,Cfg.HUDSize*58*h/768)
		self:QuadRot(self._matCompassArrow,495*w/1024,Cfg.HUDSize*58*h/768,Cfg.HUDSize,self._arrowRot,511*w/1024,Cfg.HUDSize*54*h/768)
		self:QuadRotTrans(self._matCompassArrGlow,495*w/1024,Cfg.HUDSize*58*h/768,Cfg.HUDSize,self._arrowRot,511*w/1024,Cfg.HUDSize*54*h/768,self._glowTrans)
	end
end
--============================================================================
function Hud:RenderUpDown()
	local w,h = R3D.ScreenSize()
	local trans = HUD.GetTransparency()
	if self.upDown == 0 then
		self:QuadTrans(self._matCompassUp,(512-17*Cfg.HUDSize)*w/1024,0,Cfg.HUDSize,false,trans)
		self:QuadTrans(self._matCompassDown,(512-17*Cfg.HUDSize)*w/1024,87*Cfg.HUDSize*h/768,Cfg.HUDSize,false,trans)
	elseif self.upDown == 1 then
		self:QuadTrans(self._matCompassUp,(512-17*Cfg.HUDSize)*w/1024,0,Cfg.HUDSize,false,trans)
		self:QuadTrans(self._matCompassDownOn,(512-17*Cfg.HUDSize)*w/1024,87*Cfg.HUDSize*h/768,Cfg.HUDSize,false,self._glowTrans2)
	elseif self.upDown == 2 then
		self:QuadTrans(self._matCompassUpOn,(512-17*Cfg.HUDSize)*w/1024,0,Cfg.HUDSize,false,self._glowTrans2)
		self:QuadTrans(self._matCompassDown,(512-17*Cfg.HUDSize)*w/1024,87*Cfg.HUDSize*h/768,Cfg.HUDSize,false,trans)
	end
end
--============================================================================
function Hud:UpdateCompass()
	self.r_closestEnemy = GetNearestLiveActor()
	if self.r_closestEnemy then
		-- kill active checkpoints
		for i,v in GObjects.CheckPoints do
			if v.Frozen == false and v.BaseObj == "CheckPoint.CItem" then
				GObjects:ToKill(v)
			end
		end
	end
	self._nearestIsCheckpoint = false
	self._nearestCheckPoint, self._nearestIsCheckpoint = GetNearestCheckPoint()
end
--============================================================================
function Hud:QuadSlice(mat,mw,mh,x,y,u1,v1,u2,v2)
    if u1 > 0 then
		mw = mw * (1 - u1)
    end
    if v1 > 0 then
		mh = mh * (1 - v1)
    end

    if u2 > 0 then
		mw = mw * (u2)
    end
    if v2 > 0 then
		mh = mh * (v2)
    end
    HUD.DrawQuad(mat,x,y,mw,mh,color,u1,v1,u2,v2)
end


--============================================================================
function Hud:Quad(mat,x,y,size,center)
    local mw,mh = MATERIAL.Size(mat)
    if mw == -1 then
        Game:Print('Hud:Quad - material: '.. mat.." not found!")
        return
    end
    local w,h = R3D.ScreenSize()
    mw = mw * size * w / 1024
    mh = mh * size * h / 768
    if center then
        x = x - mw/2
        y = y - mh/2
    end
    HUD.DrawQuad(mat,x,y,mw,mh)
end
--============================================================================
function Hud:QuadUV(mat,x,y,size,center,u,v,u1,v1)
    local mw,mh = MATERIAL.Size(mat)
    local w,h = R3D.ScreenSize()
    mw = mw * size * w / 1024
    mh = mh * size * h / 768
    if center then
        x = x - mw/2
        y = y - mh/2
    end
    HUD.DrawQuad(mat,x,y,mw,mh,R3D.RGB(255,255,255),u,v,u1,v1)
end
--============================================================================
function Hud:QuadTrans(mat,x,y,size,center,trans)
    local mw,mh = MATERIAL.Size(mat)
    local w,h = R3D.ScreenSize()
    mw = mw * size * w /1024
    mh = mh * size * h / 768
    if center then
        x = x - mw/2
        y = y - mh/2
    end
    HUD.DrawQuadRGBA(mat,x,y,mw,mh,255,255,255,trans)
end
--============================================================================
function Hud:QuadTransUV(mat,x,y,size,center,trans,u,v,u1,v1)
    local mw,mh = MATERIAL.Size(mat)
    local w,h = R3D.ScreenSize()
    mw = mw * size * w /1024
    mh = mh * size * h / 768
    if center then
        x = x - mw/2
        y = y - mh/2
    end
    HUD.DrawQuadRGBA(mat,x,y,mw,mh,255,255,255,trans,u,v,u1,v1)
end
--============================================================================
function Hud:QuadRGBA(mat,x,y,size,center,r,g,b,a)
    local mw,mh = MATERIAL.Size(mat)
    local w,h = R3D.ScreenSize()
    mw = mw * size * w /1024
    mh = mh * size * h / 768
    if center then
        x = x - mw/2
        y = y - mh/2
    end
    HUD.DrawQuadRGBA(mat,x,y,mw,mh,r,g,b,a)
end
--============================================================================
function Hud:QuadRot(mat,x,y,size,angle,rotx,roty)
	local mw,mh = MATERIAL.Size(mat)
	local w,h = R3D.ScreenSize()
	mw = mw * size * w / 1024
	mh = mh * size * h / 768
	HUD.DrawQuadRotated(mat,x,y,mw,mh,angle,rotx,roty)
end
--============================================================================
function Hud:QuadRotTrans(mat,x,y,size,angle,rotx,roty,trans)
	local mw,mh = MATERIAL.Size(mat)
	local w,h = R3D.ScreenSize()
	mw = mw * size * w / 1024
	mh = mh * size * h / 768
	HUD.DrawQuadRotated(mat,x,y,mw,mh,angle,rotx,roty,255,255,255,trans)
end
--============================================================================
function Hud:DrawChar(x,y,chr,color,size)
    --Log(chr.."\n")
    local n = tonumber(chr)
    if not n then return end
    local cy = math.floor(n/4)
    local cx = n - (cy*4)
    local mw,mh = MATERIAL.Size(self._matNumbers)
    HUD.DrawQuad(self._matNumbers,x,y,mw/4*size,mh/4*size,color,cx*0.25,cy*0.25,cx*0.25+0.25,cy*0.25+0.25)
end
--============================================================================
function Hud:DrawText(x,y,txt,color,size)
    --Log("DrawText: "..txt.."\n")
    local l = string.len(txt)
    local mw,mh = MATERIAL.Size(self._matNumbers)
    for i=1,l do
        self:DrawChar(x+(i-1)*mw/4*size*0.5,y,string.sub(txt,i,i),color,size)
    end
end
--MODFIED=####################################################################################################
--Simple HUD =début=============================================================================================================================================
--============================================================================
function Hud:DrawDigit(x,y,chr,scale)
	local w,h = R3D.ScreenSize()
	local n = tonumber(chr)
    if not n then return end
    local mw,mh = MATERIAL.Size(self._matDigits[n+1])
	if not Cfg.PROD_SimpleIcons then
		HUD.DrawQuad(self._matDigits[n+1],x,y,mw*scale*w/1024,mh*scale*h/768)
	else
		HUD.DrawQuad(self._matDigitsT[n+1],x,y,mw*scale*w/1024,mh*scale*h/768)
	end
end
--============================================================================
function Hud:DrawDigitRed(x,y,chr,scale)
	local w,h = R3D.ScreenSize()
	local n = tonumber(chr)
    if not n then return end
    local mw,mh = MATERIAL.Size(self._matDigitsRed[n+1])
	if not Cfg.PROD_SimpleIcons then
		HUD.DrawQuad(self._matDigitsRed[n+1],x,y,mw*scale*w/1024,mh*scale*h/768)
	else
		HUD.DrawQuad(self._matDigitsTRed[n+1],x,y,mw*scale*w/1024,mh*scale*h/768)
	end
end
--============================================================================
function Hud:DrawDigitsText(x,y,txt,scale,warning)
	local w,h = R3D.ScreenSize()
    local l = string.len(txt)
    local mw,mh = MATERIAL.Size(self._matDigits[5])

	if warning == nil or ( warning >= 0 and warning < tonumber(txt) ) or ( warning < 0 and -warning > tonumber(txt) ) then
		for i=1,l do
			self:DrawDigit(x+(i-1)*(mw-4)*(w/1024)*scale,y,string.sub(txt,i,i),scale)
		end
	else
		for i=1,l do
			self:DrawDigitRed(x+(i-1)*(mw-4)*(w/1024)*scale,y,string.sub(txt,i,i),scale)
		end
	end
end
--============================================================================
--Simple HUD =fin=============================================================================================================================================
--MODFIED=end####################################################################################################
--============================================================================
--============================================================================
ConCommands =
{
	{ cmd = "god", params = { p1 = "GOD = true", p0 = "GOD = false", default = "p1" } },
	{ cmd = "quit", action = "Exit()" },
}
--============================================================================
function Hud_OnConsoleCommand(cmd)
    Console:OnCommand(cmd)
--    local txt = string.lower(cmd)
--    if txt == "god 1" or txt == "god" then GOD = true; return end
--    if txt == "god 0" then GOD = false; return end
    --dostring(cmd)

--[[
	local param = ""
	local found = string.find( txt, " " )
	if found then
		param = string.sub( txt, found + 1 )
		txt = string.sub( txt, 0, found - 1 )
	end

	for i=1,table.getn( ConCommands ) do
		if txt == ConCommands[i].cmd then
			Hud:ExecConsoleCommand( i, param )
			return
		end
	end

    if Player then 
        Game.SayToAll(Player.ClientID, cmd) 
    else
        Game.SayToAll(ServerID, cmd)
    end
    --]]
end
--============================================================================
function Hud_OnSayToAll(txt,color)
	if Game.GMode == GModes.SingleGame then return end
	txt = string.sub(txt,1,200)
	if not color then color = R3D.RGB(0,255,0) end -- default color 255 red PrimeviL
    Game.SayToAll(NET.GetClientID(), txt,color)
	CONSOLE.Activate(false)
end
--============================================================================
function Hud_OnSayToTeam(txt,color)
	if Game.GMode == GModes.SingleGame then return end
	txt = string.sub(txt,1,200)
    if Player then
		if not color then color = R3D.RGB(0,255,255) end -- default color 255 green PrimeviL
        Game.SayToTeam(NET.GetClientID(), txt, color)
    end
    CONSOLE.Activate(false)
end
--============================================================================
function Hud_OnSayTo(index)
	if not Cfg.MessagesTexts[index] then return end
	local txt = Cfg.MessagesTexts[index]
	local prefix = string.sub( txt, 1, 1 )
	local c = string.sub( txt, 2, 2 )
	local color = nil
	if prefix == "#" and c then
		Game:Print( "color message -"..c.."- "..txt )
		c = tonumber( c )
		if c and type(c) == "number" and c >=0 and c < 16 then
			local r,g,b = PMENU.GetTextColor(""..c)
			color = R3D.RGB(r,g,b)
			txt = string.sub( txt, 3 )
		end
	end

	if color then Game:Print( "Color ok" ) end

	if Cfg.MessagesSayAll[index] == 1 then
		Hud_OnSayToAll(txt,color)
	else
		Hud_OnSayToTeam(txt,color)
	end
end
--============================================================================
function Hud:ExecConsoleCommand( i, param )
	if ConCommands[i].params then
		if ConCommands[i].params["p"..param] then
			dostring( ConCommands[i].params["p"..param] )
		elseif param == "" then
			dostring( ConCommands[i].params[ConCommands[i].params.default] )
		end
	else
		if ConCommands[i].action then
			dostring( ConCommands[i].action )
		end
	end
end
--============================================================================
function Hud:OnConsoleTab(cmd)
    Console:OnPrompt(cmd)

    --[[
    local txt = string.lower(cmd)

	for i=1,table.getn( ConCommands ) do
		local found = string.find( ConCommands[i].cmd, txt )
		if found then
			if found == 1 then
				CONSOLE.SetCurrentText( ConCommands[i].cmd )
				return
			end
		end
	end
    --]]
end
--============================================================================
function Hud_OnConsoleTab(cmd)
	Hud:OnConsoleTab(cmd)
end
