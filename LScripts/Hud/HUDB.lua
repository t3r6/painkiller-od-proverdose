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
--AmmoList =start=################################################################################
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
		if not (INP.IsFireSwitched() or (not Game.SwitchFire[2] and Cfg.SwitchFire[2]) or (not Cfg.SwitchFire[2] and Game.SwitchFire[2])) then
			Hud:QuadTrans(matselect1,selectpoxix,((posiy+sizem*0)-sizem*sizey)*h/768,sizem,false,trans)
			Hud:QuadTrans(matselect2,selectpoxix,((posiy+sizem*42)-sizem*sizey)*h/768,sizem,false,trans)
		else
			Hud:QuadTrans(matselect1,selectpoxix,((posiy+sizem*42)-sizem*sizey)*h/768,sizem,false,trans)
			Hud:QuadTrans(matselect2,selectpoxix,((posiy+sizem*0)-sizem*sizey)*h/768,sizem,false,trans)
		end

	elseif Player._CurWeaponIndex == 3 then
		if not (INP.IsFireSwitched() or (not Game.SwitchFire[4] and Cfg.SwitchFire[4]) or (not Cfg.SwitchFire[4] and Game.SwitchFire[4])) then
			Hud:QuadTrans(matselect1,selectpoxix,((posiy+sizem*84)-sizem*sizey)*h/768,sizem,false,trans)
			Hud:QuadTrans(matselect2,selectpoxix,((posiy+sizem*126)-sizem*sizey)*h/768,sizem,false,trans)
		else
			Hud:QuadTrans(matselect1,selectpoxix,((posiy+sizem*126)-sizem*sizey)*h/768,sizem,false,trans)
			Hud:QuadTrans(matselect2,selectpoxix,((posiy+sizem*84)-sizem*sizey)*h/768,sizem,false,trans)
		end
    
	elseif Player._CurWeaponIndex == 4 then 
		if not (INP.IsFireSwitched() or (not Game.SwitchFire[7] and Cfg.SwitchFire[7]) or (not Cfg.SwitchFire[7] and Game.SwitchFire[7])) then	
			Hud:QuadTrans(matselect1,selectpoxix,((posiy+sizem*168)-sizem*sizey)*h/768,sizem,false,trans)
			Hud:QuadTrans(matselect2,selectpoxix,((posiy+sizem*210)-sizem*sizey)*h/768,sizem,false,trans)
		else
			Hud:QuadTrans(matselect1,selectpoxix,((posiy+sizem*210)-sizem*sizey)*h/768,sizem,false,trans)
			Hud:QuadTrans(matselect2,selectpoxix,((posiy+sizem*168)-sizem*sizey)*h/768,sizem,false,trans)
		end
   
	elseif Player._CurWeaponIndex == 5 then 
		if not (INP.IsFireSwitched() or (not Game.SwitchFire[2] and Cfg.SwitchFire[2]) or (not Cfg.SwitchFire[2] and Game.SwitchFire[2])) then
			Hud:QuadTrans(matselect1,selectpoxix,((posiy+sizem*252)-sizem*sizey)*h/768,sizem,false,trans)
			Hud:QuadTrans(matselect2,selectpoxix,((posiy+sizem*294)-sizem*sizey)*h/768,sizem,false,trans)
		else
			Hud:QuadTrans(matselect1,selectpoxix,((posiy+sizem*294)-sizem*sizey)*h/768,sizem,false,trans)
			Hud:QuadTrans(matselect2,selectpoxix,((posiy+sizem*252)-sizem*sizey)*h/768,sizem,false,trans)
		end

	elseif Player._CurWeaponIndex == 6 then
		if not (INP.IsFireSwitched() or (not Game.SwitchFire[7] and Cfg.SwitchFire[7]) or (not Cfg.SwitchFire[7] and Game.SwitchFire[7])) then
			Hud:QuadTrans(matselect1,selectpoxix,((posiy+sizem*336)-sizem*sizey)*h/768,sizem,false,trans)  
			Hud:QuadTrans(matselect2,selectpoxix,((posiy+sizem*378)-sizem*sizey)*h/768,sizem,false,trans) 
		else
			Hud:QuadTrans(matselect1,selectpoxix,((posiy+sizem*378)-sizem*sizey)*h/768,sizem,false,trans)  
			Hud:QuadTrans(matselect2,selectpoxix,((posiy+sizem*336)-sizem*sizey)*h/768,sizem,false,trans) 
		end

	elseif Player._CurWeaponIndex == 7 then
		if not (INP.IsFireSwitched() or (not Game.SwitchFire[6] and Cfg.SwitchFire[6]) or (not Cfg.SwitchFire[6] and Game.SwitchFire[6])) then
			Hud:QuadTrans(matselect1,selectpoxix,((posiy+sizem*420)-sizem*sizey)*h/768,sizem,false,trans)
			Hud:QuadTrans(matselect1,selectpoxix,((posiy+sizem*462)-sizem*sizey)*h/768,sizem,false,trans)
		else
			Hud:QuadTrans(matselect1,selectpoxix,((posiy+sizem*462)-sizem*sizey)*h/768,sizem,false,trans)
			Hud:QuadTrans(matselect1,selectpoxix,((posiy+sizem*420)-sizem*sizey)*h/768,sizem,false,trans)
		end

	elseif Player._CurWeaponIndex == 8 then
		Hud:QuadTrans(matselect1,selectpoxix,((posiy+sizem*504)-sizem*sizey)*h/768,sizem,false,trans)
	end

