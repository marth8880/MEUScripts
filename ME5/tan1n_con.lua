ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\master.lvl")
RandomSide = math.random(1,4)
--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- load the gametype script
ScriptCB_DoFile("ME5_Master")
ScriptCB_DoFile("ME5_setup_teams")
ScriptCB_DoFile("ME5_ObjectiveConquest")

mapSize = sm
EnvironmentType = 4
onlineSideVar = SSVxCOL
onlineHeroSSV = shep_engineer
onlineHeroGTH = gethprime_me2
onlineHeroCOL = colgeneral
onlineHeroEVG = gethprime_me3

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

---------------------------------------------------------------------------
-- FUNCTION:    ScriptInit
-- PURPOSE:     This function is only run once
-- INPUT:
-- OUTPUT:
-- NOTES:       The name, 'ScriptInit' is a chosen convention, and each
--              mission script must contain a version of this function, as
--              it is called from C to start the mission.
---------------------------------------------------------------------------

function SSVxGTH_PostLoad()
	if not ScriptCB_InMultiplayer() then
		DecideSSVHeroClass()
		DecideGTHHeroClass()
		if ME5_AIHeroes == 0 then
			SetHeroClass(REP, SSVHeroClass)
			SetHeroClass(CIS, GTHHeroClass)
		elseif ME5_AIHeroes == 1 then
			herosupport = AIHeroSupport:New{AIATTHeroHealth = 3000, AIDEFHeroHealth = 3000, gameMode = "NonConquest",}
			herosupport:SetHeroClass(REP, SSVHeroClass)
			herosupport:SetHeroClass(CIS, GTHHeroClass)
			herosupport:AddSpawnCP("CP4CON","cp4path")
			herosupport:AddSpawnCP("CP5CON","cp5path")
			herosupport:AddSpawnCP("CP6CON","cp6path")
			herosupport:AddSpawnCP("CP7CON","CP7SPAWNPATH")
			herosupport:Start()
		else end
	else end
end

function SSVxCOL_PostLoad()
	if not ScriptCB_InMultiplayer() then
		DecideSSVHeroClass()
		DecideCOLHeroClass()
		if ME5_AIHeroes == 0 then
			SetHeroClass(REP, SSVHeroClass)
			SetHeroClass(CIS, COLHeroClass)
		elseif ME5_AIHeroes == 1 then
			herosupport = AIHeroSupport:New{AIATTHeroHealth = 3000, AIDEFHeroHealth = 3000, gameMode = "NonConquest",}
			herosupport:SetHeroClass(REP, SSVHeroClass)
			herosupport:SetHeroClass(CIS, COLHeroClass)
			herosupport:AddSpawnCP("CP4CON","cp4path")
			herosupport:AddSpawnCP("CP5CON","cp5path")
			herosupport:AddSpawnCP("CP6CON","cp6path")
			herosupport:AddSpawnCP("CP7CON","CP7SPAWNPATH")
			herosupport:Start()
		else end
	else end
end

function EVGxGTH_PostLoad()
	if not ScriptCB_InMultiplayer() then
		DecideEVGHeroClass()
		DecideGTHHeroClass()
		if ME5_AIHeroes == 0 then
			SetHeroClass(REP, EVGHeroClass)
			SetHeroClass(CIS, GTHHeroClass)
		elseif ME5_AIHeroes == 1 then
			herosupport = AIHeroSupport:New{AIATTHeroHealth = 3000, AIDEFHeroHealth = 3000, gameMode = "NonConquest",}
			herosupport:SetHeroClass(REP, EVGHeroClass)
			herosupport:SetHeroClass(CIS, GTHHeroClass)
			herosupport:AddSpawnCP("CP4CON","cp4path")
			herosupport:AddSpawnCP("CP5CON","cp5path")
			herosupport:AddSpawnCP("CP6CON","cp6path")
			herosupport:AddSpawnCP("CP7CON","CP7SPAWNPATH")
			herosupport:Start()
		else end
	else end
end

