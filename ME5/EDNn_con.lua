ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\master.lvl")
--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

ScriptCB_DoFile("ME5_Master")
ScriptCB_DoFile("ME5_setup_teams")
ScriptCB_DoFile("ME5_ObjectiveConquest")

-- Create a new MapManager object
manager = MapManager:New{
	-- Map-specific details
	bIsModMap = true,
	gameMode = "conquest",
	mapSize = "med",
	environmentType = "jungle",
	
	-- In-game music
	musicVariation_SSVxGTH = "1",
	musicVariation_SSVxCOL = "5",
	musicVariation_EVGxGTH = "9",
	musicVariation_EVGxCOL = "9",
	
	-- Online matches
	onlineSideVar = "SSVxGTH",
	onlineHeroSSV = "shep_soldier",
	onlineHeroGTH = "gethprime_me2",
	onlineHeroCOL = "colgeneral",
	onlineHeroEVG = "gethprime_me3",
	
	-- AI hero spawns. CP name, CP spawn path name
	heroSupportCPs = {
				{"cp1", "cp1_spawn"},
				{"cp2", "cp2_spawn"},
				{"cp3", "cp3_spawn"},
				{"cp4", "cp4_spawn"},
				{"cp5", "cp5_spawn"},
				{"cp6", "cp6_spawn"},
	},
	-- Local ally spawns. CP name, CP spawn path name
	allySpawnCPs = {
				{"cp1", "cp1_spawn"},
				{"cp2", "cp2_spawn"},
				{"cp3", "cp3_spawn"},
				{"cp4", "cp4_spawn"},
				{"cp5", "cp5_spawn"},
				{"cp6", "cp6_spawn"},
	},
}
-- Initialize the MapManager
manager:Init()

-- Randomize which team is ATT/DEF
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
    
function ScriptPostLoad()
    
    --This defines the CPs.  These need to happen first
    cp1 = CommandPost:New{name = "cp1"}
    cp2 = CommandPost:New{name = "cp2"}
    cp3 = CommandPost:New{name = "cp3"}
    cp4 = CommandPost:New{name = "cp4"}
    cp5 = CommandPost:New{name = "cp5"}
    cp6 = CommandPost:New{name = "cp6"}
    
    
    
    --This sets up the actual objective.  This needs to happen after cp's are defined
    conquest = ObjectiveConquest:New{teamATT = ATT, teamDEF = DEF, 
                                     textATT = "game.modes.con", textDEF = "game.modes.con2", 
                                     multiplayerRules = true}
    
    --This adds the CPs to the objective.  This needs to happen after the objective is set up
    conquest:AddCommandPost(cp1)
    conquest:AddCommandPost(cp2)
    conquest:AddCommandPost(cp3)
    conquest:AddCommandPost(cp4)
    conquest:AddCommandPost(cp5)
    conquest:AddCommandPost(cp6)
    
    conquest:Start()

    EnableSPHeroRules()
	
	manager:Proc_ScriptPostLoad_End()

    AddDeathRegion("monorail")
    AddDeathRegion("ocean")
	
	SetProperty("cp1", "NeutralizeTime", 40)
	SetProperty("cp1", "CaptureTime", 35)
	SetProperty("cp2", "NeutralizeTime", 40)
	SetProperty("cp2", "CaptureTime", 35)
	SetProperty("cp3", "NeutralizeTime", 40)
	SetProperty("cp3", "CaptureTime", 35)
	SetProperty("cp4", "NeutralizeTime", 40)
	SetProperty("cp4", "CaptureTime", 35)
	SetProperty("cp5", "NeutralizeTime", 40)
	SetProperty("cp5", "CaptureTime", 35)
	SetProperty("cp6", "NeutralizeTime", 40)
	SetProperty("cp6", "CaptureTime", 35)
    
