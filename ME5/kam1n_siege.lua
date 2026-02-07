ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\master.lvl")
--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

ScriptCB_DoFile("ME5_Master")
ScriptCB_DoFile("ME5_setup_teams")
ScriptCB_DoFile("ME5_ObjectiveBFConquest")

-- Create a new MapManager object
manager = MapManager:New{
	-- Map-specific details
	gameMode = "siege",
	mapSize = "med",
	environmentType = "urban",
	
	-- In-game music
	musicVariation_SSVxGTH = "1",
	musicVariation_SSVxCOL = "5",
	musicVariation_EVGxGTH = "9",
	musicVariation_EVGxCOL = "9",
	musicVariation_SSVxRPR = "5_mahavid",
    musicVariation_SSVxCER = "7",
	
	-- Online matches
	onlineSideVar = "SSVxCOL",
	onlineHeroSSV = "shep_infiltrator",
	onlineHeroGTH = "gethprime_me2",
	onlineHeroCOL = "colgeneral",
	onlineHeroEVG = "gethprime_me3",
	
	-- AI hero spawns. CP name, CP spawn path name
	heroSupportCPs = {
				{"team2_permacp", "cp1_spawn"},
				{"team1_permacp", "cp2_spawn"},
				{"cp3", "cp3_spawn"},
				{"cp4", "path32"},
				{"cp5", "cp5_spawn"},
				{"cp6", "path31"},
				{"cp7", "cp4_spawn"},
	},
	-- Local ally spawns. CP name, CP spawn path name
	allySpawnCPs = {
				{"team2_permacp", "cp1_spawn"},
				{"team1_permacp", "cp2_spawn"},
				{"cp3", "cp3_spawn"},
				{"cp4", "path32"},
				{"cp5", "cp5_spawn"},
				{"cp6", "path31"},
				{"cp7", "cp4_spawn"},
	},
}
-- Initialize the MapManager
manager:Init()

-- Randomize which team is ATT/DEF
if manager.useRandomFactionIds == true and not ScriptCB_InMultiplayer() then
	CIS = math.random(1,2)
	REP = (3 - CIS)
else
	REP = 2
	CIS = 1
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
DisableBarriers("frog")
DisableBarriers("close")
DisableBarriers("camp")

    UnblockPlanningGraphArcs("connection71")

     SetProperty("team2_permacp", "Team", "1")
    SetProperty("team1_permacp", "Team", "2")
	SetObjectTeam("cp3", 0)
	SetObjectTeam("cp4", 0)
	SetObjectTeam("cp5", 0)
	SetObjectTeam("cp6", 0)
	SetObjectTeam("cp7", 0)
	KillObject("cp1")
	KillObject("cp2")
	
    SetAIDamageThreshold("Comp1", 0 )
    SetAIDamageThreshold("Comp2", 0 )
    SetAIDamageThreshold("Comp3", 0 )
    SetAIDamageThreshold("Comp4", 0 )
    SetAIDamageThreshold("Comp5", 0 )
  	SetAIDamageThreshold("Comp6", 0 )
    SetAIDamageThreshold("Comp7", 0 )
    SetAIDamageThreshold("Comp8", 0 )
    SetAIDamageThreshold("Comp9", 0 )
    SetAIDamageThreshold("Comp10", 0 )



	        SetProperty("Kam_Bldg_Podroom_Door32", "Islocked", 1)

    SetProperty("Kam_Bldg_Podroom_Door33", "Islocked", 1)
        SetProperty("Kam_Bldg_Podroom_Door32", "Islocked", 1)
                SetProperty("Kam_Bldg_Podroom_Door34", "Islocked", 1)
    SetProperty("Kam_Bldg_Podroom_Door35", "Islocked", 1)
        SetProperty("Kam_Bldg_Podroom_Door27", "Islocked", 0)       
            SetProperty("Kam_Bldg_Podroom_Door28", "Islocked", 1)       
    SetProperty("Kam_Bldg_Podroom_Door36", "Islocked", 1)
        SetProperty("Kam_Bldg_Podroom_Door20", "Islocked", 0)
    UnblockPlanningGraphArcs("connection71")
        
   --Objective1
    UnblockPlanningGraphArcs("connection85")
        UnblockPlanningGraphArcs("connection48")
            UnblockPlanningGraphArcs("connection63")
                UnblockPlanningGraphArcs("connection59")
                         UnblockPlanningGraphArcs("close")
                         UnblockPlanningGraphArcs("open")
                         DisableBarriers("frog")
                         DisableBarriers("close")
                         DisableBarriers("open")
        
    --blocking Locked Doors
    UnblockPlanningGraphArcs("connection194");
        UnblockPlanningGraphArcs("connection200");
            UnblockPlanningGraphArcs("connection118");
               DisableBarriers("FRONTDOOR2-3");
                DisableBarriers("FRONTDOOR2-1");  
                 DisableBarriers("FRONTDOOR2-2");  
   
    --Lower cloning facility
    UnblockPlanningGraphArcs("connection10")
        UnblockPlanningGraphArcs("connection159")
            UnblockPlanningGraphArcs("connection31")
               DisableBarriers("FRONTDOOR1-3")
                DisableBarriers("FRONTDOOR1-1")  
                 DisableBarriers("FRONTDOOR1-2")
    
        --This defines the CPs.  These need to happen first
    cp1 = CommandPost:New{name = "team2_permacp"}
    cp2 = CommandPost:New{name = "team1_permacp"}
    cp3 = CommandPost:New{name = "cp3"}
    cp4 = CommandPost:New{name = "cp4"}
    cp5 = CommandPost:New{name = "cp5"}
   	cp6 = CommandPost:New{name = "cp6"}
   	cp7 = CommandPost:New{name = "cp7"}
    
    --This sets up the actual objective.  This needs to happen after cp's are defined
    conquest = ObjectiveConquest:New{teamATT = ATT, teamDEF = DEF, textATT = "game.modes.siege", textDEF = "game.modes.siege2", multiplayerRules = true}
    
    --This adds the CPs to the objective.  This needs to happen after the objective is set up
    conquest:AddCommandPost(cp1)
    conquest:AddCommandPost(cp2)
    conquest:AddCommandPost(cp3)
    conquest:AddCommandPost(cp4)
    conquest:AddCommandPost(cp5)
 	conquest:AddCommandPost(cp6)
 	conquest:AddCommandPost(cp7)
	conquest:Start()
 
    EnableSPHeroRules()
    
    SetProperty("team1_permacp", "spawnpath", "cp2_spawn")
    
    BlockPlanningGraphArcs("group1");
        BlockPlanningGraphArcs("connection165");
            BlockPlanningGraphArcs("connection162");
                BlockPlanningGraphArcs("connection160");
                    BlockPlanningGraphArcs("connection225");
    
    
	manager:Proc_ScriptPostLoad_End()
	
