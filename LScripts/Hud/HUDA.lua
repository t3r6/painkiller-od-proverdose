--CurrentWeapon =start=################################################################################
function Hud:CurrentWeapon()
    local w,h = R3D.ScreenSize()
	local sizex, sizey = MATERIAL.Size(Hud._matHUDLeft)
	local sizehud = Cfg.PROD_HUDSize
if Cfg.PROD_SimpleIcons then	
    if Player._CurWeaponIndex == 1 then
        Hud:QuadTrans(Hud._matCubew,((1024-64*sizehud)/2)*w/1024,((768+sizehud*41)-sizehud*sizey)*h/768,sizehud,false,255)
		
    elseif Player._CurWeaponIndex == 2 then
        Hud:QuadTrans(Hud._matBoneGunw,((1024-64*sizehud)/2)*w/1024,((768+sizehud*41)-sizehud*sizey)*h/768,sizehud,false,255)

    elseif Player._CurWeaponIndex == 3 then
        Hud:QuadTrans(Hud._matCannonGunw,((1024-64*sizehud)/2)*w/1024,((768+sizehud*41)-sizehud*sizey)*h/768,sizehud,false,255)

    elseif Player._CurWeaponIndex == 4 then
        Hud:QuadTrans(Hud._matCrossBoww,((1024-64*sizehud)/2)*w/1024,((768+sizehud*41)-sizehud*sizey)*h/768,sizehud,false,255)

    elseif Player._CurWeaponIndex == 5 then
        Hud:QuadTrans(Hud._matScreamerw,((1024-64*sizehud)/2)*w/1024,((768+sizehud*41)-sizehud*sizey)*h/768,sizehud,false,255)

    elseif Player._CurWeaponIndex == 6 then
        Hud:QuadTrans(Hud._matHellBladew,((1024-64*sizehud)/2)*w/1024,((768+sizehud*41)-sizehud*sizey)*h/768,sizehud,false,255)  
		
    elseif Player._CurWeaponIndex == 7 then
        Hud:QuadTrans(Hud._matEctoplasmerw,((1024-64*sizehud)/2)*w/1024,((768+sizehud*41)-sizehud*sizey)*h/768,sizehud,false,255)     

	elseif Player._CurWeaponIndex == 8 then
        Hud:QuadTrans(Hud._matEggBombw,((1024-64*sizehud)/2)*w/1024,((768+sizehud*41)-sizehud*sizey)*h/768,sizehud,false,255) 
	end		
else
    if Player._CurWeaponIndex == 1 then
        Hud:QuadTrans(Hud._matCube2,((1024-40*sizehud)/2)*w/1024,((768+Cfg.HUDSize*47)-Cfg.HUDSize*sizey)*h/768,1,false,255)
		
    elseif Player._CurWeaponIndex == 2 then
        Hud:QuadTrans(Hud._matBoneGun2,((1024-40*sizehud)/2)*w/1024,((768+Cfg.HUDSize*47)-Cfg.HUDSize*sizey)*h/768,1,false,255)

    elseif Player._CurWeaponIndex == 3 then
        Hud:QuadTrans(Hud._matCannonGun2,((1024-40*sizehud)/2)*w/1024,((768+Cfg.HUDSize*47)-Cfg.HUDSize*sizey)*h/768,1,false,255)

    elseif Player._CurWeaponIndex == 4 then
        Hud:QuadTrans(Hud._matCrossBow2,((1024-40*sizehud)/2)*w/1024,((768+Cfg.HUDSize*47)-Cfg.HUDSize*sizey)*h/768,1,false,255)

    elseif Player._CurWeaponIndex == 5 then
        Hud:QuadTrans(Hud._matScreamer2,((1024-40*sizehud)/2)*w/1024,((768+Cfg.HUDSize*47)-Cfg.HUDSize*sizey)*h/768,1,false,255)

    elseif Player._CurWeaponIndex == 6 then
        Hud:QuadTrans(Hud._matHellBlade2,((1024-40*sizehud)/2)*w/1024,((768+Cfg.HUDSize*47)-Cfg.HUDSize*sizey)*h/768,1,false,255)  
		
    elseif Player._CurWeaponIndex == 7 then
        Hud:QuadTrans(Hud._matEctoplasmer2,((1024-40*sizehud)/2)*w/1024,((768+Cfg.HUDSize*47)-Cfg.HUDSize*sizey)*h/768,1,false,255)     

	elseif Player._CurWeaponIndex == 8 then
        Hud:QuadTrans(Hud._matEggBomb2,((1024-40*sizehud)/2)*w/1024,((768+Cfg.HUDSize*47)-Cfg.HUDSize*sizey)*h/768,1,false,255) 
	end		
