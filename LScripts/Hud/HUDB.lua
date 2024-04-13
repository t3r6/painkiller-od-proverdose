function Hud:DrawDigit1(x,y,chr,scale)
	local w,h = R3D.ScreenSize()
	local n = tonumber(chr)
    if not n then return end
    local mw,mh = MATERIAL.Size(Hud._matDigits[n+1])
	if not Cfg.PROD_SimpleIcons then
		HUD.DrawQuad(Hud._matDigits[n+1],x,y,mw*scale*w/1024,mh*scale*h/768)
	else
		HUD.DrawQuad(Hud._matDigitsT[n+1],x,y,mw*scale*w/1024,mh*scale*h/768)
	end
end
--============================================================================
function Hud:DrawDigitRed1(x,y,chr,scale)
	local w,h = R3D.ScreenSize()
	local n = tonumber(chr)
    if not n then return end
    local mw,mh = MATERIAL.Size(Hud._matDigitsRed[n+1])
	if not Cfg.PROD_SimpleIcons then
		HUD.DrawQuad(Hud._matDigitsRed[n+1],x,y,mw*scale*w/1024,mh*scale*h/768)
	else
		HUD.DrawQuad(Hud._matDigitsTRed[n+1],x,y,mw*scale*w/1024,mh*scale*h/768)
	end
end
--============================================================================
function Hud:DrawDigitsText1(x,y,txt,scale,warning)
	local w,h = R3D.ScreenSize()
    local l = string.len(txt)
    local mw,mh = MATERIAL.Size(Hud._matDigits[5])

	if MPTEST or MPCfg.GameState ~= GameStates.Playing  or MPCfg.GameMode == "Voosh" then
		local mw1,mh1 = MATERIAL.Size(Hud._matInfinity)
		if not Cfg.PROD_SimpleIcons then
			local scale1 = scale*1.2
			HUD.DrawQuad(Hud._matInfinity1,x,y,mw1*scale1*w/1024,mh1*scale1*h/768)
		else
			local scale1 = scale*1.2
			HUD.DrawQuad(Hud._matInfinity,x,y,mw1*scale1*w/1024,mh1*scale1*h/768)
		end
	else
		if warning == nil or ( warning >= 0 and warning < tonumber(txt) ) or ( warning < 0 and -warning > tonumber(txt) ) then
			for i=1,l do
				self:DrawDigit1(x+(i-1)*(mw-4)*(w/1024)*scale,y,string.sub(txt,i,i),scale)
			end

		else
			for i=1,l do
				self:DrawDigitRed1(x+(i-1)*(mw-4)*(w/1024)*scale,y,string.sub(txt,i,i),scale)
			end
		end
	end		
end
--AmmoList =début=################################################################################
function Hud:AmmoList()
    local w,h = R3D.ScreenSize()
    local gray = R3D.RGB(120,120,70)
    local sizex, sizey = MATERIAL.Size(Hud._matHUDLeft)
	local sizem = 0.8
	local posiy = 280
	local trans = 255
	local matselect1 = Hud._matammoselectl
	local matselect2 = Hud._matammoselect2
	if Cfg.PROD_AmmoList_Posix == 2 then
		icoposix = sizem*13*w/1024
		textposix = sizem*56*w/1024
		selectpoxix = sizem*123*w/1024	
	else
		icoposix = (1024-52*sizem)*w/1024
		textposix = (1024-118*sizem)*w/1024
		selectpoxix = (1024-125*sizem)*w/1024
	end

