ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\master.lvl")
RandomSide = math.random(1,4) 

isModMap = 1
--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

ScriptCB_DoFile("ME5_Master")
ScriptCB_DoFile("ME5_setup_teams")
ScriptCB_DoFile("ME5_ObjectiveConquest")

mapSize = med
EnvironmentType = 2
onlineSideVar = SSVxGTH
onlineHeroSSV = shep_soldier
onlineHeroGTH = gethprime_me2
onlineHeroCOL = colgeneral
onlineHeroEVG = gethprime_me3
isTDM = true

if not ScriptCB_InMultiplayer() then
	CIS = math.random(1,2)
	REP = (3 - CIS)
else
	REP = 2
	CIS = 1
end

HuskTeam = 3

ATT = 1
DEF = 2

function SSVxGTH_PostLoad()
	if not ScriptCB_InMultiplayer() then
		DecideSSVHeroClass()
		DecideGTHHeroClass()
	else end
end

function SSVxCOL_PostLoad()
	if not ScriptCB_InMultiplayer() then
		DecideSSVHeroClass()
		DecideCOLHeroClass()
	else end
end

function EVGxGTH_PostLoad()
	if not ScriptCB_InMultiplayer() then
		DecideEVGHeroClass()
		DecideGTHHeroClass()
	else end
end

function EVGxCOL_PostLoad()
	if not ScriptCB_InMultiplayer() then
		DecideEVGHeroClass()
		DecideCOLHeroClass()
	else end
end
    
function ScriptPostLoad() 
--WeatherMode = math.random(1,3)
--weather()
    
    --This defines the CPs.  These need to happen first
    cp1 = CommandPost:New{name = "cp1_tdm"}
    cp2 = CommandPost:New{name = "cp2_tdm"}
    cp3 = CommandPost:New{name = "cp3_tdm"}
    cp4 = CommandPost:New{name = "cp4_tdm"}
    
    
    
    --This sets up the actual objective.  This needs to happen after cp's are defined
    conquest = ObjectiveConquest:New{teamATT = ATT, teamDEF = DEF, 
                                     textATT = "game.modes.tdm", textDEF = "game.modes.tdm2", 
                                     
                                     multiplayerRules = true}
    
    --This adds the CPs to the objective.  This needs to happen after the objective is set up
    conquest:AddCommandPost(cp1)
    conquest:AddCommandPost(cp2)
    conquest:AddCommandPost(cp3)
    conquest:AddCommandPost(cp4)
	
	SetProperty("cp1_tdm", "AllyPath", "cp1_tdm_spawn")
	SetProperty("cp2_tdm", "AllyPath", "cp2_tdm_spawn")
	SetProperty("cp3_tdm", "AllyPath", "cp3_tdm_spawn")
	SetProperty("cp4_tdm", "AllyPath", "cp4_tdm_spawn")
	
	ClearAIGoals(1)
	ClearAIGoals(2)
	AddAIGoal(1, "Deathmatch", 100)
	AddAIGoal(2, "Deathmatch", 100)
	AddAIGoal(HuskTeam, "Deathmatch", 100)
	
	if not ScriptCB_InMultiplayer() then
		if ME5_SideVar == 0 then
			if RandomSide == 1 then
				SSVxGTH_PostLoad()
			elseif RandomSide == 2 then
				SSVxCOL_PostLoad()
			elseif RandomSide == 3 then
				EVGxGTH_PostLoad()
			elseif RandomSide == 4 then
				EVGxCOL_PostLoad()
			end
		elseif ME5_SideVar == 1 then
			SSVxGTH_PostLoad()
		elseif ME5_SideVar == 2 then
			SSVxCOL_PostLoad()
		elseif ME5_SideVar == 3 then
			EVGxGTH_PostLoad()
		elseif ME5_SideVar == 4 then
			EVGxCOL_PostLoad()
		else end
	else
		SSVxGTH_PostLoad()
	end
	
	SetReinforcementCount(REP, 200)
	SetReinforcementCount(CIS, 200)
    
    conquest:Start()

    EnableSPHeroRules()

    AddDeathRegion("monorail")
    AddDeathRegion("ocean")
	
	PostLoadStuff()
    
end

--[[function weather()
	if WeatherMode == 1 then
		ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ME5\\SKY\\spa_sky.lvl", "red")
	elseif WeatherMode == 2 then
		ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ME5\\SKY\\spa_sky.lvl", "blue")
	elseif WeatherMode == 3 then
		ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ME5\\SKY\\spa_sky.lvl", "night")
	end
end]]


---------------------------------------------------------------------------
-- FUNCTION:    ScriptInit
-- PURPOSE:     This function is only run once
-- INPUT:
-- OUTPUT:
-- NOTES:       The name, 'ScriptInit' is a chosen convention, and each
--              mission script must contain a version of this function, as
--              it is called from C to start the mission.
---------------------------------------------------------------------------