end

end
--CurrentWeapon =fin=################################################################################

--CurrentAmmo =start=################################################################################
function Hud:CurrentAmmo()
    local w,h = R3D.ScreenSize()
    local gray = R3D.RGB(120,120,70)
    local sizex, sizey = MATERIAL.Size(Hud._matHUDLeft)
	local sizehud = Cfg.PROD_HUDSize
	
	if Player._CurWeaponIndex == 1 then --RazorCube -> Cfg.SwitchFire[1]
		if not (INP.IsFireSwitched() or (not Game.SwitchFire[1] and Cfg.SwitchFire[1]) or (not Cfg.SwitchFire[1] and Game.SwitchFire[1])) then
			Hud:Quad(Hud._matCube1,(1024-52*sizehud)*w/1024,((768+sizehud*23)-sizehud*sizey)*h/768,sizehud,false)
			Hud:Quad(Hud._matCube1a,(1024-52*sizehud)*w/1024,((768+sizehud*65)-sizehud*sizey)*h/768,sizehud,false)
		else
			Hud:Quad(Hud._matCube1a,(1024-52*sizehud)*w/1024,((768+sizehud*23)-sizehud*sizey)*h/768,sizehud,false)
			Hud:Quad(Hud._matCube1,(1024-52*sizehud)*w/1024,((768+sizehud*65)-sizehud*sizey)*h/768,sizehud,false)
		end
    
		Hud:Quad(self._matInfinity,(1024-118*sizehud)*w/1024,((768+sizehud*26)-sizehud*sizey)*h/768,sizehud,false)
		Hud:Quad(self._matInfinity,(1024-118*sizehud)*w/1024,((768+sizehud*68)-sizehud*sizey)*h/768,sizehud,false)

	elseif Player._CurWeaponIndex == 2 then --Bonegun -> Cfg.SwitchFire[2]
		if not (INP.IsFireSwitched() or (not Game.SwitchFire[2] and Cfg.SwitchFire[2]) or (not Cfg.SwitchFire[2] and Game.SwitchFire[2])) then
			Hud:Quad(Hud._matBoneGun1,(1024-52*sizehud)*w/1024,((768+sizehud*23)-sizehud*sizey)*h/768,sizehud,false)
			Hud:Quad(Hud._matBoneGun1a,(1024-52*sizehud)*w/1024,((768+sizehud*65)-sizehud*sizey)*h/768,sizehud,false)
			Hud:DrawDigitsText((1024-118*sizehud)*w/1024,((768+sizehud*26)-sizehud*sizey)*h/768,string.sub(string.format("%03d",Player.Ammo.Bonegun),-3),0.9*sizehud,Player.s_SubClass.AmmoWarning.Bonegun)
			Hud:DrawDigitsText((1024-118*sizehud)*w/1024,((768+sizehud*68)-sizehud*sizey)*h/768,string.sub(string.format("%03d",Player.Ammo.StoneBullets),-3),0.9*sizehud,Player.s_SubClass.AmmoWarning.StoneBullets)
		else
			Hud:Quad(Hud._matBoneGun1,(1024-52*sizehud)*w/1024,((768+sizehud*65)-sizehud*sizey)*h/768,sizehud,false)
			Hud:Quad(Hud._matBoneGun1a,(1024-52*sizehud)*w/1024,((768+sizehud*23)-sizehud*sizey)*h/768,sizehud,false)
			Hud:DrawDigitsText((1024-118*sizehud)*w/1024,((768+sizehud*26)-sizehud*sizey)*h/768,string.sub(string.format("%03d",Player.Ammo.StoneBullets),-3),0.9*sizehud,Player.s_SubClass.AmmoWarning.StoneBullets)
			Hud:DrawDigitsText((1024-118*sizehud)*w/1024,((768+sizehud*68)-sizehud*sizey)*h/768,string.sub(string.format("%03d",Player.Ammo.Bonegun),-3),0.9*sizehud,Player.s_SubClass.AmmoWarning.Bonegun)
		end

	elseif Player._CurWeaponIndex == 3 then --CannonGun -> Cfg.SwitchFire[4]
		if not (INP.IsFireSwitched() or (not Game.SwitchFire[4] and Cfg.SwitchFire[4]) or (not Cfg.SwitchFire[4] and Game.SwitchFire[4])) then
			Hud:Quad(Hud._matCannonGun1a,(1024-52*sizehud)*w/1024,((768+sizehud*65)-sizehud*sizey)*h/768,sizehud,false)
			Hud:Quad(Hud._matCannonGun1,(1024-52*sizehud)*w/1024,((768+sizehud*23)-sizehud*sizey)*h/768,sizehud,false)
			Hud:DrawDigitsText((1024-118*sizehud)*w/1024,((768+sizehud*26)-sizehud*sizey)*h/768,string.sub(string.format("%03d",Player.Ammo.Cannonball),-3),0.9 * sizehud,Player.s_SubClass.AmmoWarning.Cannonball)
			Hud:DrawDigitsText((1024-118*sizehud)*w/1024,((768+sizehud*68)-sizehud*sizey)*h/768,string.sub(string.format("%03d",Player.Ammo.MiniGun),-3),0.9 * sizehud,Player.s_SubClass.AmmoWarning.MiniGun)
		else
			Hud:Quad(Hud._matCannonGun1a,(1024-52*sizehud)*w/1024,((768+sizehud*23)-sizehud*sizey)*h/768,sizehud,false)
			Hud:Quad(Hud._matCannonGun1,(1024-52*sizehud)*w/1024,((768+sizehud*65)-sizehud*sizey)*h/768,sizehud,false)
			Hud:DrawDigitsText((1024-118*sizehud)*w/1024,((768+sizehud*26)-sizehud*sizey)*h/768,string.sub(string.format("%03d",Player.Ammo.MiniGun),-3),0.9 * sizehud,Player.s_SubClass.AmmoWarning.MiniGun)
			Hud:DrawDigitsText((1024-118*sizehud)*w/1024,((768+sizehud*68)-sizehud*sizey)*h/768,string.sub(string.format("%03d",Player.Ammo.Cannonball),-3),0.9 * sizehud,Player.s_SubClass.AmmoWarning.Cannonball)
		end

	elseif Player._CurWeaponIndex == 4 then --MagicCrossbow -> Cfg.SwitchFire[7]
		Hud.NoCrosshair = nil
		local cr = Player:GetCurWeapon()
		if cr._zoom > 0 then
			if Cfg.PROD_Zoom_FX == 1 then
				HUD.DrawQuad(Hud._matZoom2,0,0,w,h)
				Hud.NoCrosshair = true  
			else
				HUD.DrawQuad(Hud._matZoom1,0,0,w,h)
				Hud.NoCrosshair = false  
			end
		end
		if not (INP.IsFireSwitched() or (not Game.SwitchFire[7] and Cfg.SwitchFire[7]) or (not Cfg.SwitchFire[7] and Game.SwitchFire[7])) then
			Hud:Quad(Hud._matCrossBow1,(1024-52*sizehud)*w/1024,((768+sizehud*23)-sizehud*sizey)*h/768,sizehud,false)
			Hud:Quad(Hud._matCrossBow1a,(1024-52*sizehud)*w/1024,((768+sizehud*65)-sizehud*sizey)*h/768,sizehud,false)
			Hud:DrawDigitsText((1024-118*sizehud)*w/1024,((768+sizehud*26)-sizehud*sizey)*h/768,string.sub(string.format("%04d",Player.Ammo.Arrows),-3),0.9*sizehud,Player.s_SubClass.AmmoWarning.Arrows)
			Hud:DrawDigitsText((1024-118*sizehud)*w/1024,((768+sizehud*68)-sizehud*sizey)*h/768,string.sub(string.format("%04d",Player.Ammo.Heads),-3),0.9*sizehud,Player.s_SubClass.AmmoWarning.Heads)
		else
			Hud:Quad(Hud._matCrossBow1a,(1024-52*sizehud)*w/1024,((768+sizehud*23)-sizehud*sizey)*h/768,sizehud,false)
			Hud:Quad(Hud._matCrossBow1,(1024-52*sizehud)*w/1024,((768+sizehud*65)-sizehud*sizey)*h/768,sizehud,false)
			Hud:DrawDigitsText((1024-118*sizehud)*w/1024,((768+sizehud*26)-sizehud*sizey)*h/768,string.sub(string.format("%04d",Player.Ammo.Heads),-3),0.9*sizehud,Player.s_SubClass.AmmoWarning.Heads)
			Hud:DrawDigitsText((1024-118*sizehud)*w/1024,((768+sizehud*68)-sizehud*sizey)*h/768,string.sub(string.format("%04d",Player.Ammo.Arrows),-3),0.9*sizehud,Player.s_SubClass.AmmoWarning.Arrows)
		end 

	elseif Player._CurWeaponIndex == 5 then --Screamer -> Cfg.SwitchFire[2]
		if not (INP.IsFireSwitched() or (not Game.SwitchFire[2] and Cfg.SwitchFire[2]) or (not Cfg.SwitchFire[2] and Game.SwitchFire[2])) then
			Hud:Quad(Hud._matScreamer1,(1024-52*sizehud)*w/1024,((768+sizehud*23)-sizehud*sizey)*h/768,sizehud,false)
			Hud:Quad(Hud._matScreamer1a,(1024-52*sizehud)*w/1024,((768+sizehud*65)-sizehud*sizey)*h/768,sizehud,false)
			Hud:DrawDigitsText((1024-118*sizehud)*w/1024,((768+sizehud*26)-sizehud*sizey)*h/768,string.sub(string.format("%03d",Player.Ammo.BrainWorms),-3),0.9*sizehud,Player.s_SubClass.AmmoWarning.BrainWorms)
			Hud:DrawDigitsText((1024-118*sizehud)*w/1024,((768+sizehud*68)-sizehud*sizey)*h/768,string.sub(string.format("%03d",Player.Ammo.BrokenSouls),-3),0.9*sizehud,Player.s_SubClass.AmmoWarning.BrokenSouls)
		else
			Hud:Quad(Hud._matScreamer1,(1024-52*sizehud)*w/1024,((768+sizehud*65)-sizehud*sizey)*h/768,sizehud,false)
			Hud:Quad(Hud._matScreamer1a,(1024-52*sizehud)*w/1024,((768+sizehud*23)-sizehud*sizey)*h/768,sizehud,false)
			Hud:DrawDigitsText((1024-118*sizehud)*w/1024,((768+sizehud*26)-sizehud*sizey)*h/768,string.sub(string.format("%03d",Player.Ammo.BrokenSouls),-3),0.9*sizehud,Player.s_SubClass.AmmoWarning.BrokenSouls)
			Hud:DrawDigitsText((1024-118*sizehud)*w/1024,((768+sizehud*68)-sizehud*sizey)*h/768,string.sub(string.format("%03d",Player.Ammo.BrainWorms),-3),0.9*sizehud,Player.s_SubClass.AmmoWarning.BrainWorms)
		end

	elseif Player._CurWeaponIndex == 6 then --HellBlade -> Cfg.SwitchFire[7]
		if not (INP.IsFireSwitched() or (not Game.SwitchFire[7] and Cfg.SwitchFire[7]) or (not Cfg.SwitchFire[7] and Game.SwitchFire[7])) then
			Hud:Quad(Hud._matHellBlade1,(1024-52*sizehud)*w/1024,((768+sizehud*23)-sizehud*sizey)*h/768,sizehud,false)
			Hud:Quad(Hud._matHellBlade1a,(1024-52*sizehud)*w/1024,((768+sizehud*65)-sizehud*sizey)*h/768,sizehud,false)
			Hud:DrawDigitsText((1024-118*sizehud)*w/1024,((768+sizehud*26)-sizehud*sizey)*h/768,string.sub(string.format("%04d",Player.Ammo.Skulls),-3),0.9*sizehud,Player.s_SubClass.AmmoWarning.Skulls)
			Hud:DrawDigitsText((1024-118*sizehud)*w/1024,((768+sizehud*68)-sizehud*sizey)*h/768,string.sub(string.format("%04d",Player.Ammo.DarkEnergy),-3),0.9*sizehud,Player.s_SubClass.AmmoWarning.DarkEnergy)
		else
			Hud:Quad(Hud._matHellBlade1a,(1024-52*sizehud)*w/1024,((768+sizehud*23)-sizehud*sizey)*h/768,sizehud,false)
			Hud:Quad(Hud._matHellBlade1,(1024-52*sizehud)*w/1024,((768+sizehud*65)-sizehud*sizey)*h/768,sizehud,false)
			Hud:DrawDigitsText((1024-118*sizehud)*w/1024,((768+sizehud*26)-sizehud*sizey)*h/768,string.sub(string.format("%04d",Player.Ammo.DarkEnergy),-3),0.9*sizehud,Player.s_SubClass.AmmoWarning.DarkEnergy)
			Hud:DrawDigitsText((1024-118*sizehud)*w/1024,((768+sizehud*68)-sizehud*sizey)*h/768,string.sub(string.format("%04d",Player.Ammo.Skulls),-3),0.9*sizehud,Player.s_SubClass.AmmoWarning.Skulls)
		end    
		
	elseif Player._CurWeaponIndex == 7 then --Ectoplasmer -> Cfg.SwitchFire[6]
		if not (INP.IsFireSwitched() or (not Game.SwitchFire[6] and Cfg.SwitchFire[6]) or (not Cfg.SwitchFire[6] and Game.SwitchFire[6])) then
			Hud:Quad(Hud._matEctoplasmer1,(1024-52*sizehud)*w/1024,((768+sizehud*23)-sizehud*sizey)*h/768,sizehud,false)
			Hud:Quad(Hud._matEctoplasmer1a,(1024-52*sizehud)*w/1024,((768+sizehud*65)-sizehud*sizey)*h/768,sizehud,false)
			Hud:DrawDigitsText((1024-118*sizehud)*w/1024,((768+sizehud*26)-sizehud*sizey)*h/768,string.sub(string.format("%04d",Player.Ammo.Ectoplasm),-3),0.9*sizehud,Player.s_SubClass.AmmoWarning.Ectoplasm)
			Hud:DrawDigitsText((1024-118*sizehud)*w/1024,((768+sizehud*68)-sizehud*sizey)*h/768,string.sub(string.format("%04d",Player.Ammo.GreenGoo),-3),0.9*sizehud,Player.s_SubClass.AmmoWarning.GreenGoo)
		else
			Hud:Quad(Hud._matEctoplasmer1a,(1024-52*sizehud)*w/1024,((768+sizehud*23)-sizehud*sizey)*h/768,sizehud,false)
			Hud:Quad(Hud._matEctoplasmer1,(1024-52*sizehud)*w/1024,((768+sizehud*65)-sizehud*sizey)*h/768,sizehud,false)
			Hud:DrawDigitsText((1024-118*sizehud)*w/1024,((768+sizehud*26)-sizehud*sizey)*h/768,string.sub(string.format("%04d",Player.Ammo.GreenGoo),-3),0.9*sizehud,Player.s_SubClass.AmmoWarning.GreenGoo)
			Hud:DrawDigitsText((1024-118*sizehud)*w/1024,((768+sizehud*68)-sizehud*sizey)*h/768,string.sub(string.format("%04d",Player.Ammo.Ectoplasm),-3),0.9*sizehud,Player.s_SubClass.AmmoWarning.Ectoplasm)
		end

	elseif Player._CurWeaponIndex == 8 then --EggBomb -> Cfg.SwitchFire[7]
		if not (INP.IsFireSwitched() or (not Game.SwitchFire[7] and Cfg.SwitchFire[7]) or (not Cfg.SwitchFire[7] and Game.SwitchFire[7])) then
			Hud:Quad(Hud._matEggBomb1,(1024-52*sizehud)*w/1024,((768+sizehud*23)-sizehud*sizey)*h/768,sizehud,false)
			Hud:DrawDigitsText((1024-118*sizehud)*w/1024,((768+sizehud*26)-sizehud*sizey)*h/768,string.sub(string.format("%04d",Player.Ammo.StickyBombs),-3),0.9*sizehud,Player.s_SubClass.AmmoWarning.StickyBombs)
		else
			Hud:Quad(Hud._matEggBomb1,(1024-52*sizehud)*w/1024,((768+sizehud*65)-sizehud*sizey)*h/768,sizehud,false)
			Hud:DrawDigitsText((1024-118*sizehud)*w/1024,((768+sizehud*68)-sizehud*sizey)*h/768,string.sub(string.format("%04d",Player.Ammo.StickyBombs),-3),0.9*sizehud,Player.s_SubClass.AmmoWarning.StickyBombs)
		end 
	end