--CurrentAmmo
	if Player._CurWeaponIndex == 1 then
	elseif Player._CurWeaponIndex == 2 then
		Hud:QuadTrans(matselect1,selectpoxix,((posiy+sizem*0)-sizem*sizey)*h/768,sizem,false,trans)
		--Hud:QuadTrans(Hud._matammoselect,(1024-240*sizem)*w/1024,((posiy+sizem*42)-sizem*sizey)*h/768,sizem,false,255)
    
	elseif Player._CurWeaponIndex == 3 then  
		if not (INP.IsFireSwitched() or (not Game.SwitchFire[4] and Cfg.SwitchFire[4]) or (not Cfg.SwitchFire[4] and Game.SwitchFire[4])) then
			Hud:QuadTrans(matselect1,selectpoxix,((posiy+sizem*42)-sizem*sizey)*h/768,sizem,false,trans)
			Hud:QuadTrans(matselect2,selectpoxix,((posiy+sizem*84)-sizem*sizey)*h/768,sizem,false,trans)
		else
			Hud:QuadTrans(matselect1,selectpoxix,((posiy+sizem*84)-sizem*sizey)*h/768,sizem,false,trans)
			Hud:QuadTrans(matselect2,selectpoxix,((posiy+sizem*42)-sizem*sizey)*h/768,sizem,false,trans)
		end
    
	elseif Player._CurWeaponIndex == 4 then 
		if not (INP.IsFireSwitched() or (not Game.SwitchFire[7] and Cfg.SwitchFire[7]) or (not Cfg.SwitchFire[7] and Game.SwitchFire[7])) then	
			Hud:QuadTrans(matselect1,selectpoxix,((posiy+sizem*126)-sizem*sizey)*h/768,sizem,false,trans)
			Hud:QuadTrans(matselect2,selectpoxix,((posiy+sizem*168)-sizem*sizey)*h/768,sizem,false,trans)
		else
			Hud:QuadTrans(matselect1,selectpoxix,((posiy+sizem*168)-sizem*sizey)*h/768,sizem,false,trans)
			Hud:QuadTrans(matselect2,selectpoxix,((posiy+sizem*126)-sizem*sizey)*h/768,sizem,false,trans)
		end
   
	elseif Player._CurWeaponIndex == 5 then 
		if not (INP.IsFireSwitched() or (not Game.SwitchFire[2] and Cfg.SwitchFire[2]) or (not Cfg.SwitchFire[2] and Game.SwitchFire[2])) then
			Hud:QuadTrans(matselect1,selectpoxix,((posiy+sizem*210)-sizem*sizey)*h/768,sizem,false,trans)
			Hud:QuadTrans(matselect2,selectpoxix,((posiy+sizem*252)-sizem*sizey)*h/768,sizem,false,trans)
		else
			Hud:QuadTrans(matselect1,selectpoxix,((posiy+sizem*252)-sizem*sizey)*h/768,sizem,false,trans)
			Hud:QuadTrans(matselect2,selectpoxix,((posiy+sizem*210)-sizem*sizey)*h/768,sizem,false,trans)
		end

	elseif Player._CurWeaponIndex == 6 then
		if not (INP.IsFireSwitched() or (not Game.SwitchFire[7] and Cfg.SwitchFire[7]) or (not Cfg.SwitchFire[7] and Game.SwitchFire[7])) then
			Hud:QuadTrans(matselect1,selectpoxix,((posiy+sizem*294)-sizem*sizey)*h/768,sizem,false,trans)  
			Hud:QuadTrans(matselect2,selectpoxix,((posiy+sizem*336)-sizem*sizey)*h/768,sizem,false,trans) 
		else
			Hud:QuadTrans(matselect1,selectpoxix,((posiy+sizem*336)-sizem*sizey)*h/768,sizem,false,trans)  
			Hud:QuadTrans(matselect2,selectpoxix,((posiy+sizem*294)-sizem*sizey)*h/768,sizem,false,trans) 
		end

	elseif Player._CurWeaponIndex == 7 then
		Hud:QuadTrans(matselect1,selectpoxix,((posiy+sizem*378)-sizem*sizey)*h/768,sizem,false,trans)
		
	elseif Player._CurWeaponIndex == 8 then
		Hud:QuadTrans(matselect1,selectpoxix,((posiy+sizem*420)-sizem*sizey)*h/768,sizem,false,trans)
    
	end
	
--AMMO==################################################################################
		if not Cfg.PROD_SimpleIcons then
			ammo1 = { Hud._matBoneGun2, Hud._matCannonGun2, Hud._matCrossBow2, Hud._matScreamer2, Hud._matHellBlade2, Hud._matEctoplasmer2, Hud._matEggBomb2 }
			ammo2 = { Hud._matCannonGun2a, Hud._matCrossBow2a, Hud._matScreamer2a, Hud._matHellBlade2a, }
		else
			ammo1 = { Hud._matBoneGun1, Hud._matCannonGun1, Hud._matCrossBow1, Hud._matScreamer1, Hud._matHellBlade1, Hud._matEctoplasmer1, Hud._matEggBomb1 }
			ammo2 = { Hud._matCannonGun1a, Hud._matCrossBow1a, Hud._matScreamer1a, Hud._matHellBlade1a, }
		end