function EVGxCOL_PostLoad()
	if not ScriptCB_InMultiplayer() then
		DecideEVGHeroClass()
		DecideCOLHeroClass()
		if ME5_AIHeroes == 0 then
			SetHeroClass(REP, EVGHeroClass)
			SetHeroClass(CIS, COLHeroClass)
		elseif ME5_AIHeroes == 1 then
			herosupport = AIHeroSupport:New{AIATTHeroHealth = 3000, AIDEFHeroHealth = 3000, gameMode = "NonConquest",}
			herosupport:SetHeroClass(REP, EVGHeroClass)
			herosupport:SetHeroClass(CIS, COLHeroClass)
			herosupport:AddSpawnCP("CP4CON","cp4path")
			herosupport:AddSpawnCP("CP5CON","cp5path")
			herosupport:AddSpawnCP("CP6CON","cp6path")
			herosupport:AddSpawnCP("CP7CON","CP7SPAWNPATH")
			herosupport:Start()
		else end
	else end
end

function ScriptPostLoad()

    AddDeathRegion("turbinedeath")
    
    KillObject("blastdoor")
    DisableBarriers("barracks")
    DisableBarriers("liea")
    SetMapNorthAngle(180)
    
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
	
	SetProperty("CP4CON", "AllyPath", "cp4path")
	SetProperty("CP5CON", "AllyPath", "cp5path")
	SetProperty("CP6CON", "AllyPath", "cp6path")
	SetProperty("CP7CON", "AllyPath", "CP7SPAWNPATH")
	
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
		SSVxCOL_PostLoad()
	end
    
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
	
	
	--[[oxygen1Ptr = GetEntityPtr("lvlution_oxygen_fx1")
	oxygen2Ptr = GetEntityPtr("lvlution_oxygen_fx2")
	oxygen3Ptr = GetEntityPtr("lvlution_oxygen_fx3")
	oxygen4Ptr = GetEntityPtr("lvlution_oxygen_fx4")
	oxygen5Ptr = GetEntityPtr("lvlution_oxygen_fx5")
	
	--print("oxygen1Ptr: "..oxygen1Ptr)
	
	Oxygen1Node = GetPathPoint("oxygen_path", 3) -- gets the path point
	Oxygen2Node = GetPathPoint("oxygen_path", 0)
	Oxygen3Node = GetPathPoint("oxygen_path", 4)
	Oxygen4Node = GetPathPoint("oxygen_path", 2)
	Oxygen5Node = GetPathPoint("oxygen_path", 1)
	OxygenDummyNode = GetPathPoint("oxygen_path", 5)
	
	SetEntityMatrix( oxygen1Ptr, OxygenDummyNode ) -- hide Levolution oxygen vacuum pfx
	SetEntityMatrix( oxygen2Ptr, OxygenDummyNode )
	SetEntityMatrix( oxygen3Ptr, OxygenDummyNode )
	SetEntityMatrix( oxygen4Ptr, OxygenDummyNode )
	SetEntityMatrix( oxygen5Ptr, OxygenDummyNode )]]
	
	--SetClassProperty("lvlution_prop_oxygen", "MaxParticles", "0")
	--SetClassProperty("lvlution_prop_oxygen1", "MaxParticles", "0")
	--SetClassProperty("lvlution_prop_oxygen2", "MaxParticles", "0")
	
	--[[KillObject(oxygen1Ptr)
	KillObject(oxygen2Ptr)
	KillObject(oxygen3Ptr)
	KillObject(oxygen4Ptr)
	KillObject(oxygen5Ptr)
	DeleteEntity("lvlution_oxygen1")
	DeleteEntity("lvlution_oxygen2")
	DeleteEntity("lvlution_oxygen3")
	DeleteEntity("lvlution_oxygen4")
	DeleteEntity("lvlution_oxygen5")]]
	
	--[[oxygenPfx = CreateEffect("lvlution_oxygen_vacuum")
	oxygen1Pos = GetEntityMatrix(oxygen1Ptr)
	oxygen2Pos = GetEntityMatrix(oxygen2Ptr)
	oxygen3Pos = GetEntityMatrix(oxygen3Ptr)
	oxygen4Pos = GetEntityMatrix(oxygen4Ptr)
	oxygen5Pos = GetEntityMatrix(oxygen5Ptr)
	AttachEffectToMatrix(oxygenPfx, Oxygen1Node)
	AttachEffectToMatrix(oxygenPfx, Oxygen2Node)
	AttachEffectToMatrix(oxygenPfx, Oxygen3Node)
	AttachEffectToMatrix(oxygenPfx, Oxygen4Node)
	AttachEffectToMatrix(oxygenPfx, Oxygen5Node)]]
	
	if not ScriptCB_InMultiplayer() then
		mathTimeDestruct = math.random(60,360)
	else
		mathTimeDestruct = 200
	end
	
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
	
	   --Setup Levolution Timer - Pre-Destruction-- 
	
	timePreDestruction = CreateTimer("timePreDestruction")
	SetTimerValue(timePreDestruction, 0.2)
	StartTimer(timePreDestruction)
	--ShowTimer(timePreDestruction)
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
			
			DestroyTimer(timer)
		end,
	timePreDestruction
	)
	
	   --Setup Levolution Timer - Hull Breach Seal-- 

	timeCorridorSeal = CreateTimer("timeCorridorSeal")
	SetTimerValue(timeCorridorSeal, 10)
	--ShowTimer(timeCorridorSeal)
	OnTimerElapse(
		function(timer)
				print("tan1n_con: Initiating Levolution corridor hull breach seal")
			ScriptCB_SndPlaySound("tan_vo_hull_sealed")
			ShowMessageText("level.tan1.events.hull_sealed")
			--ShowMessageText("level.tan1.events.doors_unlocked")
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
			--[[SetEntityMatrix( "lvlution_oxygen1", OxygenDummyNode )
			SetEntityMatrix( "lvlution_oxygen2", OxygenDummyNode )
			SetEntityMatrix( "lvlution_oxygen3", OxygenDummyNode )
			SetEntityMatrix( "lvlution_oxygen4", OxygenDummyNode )
			SetEntityMatrix( "lvlution_oxygen5", OxygenDummyNode )]]
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
			DestroyTimer(timer)
		end,
	timeCorridorSeal
	)
	
	   --Setup Levolution Timer - Destruction-- 

	timeCorridorDestruct = CreateTimer("timeCorridorDestruct")
	SetTimerValue(timeCorridorDestruct, mathTimeDestruct)	-- 20
	StartTimer(timeCorridorDestruct)
	--ShowTimer(timeCorridorDestruct)
	OnTimerElapse(
		function(timer)
				print("tan1n_con: Initiating Levolution corridor destruction")
			ScriptCB_SndPlaySound("tan_vo_hull_breached")
			ShowMessageText("level.tan1.events.hull_breached")
			--ShowMessageText("level.tan1.events.doors_locked")
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
			--[[SetProperty("lvlution_oxygen_fx1", "AttachEffect", "lvlution_oxygen_vacuum")
			SetProperty("lvlution_oxygen_fx1", "AttachToHardPoint", "hp_attach")
			SetProperty("lvlution_oxygen_fx2", "AttachEffect", "lvlution_oxygen_vacuum")
			SetProperty("lvlution_oxygen_fx2", "AttachToHardPoint", "hp_attach")
			SetProperty("lvlution_oxygen_fx3", "AttachEffect", "lvlution_oxygen_vacuum")
			SetProperty("lvlution_oxygen_fx3", "AttachToHardPoint", "hp_attach")
			SetProperty("lvlution_oxygen_fx4", "AttachEffect", "lvlution_oxygen_vacuum")
			SetProperty("lvlution_oxygen_fx4", "AttachToHardPoint", "hp_attach")
			SetProperty("lvlution_oxygen_fx5", "AttachEffect", "lvlution_oxygen_vacuum")
			SetProperty("lvlution_oxygen_fx5", "AttachToHardPoint", "hp_attach")
			SetEntityMatrix( "lvlution_oxygen1", Oxygen1Node )
			SetEntityMatrix( "lvlution_oxygen2", Oxygen2Node )
			SetEntityMatrix( "lvlution_oxygen3", Oxygen3Node )
			SetEntityMatrix( "lvlution_oxygen4", Oxygen4Node )
			SetEntityMatrix( "lvlution_oxygen5", Oxygen5Node )]]
			
			StartTimer(timeCorridorSeal)
			--ShowTimer(timeCorridorSeal)
			DestroyTimer(timer)
		end,
	timeCorridorDestruct
	)
	
	
	PostLoadStuff()
    