end
--CurrentAmmo =fin=#########################################################################
--FragMessage =###########################################################################
function Hud:FMessage()
 local w,h = R3D.ScreenSize()
	if not Cfg.PROD_SimpleIcons then
		fmfontcolortxt = { 230, 161, 97 }
		fmfontsizes = 26
		fmfonttypo = "timesbd"
		HUD.SetFont("timesbd",26)
	else
		fmfontcolortxt = { 255, 255, 255 }
		fmfontsizes = 22
		fmfonttypo = "../ProOptions/Fonts/impact"
		HUD.SetFont("../ProOptions/Fonts/impact",22)
	end
    HUD.PrintXY((w-HUD.GetTextWidth("You killed: "..HUD.StripColorInfo(youarekilled).."!"))/2+1,450*h/768+1,"You killed: "..HUD.StripColorInfo(youarekilled).."!",fmfonttypo,15,15,15,fmfontsizes)
    HUD.PrintXY((w-HUD.GetTextWidth("You killed: "..youarekilled.."!"))/2,450*h/768,"You killed: "..youarekilled.."!",fmfonttypo,fmfontcolortxt[1],fmfontcolortxt[2],fmfontcolortxt[3],fmfontsizes)
end
--FragMessage =end###########################################################################
--Palyer VS Player =###########################################################################
function Hud:VsPlayer()
	if MPCfg.GameState == GameStates.WarmUp or MPCfg.GameState == GameStates.Counting then
	local w,h = R3D.ScreenSize()
	local pl1 = ""
	local pl2 = ""
		for i,o in Game.PlayerStats do
			if o.Spectator == 0 then
				if pl1 == "" then
					pl1 = o.Name	
				else
					pl2 = o.Name
				end
			end
		end	
		if pl1 ~= "" and pl2 ~= "" then
			if not Cfg.PROD_SimpleIcons then
				vsfontcolortxt = { 230, 161, 97 }
				vsfontsizes = 36
				vsfonttypo = "timesbd"
				HUD.SetFont("timesbd",36)
			else
				vsfontcolortxt = { 255, 255, 255 }
				vsfontsizes = 32
				vsfonttypo = "../ProOptions/Fonts/impact"
				HUD.SetFont("../ProOptions/Fonts/impact",32)
			end
		    HUD.PrintXY((w-HUD.GetTextWidth(""..HUD.StripColorInfo(pl1).."  -VS-  "..HUD.StripColorInfo(pl2)..""))/2+2,200*h/768+2,""..HUD.StripColorInfo(pl1).."  -VS-  "..HUD.StripColorInfo(pl2).."",vsfonttypo,15,15,15,vsfontsizes)
		    HUD.PrintXY((w-HUD.GetTextWidth(""..pl1.."  -VS-  "..pl2..""))/2,200*h/768,""..pl1.."  -VS-  "..pl2.."",vsfonttypo,vsfontcolortxt[1],vsfontcolortxt[2],vsfontcolortxt[3],vsfontsizes)
		end
	end