--BoneGun
		--if not (INP.IsFireSwitched() or (not Game.SwitchFire[2] and Cfg.SwitchFire[2]) or (not Cfg.SwitchFire[2] and Game.SwitchFire[2])) then
			Hud:Quad(ammo1[1],icoposix,((posiy+sizem*0)-sizem*sizey)*h/768,sizem,false)
			--Hud:Quad(Hud._matBoneGun1a,icoposix,((posiy+sizem*42)-sizem*sizey)*h/768,sizem,false)
			Hud:DrawDigitsText1(textposix,((posiy+sizem*3)-sizem*sizey)*h/768,string.sub(string.format("%03d",Player.Ammo.Bonegun),-3),0.9*sizem,Player.s_SubClass.AmmoWarning.Bonegun)

	--end
			--Hud:DrawDigitsText1(textposix,((posiy+sizem*45)-sizem*sizey)*h/768,string.sub(string.format("%03d",Player.Ammo.StoneBullets),-3),0.9*sizem,Player.s_SubClass.AmmoWarning.StoneBullets)
		--[[else
			Hud:Quad(Hud._matBoneGun1,icoposix,((posiy+sizem*42)-sizem*sizey)*h/768,sizem,false)
			Hud:Quad(Hud._matBoneGun1a,icoposix,((posiy+sizem*0)-sizem*sizey)*h/768,sizem,false)
			Hud:DrawDigitsText1(textposix,((posiy+sizem*3)-sizem*sizey)*h/768,string.sub(string.format("%03d",Player.Ammo.StoneBullets),-3),0.9*sizem,Player.s_SubClass.AmmoWarning.StoneBullets)
			Hud:DrawDigitsText(textposix,((posiy+sizem*45)-sizem*sizey)*h/768,string.sub(string.format("%03d",Player.Ammo.Bonegun),-3),0.9*sizem,Player.s_SubClass.AmmoWarning.Bonegun)]]--
		--end
		
--CannonGun
		if not (INP.IsFireSwitched() or (not Game.SwitchFire[4] and Cfg.SwitchFire[4]) or (not Cfg.SwitchFire[4] and Game.SwitchFire[4])) then
			Hud:Quad(ammo2[1],icoposix,((posiy+sizem*84)-sizem*sizey)*h/768,sizem,false)
			Hud:Quad(ammo1[2],icoposix,((posiy+sizem*42)-sizem*sizey)*h/768,sizem,false)
			Hud:DrawDigitsText1(textposix,((posiy+sizem*45)-sizem*sizey)*h/768,string.sub(string.format("%03d",Player.Ammo.Cannonball),-3),0.9 * sizem,Player.s_SubClass.AmmoWarning.Cannonball)
			Hud:DrawDigitsText1(textposix,((posiy+sizem*87)-sizem*sizey)*h/768,string.sub(string.format("%03d",Player.Ammo.MiniGun),-3),0.9 * sizem,Player.s_SubClass.AmmoWarning.MiniGun)
		else
			Hud:Quad(ammo2[1],icoposix,((posiy+sizem*42)-sizem*sizey)*h/768,sizem,false)
			Hud:Quad(ammo1[2],icoposix,((posiy+sizem*84)-sizem*sizey)*h/768,sizem,false)
			Hud:DrawDigitsText1(textposix,((posiy+sizem*45)-sizem*sizey)*h/768,string.sub(string.format("%03d",Player.Ammo.MiniGun),-3),0.9 * sizem,Player.s_SubClass.AmmoWarning.MiniGun)
			Hud:DrawDigitsText1(textposix,((posiy+sizem*87)-sizem*sizey)*h/768,string.sub(string.format("%03d",Player.Ammo.Cannonball),-3),0.9 * sizem,Player.s_SubClass.AmmoWarning.Cannonball)
		end

