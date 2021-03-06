ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\master.lvl")
--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- load the gametype script
ScriptCB_DoFile("ME5_Master")
ScriptCB_DoFile("ME5_setup_teams")
ScriptCB_DoFile("ME5_ObjectiveConquest")

-- Create a new MapManager object
manager = MapManager:New{
	-- Map-specific details
	gameMode = "conquest",
	mapSize = "lg",
	environmentType = "jungle",
	
	-- In-game music
	musicVariation_SSVxGTH = "3_vrm",
	musicVariation_SSVxCOL = "5",
	musicVariation_EVGxGTH = "9",
	musicVariation_EVGxCOL = "9",
	musicVariation_SSVxRPR = {"8", "5_mahavid"},
	
	-- Online matches
	onlineSideVar = "SSVxGTH",
	onlineHeroSSV = "shep_infiltrator",
	onlineHeroGTH = "gethprime_me2",
	onlineHeroCOL = "colgeneral",
	onlineHeroEVG = "gethprime_me3",
	
	-- AI hero spawns. CP name, CP spawn path name
	heroSupportCPs = {
				{"CP1CON", "CP1CONPATH"},
				{"CP3CON", "CP3CONPATH"},
				{"CP4CON", "CP4CONPATH"},
				{"CP5CON", "CP5CONPATH"},
	},
	-- Local ally spawns. CP name, CP spawn path name
	allySpawnCPs = {
				{"CP1CON", "CP1CONPATH"},
				{"CP3CON", "CP3CONPATH"},
				{"CP4CON", "CP4CONPATH"},
				{"CP5CON", "CP5CONPATH"},
	},
	
	-- Artillery strike path nodes. Path name, path node ID
	artilleryNodes = {
				{"CP1CONPATH", 0},
				{"CP3CONPATH", 0},
				{"CP4CONPATH", 0},
				{"CP5CONPATH", 0},
	},
	terrainType = "dirt",
}
-- Initialize the MapManager
manager:Init()

-- Randomize which team is ATT/DEF
if not ScriptCB_InMultiplayer() then
	CIS = math.random(1,2)
	REP = (3 - CIS)
else
	REP = 1
	CIS = 2
end

HuskTeam = 3

ATT = 1
DEF = 2

---------------------------------------------------------------------------
-- FUNCTION:    ScriptInit
-- PURPOSE:     This function is only run once
-- INPUT:
-- OUTPUT:
-- NOTES:       The name, 'ScriptInit' is a chosen convention, and each
--              mission script must contain a version of this function, as
--              it is called from C to start the mission.
---------------------------------------------------------------------------

function ScriptPostLoad()

	AddDeathRegion("deathregion")
	AddDeathRegion("deathregion2")
 
    EnableSPHeroRules()
    
    --CP SETUP for CONQUEST
    
    cp1 = CommandPost:New{name = "CP1CON"}
    cp3 = CommandPost:New{name = "CP3CON"}
    cp4 = CommandPost:New{name = "CP4CON"}
    cp5 = CommandPost:New{name = "CP5CON"}
    
    conquest = ObjectiveConquest:New{teamATT = ATT, teamDEF = DEF, textATT = "game.modes.con", textDEF = "game.modes.con2", multiplayerRules = true}
    
    conquest:AddCommandPost(cp1)
    conquest:AddCommandPost(cp3)
    conquest:AddCommandPost(cp4)
    conquest:AddCommandPost(cp5)
    
    conquest.OnStart = function(self)
    	conquest.goal1 = AddAIGoal(REP, "Defend", 30, "gatepanel")
		conquest.goal2 = AddAIGoal(CIS, "Destroy", 30, "gatepanel")
		conquest.goal3 = AddAIGoal(CIS, "Destroy", 10, "woodl")
		conquest.goal4 = AddAIGoal(CIS, "Destroy", 10, "woodc")
		conquest.goal5 = AddAIGoal(CIS, "Destroy", 10, "woodr")
		conquest.goal6 = AddAIGoal(REP, "Defend", 10, "woodl")
		conquest.goal7 = AddAIGoal(REP, "Defend", 10, "woodc")
		conquest.goal8 = AddAIGoal(REP, "Defend", 10, "woodr")
	end
    
    conquest:Start()
	
	manager:Proc_ScriptPostLoad_End()
    
    --Gate Stuff -- 
    BlockPlanningGraphArcs("seawall1")
    BlockPlanningGraphArcs("woodl")
    BlockPlanningGraphArcs("woodc")
    BlockPlanningGraphArcs("woodr")
    DisableBarriers("disableme");
    
    SetProperty("woodl", "MaxHealth", 15000)
    SetProperty("woodl", "CurHealth", 15000)
    SetProperty("woodr", "MaxHealth", 15000)
    SetProperty("woodr", "CurHealth", 15000)
    SetProperty("woodc", "MaxHealth", 15000)
    SetProperty("woodc", "CurHealth", 15000)
    SetProperty("gatepanel", "MaxHealth", 1000)
    SetProperty("gatepanel", "CurHealth", 1000)
    
    
     OnObjectKillName(PlayAnimDown, "gatepanel");
     OnObjectRespawnName(PlayAnimUp, "gatepanel");
     OnObjectKillName(woodl, "woodl");
     OnObjectKillName(woodc, "woodc");
     OnObjectKillName(woodr, "woodr");
     OnObjectRespawnName(woodlr, "woodl");
     OnObjectRespawnName(woodcr, "woodc");
     OnObjectRespawnName(woodrr, "woodr");
 end
 
 function PlayAnimDown()
    PauseAnimation("thegateup");
    RewindAnimation("thegatedown");
    PlayAnimation("thegatedown");
    ShowMessageText("level.kas2.objectives.gateopen",1)
    ScriptCB_SndPlaySound("KAS_obj_13")
    SetProperty("gatepanel", "MaxHealth", 2200)