end
--Palyer VS Player =end########################################################################
--CheckScore=end########################################################################
function Hud:CheckScore()
	local playerlist = {}
	local scorelist = {}
	
		for id,li in Game.PlayerStats do 
			if li.Spectator == 0 then 
				playerlist[id] = li.ClientID 
			end
		end
	
		for ie,mi in playerlist do
			if Game.PlayerStats[playerlist[mi]].Spectator == 0 then 
				if playerlist[ie] ~= Player.ClientID then
					scorelist[ie] = Game.PlayerStats[playerlist[ie]].Score
				end
			end
		end
		
		for ig,ni in scorelist do
			checksc = scorelist[ig]
			if checksc > enemyscore then
				enemyscore = scorelist[ig]
			end
		end
		
		for ih,oi in Game.PlayerStats do 
			if oi.Spectator == 0 then 
				if Game.PlayerStats[oi.ClientID].Score == enemyscore then
					playerlistid = oi.ClientID
				end
			end
		end
end
--CheckScore=end########################################################################
--DrawScores =############################################################################
function Hud:DrawScores()
	local gteam1Score = Game._team1Score
	local gteam2Score = Game._team2Score
	local w,h = R3D.ScreenSize()
    local sizex, sizey = MATERIAL.Size(Hud._matHUDLeft)
	local scsizehud = Cfg.PROD_Score_Size
	local myscore = Game.PlayerStats[Player.ClientID].Score
	
	local scplayer1 = 0
	local scplayer2 = 0
	for i,psc in Game.PlayerStats do
		checkifenemy = psc.ClientID
		if psc.Spectator == 0 then
			if checkifenemy == Player.ClientID then
				scplayer1 = Game.PlayerStats[psc.ClientID].Score
			else
				scplayer2 = Game.PlayerStats[psc.ClientID].Score
			end
		end				
	end

	Hud:CheckScore()
		
	if not Cfg.PROD_SimpleIcons then
		--scsizehud = Cfg.HUDSize
		matminus = Hud._matMinusDef
	else
		--scsizehud = Cfg.PROD_HUDSize
		matminus = Hud._matMinus
	end
	
	if Cfg.PROD_Score_Size == 1.0 then
		upscore = 0
	else
		upscore = -190
	end
	
	if MPCfg.GameMode == "Team Deathmatch" or MPCfg.GameMode == "Capture The Flag" then
		if Cfg.Team == 0 then	
			scposxy1 = {-647+upscore, -640+upscore, 88, 81.5, -650+upscore}
			scposxy2 = {-597+upscore, -590+upscore, 88, 81.5, -600+upscore}
			markframe = scposxy1
			cmarframe = {0, 0, 140}
			--scposxy1 = {23, 29, 200, 200}
			--scposxy2 = {60, 65, 200, 200}
		elseif Cfg.Team == 1 then
			scposxy1 = {-597+upscore, -590+upscore, 88, 81.5, -600+upscore}
			scposxy2 = {-647+upscore, -640+upscore, 88, 81.5, -650+upscore}
			markframe = scposxy2
			cmarframe = {255, 0, 0}
			--scposxy1 = {60, 65, 200, 200}
			--scposxy2 = {23, 29, 200, 200}
		end
	else
			scposxy1 = {-647+upscore, -640+upscore, 88, 81.5, -650+upscore}
			scposxy2 = {-597+upscore, -590+upscore, 88, 81.5, -600+upscore}
			markframe = scposxy1
			cmarframe = {0, 0, 140}
			--scposxy1 = {23, 29, 200, 200}
			--scposxy2 = {60, 65, 200, 200}
	end
	
