LevelsExp =
{
	{
		-- map directory, name, sketch, card cond, card index, min. level
		{ "C8L03_Cataclysm", Languages.Texts[907], "sketch_cataclysm", Languages.Texts[397], 1, 0, nil },
		{ "C8L06_Japan_massacre", Languages.Texts[910], "sketch_japan", Languages.Texts[871], 6, 0, nil },
		{ "C7L08_desert", Languages.Texts[882], "sketch_desert", Languages.Texts[413], 13, 0, nil },
		{ "C7L07_asteroids", Languages.Texts[883], "sketch_asteroids", Languages.Texts[418], 32, 0, nil },
		{ "C8L04_Dead_march", Languages.Texts[908], "sketch_deadmarsch", Languages.Texts[870], 8, 0, nil },
		{ "C8L07_Black_tower", Languages.Texts[911], "sketch_blacktower", Languages.Texts[872], 10, 0, "Story2.bik" },
	},

	{
		-- map directory, name, sketch, card cond, card index, min. level
		{ "C8L01_riot", Languages.Texts[905], "sketch_riot", Languages.Texts[412], 14, 0, nil },
		{ "C7L03_powerplant", Languages.Texts[886], "sketch_powerplant", Languages.Texts[414], 9, 0, nil },
		{ "C7L06_slaughterhouse", Languages.Texts[885], "sketch_slaughterhouse", Languages.Texts[915], 20, 0, nil },
		{ "C7L01_field_ambulance", Languages.Texts[880], "sketch_field", Languages.Texts[811], 24, 0, nil },
		{ "C7L05_ragnarok", Languages.Texts[887], "sketch_ragnarok", Languages.Texts[404], 3, 0, "Story3.bik" },
	},
	{
		-- map directory, name, sketch, card cond, card index, min. level
		{ "C7L04_haunted_valley", Languages.Texts[884], "sketch_haunted", Languages.Texts[407], 16, 0, nil },
		{ "C7L02_village_of_damned", Languages.Texts[881], "sketch_village", Languages.Texts[875], 33, 0, nil },
		{ "C8L05_Studios", Languages.Texts[909], "sketch_movies", Languages.Texts[418], 7, 0, nil },
		{ "C7L09_LoonyPark", Languages.Texts[817], "sketch_loony", Languages.Texts[397], 26, 0, nil },
		{ "C8L02_air_combat", Languages.Texts[906], "sketch_aircombat", Languages.Texts[922], 27, 0, nil },
		{ "C8L08_Sammaels_Lair", Languages.Texts[912], "sketch_samaelslair", Languages.Texts[418], 23, 0, "Story4.bik" },
	},
}

--ADDED=#####################################################################################
MapsMulti =
{
--	 Carte Multi
	{
		-- map directory, sketch
		{ "dm_blink", "blink_dm" },
		{ "dm_chessboard", "chessboard_dm" },
		{ "dm_fortress", "fortress_dm" },
		{ "dm_meatless", "meatless_dm" },
		{ "dm_powerplant", "powerplant_dm" },
		{ "dm_ragnarok", "ragnarok_dm" },
		{ "dm_riot", "riot_dm" },
		{ "dm_sphere", "sphere_dm" },	
		{ "dm_od_sacred", "sacred_dm" },
		{ "dm_od_absinthe", "absinthe_dm" },
		{ "dm_od_cursed", "cursed_dm" },
		{ "dm_od_psycho", "psycho_dm" },
		{ "ctf_trainstation", "trainstation_ctf" },
		{ "ctf_chaos", "chaos_ctf" },
		{ "ctf_forbidden", "forbidden_ctf" },
		{ "dmpcf_tower", "tower_pcf" },
		{ "dmpcf_warehouse", "warehouse_pcf" },	
		{ dir, "sketch_mp" },
	},	
}
--ADDED=end#####################################################################################

LevelsDemo = {
	{
		{ "C7L01_field_ambulance", Languages.Texts[880], "sketch_field", Languages.Texts[811], 8, 0, nil },
		{ "C7L04_haunted_valley", Languages.Texts[884], "sketch_haunted", Languages.Texts[407], 8, 0, nil },

	}
}


Levels = LevelsExp

function Levels_FillMap()
	if not Game then return end
	
	Levels = LevelsExp
	if IsDemoPress() then Levels=LevelsDemo end
	
	local current_set = false

	for i=1,table.getn(Levels) do
		for j=1,table.getn(Levels[i]) do
			if (i < 5 or Game.Difficulty < Difficulties.Trauma) and Levels[i][j][1] ~= "" then
				local dir = Levels[i][j][1]
				local diff = Levels[i][j][6]

				local status = 0 -- unavailable

				if Game.LevelsStats[Levels[i][j][1]] == nil then
					Game:MakeEmptyLevelStats(Levels[i][j][1])
				end

				if Game.LevelsStats[Levels[i][j][1]].Finished == true then
					status = 2 -- finished
				end