end

function destturbine()
    UnblockPlanningGraphArcs("turbine")
    PauseAnimation("Turbine Animation")
    RemoveRegion("turbinedeath")
--    SetProperty("woodr", "CurHealth", 15)
end

function returbine()
    BlockPlanningGraphArcs("turbine")
    PlayAnimation("Turbine Animation")
    AddDeathRegion("turbinedeath")
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
	
	PreLoadStuff()
    SetWorldExtents(1064.5)
	
	-- This sets the agressiveness for each team.
	----SetTeamAggressiveness(CIS,(0.99))
	--SetTeamAggressiveness(REP,(0.99))
	
	
	SetMemoryPoolSize("Combo",4)              -- should be ~ 2x number of jedi classes
	SetMemoryPoolSize("Combo::State",48)      -- should be ~12x #Combo
	SetMemoryPoolSize("Combo::Transition",54) -- should be a bit bigger than #Combo::State
	SetMemoryPoolSize("Combo::Condition",54)  -- should be a bit bigger than #Combo::State
	SetMemoryPoolSize("Combo::Attack",48)     -- should be ~8-12x #Combo
	SetMemoryPoolSize("Combo::DamageSample",580)  -- should be ~8-12x #Combo::Attack
	SetMemoryPoolSize("Combo::Deflect",4)     -- should be ~1x #combo
	
	SetMemoryPoolSize ("Music", 72)
	
	Init_SideSetup()
	
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_s_TAN_Streaming.lvl;tan1n")
	
    --  Level Stats
    ClearWalkers()
    AddWalkerType(0, 0)  -- number of droidekas

	local weaponCnt = 177
	local guyCnt = 50
	SetMemoryPoolSize("Aimer", 25)
	SetMemoryPoolSize("AmmoCounter", weaponCnt)
	SetMemoryPoolSize("BaseHint", 250)
	SetMemoryPoolSize("EnergyBar", weaponCnt)
	SetMemoryPoolSize("EntitySoundStream", 14)
	SetMemoryPoolSize("EntitySoundStatic", 45)
	SetMemoryPoolSize("FlagItem", 512)
	SetMemoryPoolSize("MountedTurret", 25)
	SetMemoryPoolSize("Navigator", guyCnt)
	SetMemoryPoolSize("Obstacle", 250)
	SetMemoryPoolSize("PathFollower", guyCnt)
	SetMemoryPoolSize("PathNode", 384)
	SetMemoryPoolSize("SoldierAnimation", 370)
	SetMemoryPoolSize("SoundSpaceRegion", 15)
	SetMemoryPoolSize("TentacleSimulator", 0)
	SetMemoryPoolSize("TreeGridStack", 150)
	SetMemoryPoolSize("UnitAgent", guyCnt)
	SetMemoryPoolSize("UnitController", guyCnt)
	SetMemoryPoolSize("Weapon", weaponCnt)
	
	
	--	SetMemoryPoolSize("Obstacle", 182)
	--
    SetSpawnDelay(10.0, 0.25)
    ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ME5\\tan1.lvl", "tan1_conquest")
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\minimap.lvl;tan1")
    SetDenseEnvironment("false")
	AISnipeSuitabilityDist(50)
	SetAttackerSnipeRange(60)
	SetDefenderSnipeRange(70)
    --AddDeathRegion("Sarlac01")
    -- SetMaxFlyHeight(90)
    -- SetMaxPlayerFlyHeight(90)

    --  Sound Stats

	if not ScriptCB_InMultiplayer() then
		if ME5_SideVar == 0 then
			if RandomSide == 1 then
				Music06()
			elseif RandomSide == 2 then
				Music02()
			elseif RandomSide == 3 then
				Music06()
			elseif RandomSide == 4 then
				Music09()
			end
		elseif ME5_SideVar == 1 then
			Music06()
		elseif ME5_SideVar == 2 then
			Music02()
		elseif ME5_SideVar == 3	then
			Music06()
		elseif ME5_SideVar == 4	then
			Music09()
		else end
	else
		Music02()
	end
	
	OpenAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_s_TAN_Streaming.lvl",  "tan1")
	OpenAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_s_TAN_Streaming.lvl",  "tan")
	
	SoundFX()


    --  Camera Stats
    AddCameraShot(0.233199, -0.019441, -0.968874, -0.080771, -240.755920, 11.457644, 105.944176);
    AddCameraShot(-0.395561, 0.079428, -0.897092, -0.180135, -264.022278, 6.745873, 122.715752);
    AddCameraShot(0.546703, -0.041547, -0.833891, -0.063371, -309.709900, 5.168304, 145.334381);

end