function ScriptInit()
    -- Designers, these two lines *MUST* be first!
    StealArtistHeap(256*1024)
    SetPS2ModelMemory(2097152 + 65536 * 10)
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\Load\\edn.lvl")
	
	SetMemoryPoolSize("ParticleTransformer::ColorTrans", 2551)
	SetMemoryPoolSize("ParticleTransformer::PositionTr", 1532)
	SetMemoryPoolSize("ParticleTransformer::SizeTransf", 1691)
	
	PreLoadStuff()
	
	SetMaxFlyHeight(23)
	SetMaxPlayerFlyHeight(23)
	AISnipeSuitabilityDist(55)
	SetAttackerSnipeRange(70)
	SetDefenderSnipeRange(100)
	
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\me5tur.lvl",
					"tur_bldg_mturret",
					"tur_bldg_laser")
	
	Init_SideSetup()
	
	--SetTeamAggressiveness(CIS,(0.97))
	--SetTeamAggressiveness(REP,(0.99))
	
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_EDN_Streaming.lvl")

    --  Level Stats
    ClearWalkers()
    AddWalkerType(0, 0) -- special -> droidekas
    AddWalkerType(1, 0) -- 1x2 (1 pair of legs)
    AddWalkerType(2, 0) -- 2x2 (2 pairs of legs)
    AddWalkerType(3, 0) -- 3x2 (3 pairs of legs)
    
    local weaponCnt = 230
    SetMemoryPoolSize("Aimer", 46)
    SetMemoryPoolSize("AmmoCounter", weaponCnt)
    SetMemoryPoolSize("BaseHint", 325)
    SetMemoryPoolSize("EnergyBar", weaponCnt)
    SetMemoryPoolSize("EntityCloth", 0)
    SetMemoryPoolSize("EntitySoundStatic", 43)
	SetMemoryPoolSize("FlagItem", 512)
    SetMemoryPoolSize("MountedTurret", 20)
    SetMemoryPoolSize("Music", 99)
    SetMemoryPoolSize("Navigator", 100)
    SetMemoryPoolSize("Obstacle", 667)
    SetMemoryPoolSize("PathFollower", 100)
    SetMemoryPoolSize("PathNode", 256)
	SetMemoryPoolSize("SoldierAnimation", 382)
	SetMemoryPoolSize("SoundSpaceRegion", 96)
    SetMemoryPoolSize("TreeGridStack", 325)
    SetMemoryPoolSize("UnitAgent", 100)
    SetMemoryPoolSize("UnitController", 100)
    SetMemoryPoolSize("Weapon", weaponCnt)
	
	if not ScriptCB_InMultiplayer() then
		if ME5_SideVar == 0 then
			if RandomSide >= 3 then
					print("EDNn_con: Injecting Alliance Soldier textures workaround...")
				ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ME5\\GFX_EDN_Corpses.lvl")
			else end
		elseif ME5_SideVar >= 3 then
				print("EDNn_con: Injecting Alliance Soldier textures workaround...")
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ME5\\GFX_EDN_Corpses.lvl")
		else end
	else end

    SetSpawnDelay(10.0, 0.25)
	WeatherMode = math.random(1,3)
	if not ScriptCB_InMultiplayer() then
		if WeatherMode == 1 then
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ME5\\SKY\\spa_sky.lvl", "red")
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ME5\\EDN.lvl", "EDN_tdm_red")
			
			SetDenseEnvironment("false")
			SetAIViewMultiplier(0.85)
		elseif WeatherMode == 2 then
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ME5\\SKY\\spa_sky.lvl", "blue")
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ME5\\EDN.lvl", "EDN_tdm_day")
			
			SetNumBirdTypes(1)
			SetBirdType(0,1.0,"bird")
			SetBirdFlockMinHeight(50);
			
			SetDenseEnvironment("false")
			SetAIViewMultiplier(0.9)
		elseif WeatherMode == 3 then
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ME5\\SKY\\spa_sky.lvl", "night")
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ME5\\EDN.lvl", "EDN_tdm_night")
			
			SetDenseEnvironment("false")
			SetAIViewMultiplier(0.65)
		end
	else
		ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ME5\\SKY\\spa_sky.lvl", "blue")
		ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ME5\\EDN.lvl", "EDN_tdm_day")
		
		SetNumBirdTypes(1)
		SetBirdType(0,1.0,"bird")
		SetBirdFlockMinHeight(50);
		
		SetDenseEnvironment("false")
		SetAIViewMultiplier(0.9)
	end


	--  Sound Stats
    
	OpenAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\Sound\\SFL_EDN_Streaming.lvl",  "EDN_ambiance")
	
	if not ScriptCB_InMultiplayer() then
		if ME5_SideVar == 0 then
			if RandomSide == 1 then
				Music01()
			elseif RandomSide == 2 then
				Music05()
			elseif RandomSide == 3 then
				Music09()
			elseif RandomSide == 4 then
				Music09()
			end
		elseif ME5_SideVar == 1 then
			Music01()
		elseif ME5_SideVar == 2 then
			Music05()
		elseif ME5_SideVar == 3	then
			Music09()
		elseif ME5_SideVar == 4	then
			Music09()
		else end
	else
		Music01()
	end
	
	SoundFX()
	
    --  Camera Stats
    --Tat2 Mos Eisley
	-- Information: rot_y     rot_z      unknown   rot_x       pos_x     pos_y       pos_z
	AddCameraShot(0.327342, 0.011198, -0.944287, 0.032303, -74.878967, 5.497213, -69.507790);		-- tram station
	--AddCameraShot(0.335859, -0.053222, -0.928818, -0.147186, -74.092560, 6.867630, -67.068901);
	AddCameraShot(0.691021, -0.071285, 0.715514, 0.073812, 5.180315, 13.413967, 64.938232);			-- rock arena
	AddCameraShot(0.890509, -0.062477, -0.449551, -0.031540, -103.704811, 15.089904, 28.269190);	-- hillside
	AddCameraShot(0.609606, -0.055640, -0.787476, -0.071874, -108.782745, 17.936119, 58.947346);	-- sharkteeth
	AddCameraShot(-0.288168, 0.029941, -0.951987, -0.098914, -10.234917, 8.470562, -24.091652);		-- crate arena
	AddCameraShot(-0.000239, 0.000023, -0.995519, -0.094558, -1.801559, 5.236121, 14.380723);		-- greenhouse
end