--				if Game.Difficulty < diff then
--					status = 3 -- not available
--					Game.LevelsStats[Levels[i][j][1]].Finished = true
--				end


				if status == 0 then
					if (i == 1 and j == 1) then
						status = 1
					elseif j > 1 and Game.LevelsStats[Levels[i][j-1][1]] and Game.LevelsStats[Levels[i][j-1][1]].Finished == true then
						status = 1
					elseif i > 1 and Game.LevelsStats[Levels[i-1][table.getn(Levels[i-1])][1]] and Game.LevelsStats[Levels[i-1][table.getn(Levels[i-1])][1]].Finished == true then
						status = 1
					end
				end


				if current_set then
					status = 0
				elseif status == 1 then
					current_set = true
				end

				if status == 1 or status == 2 then
					PMENU.AddLevelToMap( i, Levels[i][j][1], Levels[i][j][2], "HUD/Map/"..Levels[i][j][3], Levels[i][j][4], Levels[i][j][5], status )
				else
					PMENU.AddLevelToMap( i, Levels[i][j][1], TXT.SPStats.Locked, "HUD/Map/sketch_question", Levels[i][j][4], 0, status )
				end
			end
		end
    end
end

function Levels_GetNextLevel(name)
	if name == nil then return nil end

	if not Game then return end
	
	Levels = LevelsExp
	if IsDemoPress() then Levels=LevelsDemo end

	local ret = false
	for i=1,table.getn(Levels) do
		for j=1,table.getn(Levels[i]) do
			if ret == true and Game.Difficulty >= Levels[i][j][6] then
				return Levels[i][j][1]
			end
			if Levels[i][j][1] == name then
				ret = true
			end
		end
	end

	if ret then return Levels[1][1][1] end

--	if ret then return Levels[5][1][1] end
end

function Levels_GetLevelName(dir)
	if dir == nil then return nil end

	if not Game then return end
	
	Levels = LevelsExp
	if IsDemoPress() then Levels=LevelsDemo end

	for i=1,table.getn(Levels) do
		for j=1,table.getn(Levels[i]) do
			if Levels[i][j][1] == dir then
					return "C"..string.format("%02d",i).."E"..string.format("%02d",j).." - "..Levels[i][j][2]
			end
		end
	end
end

function Levels_GetLevelByDir(dir)
	Levels = LevelsExp
	if IsDemoPress() then Levels=LevelsDemo end
	if dir == nil then return nil, nil end
	for i=1,table.getn(Levels) do
		for j=1,table.getn(Levels[i]) do
			if Levels[i][j][1] == dir then
				return j,i
			end
		end
	end
end

function Levels_GetSketchByDir(dir)
	--Levels = LevelsExp
	--if IsDemoPress() then Levels=LevelsDemo end
	if dir == nil then return nil end
	--[[for i=1,table.getn(Levels) do
		for j=1,table.getn(Levels[i]) do
			if Levels[i][j][1] == dir then
				return "HUD/Map/"..Levels[i][j][3]
			end
		end
	end]]--
--MODiFIED=#####################################################################################
	if string.find(string.lower(dir),"dm_") or string.find(string.lower(dir),"dmpcf_") or string.find(string.lower(dir),"ctf_") then
		for i=1,table.getn(MapsMulti) do
		 	for j=1,table.getn(MapsMulti[i]) do
				if MapsMulti[i][j][1] == string.lower(dir) then				
					return "../ProOptions/Loading/"..MapsMulti[i][j][2]	
				end
		 	end
	  	end	
		--return "HUD/Map/sketch_mp"
	end

	return "HUD/Map/sketch_mp"	
--MODiFIED=end###################################################################################
end


-- Loading screen

ProgressIcons =
{
	{ 275, 92, "HUD/loading/s_1" },
	{ 300, 98, "HUD/loading/s_2" },
	{ 323, 109, "HUD/loading/s_3" },
--	{ 307, 92, "HUD/loading/s_3" },
	{ 347, 124, "HUD/loading/s_4" },
	{ 367, 142, "HUD/loading/s_5" },

	{ 404, 202, "HUD/loading/s_6" },
	{ 411, 223, "HUD/loading/s_7" },
	{ 415, 248, "HUD/loading/s_2" },
	{ 410, 275, "HUD/loading/s_8" },
	{ 406, 300, "HUD/loading/s_9" },

	{ 373, 363, "HUD/loading/s_5" },
	{ 354, 381, "HUD/loading/s_1" },
	{ 333, 394, "HUD/loading/s_4" },
	{ 305, 408, "HUD/loading/s_6" },
	{ 279, 416, "HUD/loading/s_3" },

	{ 218, 415, "HUD/loading/s_8" },
	{ 193, 409, "HUD/loading/s_7" },
	{ 168, 396, "HUD/loading/s_9" },
	{ 142, 381, "HUD/loading/s_2" },
	{ 123, 360, "HUD/loading/s_5" },

	{ 92, 304, "HUD/loading/s_1" },
	{ 87, 280, "HUD/loading/s_4" },
	{ 85, 254, "HUD/loading/s_8" },
	{ 87, 227, "HUD/loading/s_3" },
	{ 93, 204, "HUD/loading/s_6" },

	{ 123, 148, "HUD/loading/s_9" },
	{ 142, 129, "HUD/loading/s_2" },
	{ 168, 109, "HUD/loading/s_7" },
	{ 195, 98, "HUD/loading/s_8" },
	{ 220, 92, "HUD/loading/s_5" },
}

function LoadScreen_FillIcons()
	for i=1,table.getn(ProgressIcons) do
		PMENU.SetProgressIcon( i - 1, ProgressIcons[i][1], ProgressIcons[i][2], ProgressIcons[i][3] )
	end
end