--AMMO==################################################################################
		if not Cfg.PROD_SimpleIcons then
			ammo1 = { Hud._matBoneGun2, Hud._matCannonGun2, Hud._matCrossBow2, Hud._matScreamer2, Hud._matHellBlade2, Hud._matEctoplasmer2, Hud._matEggBomb2 }
			ammo2 = { Hud._matBoneGun2a, Hud._matCannonGun2a, Hud._matCrossBow2a, Hud._matScreamer2a, Hud._matHellBlade2a, Hud._matEctoplasmer2a }
		else
			ammo1 = { Hud._matBoneGun1, Hud._matCannonGun1, Hud._matCrossBow1, Hud._matScreamer1, Hud._matHellBlade1, Hud._matEctoplasmer1, Hud._matEggBomb1 }
			ammo2 = { Hud._matBoneGun1a, Hud._matCannonGun1a, Hud._matCrossBow1a, Hud._matScreamer1a, Hud._matHellBlade1a, Hud._matEctoplasmer1a }
		end
--BoneGun
		if not (INP.IsFireSwitched() or (not Game.SwitchFire[2] and Cfg.SwitchFire[2]) or (not Cfg.SwitchFire[2] and Game.SwitchFire[2])) then
			Hud:Quad(ammo2[1],icoposix,((posiy+sizem*42)-sizem*sizey)*h/768,sizem,false)
			Hud:Quad(ammo1[1],icoposix,((posiy+sizem*0)-sizem*sizey)*h/768,sizem,false)
			Hud:DrawDigitsText1(textposix,((posiy+sizem*3)-sizem*sizey)*h/768,string.sub(string.format("%03d",Player.Ammo.Bonegun),-3),0.9*sizem,Player.s_SubClass.AmmoWarning.Bonegun)
			Hud:DrawDigitsText1(textposix,((posiy+sizem*45)-sizem*sizey)*h/768,string.sub(string.format("%03d",Player.Ammo.StoneBullets),-3),0.9*sizem,Player.s_SubClass.AmmoWarning.StoneBullets)
		else
			Hud:Quad(ammo2[1],icoposix,((posiy+sizem*0)-sizem*sizey)*h/768,sizem,false)
			Hud:Quad(ammo1[1],icoposix,((posiy+sizem*42)-sizem*sizey)*h/768,sizem,false)
			Hud:DrawDigitsText1(textposix,((posiy+sizem*3)-sizem*sizey)*h/768,string.sub(string.format("%03d",Player.Ammo.StoneBullets),-3),0.9*sizem,Player.s_SubClass.AmmoWarning.StoneBullets)
			Hud:DrawDigitsText1(textposix,((posiy+sizem*45)-sizem*sizey)*h/768,string.sub(string.format("%03d",Player.Ammo.Bonegun),-3),0.9*sizem,Player.s_SubClass.AmmoWarning.Bonegun)
		end

