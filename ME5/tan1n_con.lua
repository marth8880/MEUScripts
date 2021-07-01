ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\master.lvl")
--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- load the gametype script
ScriptCB_DoFile("ME5_Master")
ScriptCB_DoFile("ME5_setup_teams")
ScriptCB_DoFile("ME5_ObjectiveConquest")

local __SCRIPT_NAME = "tan1n_con";
local debug = true;

local function PrintLog(...)
	if debug == true then
		print("["..__SCRIPT_NAME.."]", unpack(arg));
	end
end

-- Create a new MapManager object
manager = MapManager:New{
	-- Map-specific details
	gameMode = "conquest",
	mapSize = "sm",
	environmentType = "urban",
	
	-- In-game music
	musicVariation_SSVxGTH = "6",
	musicVariation_SSVxCOL = "2",
	musicVariation_EVGxGTH = "6",
	musicVariation_EVGxCOL = "2",
	
	-- Online matches
	onlineSideVar = "SSVxCOL",
	onlineHeroSSV = "shep_engineer",
	onlineHeroGTH = "gethprime_me2",
	onlineHeroCOL = "colgeneral",
	onlineHeroEVG = "gethprime_me3",
	
	-- Local ally spawns. CP name, CP spawn path name
	heroSupportCPs = {
				{"CP4CON", "cp4path"},
				{"CP5CON", "cp5path"},
				{"CP6CON", "cp6path"},
				{"CP7CON", "CP7SPAWNPATH"},
	},
	-- AI hero spawns. CP name, CP spawn path name
	allySpawnCPs = {
				{"CP4CON", "cp4path"},
				{"CP5CON", "cp5path"},
				{"CP6CON", "cp6path"},
				{"CP7CON", "CP7SPAWNPATH"},
	},
}
-- Initialize the MapManager
manager:Init()

-- No randomizing on this map!
REP = 1
CIS = 2

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

    AddDeathRegion("turbinedeath")
    
    KillObject("blastdoor")
    DisableBarriers("barracks")
    DisableBarriers("liea")
    -- SetMapNorthAngle(180)
    
