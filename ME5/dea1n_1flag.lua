ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\master.lvl")
--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- load the gametype script
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
	musicVariation_SSVxGTH = {"4","6"},
	musicVariation_SSVxCOL = "2",
	musicVariation_EVGxGTH = "9",
	musicVariation_EVGxCOL = "9",
	musicVariation_SSVxRPR = "8",
    musicVariation_SSVxCER = {"7_2", "7_3"},
	
	-- Online matches
	onlineSideVar = "EVGxGTH",
	onlineHeroSSV = "shep_vanguard",
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
if manager.useRandomFactionIds == true and not ScriptCB_InMultiplayer() then
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

    TrashStuff();
    --lock the hangar doors
    
    SetProperty("Dr-LeftMain", "IsLocked", 1)
    SetProperty("dea1_prop_door_blast0", "IsLocked", 1)
    
    SoundEvent_SetupTeams( REP, 'rep', CIS, 'cis' )

    PlayAnimExtend();
    PlayAnimTakExtend();

    BlockPlanningGraphArcs("Connection41")    
    BlockPlanningGraphArcs("Connection115")
    BlockPlanningGraphArcs("compactor")
    OnObjectKillName(CompactorConnectionOn, "grate01")
    
    DisableBarriers("start_room_barrier")
    DisableBarriers("dr_left")
    DisableBarriers("circle_bar1")
    DisableBarriers("circle_bar2")

    OnObjectRespawnName(PlayAnimExtend, "Panel-Chasm");
    OnObjectKillName(PlayAnimRetract, "Panel-Chasm");

    OnObjectRespawnName(PlayAnimTakExtend, "Panel-Tak");
    OnObjectKillName(PlayAnimTakRetract, "Panel-Tak");

--  SetProperty("flag", "GeometryName", "com_icon_neutral_flag")
--    SetProperty("flag", "CarriedGeometryName", "com_icon_neutral_flag_carried")
    
    ctf = ObjectiveOneFlagCTF:New{teamATT = 1, teamDEF = 2,
           textATT = "game.modes.1flag", textDEF = "game.modes.1flag2", 
           captureLimit = 5, flag = "flag", flagIcon = "flag_icon", 
           flagIconScale = 3.0, homeRegion = "Flag_Home",
           captureRegionATT = "Team2Cap", captureRegionDEF = "Team1Cap",
           capRegionMarkerATT = "hud_objective_icon_circle", capRegionMarkerDEF = "hud_objective_icon_circle",
           capRegionMarkerScaleATT = 3.0, capRegionMarkerScaleDEF = 3.0, multiplayerRules = true, hideCPs = true, AIGoalWeight = 15,
                           capRegionDummyObjectATT = "com_bldg_ctfbase1", capRegionDummyObjectDEF = "com_bldg_ctfbase",}
           
    ctf:Start()
    EnableSPHeroRules()
	
	manager:Proc_ScriptPostLoad_End()
	
end

function CompactorConnectionOn()
    UnblockPlanningGraphArcs ("compactor")
end
--START BRIDGEWORK!

-- OPEN
function PlayAnimExtend()
      PauseAnimation("bridgeclose");    
      RewindAnimation("bridgeopen");
      PlayAnimation("bridgeopen");
        
    -- allow the AI to run across it
    UnblockPlanningGraphArcs("Connection122");
    DisableBarriers("BridgeBarrier");
    
end
-- CLOSE
function PlayAnimRetract()
      PauseAnimation("bridgeopen");
      RewindAnimation("bridgeclose");
      PlayAnimation("bridgeclose");
            
    -- prevent the AI from running across it
    BlockPlanningGraphArcs("Connection122");
    EnableBarriers("BridgeBarrier");
      
end

--START BRIDGEWORK TAK!!!

-- OPEN
function PlayAnimTakExtend()
      PauseAnimation("TakBridgeOpen");  
      RewindAnimation("TakBridgeClose");
      PlayAnimation("TakBridgeClose");
        
    -- allow the AI to run across it
    UnblockPlanningGraphArcs("Connection128");
    DisableBarriers("Barrier222");
    
end
-- CLOSE
function PlayAnimTakRetract()
      PauseAnimation("TakBridgeClose");
      RewindAnimation("TakBridgeOpen");
      PlayAnimation("TakBridgeOpen");
            
    -- prevent the AI from running across it
    BlockPlanningGraphArcs("Connection128");
    EnableBarriers("Barrier222");
      
end