--CannonGun
		if not (INP.IsFireSwitched() or (not Game.SwitchFire[4] and Cfg.SwitchFire[4]) or (not Cfg.SwitchFire[4] and Game.SwitchFire[4])) then
			Hud:Quad(ammo2[2],icoposix,((posiy+sizem*126)-sizem*sizey)*h/768,sizem,false)
			Hud:Quad(ammo1[2],icoposix,((posiy+sizem*84)-sizem*sizey)*h/768,sizem,false)
			Hud:DrawDigitsText1(textposix,((posiy+sizem*87)-sizem*sizey)*h/768,string.sub(string.format("%03d",Player.Ammo.Cannonball),-3),0.9 * sizem,Player.s_SubClass.AmmoWarning.Cannonball)
			Hud:DrawDigitsText1(textposix,((posiy+sizem*129)-sizem*sizey)*h/768,string.sub(string.format("%03d",Player.Ammo.MiniGun),-3),0.9 * sizem,Player.s_SubClass.AmmoWarning.MiniGun)
		else
			Hud:Quad(ammo2[2],icoposix,((posiy+sizem*84)-sizem*sizey)*h/768,sizem,false)
			Hud:Quad(ammo1[2],icoposix,((posiy+sizem*126)-sizem*sizey)*h/768,sizem,false)
			Hud:DrawDigitsText1(textposix,((posiy+sizem*87)-sizem*sizey)*h/768,string.sub(string.format("%03d",Player.Ammo.MiniGun),-3),0.9 * sizem,Player.s_SubClass.AmmoWarning.MiniGun)
			Hud:DrawDigitsText1(textposix,((posiy+sizem*129)-sizem*sizey)*h/768,string.sub(string.format("%03d",Player.Ammo.Cannonball),-3),0.9 * sizem,Player.s_SubClass.AmmoWarning.Cannonball)
		end

--CrossBow
		if not (INP.IsFireSwitched() or (not Game.SwitchFire[7] and Cfg.SwitchFire[7]) or (not Cfg.SwitchFire[7] and Game.SwitchFire[7])) then
			Hud:Quad(ammo1[3],icoposix,((posiy+sizem*168)-sizem*sizey)*h/768,sizem,false)
			Hud:Quad(ammo2[3],icoposix,((posiy+sizem*210)-sizem*sizey)*h/768,sizem,false)
			Hud:DrawDigitsText1(textposix,((posiy+sizem*171)-sizem*sizey)*h/768,string.sub(string.format("%04d",Player.Ammo.Arrows),-3),0.9*sizem,Player.s_SubClass.AmmoWarning.Arrows)
			Hud:DrawDigitsText1(textposix,((posiy+sizem*213)-sizem*sizey)*h/768,string.sub(string.format("%04d",Player.Ammo.Heads),-3),0.9*sizem,Player.s_SubClass.AmmoWarning.Heads)
		else
			Hud:Quad(ammo2[3],icoposix,((posiy+sizem*168)-sizem*sizey)*h/768,sizem,false)
			Hud:Quad(ammo1[3],icoposix,((posiy+sizem*210)-sizem*sizey)*h/768,sizem,false)
			Hud:DrawDigitsText1(textposix,((posiy+sizem*171)-sizem*sizey)*h/768,string.sub(string.format("%04d",Player.Ammo.Heads),-3),0.9*sizem,Player.s_SubClass.AmmoWarning.Heads)
			Hud:DrawDigitsText1(textposix,((posiy+sizem*213)-sizem*sizey)*h/768,string.sub(string.format("%04d",Player.Ammo.Arrows),-3),0.9*sizem,Player.s_SubClass.AmmoWarning.Arrows)
		end 