-- Turbine Stuff -- 
    BlockPlanningGraphArcs("turbine")
    OnObjectKillName(destturbine, "turbineconsole")
    OnObjectRespawnName(returbine, "turbineconsole")
    
    
    cp4 = CommandPost:New{name = "CP4CON"}
    cp5 = CommandPost:New{name = "CP5CON"}
    cp6 = CommandPost:New{name = "CP6CON"}
    cp7 = CommandPost:New{name = "CP7CON"}
    
    conquest = ObjectiveConquest:New{teamATT = ATT, teamDEF = DEF, textATT = "game.modes.con", textDEF = "game.modes.con2", multiplayerRules = true}
    
    conquest:AddCommandPost(cp4)
    conquest:AddCommandPost(cp5)
    conquest:AddCommandPost(cp6)
    conquest:AddCommandPost(cp7)
    
    conquest:Start()
    
    EnableSPHeroRules()
    
	manager:Proc_ScriptPostLoad_End()
    
   --Setup Timer-- 

    timeConsole = CreateTimer("timeConsole")
    SetTimerValue(timeConsole, 0.3)
    StartTimer(timeConsole)
    OnTimerElapse(
        function(timer)
            SetProperty("turbineconsole", "CurHealth", GetObjectHealth("turbineconsole") + 1)
            DestroyTimer(timer)
        end,
    	timeConsole
    )
	
	SetProperty("CP4CON", "NeutralizeTime", 35)
	SetProperty("CP4CON", "CaptureTime", 30)
	SetProperty("CP5CON", "NeutralizeTime", 35)
	SetProperty("CP5CON", "CaptureTime", 30)
	SetProperty("CP6CON", "NeutralizeTime", 35)
	SetProperty("CP6CON", "CaptureTime", 30)
	SetProperty("CP7CON", "NeutralizeTime", 35)
	SetProperty("CP7CON", "CaptureTime", 30)
	
	KillObject("lvlution_corridor_02_a_masseffectfield")
	KillObject("lvlution_oxygen_fx1")
	KillObject("lvlution_oxygen_fx2")
	KillObject("lvlution_oxygen_fx3")
	KillObject("lvlution_oxygen_fx4")
	KillObject("lvlution_oxygen_fx5")
	
	DisableBarriers("door1")
	DisableBarriers("door2")
	DisableBarriers("door3")
	DisableBarriers("door4")
	DisableBarriers("door5")
	DisableBarriers("door6")
	DisableBarriers("door7")
	DisableBarriers("door8")
	DisableBarriers("door9")
	DisableBarriers("door10")
	DisableBarriers("door11")
	DisableBarriers("door12")
	DisableBarriers("door13")
	UnblockPlanningGraphArcs("Connection134")
	UnblockPlanningGraphArcs("group2")
	UnblockPlanningGraphArcs("Connection89")
	UnblockPlanningGraphArcs("Connection52")
	UnblockPlanningGraphArcs("Connection82")
	UnblockPlanningGraphArcs("Connection104")
	UnblockPlanningGraphArcs("test2")
	UnblockPlanningGraphArcs("Connection49")
	UnblockPlanningGraphArcs("test1")
	UnblockPlanningGraphArcs("group1")
	UnblockPlanningGraphArcs("Connection11")
	UnblockPlanningGraphArcs("group3")
	UnblockPlanningGraphArcs("Connection60")
	UnblockPlanningGraphArcs("test3")
	
	stageEnginesDisabled = 1
	stageEnemyApproaching = 2
	stageEnemyCharging = 3
	stageHullBreached = 4
	stageHullSealed = 5
	
	levolutionStream = nil
	lvlutionStartDelay = 20.0
	lvlutionStages = {
		[stageEnginesDisabled] =	{ vo = "tan_vo_engines_disabled", msg = "level.tan1.events.engines_disabled", timeTilNext = 10.0 },
		[stageEnemyApproaching] =	{ vo = "tan_vo_enemy_approaching", msg = "level.tan1.events.enemy_approaching", timeTilNext = 55.0 - lvlutionStartDelay },
		[stageEnemyCharging] =		{ vo = "tan_vo_enemy_charging", msg = "level.tan1.events.enemy_charging", timeTilNext = 12.0 },
		[stageHullBreached] =		{ vo = "tan_vo_hull_breached", msg = "level.tan1.events.hull_breached", timeTilNext = 10.0 },
		[stageHullSealed] =			{ vo = "tan_vo_hull_sealed", msg = "level.tan1.events.hull_sealed", timeTilNext = 20.0 },
	}
	lvlutionCurStage = 0
	
	lvlutionStages[stageEnemyApproaching].timeTilNext = lvlutionStages[stageEnemyApproaching].timeTilNext - lvlutionStages[stageEnginesDisabled].timeTilNext
	
	--Setup Levolution Timer - Pre-Destruction-- 
	
	timePreDestruction = CreateTimer("timePreDestruction")
	SetTimerValue(timePreDestruction, 0.2)
	StartTimer(timePreDestruction)
	OnTimerElapse(
		function(timer)
			print("tan1n_con: Initiating Levolution pre-setup")
			--RemoveRegion("lvlution_death1")
			--RemoveRegion("lvlution_death2")
			--RemoveRegion("lvlution_death3")
			--KillObject("lvlution_bldg_spacevacuum")
			KillObject("lvlution_bldg_spacevacuum1")
			KillObject("lvlution_bldg_spacevacuum2")
			KillObject("lvlution_bldg_spacevacuum3")
			KillObject("lvlution_bldg_spacevacuum4")
			--KillObject("lvlution_bldg_spacevacuum5")
			KillObject("lvlution_bldg_spacevacuum6")
			KillObject("lvlution_bldg_spacevacuum7")
			KillObject("lvlution_bldg_spacevacuum8")
			KillObject("lvlution_bldg_spacevacuum9")
			KillObject("lvlution_bldg_spacevacuum10")
			KillObject("lvlution_bldg_spacevacuum11")
			KillObject("lvlution_bldg_spacevacuum12")
	
			PlayAnimation("shiparrive")
			
			DestroyTimer(timer)
		end,
		timePreDestruction
	)
	
	KillObject("ship")
	-- lvlutionShipChargeupEffect = CreateEffect("collector_beam_charge")
	-- AttachEffectToObject(lvlutionShipChargeupEffect, "ship")
	
	timerLvlutionStartDelay = CreateTimer("timerLvlutionStartDelay")
	timerLvlutionNextStage = CreateTimer("timerLvlutionNextStage")
	timerLvlutionNextStageElapse = nil
	
	SetTimerValue(timerLvlutionStartDelay, lvlutionStartDelay)
	StartTimer(timerLvlutionStartDelay)
	-- ShowTimer(timerLvlutionStartDelay)
	timerLvlutionStartDelayElapse = OnTimerElapse(
		function(timer)
			-- Start the first stage
			StartNextStage()
			
			DestroyTimer(timerLvlutionStartDelay)
			ReleaseTimerElapse(timerLvlutionStartDelayElapse)
			timerLvlutionStartDelayElapse = nil
		end,
		timerLvlutionStartDelay
	)
    