--minus position======================================================================	
	if gteam1Score < -9 or gteam2Score < -9 or scplayer1 < -9 or scplayer2 < -9 then
		scx = 4
	else
		scx = -14
	end
		
--TDM or CTF	
	if MPCfg.GameMode == "Team Deathmatch" or MPCfg.GameMode == "Capture The Flag" then
		HUD.DrawQuadRGBA(nil,(1024-scposxy1[3]*scsizehud)*w/1024,((768+scsizehud*scposxy1[1])-scsizehud*sizey)*h/768,(77*scsizehud)*w/1024,(50*scsizehud)*h/768,0,0,140,100)
		HUD.DrawQuadRGBA(nil,(1024-scposxy2[3]*scsizehud)*w/1024,((768+scsizehud*scposxy2[1])-scsizehud*sizey)*h/768,(77*scsizehud)*w/1024,(50*scsizehud)*h/768,255,0,0,100)
	
		--Hud:QuadTrans(Hud._matTRed,(1024-scposxy1[3]*scsizehud)*w/1024,((768+scsizehud*scposxy1[1])-scsizehud*sizey)*h/768,scsizehud,false,255)
		--Hud:QuadTrans(Hud._matTBlue,(1024-scposxy2[3]*scsizehud)*w/1024,((768+scsizehud*scposxy2[1])-scsizehud*sizey)*h/768,scsizehud,false,255)
		
		if gteam1Score < 0 then
			Hud:QuadTrans(matminus,((1024-(scposxy1[3]+scx)*scsizehud)*w/1024),((768+scsizehud*scposxy1[5])-scsizehud*sizey)*h/768,scsizehud*1.5,false,255)
		end
		if gteam2Score < 0 then
			Hud:QuadTrans(matminus,((1024-(scposxy2[3]+scx)*scsizehud)*w/1024),((768+scsizehud*scposxy2[5])-scsizehud*sizey)*h/768,scsizehud*1.5,false,255)
		end
			
		Hud:DrawDigitsText((1024-scposxy1[4]*scsizehud)*w/1024,((768+scsizehud*scposxy1[2])-scsizehud*sizey)*h/768,string.format("%3d",gteam1Score),0.9*scsizehud,nil)
		Hud:DrawDigitsText((1024-scposxy2[4]*scsizehud)*w/1024,((768+scsizehud*scposxy2[2])-scsizehud*sizey)*h/768,string.format("%3d",gteam2Score),0.9*scsizehud,nil)

