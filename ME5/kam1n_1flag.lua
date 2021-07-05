ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\master.lvl")
--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

ScriptCB_DoFile("ME5_Master")
ScriptCB_DoFile("ME5_setup_teams")
ScriptCB_DoFile("ME5_ObjectiveOneFlagCTF")

-- Create a new MapManager object
manager = MapManager:New{
	-- Map-specific details
	gameMode = "1flag",
	mapSize = "med",
	environmentType = "urban",
	
	-- In-game music
	musicVariation_SSVxGTH = "1",
	musicVariation_SSVxCOL = "5",
	musicVariation_EVGxGTH = "9",
	musicVariation_EVGxCOL = "9",
	musicVariation_SSVxRPR = "5_mahavid",
	
	-- Online matches
	onlineSideVar = "SSVxCOL",
	onlineHeroSSV = "shep_infiltrator",
	onlineHeroGTH = "gethprime_me2",
	onlineHeroCOL = "colgeneral",
	onlineHeroEVG = "gethprime_me3",
	
	-- AI hero spawns. CP name, CP spawn path name
	heroSupportCPs = {},
	-- Local ally spawns. CP name, CP spawn path name
	allySpawnCPs = {},
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
KillObject("cp2")
KillObject("cp1")

     SetProperty("cp11", "Team", "2")
    SetProperty("cp22", "Team", "1")        
    SetProperty("cp22", "SpawnPath", "NEW")
    SetProperty("cp22", "captureregion", "death")
    SetProperty("cp11", "captureregion", "death")
    --SetProperty("CP4", "HUDIndexDisplay", 0)
    KillObject("cp3")
    KillObject("CP4")
    KillObject("CP5")
    --SetProperty("FDL-2", "IsLocked", 1)
    --SetProperty("cp4", "IsVisible", 0)
   
    SetProperty("cp6", "Team", "2")
    SetProperty("cp7", "Team", "1")


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
    
    SetAIDamageThreshold("Comp1", 0 )
    SetAIDamageThreshold("Comp2", 0 )
    SetAIDamageThreshold("Comp3", 0 )
    SetAIDamageThreshold("Comp4", 0 )
    SetAIDamageThreshold("Comp5", 0 )



    
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
    
   EnableSPHeroRules()
   SoundEvent_SetupTeams( REP, 'rep', CIS, 'cis' )
        --This is the actual objective setup
    ctf = ObjectiveOneFlagCTF:New{teamATT = 1, teamDEF = 2,
                           textATT = "game.modes.1flag", textDEF = "game.modes.1flag2", 
                           captureLimit = 5, flag = "flag", flagIcon = "flag_icon", 
                           flagIconScale = 3.0, homeRegion = "flag_home",
                           captureRegionATT = "lag_capture2", captureRegionDEF = "lag_capture1",
                           capRegionMarkerATT = "hud_objective_icon_circle", capRegionMarkerDEF = "hud_objective_icon_circle",
                           capRegionMarkerScaleATT = 3.0, capRegionMarkerScaleDEF = 3.0, hideCPs = true, multiplayerRules = true,
                           capRegionDummyObjectATT = "cap1", capRegionDummyObjectDEF = "cap2",}
    ctf:Start()
	
	manager:Proc_ScriptPostLoad_End()
	
end

function ScriptInit()

    StealArtistHeap(256*1024)
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
    local weaponCnt = 240
    SetMemoryPoolSize("Aimer", 50)
    SetMemoryPoolSize("AmmoCounter", weaponCnt)
    SetMemoryPoolSize("BaseHint", 250)
    SetMemoryPoolSize("EnergyBar", weaponCnt)
    SetMemoryPoolSize("EntityCloth", 0)
    SetMemoryPoolSize("EntityLight", 74)
    SetMemoryPoolSize("EntitySoundStream", 12)
    SetMemoryPoolSize("EntitySoundStatic", 85)
    SetMemoryPoolSize("Navigator", 50)
    SetMemoryPoolSize("Obstacle", 931)
    SetMemoryPoolSize("PathFollower", 50)
    SetMemoryPoolSize("PathNode", 128)
    SetMemoryPoolSize("SoundSpaceRegion", 36)
    SetMemoryPoolSize("TentacleSimulator", 0)
    SetMemoryPoolSize("EntityFlyer", 6)
    SetMemoryPoolSize("TreeGridStack", 338)
    SetMemoryPoolSize("Weapon", weaponCnt)
	manager:Proc_ScriptInit_MemoryPoolInit()
    
    SetSpawnDelay(10.0, 0.25)
    ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ME5\\kam1.lvl", "kamino1_1CTF")
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
    SetAllowBlindJetJumps(0)

    --  Sound
	
	manager:Proc_ScriptInit_MusicSetup()
	
	OpenAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_s_KAM_Streaming.lvl",  "kam1")
	--OpenAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_s_KAM_Streaming.lvl",  "kam1")
	
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