end

function StartNextStage()
	lvlutionCurStage = lvlutionCurStage + 1
	
	if lvlutionCurStage <= table.getn(lvlutionStages) then
		PrintLog("Starting lvlution stage " .. lvlutionCurStage)
		if debug then
			tprint(lvlutionStages[lvlutionCurStage])
		end
		
		-- Stop the low health sound if it's playing
		if LH_bIsLowHealthSoundPlaying == true then
			StopLowHealthSound(true)
		end
		
		ScriptCB_SndPlaySound(lvlutionStages[lvlutionCurStage].vo)
		ShowMessageText(lvlutionStages[lvlutionCurStage].msg)
		
		if lvlutionCurStage == stageEnginesDisabled then
			KillObject("tan4_bldg_engine_b")
			KillObject("tan4_bldg_engine_c")
			KillObject("tan4_bldg_engine")
			KillObject("turbineconsole")
			SetProperty("tan4_bldg_engineroom_damage", "CurHealth", 10000)
		elseif lvlutionCurStage == stageEnemyApproaching then
			
		elseif lvlutionCurStage == stageEnemyCharging then
			lvlutionShipChargeupEffect = CreateEffect("collector_beam_charge")
			AttachEffectToObject(lvlutionShipChargeupEffect, "ship")
			
			local fireDelay = 0.75
			local fireAnimLength = 1.45
			
			lvlutionShipFireBeamTimer = CreateTimer("lvlutionShipFireBeamTimer")
			SetTimerValue(lvlutionShipFireBeamTimer, lvlutionStages[stageEnemyCharging].timeTilNext - fireDelay)
			
			lvlutionShipFireBeamEndTimer = CreateTimer("lvlutionShipFireBeamEndTimer")
			SetTimerValue(lvlutionShipFireBeamEndTimer, lvlutionStages[stageEnemyCharging].timeTilNext - fireDelay + fireAnimLength)
			
			StartTimer(lvlutionShipFireBeamTimer)
			StartTimer(lvlutionShipFireBeamEndTimer)
			lvlutionShipFireBeamTimerElapse = OnTimerElapse(
				function(timer)
					PrintLog("lvlutionShipFireBeamTimerElapse")
					RespawnObject("ship")
					
					DestroyTimer(timer)
					ReleaseTimerElapse(lvlutionShipFireBeamTimerElapse)
				end,
				lvlutionShipFireBeamTimer
			)
			lvlutionShipFireBeamEndTimerElapse = OnTimerElapse(
				function(timer)
					PrintLog("lvlutionShipFireBeamEndTimerElapse")
					KillObject("ship")
					
					DestroyTimer(timer)
					ReleaseTimerElapse(lvlutionShipFireBeamEndTimerElapse)
				end,
				lvlutionShipFireBeamEndTimer
			)
		elseif lvlutionCurStage == stageHullBreached then
			CorridorDestruct()
		elseif lvlutionCurStage == stageHullSealed then
			CorridorSeal()
		end
		
		if lvlutionCurStage < table.getn(lvlutionStages) then
			SetTimerValue(timerLvlutionNextStage, lvlutionStages[lvlutionCurStage].timeTilNext)
			StartTimer(timerLvlutionNextStage)
			-- ShowTimer(timerLvlutionNextStage)
			timerLvlutionNextStageElapse = OnTimerElapse(
				function(timer)
					StartNextStage()
					
					ReleaseTimerElapse(timerLvlutionNextStageElapse)
				end,
				timerLvlutionNextStage
			)
		end
		
	end