--DUEL	
	elseif MPCfg.GameMode == "Duel" then
		HUD.DrawQuadRGBA(nil,(1024-scposxy1[3]*scsizehud)*w/1024,((768+scsizehud*scposxy1[1])-scsizehud*sizey)*h/768,(77*scsizehud)*w/1024,(50*scsizehud)*h/768,0,0,140,100)
		HUD.DrawQuadRGBA(nil,(1024-scposxy2[3]*scsizehud)*w/1024,((768+scsizehud*scposxy2[1])-scsizehud*sizey)*h/768,(77*scsizehud)*w/1024,(50*scsizehud)*h/768,255,0,0,100)
	
		--Hud:QuadTrans(Hud._matTRed,(1024-scposxy2[3]*scsizehud)*w/1024,((768+scsizehud*scposxy2[1])-scsizehud*sizey)*h/768,scsizehud,false,255)
		--Hud:QuadTrans(Hud._matTBlue,(1024-scposxy1[3]*scsizehud)*w/1024,((768+scsizehud*scposxy1[1])-scsizehud*sizey)*h/768,scsizehud,false,255)
		
		if scplayer1 < 0 then
			Hud:QuadTrans(matminus,((1024-(scposxy1[3]+scx)*scsizehud)*w/1024),((768+scsizehud*scposxy1[5])-scsizehud*sizey)*h/768,scsizehud*1.5,false,255)
		end
		if scplayer2 < 0 then
			Hud:QuadTrans(matminus,((1024-(scposxy2[3]+scx)*scsizehud)*w/1024),((768+scsizehud*scposxy2[5])-scsizehud*sizey)*h/768,scsizehud*1.5,false,255)
		end
		
		Hud:DrawDigitsText((1024-scposxy1[4]*scsizehud)*w/1024,((768+scsizehud*scposxy1[2])-scsizehud*sizey)*h/768,string.format("%3d",scplayer1),0.9*scsizehud,nil)
		Hud:DrawDigitsText((1024-scposxy2[4]*scsizehud)*w/1024,((768+scsizehud*scposxy2[2])-scsizehud*sizey)*h/768,string.format("%3d",scplayer2),0.9*scsizehud,nil)