--CrossBow
		if not (INP.IsFireSwitched() or (not Game.SwitchFire[7] and Cfg.SwitchFire[7]) or (not Cfg.SwitchFire[7] and Game.SwitchFire[7])) then
			Hud:Quad(ammo1[3],icoposix,((posiy+sizem*126)-sizem*sizey)*h/768,sizem,false)
			Hud:Quad(ammo2[2],icoposix,((posiy+sizem*168)-sizem*sizey)*h/768,sizem,false)
			Hud:DrawDigitsText1(textposix,((posiy+sizem*129)-sizem*sizey)*h/768,string.sub(string.format("%04d",Player.Ammo.Arrows),-3),0.9*sizem,Player.s_SubClass.AmmoWarning.Arrows)
			Hud:DrawDigitsText1(textposix,((posiy+sizem*171)-sizem*sizey)*h/768,string.sub(string.format("%04d",Player.Ammo.Heads),-3),0.9*sizem,Player.s_SubClass.AmmoWarning.Heads)
		else
			Hud:Quad(ammo2[2],icoposix,((posiy+sizem*126)-sizem*sizey)*h/768,sizem,false)
			Hud:Quad(ammo1[3],icoposix,((posiy+sizem*168)-sizem*sizey)*h/768,sizem,false)
			Hud:DrawDigitsText1(textposix,((posiy+sizem*129)-sizem*sizey)*h/768,string.sub(string.format("%04d",Player.Ammo.Heads),-3),0.9*sizem,Player.s_SubClass.AmmoWarning.Heads)
			Hud:DrawDigitsText1(textposix,((posiy+sizem*171)-sizem*sizey)*h/768,string.sub(string.format("%04d",Player.Ammo.Arrows),-3),0.9*sizem,Player.s_SubClass.AmmoWarning.Arrows)
		end 
		
--Screamer		
		if not (INP.IsFireSwitched() or (not Game.SwitchFire[2] and Cfg.SwitchFire[2]) or (not Cfg.SwitchFire[2] and Game.SwitchFire[2])) then
			Hud:Quad(ammo1[4],icoposix,((posiy+sizem*210)-sizem*sizey)*h/768,sizem,false)
			Hud:Quad(ammo2[3],icoposix,((posiy+sizem*252)-sizem*sizey)*h/768,sizem,false)
			Hud:DrawDigitsText1(textposix,((posiy+sizem*213)-sizem*sizey)*h/768,string.sub(string.format("%03d",Player.Ammo.BrainWorms),-3),0.9*sizem,Player.s_SubClass.AmmoWarning.BrainWorms)
			Hud:DrawDigitsText1(textposix,((posiy+sizem*255)-sizem*sizey)*h/768,string.sub(string.format("%03d",Player.Ammo.BrokenSouls),-3),0.9*sizem,Player.s_SubClass.AmmoWarning.BrokenSouls)
		else
			Hud:Quad(ammo1[4],icoposix,((posiy+sizem*252)-sizem*sizey)*h/768,sizem,false)
			Hud:Quad(ammo2[3],icoposix,((posiy+sizem*210)-sizem*sizey)*h/768,sizem,false)
			Hud:DrawDigitsText1(textposix,((posiy+sizem*213)-sizem*sizey)*h/768,string.sub(string.format("%03d",Player.Ammo.BrokenSouls),-3),0.9*sizem,Player.s_SubClass.AmmoWarning.BrokenSouls)
			Hud:DrawDigitsText1(textposix,((posiy+sizem*255)-sizem*sizey)*h/768,string.sub(string.format("%03d",Player.Ammo.BrainWorms),-3),0.9*sizem,Player.s_SubClass.AmmoWarning.BrainWorms)
		end
		