end

function CorridorDestruct()
	KillObject("lvlution_corridor_02_a")
	KillObject("lvlution_oxygen_rumble")
	SetProperty("lvlution_weaponrecharge5", "AddHealth", 0)
	SetProperty("blastbar1", "IsLocked", "1")
	SetProperty("blasteng2", "IsLocked", "1")
	SetProperty("blasteng1", "IsLocked", "1")
	SetProperty("lpodroom1", "IsLocked", "1")
	SetProperty("engine01", "IsLocked", "1")
	SetProperty("lpodroom2", "IsLocked", "1")
	SetProperty("techroom1", "IsLocked", "1")
	SetProperty("tan4_prop_door5", "IsLocked", "1")
	SetProperty("tan4_prop_door1", "IsLocked", "1")
	SetProperty("tan4_prop_door4", "IsLocked", "1")
	SetProperty("tan4_prop_door_minus_darkside", "IsLocked", "1")
	SetProperty("lpodroom3", "IsLocked", "1")
	SetProperty("techroom2", "IsLocked", "1")
	SetProperty("rpodroom2", "IsLocked", "1")
	SetProperty("rpodroom1", "IsLocked", "1")
	SetProperty("rpodroom1f", "IsLocked", "1")
	KillObject("lvlution_weaponrecharge5")
	AddDeathRegion("lvlution_death1")
	AddDeathRegion("lvlution_death2")
	AddDeathRegion("lvlution_death3")
	--RespawnObject("lvlution_bldg_spacevacuum")
	RespawnObject("lvlution_bldg_spacevacuum1")
	RespawnObject("lvlution_bldg_spacevacuum2")
	RespawnObject("lvlution_bldg_spacevacuum3")
	RespawnObject("lvlution_bldg_spacevacuum4")
	--RespawnObject("lvlution_bldg_spacevacuum5")
	RespawnObject("lvlution_bldg_spacevacuum6")
	RespawnObject("lvlution_bldg_spacevacuum7")
	RespawnObject("lvlution_bldg_spacevacuum8")
	RespawnObject("lvlution_bldg_spacevacuum9")
	RespawnObject("lvlution_bldg_spacevacuum10")
	RespawnObject("lvlution_bldg_spacevacuum11")
	RespawnObject("lvlution_bldg_spacevacuum12")
	RespawnObject("lvlution_oxygen_fx1")
	RespawnObject("lvlution_oxygen_fx2")
	RespawnObject("lvlution_oxygen_fx3")
	RespawnObject("lvlution_oxygen_fx4")
	RespawnObject("lvlution_oxygen_fx5")
	EnableBarriers("door1")
	EnableBarriers("door2")
	EnableBarriers("door3")
	EnableBarriers("door4")
	EnableBarriers("door5")
	EnableBarriers("door6")
	EnableBarriers("door7")
	EnableBarriers("door8")
	EnableBarriers("door9")
	EnableBarriers("door10")
	EnableBarriers("door11")
	EnableBarriers("door12")
	EnableBarriers("door13")
	BlockPlanningGraphArcs("Connection134")
	BlockPlanningGraphArcs("group2")
	BlockPlanningGraphArcs("Connection89")
	BlockPlanningGraphArcs("Connection52")
	BlockPlanningGraphArcs("Connection82")
	BlockPlanningGraphArcs("Connection104")
	BlockPlanningGraphArcs("test2")
	BlockPlanningGraphArcs("Connection49")
	BlockPlanningGraphArcs("test1")
	BlockPlanningGraphArcs("group1")
	BlockPlanningGraphArcs("Connection11")
	BlockPlanningGraphArcs("group3")
	BlockPlanningGraphArcs("Connection60")
	BlockPlanningGraphArcs("test3")