--    SetProperty("gatepanel", "CurHealth", 50000)
--    PlayAnimation("gatepanel");
    --SetProperty("gatepanel", "MaxHealth", 1e+37)
    --SetProperty("gatepanel", "CurHealth", 1e+37)
      
            
   -- Allowing AI to run under gate   
    UnblockPlanningGraphArcs("seawall1");
    DisableBarriers("seawalldoor1");
    DisableBarriers("vehicleblocker");
      
end

function PlayAnimUp()
    PauseAnimation("thegatedown");
    RewindAnimation("thegateup");
    PlayAnimation("thegateup");
      
            
   -- Allowing AI to run under gate   
    BlockPlanningGraphArcs("seawall1");
    EnableBarriers("seawalldoor1");
    EnableBarriers("vehicleblocker");
    SetProperty("gatepanel", "MaxHealth", 1000)
    SetProperty("gatepanel", "CurHealth", 1000)
      
end

function woodl()
    UnblockPlanningGraphArcs("woodl");
    DisableBarriers("woodl");
    SetProperty("woodl", "MaxHealth", 1800)
--    SetProperty("woodl", "CurHealth", 15)
end
    
function woodc()
    UnblockPlanningGraphArcs("woodc");
    DisableBarriers("woodc");
    SetProperty("woodc", "MaxHealth", 1800)
--    SetProperty("woodc", "CurHealth", 15)
end
    
function woodr()
    UnblockPlanningGraphArcs("woodr");
    DisableBarriers("woodr");
    SetProperty("woodr", "MaxHealth", 1800)
--    SetProperty("woodr", "CurHealth", 15)
end

function woodlr()
	BlockPlanningGraphArcs("woodl")
	EnableBarriers("woodl")
	SetProperty("woodl", "MaxHealth", 15000)
    SetProperty("woodl", "CurHealth", 15000)
end
	
function woodcr()
	BlockPlanningGraphArcs("woodc")
	EnableBarriers("woodc")
	SetProperty("woodc", "MaxHealth", 15000)
    SetProperty("woodc", "CurHealth", 15000)
end

function woodrr()
	BlockPlanningGraphArcs("woodr")
	EnableBarriers("woodr")
	SetProperty("woodr", "MaxHealth", 15000)
    SetProperty("woodr", "CurHealth", 15000)
end