end

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
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\Load\\edn.lvl")
	
	SetMemoryPoolSize("ParticleTransformer::ColorTrans", 2551)
	SetMemoryPoolSize("ParticleTransformer::PositionTr", 1532)
	SetMemoryPoolSize("ParticleTransformer::SizeTransf", 1691)
	
	manager:Proc_ScriptInit_Begin()
	
	if not ScriptCB_InMultiplayer() then
		if ME5_Difficulty == 1 then
			SetAIDifficulty(1, -1)
			SetTeamAggressiveness(CIS,(0.53))
			SetTeamAggressiveness(REP,(0.63))
		elseif ME5_Difficulty == 2 then
			SetAIDifficulty(0, 0)
			SetTeamAggressiveness(CIS,(0.63))
			SetTeamAggressiveness(REP,(0.73))
		elseif ME5_Difficulty == 3 then
			SetAIDifficulty(-2, 1)
			SetTeamAggressiveness(CIS,(0.73))
			SetTeamAggressiveness(REP,(0.83))
		elseif ME5_Difficulty == 4 then
			SetAIDifficulty(-2, 2)
			SetTeamAggressiveness(CIS,(0.83))
			SetTeamAggressiveness(REP,(0.93))
		elseif ME5_Difficulty == 5 then
			SetAIDifficulty(-3, 3)
			SetTeamAggressiveness(CIS,(0.9))
			SetTeamAggressiveness(REP,(1.0))
		else
			SetAIDifficulty(-2, 2)
			SetTeamAggressiveness(CIS,(0.83))
			SetTeamAggressiveness(REP,(0.93))
		end
	else
		SetAIDifficulty(-2, 2)
		SetTeamAggressiveness(CIS,(0.85))
		SetTeamAggressiveness(REP,(0.95))
	end
	
	SetMaxFlyHeight(23)
	SetMaxPlayerFlyHeight(23)
	AISnipeSuitabilityDist(55)
	SetAttackerSnipeRange(70)
	SetDefenderSnipeRange(100)
	
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\me5tur.lvl",
					"tur_bldg_mturret",
					"tur_bldg_laser")
	
	manager:Proc_ScriptInit_SideSetup()
	
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
		if ME5_SideVar >= 3 then
			print("EDNn_con: Injecting Alliance Soldier textures workaround...")
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ME5\\GFX_EDN_Corpses.lvl")
		end
	end

    SetSpawnDelay(10.0, 0.25)
    
	-- Stormy variant
	if ME5_MapVarEDN == 1 then
		ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ME5\\SKY\\spa_sky.lvl", "red")
		ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ME5\\EDN.lvl", "EDN_conquest_red")
		
		SetDenseEnvironment("false")
		SetAIViewMultiplier(0.85)
		
	-- Cloudy variant
	elseif ME5_MapVarEDN == 2 then
		ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ME5\\SKY\\spa_sky.lvl", "blue")
		ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ME5\\EDN.lvl", "EDN_conquest_day")
		
		SetNumBirdTypes(1)
		SetBirdType(0,1.0,"bird")
		SetBirdFlockMinHeight(50);
		
		SetDenseEnvironment("false")
		SetAIViewMultiplier(0.9)
		
	-- Night variant
	elseif ME5_MapVarEDN == 3 then
		ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ME5\\SKY\\spa_sky.lvl", "night")
		ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ME5\\EDN.lvl", "EDN_conquest_night")
		
		SetDenseEnvironment("false")
		SetAIViewMultiplier(0.65)
	end
	
	
	--  Sound Stats
    
	OpenAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\Sound\\SFL_EDN_Streaming.lvl",  "EDN_ambiance")
	
	manager:Proc_ScriptInit_MusicSetup()
	
	SoundFX()
	
    -- Camera Stats
	AddCameraShot(0.327342, 0.011198, -0.944287, 0.032303, -74.878967, 5.497213, -69.507790);		-- tram station
	--AddCameraShot(0.335859, -0.053222, -0.928818, -0.147186, -74.092560, 6.867630, -67.068901);
	AddCameraShot(0.691021, -0.071285, 0.715514, 0.073812, 5.180315, 13.413967, 64.938232);			-- rock arena
	AddCameraShot(0.890509, -0.062477, -0.449551, -0.031540, -103.704811, 15.089904, 28.269190);	-- hillside
	AddCameraShot(0.609606, -0.055640, -0.787476, -0.071874, -108.782745, 17.936119, 58.947346);	-- sharkteeth
	AddCameraShot(-0.288168, 0.029941, -0.951987, -0.098914, -10.234917, 8.470562, -24.091652);		-- crate arena
	AddCameraShot(-0.000239, 0.000023, -0.995519, -0.094558, -1.801559, 5.236121, 14.380723);		-- greenhouse
	
	manager:Proc_ScriptInit_End()
end