end

function CorridorSeal()
	RespawnObject("lvlution_corridor_02_a_masseffectfield")
	--KillObject("lvlution_bldg_spacevacuum")
	KillObject("lvlution_bldg_spacevacuum1")
	KillObject("lvlution_bldg_spacevacuum2")
	KillObject("lvlution_bldg_spacevacuum3")
	KillObject("lvlution_bldg_spacevacuum4")
	--KillObject("lvlution_bldg_spacevacuum5")
	KillObject("lvlution_bldg_spacevacuum6")
	KillObject("lvlution_bldg_spacevacuum7")
	KillObject("lvlution_bldg_spacevacuum8")
	KillObject("lvlution_bldg_spacevacuum9")
	KillObject("lvlution_bldg_spacevacuum10")
	KillObject("lvlution_bldg_spacevacuum11")
	KillObject("lvlution_bldg_spacevacuum12")
	KillObject("lvlution_oxygen_fx1")
	KillObject("lvlution_oxygen_fx2")
	KillObject("lvlution_oxygen_fx3")
	KillObject("lvlution_oxygen_fx4")
	KillObject("lvlution_oxygen_fx5")
	SetProperty("blastbar1", "IsLocked", "0")
	SetProperty("blasteng2", "IsLocked", "0")
	SetProperty("blasteng1", "IsLocked", "0")
	SetProperty("lpodroom1", "IsLocked", "0")
	SetProperty("engine01", "IsLocked", "0")
	SetProperty("lpodroom2", "IsLocked", "0")
	SetProperty("techroom1", "IsLocked", "0")
	SetProperty("tan4_prop_door5", "IsLocked", "0")
	SetProperty("tan4_prop_door1", "IsLocked", "0")
	SetProperty("tan4_prop_door4", "IsLocked", "0")
	SetProperty("tan4_prop_door_minus_darkside", "IsLocked", "0")
	SetProperty("lpodroom3", "IsLocked", "0")
	SetProperty("techroom2", "IsLocked", "0")
	SetProperty("rpodroom2", "IsLocked", "0")
	SetProperty("rpodroom1", "IsLocked", "0")
	SetProperty("rpodroom1f", "IsLocked", "0")
	DisableBarriers("door1")
	DisableBarriers("door2")
	DisableBarriers("door3")
	DisableBarriers("door4")
	DisableBarriers("door5")
	DisableBarriers("door6")
	DisableBarriers("door7")
	DisableBarriers("door8")
	DisableBarriers("door9")
	DisableBarriers("door10")
	DisableBarriers("door11")
	DisableBarriers("door12")
	DisableBarriers("door13")
	UnblockPlanningGraphArcs("Connection134")
	UnblockPlanningGraphArcs("group2")
	UnblockPlanningGraphArcs("Connection89")
	UnblockPlanningGraphArcs("Connection52")
	UnblockPlanningGraphArcs("Connection82")
	UnblockPlanningGraphArcs("Connection104")
	UnblockPlanningGraphArcs("test2")
	UnblockPlanningGraphArcs("Connection49")
	UnblockPlanningGraphArcs("test1")
	UnblockPlanningGraphArcs("group1")
	UnblockPlanningGraphArcs("Connection11")
	UnblockPlanningGraphArcs("group3")
	UnblockPlanningGraphArcs("Connection60")
	UnblockPlanningGraphArcs("test3")
end

function destturbine()
    UnblockPlanningGraphArcs("turbine")
    PauseAnimation("Turbine Animation")
    RemoveRegion("turbinedeath")
    DisableBarriers("turbine")
--    SetProperty("woodr", "CurHealth", 15)
end

function returbine()
    BlockPlanningGraphArcs("turbine")
    PlayAnimation("Turbine Animation")
    AddDeathRegion("turbinedeath")
    EnableBarriers("turbine")
--    SetProperty("woodr", "CurHealth", 15)
end

