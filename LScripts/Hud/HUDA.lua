--CurrentWeapon =début=################################################################################
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

--CurrentAmmo =début=################################################################################
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
			--Hud:Quad(Hud._matBoneGun1a,(1024-52*sizehud)*w/1024,((768+sizehud*65)-sizehud*sizey)*h/768,sizehud,false)
			Hud:DrawDigitsText((1024-118*sizehud)*w/1024,((768+sizehud*26)-sizehud*sizey)*h/768,string.sub(string.format("%03d",Player.Ammo.Bonegun),-3),0.9*sizehud,Player.s_SubClass.AmmoWarning.Bonegun)
			--Hud:DrawDigitsText((1024-118*sizehud)*w/1024,((768+sizehud*68)-sizehud*sizey)*h/768,string.sub(string.format("%03d",Player.Ammo.StoneBullets),-3),0.9*sizehud,Player.s_SubClass.AmmoWarning.StoneBullets)
		else
			Hud:Quad(Hud._matBoneGun1,(1024-52*sizehud)*w/1024,((768+sizehud*65)-sizehud*sizey)*h/768,sizehud,false)
			--Hud:Quad(Hud._matBoneGun1a,(1024-52*sizehud)*w/1024,((768+sizehud*23)-sizehud*sizey)*h/768,sizehud,false)
			--Hud:DrawDigitsText((1024-118*sizehud)*w/1024,((768+sizehud*26)-sizehud*sizey)*h/768,string.sub(string.format("%03d",Player.Ammo.StoneBullets),-3),0.9*sizehud,Player.s_SubClass.AmmoWarning.StoneBullets)
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
			--Hud:Quad(Hud._matEctoplasmer1a,(1024-56*sizehud)*w/1024,((768+sizehud*49)-sizehud*sizey)*h/768,sizehud,false)
			--Hud:DrawDigitsText((1024-118*sizehud)*w/1024,((768+sizehud*50)-sizehud*sizey)*h/768,string.sub(string.format("%04d",Player.Ammo.GreenGoo),-3),0.9*sizehud,Player.s_SubClass.AmmoWarning.GreenGoo)
			Hud:DrawDigitsText((1024-118*sizehud)*w/1024,((768+sizehud*26)-sizehud*sizey)*h/768,string.sub(string.format("%04d",Player.Ammo.Ectoplasm),-3),0.9*sizehud,Player.s_SubClass.AmmoWarning.Ectoplasm)
		else
			--Hud:Quad(Hud._matEctoplasmer1a,(1024-56*sizehud)*w/1024,((768+sizehud*12)-sizehud*sizey)*h/768,sizehud,false)
			Hud:Quad(Hud._matEctoplasmer1,(1024-52*sizehud)*w/1024,((768+sizehud*65)-sizehud*sizey)*h/768,sizehud,false)
			Hud:DrawDigitsText((1024-118*sizehud)*w/1024,((768+sizehud*68)-sizehud*sizey)*h/768,string.sub(string.format("%04d",Player.Ammo.Ectoplasm),-3),0.9*sizehud,Player.s_SubClass.AmmoWarning.Ectoplasm)
			--Hud:DrawDigitsText((1024-118*sizehud)*w/1024,((768+sizehud*16)-sizehud*sizey)*h/768,string.sub(string.format("%04d",Player.Ammo.GreenGoo),-3),0.9*sizehud,Player.s_SubClass.AmmoWarning.GreenGoo)
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
