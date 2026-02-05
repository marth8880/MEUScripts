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
	heroSupportCPs = {
				{"CP1", "CP1Spawn"},
				{"CP2", "CP2Spawn"},
				{"CP3", "CP3Spawn"},
				{"CP4", "CP4Spawn"},
				{"CP5", "CP5Spawn"},
				{"CP7", "CP7Spawn"},
	},
	-- Local ally spawns. CP name, CP spawn path name
	allySpawnCPs = {
				{"CP1", "CP1Spawn"},
				{"CP2", "CP2Spawn"},
				{"CP3", "CP3Spawn"},
				{"CP4", "CP4Spawn"},
				{"CP5", "CP5Spawn"},
				{"CP7", "CP7Spawn"},
	},
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

    TrashStuff();
    PlayAnimExtend();
    PlayAnimTakExtend();
    
    BlockPlanningGraphArcs("compactor")
    OnObjectKillName(CompactorConnectionOn, "grate01")
    
    DisableBarriers("start_room_barrier")
    DisableBarriers("dr_left")
    DisableBarriers("circle_bar1")
    DisableBarriers("circle_bar2")
    
    -- handle reinforcment loss and defeat condition
    -- OnCharacterDeathTeam(function(character, killer) AddReinforcements(1, -1) end, 1)
    -- OnTicketCountChange(function(team, count) if count == 0 then MissionDefeat(team) end end)

    OnObjectRespawnName(PlayAnimExtend, "Panel-Chasm");
    OnObjectKillName(PlayAnimRetract, "Panel-Chasm");

    OnObjectRespawnName(PlayAnimTakExtend, "Panel-Tak");
    OnObjectKillName(PlayAnimTakRetract, "Panel-Tak");
     
        EnableSPHeroRules()
    KillObject("CP6")    
    cp1 = CommandPost:New{name = "CP1"}
    cp2 = CommandPost:New{name = "CP2"}
    cp3 = CommandPost:New{name = "CP3"}
    cp4 = CommandPost:New{name = "CP4"}
    cp5 = CommandPost:New{name = "CP5"}
    --cp6 = CommandPost:New{name = "CP6"}
    cp7 = CommandPost:New{name = "CP7"}
    
    --This sets up the actual objective.  This needs to happen after cp's are defined
    conquest = ObjectiveConquest:New{teamATT = ATT, teamDEF = DEF, textATT = "game.modes.con", textDEF = "game.modes.con2", multiplayerRules = true}
    
    --This adds the CPs to the objective.  This needs to happen after the objective is set up
    conquest:AddCommandPost(cp1)
    conquest:AddCommandPost(cp2)
    conquest:AddCommandPost(cp3)
    conquest:AddCommandPost(cp4)
    conquest:AddCommandPost(cp5)
    --conquest:AddCommandPost(cp6)
    conquest:AddCommandPost(cp7)
    
    conquest:Start()
    
    AddDeathRegion("DeathRegion01")
    AddDeathRegion("DeathRegion02")
    AddDeathRegion("DeathRegion03")
    AddDeathRegion("DeathRegion04")
    AddDeathRegion("DeathRegion05")
	
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
    StealArtistHeap(650*1024)
    -- Designers, these two lines *MUST* be first.
    SetPS2ModelMemory(4200000)
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\Load\\load.lvl;dea1")
	
	SetMemoryPoolSize("ParticleTransformer::ColorTrans", 2305)
	SetMemoryPoolSize("ParticleTransformer::PositionTr", 1383)
	SetMemoryPoolSize("ParticleTransformer::SizeTransf", 1533)
	
	manager:Proc_ScriptInit_Begin()
    
	AISnipeSuitabilityDist(45)
	SetAttackerSnipeRange(70)
	SetDefenderSnipeRange(100)
	
	
	manager:Proc_ScriptInit_SideSetup()
	
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_s_DEA_Streaming.lvl;dea1n")
    
	
    --  Level Stats
    ClearWalkers()
    AddWalkerType(0, 0)
    local weaponNum = 220
    SetMemoryPoolSize ("Aimer", 10)
    SetMemoryPoolSize ("AmmoCounter", weaponNum)
    SetMemoryPoolSize ("BaseHint", 300)
    SetMemoryPoolSize ("EnergyBar", weaponNum)
    SetMemoryPoolSize ("EntityFlyer", 6)
    SetMemoryPoolSize ("EntityLight", 100)
    SetMemoryPoolSize ("EntitySoundStatic", 30)
    SetMemoryPoolSize ("Navigator", 45)
    SetMemoryPoolSize ("Obstacle", 325)
    SetMemoryPoolSize ("PathFollower", 45)
    SetMemoryPoolSize ("PathNode", 512)
	SetMemoryPoolSize ("SoldierAnimation", 432)
    SetMemoryPoolSize ("SoundSpaceRegion", 50)
    SetMemoryPoolSize ("TreeGridStack", 250)
    SetMemoryPoolSize ("Weapon", weaponNum)
	manager:Proc_ScriptInit_MemoryPoolInit()
    

  --  SetMemoryPoolSize("Obstacle", 725)
    SetSpawnDelay(10.0, 0.25)
    --ReadDataFile("dea\\dea1.lvl", "dea1_Conquest")
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ME5\\dea1.lvl", "dea1_Conquest")
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\minimap.lvl;dea1")
    SetDenseEnvironment("false")
    
    SetMaxFlyHeight(72)
    SetMaxPlayerFlyHeight(72)

    --  Sound Stats
	
	manager:Proc_ScriptInit_MusicSetup()
	
	OpenAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_s_DEA_Streaming.lvl",  "dea1")
	OpenAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_s_DEA_Streaming.lvl",  "dea1")
	
	SoundFX()

  
    --  Camera Stats
    --Tat 1 - Dune Sea
    --Crawler
    AddCameraShot(-0.404895, 0.000992, -0.514360, -0.002240, -121.539894, 62.536297, -257.699493)
    --Homestead
    AddCameraShot(0.040922, -0.004049, -0.994299, -0.098381, -103.729523, 55.546598, -225.360893)
    --Sarlac Pit
    AddCameraShot(-1.0, 0.0, -0.514360, 0.0, -55.381485, 50.450953, -96.514324)
	
	manager:Proc_ScriptInit_End()
end