function ScriptInit()
    -- Designers, these two lines *MUST* be first!
    StealArtistHeap(840000)
    SetPS2ModelMemory(4990000)
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\Load\\load.lvl;tan1")
	
	SetMemoryPoolSize("ParticleTransformer::ColorTrans", 2740)
	SetMemoryPoolSize("ParticleTransformer::PositionTr", 1623)
	SetMemoryPoolSize("ParticleTransformer::SizeTransf", 1821)
	
	manager:Proc_ScriptInit_Begin()
    SetWorldExtents(2500)
	
	
	SetMemoryPoolSize("Combo",4)              -- should be ~ 2x number of jedi classes
	SetMemoryPoolSize("Combo::State",48)      -- should be ~12x #Combo
	SetMemoryPoolSize("Combo::Transition",54) -- should be a bit bigger than #Combo::State
	SetMemoryPoolSize("Combo::Condition",54)  -- should be a bit bigger than #Combo::State
	SetMemoryPoolSize("Combo::Attack",48)     -- should be ~8-12x #Combo
	SetMemoryPoolSize("Combo::DamageSample",580)  -- should be ~8-12x #Combo::Attack
	SetMemoryPoolSize("Combo::Deflect",4)     -- should be ~1x #combo
	
	SetMemoryPoolSize("Music", 72)
	
	manager:Proc_ScriptInit_SideSetup()
	
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_s_TAN_Streaming.lvl;tan1n")
	
    --  Level Stats
    ClearWalkers()
    AddWalkerType(0, 0)  -- number of droidekas

	local weaponCnt = 256
	local guyCnt = 64
	SetMemoryPoolSize("Aimer", 32)
	SetMemoryPoolSize("AmmoCounter", weaponCnt)
	SetMemoryPoolSize("BaseHint", 250)
	SetMemoryPoolSize("EnergyBar", weaponCnt)
    SetMemoryPoolSize("EntityLight", 337)
	SetMemoryPoolSize("EntitySoundStream", 14)
	SetMemoryPoolSize("EntitySoundStatic", 45)
	SetMemoryPoolSize("Navigator", guyCnt)
	SetMemoryPoolSize("Obstacle", 250)
	SetMemoryPoolSize("PathFollower", guyCnt)
	SetMemoryPoolSize("PathNode", 384)
	SetMemoryPoolSize("RedOmniLight", 383)
	SetMemoryPoolSize("SoldierAnimation", 370)
	SetMemoryPoolSize("SoundSpaceRegion", 15)
	SetMemoryPoolSize("TentacleSimulator", 0)
	SetMemoryPoolSize("TreeGridStack", 150)
	SetMemoryPoolSize("UnitAgent", guyCnt)
	SetMemoryPoolSize("UnitController", guyCnt)
	SetMemoryPoolSize("Weapon", weaponCnt)
	manager:Proc_ScriptInit_MemoryPoolInit()
	
	
	--	SetMemoryPoolSize("Obstacle", 182)
	--
    SetSpawnDelay(10.0, 0.25)
    ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ME5\\tan1.lvl", "tan1_conquest")
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\minimap.lvl;tan1")
    SetDenseEnvironment("false")
    
	AISnipeSuitabilityDist(50)
	SetAttackerSnipeRange(60)
	SetDefenderSnipeRange(70)
    -- SetMaxFlyHeight(90)
    -- SetMaxPlayerFlyHeight(90)
	
	SetParticleLODBias(3000)

    --  Sound Stats

	manager:Proc_ScriptInit_MusicSetup()
	
	OpenAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_s_TAN_Streaming.lvl",  "tan1")	-- ambient streams
	
	SoundFX()


    --  Camera Stats
    AddCameraShot(0.233199, -0.019441, -0.968874, -0.080771, -240.755920, 11.457644, 105.944176);
    AddCameraShot(-0.395561, 0.079428, -0.897092, -0.180135, -264.022278, 6.745873, 122.715752);
    AddCameraShot(0.546703, -0.041547, -0.833891, -0.063371, -309.709900, 5.168304, 145.334381);
	
	manager:Proc_ScriptInit_End()

end