end

function ScriptInit()
	StealArtistHeap(2048*1024)
    -- Designers, these two lines *MUST* be first!
    SetPS2ModelMemory(3000000)
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\Load\\load.lvl;kam1")
	
	SetMemoryPoolSize("ParticleTransformer::ColorTrans", 2225)
	SetMemoryPoolSize("ParticleTransformer::PositionTr", 1330)
	SetMemoryPoolSize("ParticleTransformer::SizeTransf", 1478)
	
    manager:Proc_ScriptInit_Begin()
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\PFX_SSV_Veh.lvl;vehcommon")
	
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\me5tur.lvl",
					"tur_bldg_laser",
					"tur_bldg_mturret")
	
	manager:Proc_ScriptInit_SideSetup()
	
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_s_KAM_Streaming.lvl;kam1n")
	
	
    --  Level Stats
    ClearWalkers()
 
    AddWalkerType(0, 0) -- droidekas
    local weaponCnt = 215
    SetMemoryPoolSize("Aimer", 39)
    SetMemoryPoolSize("AmmoCounter", weaponCnt)
    SetMemoryPoolSize("BaseHint", 210)
    SetMemoryPoolSize("EnergyBar", weaponCnt)
	SetMemoryPoolSize("EntityCloth", 0)
	SetMemoryPoolSize("EntityHover", 10)
    SetMemoryPoolSize("EntityLight", 152)
    SetMemoryPoolSize("EntitySoundStream", 12)
    SetMemoryPoolSize("EntitySoundStatic", 84)
    SetMemoryPoolSize("Music", 88)
    SetMemoryPoolSize("Navigator", 50)
    SetMemoryPoolSize("Obstacle", 931)
    SetMemoryPoolSize("PathFollower", 50)
    SetMemoryPoolSize("PathNode", 256)
    SetMemoryPoolSize("RedOmniLight", 155)
	SetMemoryPoolSize("SoldierAnimation", 406)
    SetMemoryPoolSize("SoundSpaceRegion", 36)
    SetMemoryPoolSize("TentacleSimulator", 0)
    SetMemoryPoolSize("TreeGridStack", 391)
    SetMemoryPoolSize("UnitAgent", 50)
    SetMemoryPoolSize("EntityFlyer", 6)
    SetMemoryPoolSize("UnitController", 50)
    SetMemoryPoolSize("Weapon", weaponCnt)
	manager:Proc_ScriptInit_MemoryPoolInit()
    
    SetSpawnDelay(10.0, 0.25)
    ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ME5\\kam1.lvl", "kamino1_siege")
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\minimap.lvl;kam1")
    SetDenseEnvironment("false")

    --  AI
    SetMinFlyHeight(60)
    SetAllowBlindJetJumps(0)
       SetMaxFlyHeight(102)
    SetMaxPlayerFlyHeight(102)
	AISnipeSuitabilityDist(90)
	SetAttackerSnipeRange(100)
	SetDefenderSnipeRange(150)

    --  Sound
	
	manager:Proc_ScriptInit_MusicSetup()
	
	OpenAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_s_KAM_Streaming.lvl",  "kam1")
	OpenAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_s_KAM_Streaming.lvl",  "kam1")
	
	SoundFX()
	ScaleSoundParameter("ambientenv",	"Gain", 1.0)


    SetAttackingTeam(ATT)

    AddDeathRegion("deathregion")

 		    AddCameraShot(0.564619, -0.121047, 0.798288, 0.171142, 68.198814, 79.137611, 110.850922);

            AddCameraShot(-0.281100, 0.066889, -0.931340, -0.221616, 10.076019, 82.958336, -26.261774);

            AddCameraShot(0.209553, -0.039036, -0.960495, -0.178923, 92.558563, 58.820618, 130.675919);

            AddCameraShot(0.968794, 0.154227, 0.191627, -0.030506, -173.914413, 69.858940, 52.532421);

            AddCameraShot(0.744389, 0.123539, 0.647364, -0.107437, 97.475639, 53.216236, 76.477089);

            AddCameraShot(-0.344152, 0.086702, -0.906575, -0.228393, 95.062233, 105.285820, -37.661552);
	
	manager:Proc_ScriptInit_End()
end