function ScriptInit()
    -- Designers, these two lines *MUST* be first!
    StealArtistHeap(800 * 1024)
    SetPS2ModelMemory(3535000)
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\Load\\load.lvl;kas2")
	
	SetMemoryPoolSize("ParticleTransformer::ColorTrans", 2204)
	SetMemoryPoolSize("ParticleTransformer::PositionTr", 1302)
	SetMemoryPoolSize("ParticleTransformer::SizeTransf", 1420)
	
	manager:Proc_ScriptInit_Begin()
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\PFX_SSV_Veh.lvl")

    SetMaxFlyHeight(70);
	SetGroundFlyerMap(1);
	
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\me5tur.lvl",
					"tur_bldg_mturret")
	
	manager:Proc_ScriptInit_SideSetup()
	
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_s_KAS_Streaming.lvl;kas2n")

    --  Level Stats
    ClearWalkers()
    AddWalkerType(0, 0) -- 4 droidekas (special case: 0 leg pairs)
    AddWalkerType(1, 0) --
    AddWalkerType(2, 6) -- 2 spider walkers with 2 leg pairs each
    AddWalkerType(3, 0) -- 2 attes with 3 leg pairs each
    local weaponCnt = 230
    SetMemoryPoolSize("Aimer", 70)
    SetMemoryPoolSize("AmmoCounter", weaponCnt)
    SetMemoryPoolSize("BaseHint", 220)
    SetMemoryPoolSize("EnergyBar", weaponCnt)
    SetMemoryPoolSize("EntityHover", 11)
    SetMemoryPoolSize("EntityLight", 40)
    SetMemoryPoolSize("EntityCloth", 0)
    SetMemoryPoolSize("EntityFlyer", 6)
    SetMemoryPoolSize("EntitySoundStream", 32)
    SetMemoryPoolSize("EntitySoundStatic", 120)
    SetMemoryPoolSize("Navigator", 50)
    SetMemoryPoolSize("Obstacle", 300)
    SetMemoryPoolSize("PathFollower", 50)
    SetMemoryPoolSize("PathNode", 512)
    SetMemoryPoolSize("SoldierAnimation", 405)
    SetMemoryPoolSize("TentacleSimulator", 8)
    SetMemoryPoolSize("TreeGridStack", 300)
    SetMemoryPoolSize("UnitAgent", 50)
    SetMemoryPoolSize("UnitController", 50)
    SetMemoryPoolSize("Weapon", weaponCnt)
	manager:Proc_ScriptInit_MemoryPoolInit()

    SetSpawnDelay(10.0, 0.25)
    ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ME5\\kas2.lvl", "kas2_con")
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\minimap.lvl;kas2")
    SetDenseEnvironment("false")
    
    SetMaxFlyHeight(65)
    SetMaxPlayerFlyHeight(65)
	AISnipeSuitabilityDist(90)
	SetAttackerSnipeRange(100)
	SetDefenderSnipeRange(150)

    --  Birdies
    SetNumBirdTypes(1)
    SetBirdType(0,1.0,"bird")

    --  Fishies
    SetNumFishTypes(1)
    SetFishType(0,0.8,"fish")

    --  Sound
	
	manager:Proc_ScriptInit_MusicSetup()
	
	OpenAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_s_KAS_Streaming.lvl",  "kas2")
	
	SoundFX()

    SetAttackingTeam(ATT)


    --Kas2 Docks
    --Wide beach shot
	AddCameraShot(0.977642, -0.052163, -0.203414, -0.010853, 66.539520, 21.864969, 168.598495);
	AddCameraShot(0.969455, -0.011915, 0.244960, 0.003011, 219.552948, 21.864969, 177.675674);
	AddCameraShot(0.995040, -0.013447, 0.098558, 0.001332, 133.571289, 16.216759, 121.571236);
	AddCameraShot(0.350433, -0.049725, -0.925991, -0.131394, 30.085188, 32.105236, -105.325264);



-- GOOD SHOTS -- 
	-- Gate to Right


--Kinda Cool -- 
	
    AddCameraShot(0.163369, -0.029669, -0.970249, -0.176203, 85.474831, 47.313362, -156.345627);
	AddCameraShot(0.091112, -0.011521, -0.987907, -0.124920, 97.554062, 53.690968, -179.347076);
	AddCameraShot(0.964953, -0.059962, 0.254988, 0.015845, 246.471008, 20.362143, 153.701050);  
	
-- OLD -- 

--    AddCameraShot(0.993669, -0.099610, -0.051708, -0.005183, 109.473549, 34.506077, 272.889221);
--    AddCameraShot(0.940831, -0.108255, -0.319013, -0.036707, -65.793930, 66.455177, 289.432678);
	
	manager:Proc_ScriptInit_End()


end
