XBOX = nil			-- typy maja funkcje dostepne przez meta,
XBOX_lev2 = nil	        -- niektore dane w klasach nie sa kopiowane, gdy nie sa potrzebne (inne utils i inne klasy -
						-- s_SubClassParams) i __funcs inaczej zapamietywane (pliki .xbox)
							
EditorFiles = true

if IsFinalBuild() or XBOX then
	EditorFiles = nil
end



path = "../Data/LScripts/"


--collectgarbage(0)
--Log("START LOADER.LUA : "..GetGCCount())
FS.RegisterPack("../Data/".."PRODdata.pak","../Data/")

------------------------------------------------------------------------------
DoFile(path.."Main/Utils.lua")
if XBOX_lev2 then
	DoFile(path.."Main/Utils.xbox")
end

DoFile(path.."Main/Cfg.lua")
DoFile(path.."Main/Tweak.lua")
DoFile(path.."Main/Definitions.lua")
DoFile(path.."Main/Network.lua")
DoFile(path.."Main/Profiler.lua")
------------------------------------------------------------------------------
if XBOX then
	DoFile(path.."Classes/TypesXBOX/Vector.lua")
	DoFile(path.."Classes/TypesXBOX/VectorA.lua")
	DoFile(path.."Classes/TypesXBOX/Quaternion.lua")
	DoFile(path.."Classes/TypesXBOX/Color.lua")
	DoFile(path.."Classes/TypesXBOX/Collection.lua")
else
	DoFile(path.."Classes/Types/Vector.lua")
	DoFile(path.."Classes/Types/VectorA.lua")
	DoFile(path.."Classes/Types/Quaternion.lua")
	DoFile(path.."Classes/Types/Color.lua")
	DoFile(path.."Classes/Types/Collection.lua")
end

ToLoadClasses = {
		"CObject",
		"CItem",
		"CActor",
		"CPlayer",
		"CProcess",
		"CLevel",
		"CLight",
		"CBillboard",
		"CSound",
		"CArea",
		"CBox",
		"CWeapon",
		"CAcousticEnv",
		"CMusicEnv",
		"CAction",
		"CSpawnPoint",
		"CParticleFX",
		"CEnvironment",
	}
for i,v in ToLoadClasses do
	DoFile(path.."Classes/"..v..".lua")
	if EditorFiles then
		DoFile(path.."Classes/"..v..".editor", false)
	end
	if XBOX_lev2 then
		DoFile(path.."Classes/"..v..".xbox", false)
	end
end

for i,v in ToLoadClasses do
    Inherit(getfenv()[v],CObject)
end

ToLoadClasses = nil

------------------------------------------------------------------------------
DoFile(path.."Classes/Ai/CAiBrain.lua")
DoFile(path.."Classes/Entities/EMesh.lua")
DoFile(path.."Classes/Entities/EVolumetric.lua")
------------------------------------------------------------------------------
--DoFile(path.."Processes/PFadeInOutLight.lua")
--DoFile(path.."Processes/PBindToJoint.lua")
--DoFile(path.."Processes/PMusicFade.lua")
--DoFile(path.."Templates/Processes/TWait.CProcess")
--DoFile(path.."Processes/PBindJointToJoint.lua")
--DoFile(path.."Processes/PCameraControler.lua")
--DoFile(path.."Processes/PBenchmarkControler.lua")
--DoFile(path.."Processes/PBulletTimeControler.lua")
--DoFile(path.."Processes/PMove.lua")
--DoFile(path.."Processes/PBurningItem.lua")
--DoFile(path.."Processes/PPlayerAnimation.lua")		-- zmienic w gameMP
--DoFile(path.."Processes/PSpectatorControler.lua")	-- zmienic w gameMP
------------------------------------------------------------------------------
DoFile(path.."Main/GObjects.lua")
DoFile(path.."Main/Game.lua")
DoFile(path.."Main/GameMP.lua")
DoFile(path.."Main/Languages.lua")
DoFile(path.."Main/SaveGame.lua")
DoFile(path.."Main/Cache.lua")
------------------------------------------------------------------------------
DoFile(path.."HUD/HUD.lua")
--ADDED=####################################################################################################
DoFile(path.."HUD/HUDA.lua")
DoFile(path.."HUD/HUDB.lua")
--ADDED=end##################################################################################################
DoFile(path.."HUD/Levels.lua")
if not XBOX_lev2 then
	DoFile(path.."HUD/PainMenu.lua")
end
DoFile(path.."HUD/MagicBoard.lua")
DoFile(path.."HUD/Console.lua")
------------------------------------------------------------------------------
if EditorFiles then
	DoFile(path.."Editor/EWayPoints.lua")
	DoFile(path.."Editor/EFloors.lua")
end
DoFile(path.."Editor/Editor.lua")
--DoFile(path.."Templates/Templates.lua")
------------------------------------------------------------------------------
--MsgBox("Loader - koniec")
if loadfile(path.."local.lua") then
	dofile(path.."local.lua")
end

DoFile(path.."Main/Bot.lua")
DoFile(path.."Main/Eliza.lua")
DoFile(path.."Main/Waypoint.lua")