-- --Screamer
		if not (INP.IsFireSwitched() or (not Game.SwitchFire[2] and Cfg.SwitchFire[2]) or (not Cfg.SwitchFire[2] and Game.SwitchFire[2])) then
			Hud:Quad(ammo1[4],icoposix,((posiy+sizem*252)-sizem*sizey)*h/768,sizem,false)
			Hud:Quad(ammo2[4],icoposix,((posiy+sizem*294)-sizem*sizey)*h/768,sizem,false)
			Hud:DrawDigitsText1(textposix,((posiy+sizem*255)-sizem*sizey)*h/768,string.sub(string.format("%03d",Player.Ammo.BrainWorms),-3),0.9*sizem,Player.s_SubClass.AmmoWarning.BrainWorms)
			Hud:DrawDigitsText1(textposix,((posiy+sizem*297)-sizem*sizey)*h/768,string.sub(string.format("%03d",Player.Ammo.BrokenSouls),-3),0.9*sizem,Player.s_SubClass.AmmoWarning.BrokenSouls)
		else
			Hud:Quad(ammo1[4],icoposix,((posiy+sizem*294)-sizem*sizey)*h/768,sizem,false)
			Hud:Quad(ammo2[4],icoposix,((posiy+sizem*252)-sizem*sizey)*h/768,sizem,false)
			Hud:DrawDigitsText1(textposix,((posiy+sizem*255)-sizem*sizey)*h/768,string.sub(string.format("%03d",Player.Ammo.BrokenSouls),-3),0.9*sizem,Player.s_SubClass.AmmoWarning.BrokenSouls)
			Hud:DrawDigitsText1(textposix,((posiy+sizem*297)-sizem*sizey)*h/768,string.sub(string.format("%03d",Player.Ammo.BrainWorms),-3),0.9*sizem,Player.s_SubClass.AmmoWarning.BrainWorms)
		end

--HellBlade
		if not (INP.IsFireSwitched() or (not Game.SwitchFire[7] and Cfg.SwitchFire[7]) or (not Cfg.SwitchFire[7] and Game.SwitchFire[7])) then
			Hud:Quad(ammo1[5],icoposix,((posiy+sizem*336)-sizem*sizey)*h/768,sizem,false)
			Hud:Quad(ammo2[5],icoposix,((posiy+sizem*378)-sizem*sizey)*h/768,sizem,false)
			Hud:DrawDigitsText1(textposix,((posiy+sizem*339)-sizem*sizey)*h/768,string.sub(string.format("%04d",Player.Ammo.Skulls),-3),0.9*sizem,Player.s_SubClass.AmmoWarning.Skulls)
			Hud:DrawDigitsText1(textposix,((posiy+sizem*381)-sizem*sizey)*h/768,string.sub(string.format("%04d",Player.Ammo.DarkEnergy),-3),0.9*sizem,Player.s_SubClass.AmmoWarning.DarkEnergy)
		else
			Hud:Quad(ammo2[5],icoposix,((posiy+sizem*336)-sizem*sizey)*h/768,sizem,false)
			Hud:Quad(ammo1[5],icoposix,((posiy+sizem*378)-sizem*sizey)*h/768,sizem,false)
			Hud:DrawDigitsText1(textposix,((posiy+sizem*339)-sizem*sizey)*h/768,string.sub(string.format("%04d",Player.Ammo.DarkEnergy),-3),0.9*sizem,Player.s_SubClass.AmmoWarning.DarkEnergy)
			Hud:DrawDigitsText1(textposix,((posiy+sizem*381)-sizem*sizey)*h/768,string.sub(string.format("%04d",Player.Ammo.Skulls),-3),0.9*sizem,Player.s_SubClass.AmmoWarning.Skulls)
		end

--Ectoplasmer
		if not (INP.IsFireSwitched() or (not Game.SwitchFire[6] and Cfg.SwitchFire[6]) or (not Cfg.SwitchFire[6] and Game.SwitchFire[6])) then
			Hud:Quad(ammo1[6],icoposix,((posiy+sizem*420)-sizem*sizey)*h/768,sizem,false)
			Hud:Quad(ammo2[6],icoposix,((posiy+sizem*462)-sizem*sizey)*h/768,sizem,false)
			Hud:DrawDigitsText1(textposix,((posiy+sizem*423)-sizem*sizey)*h/768,string.sub(string.format("%04d",Player.Ammo.Ectoplasm),-3),0.9*sizem,Player.s_SubClass.AmmoWarning.Ectoplasm)
			Hud:DrawDigitsText1(textposix,((posiy+sizem*465)-sizem*sizey)*h/768,string.sub(string.format("%04d",Player.Ammo.GreenGoo),-3),0.9*sizem,Player.s_SubClass.AmmoWarning.GreenGoo)
		else
			Hud:Quad(ammo1[6],icoposix,((posiy+sizem*462)-sizem*sizey)*h/768,sizem,false)
			Hud:Quad(ammo2[6],icoposix,((posiy+sizem*420)-sizem*sizey)*h/768,sizem,false)
			Hud:DrawDigitsText1(textposix,((posiy+sizem*423)-sizem*sizey)*h/768,string.sub(string.format("%04d",Player.Ammo.GreenGoo),-3),0.9*sizem,Player.s_SubClass.AmmoWarning.GreenGoo)
			Hud:DrawDigitsText1(textposix,((posiy+sizem*465)-sizem*sizey)*h/768,string.sub(string.format("%04d",Player.Ammo.Ectoplasm),-3),0.9*sizem,Player.s_SubClass.AmmoWarning.Ectoplasm)
		end