--OTHER MODE
	else
		HUD.DrawQuadRGBA(nil,(1024-scposxy1[3]*scsizehud)*w/1024,((768+scsizehud*scposxy1[1])-scsizehud*sizey)*h/768,(77*scsizehud)*w/1024,(50*scsizehud)*h/768,0,0,140,100)
		HUD.DrawQuadRGBA(nil,(1024-scposxy2[3]*scsizehud)*w/1024,((768+scsizehud*scposxy2[1])-scsizehud*sizey)*h/768,(77*scsizehud)*w/1024,(50*scsizehud)*h/768,255,0,0,100)
		
	--Hud:QuadTrans(Hud._matTRed,(1024-scposxy2[3]*scsizehud)*w/1024,((768+scsizehud*scposxy2[1])-scsizehud*sizey)*h/768,scsizehud*1.3,false,255)
	--Hud:QuadTrans(Hud._matTBlue,(1024-scposxy1[3]*scsizehud)*w/1024,((768+scsizehud*scposxy1[1])-scsizehud*sizey)*h/768,scsizehud*1.3,false,255)
		
		if myscore < 0 then
			Hud:QuadTrans(matminus,((1024-(scposxy1[3]+scx)*scsizehud)*w/1024),((768+scsizehud*scposxy1[5])-scsizehud*sizey)*h/768,scsizehud*1.5,false,255)
		end
		if enemyscore < 0 then
			Hud:QuadTrans(matminus,((1024-(scposxy2[3]+scx)*scsizehud)*w/1024),((768+scsizehud*scposxy2[5])-scsizehud*sizey)*h/768,scsizehud*1.5,false,255)
		end
		
		Hud:DrawDigitsText((1024-scposxy1[4]*scsizehud)*w/1024,((768+scsizehud*scposxy1[2])-scsizehud*sizey)*h/768,string.format("%3d",myscore),0.9*scsizehud,nil)
		Hud:DrawDigitsText((1024-scposxy2[4]*scsizehud)*w/1024,((768+scsizehud*scposxy2[2])-scsizehud*sizey)*h/768,string.format("%3d",enemyscore),0.9*scsizehud,nil)
	end
	