function TrashStuff()

    trash_open = 1
    trash_closed = 0
    
    trash_timer = CreateTimer("trash_timer")
    SetTimerValue(trash_timer, 7)
    StartTimer(trash_timer)
    trash_death = OnTimerElapse(
        function(timer)
            if trash_open == 1 then
                AddDeathRegion("deathregion")
                SetTimerValue(trash_timer, 5)
                StartTimer(trash_timer)
                trash_closed = 1
                trash_open = 0
                print("death region added")
            
            elseif trash_closed == 1 then
                RemoveRegion("deathregion")
                SetTimerValue(trash_timer, 15)
                StartTimer(trash_timer)
                print("death region removed")
                trash_closed = 0
                trash_open = 1
            end
        end,
        trash_timer
        )
end



function ScriptInit()
    StealArtistHeap(550*1024)
    -- Designers, these two lines *MUST* be first.
    SetPS2ModelMemory(4200000)
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\Load\\load.lvl;dea1")
	
	SetMemoryPoolSize("ParticleTransformer::ColorTrans", 2305)
	SetMemoryPoolSize("ParticleTransformer::PositionTr", 1383)
	SetMemoryPoolSize("ParticleTransformer::SizeTransf", 1533)
	
    manager:Proc_ScriptInit_Begin()

    
    SetMaxFlyHeight(72)
    SetMaxPlayerFlyHeight (72)
	AISnipeSuitabilityDist(45)
	SetAttackerSnipeRange(70)
	SetDefenderSnipeRange(100)
	
	manager:Proc_ScriptInit_SideSetup()
	
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_s_DEA_Streaming.lvl;dea1n")

    --  Level Stats
    ClearWalkers()
    AddWalkerType(0, 0) -- 3 droidekas (special case: 0 leg pairs)
    --    AddWalkerType(1, 0) -- 8 droidekas (special case: 0 leg pairs)
    --    AddWalkerType(2, 0) -- 2 spider walkers with 2 leg pairs each
    --    AddWalkerType(3, 0) -- 2 attes with 3 leg pairs each
    local weaponCnt = 180
    local guyCnt = 60
    SetMemoryPoolSize ("Aimer", 9)
    SetMemoryPoolSize ("AmmoCounter", weaponCnt)
    SetMemoryPoolSize ("EnergyBar", weaponCnt)
    SetMemoryPoolSize ("EntityLight", 170)
    SetMemoryPoolSize ("EntitySoundStatic", 30)
    SetMemoryPoolSize ("SoundSpaceRegion", 50)
    SetMemoryPoolSize ("Navigator", guyCnt)
    SetMemoryPoolSize ("Obstacle", 275)
    SetMemoryPoolSize ("PathFollower", guyCnt)
    SetMemoryPoolSize ("SoldierAnimation", 410)
    SetMemoryPoolSize ("UnitAgent", guyCnt)
    SetMemoryPoolSize ("UnitController", guyCnt)
    SetMemoryPoolSize ("Weapon", weaponCnt)
    SetMemoryPoolSize ("EntityFlyer", 6)
	manager:Proc_ScriptInit_MemoryPoolInit()


    SetSpawnDelay(10.0, 0.25)
    --ReadDataFile("dea\\dea1.lvl", "dea1_CTF-SingleFlag")
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ME5\\dea1.lvl", "dea1_CTF-SingleFlag")
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\minimap.lvl;dea1")
    SetDenseEnvironment("true")
    AddDeathRegion("DeathRegion01")
    AddDeathRegion("DeathRegion02")
    AddDeathRegion("DeathRegion03")
    AddDeathRegion("DeathRegion04")
    AddDeathRegion("DeathRegion05")
    --SetStayInTurrets(1)


    --  Movies
    --  SetVictoryMovie(ALL, "all_end_victory")
    --  SetDefeatMovie(ALL, "imp_end_victory")
    --  SetVictoryMovie(IMP, "imp_end_victory")
    --  SetDefeatMovie(IMP, "all_end_victory")

    --  Sound Stats
	
	manager:Proc_ScriptInit_MusicSetup()
	
	OpenAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_s_DEA_Streaming.lvl",  "dea1")
	OpenAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_s_DEA_Streaming.lvl",  "dea1")
	
	SoundFX()


    SetAttackingTeam(ATT)



    AddCameraShot(-0.404895, 0.000992, -0.514360, -0.002240, -121.539894, 62.536297, -257.699493)
    --Homestead
    AddCameraShot(0.040922, -0.004049, -0.994299, -0.098381, -103.729523, 55.546598, -225.360893)
    --Sarlac Pit
    AddCameraShot(-1.0, 0.0, -0.514360, 0.0, -55.381485, 50.450953, -96.514324)
	
	manager:Proc_ScriptInit_End()
end