--EggBomb
			Hud:Quad(ammo1[7],icoposix,((posiy+sizem*504)-sizem*sizey)*h/768,sizem,false)
			Hud:DrawDigitsText1(textposix,((posiy+sizem*507)-sizem*sizey)*h/768,string.sub(string.format("%04d",Player.Ammo.StickyBombs),-3),0.9*sizem,Player.s_SubClass.AmmoWarning.StickyBombs)

--UnallowableWeapons
	if Player.EnabledWeapons[2] == Bonegun then
		Hud:QuadTrans(Hud._Unallowable,icoposix,((posiy+sizem*0)-sizem*sizey)*h/768,sizem,false,255)
		Hud:QuadTrans(Hud._Unallowable,icoposix,((posiy+sizem*42)-sizem*sizey)*h/768,sizem,false,255)
	end
	if Player.EnabledWeapons[3] == CannonGun then
		Hud:QuadTrans(Hud._Unallowable,icoposix,((posiy+sizem*84)-sizem*sizey)*h/768,sizem,false,255)
		Hud:QuadTrans(Hud._Unallowable,icoposix,((posiy+sizem*126)-sizem*sizey)*h/768,sizem,false,255)
	end
	if Player.EnabledWeapons[4] == MagicCrossbow then
		Hud:QuadTrans(Hud._Unallowable,icoposix,((posiy+sizem*168)-sizem*sizey)*h/768,sizem,false,255)
		Hud:QuadTrans(Hud._Unallowable,icoposix,((posiy+sizem*210)-sizem*sizey)*h/768,sizem,false,255)
	end
	if Player.EnabledWeapons[5] == Screamer then
		Hud:QuadTrans(Hud._Unallowable,icoposix,((posiy+sizem*252)-sizem*sizey)*h/768,sizem,false,255)
		Hud:QuadTrans(Hud._Unallowable,icoposix,((posiy+sizem*294)-sizem*sizey)*h/768,sizem,false,255)
	end
	if Player.EnabledWeapons[6] == HellBlade then
		Hud:QuadTrans(Hud._Unallowable,icoposix,((posiy+sizem*336)-sizem*sizey)*h/768,sizem,false,255)
		Hud:QuadTrans(Hud._Unallowable,icoposix,((posiy+sizem*378)-sizem*sizey)*h/768,sizem,false,255)
	end
	if Player.EnabledWeapons[7] == Ectoplasmer then
		Hud:QuadTrans(Hud._Unallowable,icoposix,((posiy+sizem*420)-sizem*sizey)*h/768,sizem,false,255)
		Hud:QuadTrans(Hud._Unallowable,icoposix,((posiy+sizem*462)-sizem*sizey)*h/768,sizem,false,255)
	end
	if Player.EnabledWeapons[8] == EggBomb then
		Hud:QuadTrans(Hud._Unallowable,icoposix,((posiy+sizem*504)-sizem*sizey)*h/768,sizem,false,255)
	end