--HellBlade		
		if not (INP.IsFireSwitched() or (not Game.SwitchFire[7] and Cfg.SwitchFire[7]) or (not Cfg.SwitchFire[7] and Game.SwitchFire[7])) then
			Hud:Quad(ammo1[5],icoposix,((posiy+sizem*294)-sizem*sizey)*h/768,sizem,false)
			Hud:Quad(ammo2[4],icoposix,((posiy+sizem*336)-sizem*sizey)*h/768,sizem,false)
			Hud:DrawDigitsText1(textposix,((posiy+sizem*297)-sizem*sizey)*h/768,string.sub(string.format("%04d",Player.Ammo.Skulls),-3),0.9*sizem,Player.s_SubClass.AmmoWarning.Skulls)
			Hud:DrawDigitsText1(textposix,((posiy+sizem*339)-sizem*sizey)*h/768,string.sub(string.format("%04d",Player.Ammo.DarkEnergy),-3),0.9*sizem,Player.s_SubClass.AmmoWarning.DarkEnergy)
		else
			Hud:Quad(ammo2[4],icoposix,((posiy+sizem*294)-sizem*sizey)*h/768,sizem,false)
			Hud:Quad(ammo1[5],icoposix,((posiy+sizem*336)-sizem*sizey)*h/768,sizem,false)
			Hud:DrawDigitsText1(textposix,((posiy+sizem*297)-sizem*sizey)*h/768,string.sub(string.format("%04d",Player.Ammo.DarkEnergy),-3),0.9*sizem,Player.s_SubClass.AmmoWarning.DarkEnergy)
			Hud:DrawDigitsText1(textposix,((posiy+sizem*339)-sizem*sizey)*h/768,string.sub(string.format("%04d",Player.Ammo.Skulls),-3),0.9*sizem,Player.s_SubClass.AmmoWarning.Skulls)
		end 
		
--Ectoplasmer		
			Hud:Quad(ammo1[6],icoposix,((posiy+sizem*378)-sizem*sizey)*h/768,sizem,false)
			Hud:DrawDigitsText1(textposix,((posiy+sizem*381)-sizem*sizey)*h/768,string.sub(string.format("%04d",Player.Ammo.Ectoplasm),-3),0.9*sizem,Player.s_SubClass.AmmoWarning.Ectoplasm)
			
--EggBomb		
			Hud:Quad(ammo1[7],icoposix,((posiy+sizem*420)-sizem*sizey)*h/768,sizem,false)
			Hud:DrawDigitsText1(textposix,((posiy+sizem*423)-sizem*sizey)*h/768,string.sub(string.format("%04d",Player.Ammo.StickyBombs),-3),0.9*sizem,Player.s_SubClass.AmmoWarning.StickyBombs)

--UnallowableWeapons
	if Player.EnabledWeapons[2] == Bonegun then
		Hud:QuadTrans(Hud._Unallowable,icoposix,((posiy+sizem*0)-sizem*sizey)*h/768,sizem,false,255)
		--Hud:QuadTrans(Hud._Unallowable,icoposix,((posiy+sizem*42)-sizem*sizey)*h/768,sizem,false,255)
	end
	if Player.EnabledWeapons[3] == CannonGun then
		Hud:QuadTrans(Hud._Unallowable,icoposix,((posiy+sizem*42)-sizem*sizey)*h/768,sizem,false,255)
		Hud:QuadTrans(Hud._Unallowable,icoposix,((posiy+sizem*84)-sizem*sizey)*h/768,sizem,false,255)
	end
	if Player.EnabledWeapons[4] == MagicCrossbow then
		Hud:QuadTrans(Hud._Unallowable,icoposix,((posiy+sizem*126)-sizem*sizey)*h/768,sizem,false,255)
		Hud:QuadTrans(Hud._Unallowable,icoposix,((posiy+sizem*168)-sizem*sizey)*h/768,sizem,false,255)
	end
	if Player.EnabledWeapons[5] == Screamer then
		Hud:QuadTrans(Hud._Unallowable,icoposix,((posiy+sizem*210)-sizem*sizey)*h/768,sizem,false,255)
		Hud:QuadTrans(Hud._Unallowable,icoposix,((posiy+sizem*252)-sizem*sizey)*h/768,sizem,false,255)
	end
	if Player.EnabledWeapons[6] == HellBlade then
		Hud:QuadTrans(Hud._Unallowable,icoposix,((posiy+sizem*294)-sizem*sizey)*h/768,sizem,false,255)
		Hud:QuadTrans(Hud._Unallowable,icoposix,((posiy+sizem*336)-sizem*sizey)*h/768,sizem,false,255)
	end
	if Player.EnabledWeapons[7] == Ectoplasmer then
		Hud:QuadTrans(Hud._Unallowable,icoposix,((posiy+sizem*378)-sizem*sizey)*h/768,sizem,false,255)
	end
	if Player.EnabledWeapons[8] == EggBomb then
		Hud:QuadTrans(Hud._Unallowable,icoposix,((posiy+sizem*420)-sizem*sizey)*h/768,sizem,false,255)
	end

end
--AmmoList =fin=#########################################################################