--marking===========================================================================	
	HUD.DrawQuadRGBA(nil,(1024-markframe[3]*scsizehud)*w/1024,((768+scsizehud*markframe[1])-scsizehud*sizey)*h/768,(77*scsizehud)*w/1024,(3*scsizehud)*h/768,cmarframe[1], cmarframe[2], cmarframe[3],255)
	HUD.DrawQuadRGBA(nil,(1024-markframe[3]*scsizehud)*w/1024,((768+scsizehud*(markframe[1]+47))-scsizehud*sizey)*h/768,(77*scsizehud)*w/1024,(3*scsizehud)*h/768,cmarframe[1], cmarframe[2], cmarframe[3],255)
	HUD.DrawQuadRGBA(nil,(1024-markframe[3]*scsizehud)*w/1024,((768+scsizehud*markframe[1])-scsizehud*sizey)*h/768,(3*scsizehud)*w/1024,(50*scsizehud)*h/768,cmarframe[1], cmarframe[2], cmarframe[3],255)
	HUD.DrawQuadRGBA(nil,(1024-(markframe[3]-74)*scsizehud)*w/1024,((768+scsizehud*markframe[1])-scsizehud*sizey)*h/768,(3*scsizehud)*w/1024,(50*scsizehud)*h/768,cmarframe[1], cmarframe[2], cmarframe[3],255)
	
end
--DrawScores =end########################################################################