end
--AmmoList =fin=#########################################################################
--LowAmmo=start=########################################################################
function Hud:LowAmmo()
LAmmos =
{
	{
		{ 2, Player.Ammo.Bonegun, Player.Ammo.StoneBullets, Player.s_SubClass.AmmoWarning.Bonegun, Player.s_SubClass.AmmoWarning.StoneBullets, endbonesnd, endbonetxt, endbulletsnd, endbullettxt, "Bonegun", "StoneBullets", },
		{ 3, Player.Ammo.Cannonball, Player.Ammo.MiniGun, Player.s_SubClass.AmmoWarning.Cannonball, Player.s_SubClass.AmmoWarning.MiniGun, endcannonsnd, endcannontxt, endminigunsnd, endminiguntxt, "Cannonball", "MiniGun", },
		{ 4, Player.Ammo.Arrows, Player.Ammo.Heads, Player.s_SubClass.AmmoWarning.Arrows, Player.s_SubClass.AmmoWarning.Heads, endarrowsnd, endarrowtxt, endheadsnd, endheadtxt, "Crossbow", "Heads", },
		{ 5, Player.Ammo.BrainWorms, Player.Ammo.BrokenSouls, Player.s_SubClass.AmmoWarning.BrainWorms, Player.s_SubClass.AmmoWarning.BrokenSouls, endbrainsnd, endbraintxt, endbrokensnd, endbrokentxt, "BrainWorms", "BrokenSouls", },
		{ 6, Player.Ammo.Skulls, Player.Ammo.DarkEnergy, Player.s_SubClass.AmmoWarning.Skulls, Player.s_SubClass.AmmoWarning.DarkEnergy, endskullsnd, endskulltxt, endenergysnd, endenergytxt, "Skulls", "DarkEnergy", },
		{ 7, Player.Ammo.Ectoplasm, Player.Ammo.GreenGoo, Player.s_SubClass.AmmoWarning.Ectoplasm, Player.s_SubClass.AmmoWarning.GreenGoo, endectoplasmsnd, endectoplasmtxt, endgreengoosnd, endgreengootxt, "Ectoplasm", "GreenGoo",},
		--{ 8, Player.Ammo.StickyBombs, Player.Ammo.StickyBombs, Player.s_SubClass.AmmoWarning.StickyBombs, Player.s_SubClass.AmmoWarning.StickyBombs, endbombsnd, endbombtxt, endbombsnd, endbombtxt, "StickyBombs", "StickyBombs",},
	},	
}
	local w,h = R3D.ScreenSize()
	local cw = Player._CurWeaponIndex
	for i=1,table.getn(LAmmos) do
		for j=1,table.getn(LAmmos[i]) do
			if cw == LAmmos[i][j][1] then
				cwx = LAmmos[i][j][1]
				pfire = LAmmos[i][j][2]
				paltfire = LAmmos[i][j][3]
				warfire = LAmmos[i][j][4]
				waraltfire = LAmmos[i][j][5]
				tmendsnd = LAmmos[i][j][6]
				tmendtxt = LAmmos[i][j][7]
				tmendaltsnd = LAmmos[i][j][8]
				tmendalttxt = LAmmos[i][j][9]
				cammos = LAmmos[i][j][10]
				caltammos = LAmmos[i][j][11]
			end
		 end
	end	
	local tmend = tonumber(string.format("%.02f",Game.currentTime/60))	
	local endsnd = tonumber(string.format("%.02f",tmend+0.05))
	local endtxt = tonumber(string.format("%.02f",tmend+Cfg.PROD_LA_Msg_Time/3))
	local amfire = tonumber(string.sub(string.format("%03d",pfire),-3))
	local amaltfire = tonumber(string.sub(string.format("%03d",paltfire),-3))

	if amfire > warfire and cw == 2 then 
		endbonesnd = endsnd
		endbonetxt = endtxt
		tmallwend = 0 -- a bien vérifier par le test en jeu "tm all w end == tm (time) all w(weapon) end"
	elseif amfire > warfire and cw == 3 then 
		endcannonsnd = endsnd
		endcannontxt = endtxt
		wtmcannonend = 0 -- a bien vérifier par le test en jeu
		tmallwend = 0 -- a bien vérifier par le test en jeu
	elseif amfire > warfire and cw == 4 then
		endarrowsnd = endsnd
		endarrowtxt = endtxt
		tmallwend = 0 -- a bien vérifier par le test en jeu
	elseif amfire > warfire and cw == 5 then
		endbrainsnd = endsnd
		endbraintxt = endtxt
		tmallwend = 0 -- a bien vérifier par le test en jeu
	elseif amfire > warfire and cw == 6 then
		endskullsnd = endsnd
		endskulltxt = endtxt
		tmallwend = 0 -- a bien vérifier par le test en jeu
	elseif amfire > warfire and cw == 7 then
		endectoplasmsnd = endsnd
		endectoplasmtxt = endtxt
		wtmectoplasmend = 0 -- a bien vérifier par le test en jeu
		tmallwend = 0 -- a bien vérifier par le test en jeu
		tmceamend = 0
	--elseif amfire > warfire and cw == 8 then
		--endbombsnd = endsnd
		--endbombtxt = endtxt
		--tmallwend = 0 -- a bien vérifier par le test en jeu
	end
	if amaltfire > waraltfire and cw == 2 then
		endbulletsnd = endsnd
		endbullettxt = endtxt
		tmallwaltend = 0 -- a bien vérifier par le test en jeu "tm all w end == tm (time) all w(weapon) alt(alternatif) end"
	elseif amaltfire > waraltfire and cw == 3 then
		endminigunsnd = endsnd
		endminiguntxt = endtxt
		tmallwaltend = 0 -- a bien vérifier par le test en jeu
	elseif amaltfire > waraltfire and cw == 4 then
		endheadsnd = endsnd
		endheadtxt = endtxt
		tmallwaltend = 0 -- a bien vérifier par le test en jeu
		wtmcrossbowend = 0 -- a bien vérifier par le test en jeu
		tmcramend = 0 -- a bien vérifier par le test en jeu
	elseif amaltfire > waraltfire and cw == 5 then
		endbrokensnd = endsnd
		endbrokentxt = endtxt
		tmallwaltend = 0 -- a bien vérifier par le test en jeu
	elseif amaltfire > waraltfire and cw == 6 then
		endenergysnd = endsnd
		endenergytxt = endtxt
		tmallwaltend = 0 -- a bien vérifier par le test en jeu
	elseif amaltfire > waraltfire and cw == 7 then
		endgreengoosnd = endsnd
		endgreengootxt = endtxt
		tmallwaltend = 0 -- a bien vérifier par le test en jeu
	end
	
	if not Cfg.PROD_SimpleIcons then
		--lafontcolortxt = { 230, 161, 97 }
		lafontsizes = 26
		lafonttypo = "timesbd"
		HUD.SetFont("timesbd",26)
	else
		--lafontcolortxt = { 255, 255, 255 }
		lafontsizes = 22
		lafonttypo = "../ProOptions/Fonts/impact"
		HUD.SetFont("../ProOptions/Fonts/impact",22)
	end
	
	-- On Fire===============================
	
	if amfire <= warfire and amfire ~= 0 then
		if Cfg.PROD_LA_Sound then
			if cw == cwx and tmend == tmendsnd then
				PlaySound2D("../PRODsounds/lowammo",nil,nil,true)
			end
		end
		if Cfg.PROD_LA_Msg then
			if cw == cwx and tmend <= tmendtxt then
				HUD.PrintXY((w-HUD.GetTextWidth("Low Ammo!"))/2+1,200*h/768+1,"Low Ammo!",lafonttypo,15,15,15,lafontsizes)
				HUD.PrintXY((w-HUD.GetTextWidth("Low Ammo!"))/2,200*h/768,"Low Ammo!",lafonttypo,255,0,0,lafontsizes)
			end
		end
	end
	if amaltfire <= waraltfire and amaltfire ~= 0 then
		if Cfg.PROD_LA_Sound then
			if cw == cwx and tmend == tmendaltsnd then
				PlaySound2D("../PRODsounds/lowammo",nil,nil,true)
			end
		end
		if Cfg.PROD_LA_Msg then
			if cw == cwx and tmend <= tmendalttxt then
				HUD.PrintXY((w-HUD.GetTextWidth("Low Ammo!"))/2+1,200*h/768+1,"Low Ammo!",lafonttypo,15,15,15,lafontsizes)
				HUD.PrintXY((w-HUD.GetTextWidth("Low Ammo!"))/2,200*h/768,"Low Ammo!",lafonttypo,255,0,0,lafontsizes)	
			end
		end
	end
	
	if Cfg.PROD_LA_Msg then
	-- On Change Weapons===============================
		if Cfg.PROD_LA_Msg_Switch then
			if amfire <= warfire and amfire ~= 0 then
				if cw == cwx and tmend <= tmallwend then
					HUD.PrintXY((w-HUD.GetTextWidth(cammos.." Low Ammo! "))/2+1,200*h/768+1,cammos.." Low Ammo! ",lafonttypo,15,15,15,lafontsizes)
					HUD.PrintXY((w-HUD.GetTextWidth(cammos.." Low Ammo! "))/2,200*h/768,cammos.." Low Ammo! ",lafonttypo,255,0,0,lafontsizes)
				end
			end
			if amaltfire <= waraltfire and amaltfire ~= 0 then
				if cw == cwx and tmend <= tmallwaltend then
					if cw ~= 7 then
						HUD.PrintXY((w-HUD.GetTextWidth(caltammos.." Low Ammo! "))/2+1,225*h/768+1,caltammos.." Low Ammo! ",lafonttypo,15,15,15,lafontsizes)
						HUD.PrintXY((w-HUD.GetTextWidth(caltammos.." Low Ammo! "))/2,225*h/768,caltammos.." Low Ammo! ",lafonttypo,255,0,0,lafontsizes)
					end
				end
			end
		end
		
	--On Take Ammo===========================================
		if amfire <= warfire and amfire ~= 0 then
			if cw == 7 and tmend <= tmceamend then
				HUD.PrintXY((w-HUD.GetTextWidth(cammos.." Low Ammo! "))/2+1,200*h/768+1,caltammos.." Low Ammo! "..amaltfire,lafonttypo,15,15,15,lafontsizes)
				HUD.PrintXY((w-HUD.GetTextWidth(cammos.." Low Ammo! "))/2,200*h/768,caltammos.." Low Ammo! "..amaltfire,lafonttypo,255,0,0,lafontsizes)
			end
		end
		if amaltfire <= waraltfire and amaltfire ~= 0 then
			if cw == 4 and tmend <= tmcramend then
				HUD.PrintXY((w-HUD.GetTextWidth(caltammos.." Low Ammo! "))/2+1,200*h/768+1,caltammos.." Low Ammo! "..amaltfire,lafonttypo,15,15,15,lafontsizes)
				HUD.PrintXY((w-HUD.GetTextWidth(caltammos.." Low Ammo! "))/2,200*h/768,caltammos.." Low Ammo! "..amaltfire,lafonttypo,255,0,0,lafontsizes)
			end
		end
		
	-- On Take Weapons===========================================
		if Cfg.PROD_LA_Msg_Pickup then
			if amfire <= warfire and amfire ~= 0 then
				if cw == 3 and tmend <= wtmcannonend then
					HUD.PrintXY((w-HUD.GetTextWidth(cammos.." Low Ammo! "))/2+1,200*h/768+1,cammos.." Low Ammo!",lafonttypo,15,15,15,lafontsizes)
					HUD.PrintXY((w-HUD.GetTextWidth(cammos.." Low Ammo! "))/2,200*h/768,cammos.." Low Ammo!",lafonttypo,255,0,0,lafontsizes)
				elseif cw == 7 and tmend <= wtmectoplasmend then
					HUD.PrintXY((w-HUD.GetTextWidth(cammos.." Low Ammo! "))/2+1,200*h/768+1,cammos.." Low Ammo!",lafonttypo,15,15,15,lafontsizes)
					HUD.PrintXY((w-HUD.GetTextWidth(cammos.." Low Ammo! "))/2,200*h/768,cammos.." Low Ammo!",lafonttypo,255,0,0,lafontsizes)
				end
			end
			if amaltfire <= waraltfire and amaltfire ~= 0 then
				if cw == 4 and tmend <= wtmcrossbowend then
					HUD.PrintXY((w-HUD.GetTextWidth(caltammos.." Low Ammo! "))/2+1,200*h/768+1,caltammos.." Low Ammo!",lafonttypo,15,15,15,lafontsizes)
					HUD.PrintXY((w-HUD.GetTextWidth(caltammos.." Low Ammo! "))/2,200*h/768,caltammos.." Low Ammo!",lafonttypo,255,0,0,lafontsizes)
				end
			end
		end
	end
end
--LowAmmo=end=########################################################################
