ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\master.lvl")

isModMap = 1
--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

ScriptCB_DoFile("ME5_Master")
ScriptCB_DoFile("ME5_setup_teams")
ScriptCB_DoFile("ME5_ObjectiveConquest")

mapSize = "sm"
EnvironmentType = "jungle"
onlineSideVar = "SSVxGTH"
onlineHeroSSV = "shep_engineer"
onlineHeroGTH = "gethprime_me2"
onlineHeroCOL = "colgeneral"
onlineHeroEVG = "gethprime_me3"

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
			herosupport:AddSpawnCP("cp1","cp1_spawn")
			herosupport:AddSpawnCP("cp2","cp2_spawn")
			herosupport:AddSpawnCP("cp3","cp3_spawn")
			herosupport:AddSpawnCP("cp4","cp4_spawn")
			herosupport:Start()
		end
	end
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
			herosupport:AddSpawnCP("cp1","cp1_spawn")
			herosupport:AddSpawnCP("cp2","cp2_spawn")
			herosupport:AddSpawnCP("cp3","cp3_spawn")
			herosupport:AddSpawnCP("cp4","cp4_spawn")
			herosupport:Start()
		end
	end
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
			herosupport:AddSpawnCP("cp1","cp1_spawn")
			herosupport:AddSpawnCP("cp2","cp2_spawn")
			herosupport:AddSpawnCP("cp3","cp3_spawn")
			herosupport:AddSpawnCP("cp4","cp4_spawn")
			herosupport:Start()
		end
	end
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
			herosupport:AddSpawnCP("cp1","cp1_spawn")
			herosupport:AddSpawnCP("cp2","cp2_spawn")
			herosupport:AddSpawnCP("cp3","cp3_spawn")
			herosupport:AddSpawnCP("cp4","cp4_spawn")
			herosupport:Start()
		end
	end
end

function ScriptPostLoad()	   
    
    
    --This defines the CPs.  These need to happen first
    cp1 = CommandPost:New{name = "cp1"}
    cp2 = CommandPost:New{name = "cp2"}
    cp3 = CommandPost:New{name = "cp3"}
    cp4 = CommandPost:New{name = "cp4"}
    
    
    
    --This sets up the actual objective.  This needs to happen after cp's are defined
    conquest = ObjectiveConquest:New{teamATT = ATT, teamDEF = DEF, 
                                     textATT = "game.modes.con", 
                                     textDEF = "game.modes.con2",
                                     multiplayerRules = true}
    
    --This adds the CPs to the objective.  This needs to happen after the objective is set up
    conquest:AddCommandPost(cp1)
    conquest:AddCommandPost(cp2)
    conquest:AddCommandPost(cp3)
    conquest:AddCommandPost(cp4)

	SetProperty("cp1", "AllyPath", "cp1_spawn")
	SetProperty("cp2", "AllyPath", "cp2_spawn")
	SetProperty("cp3", "AllyPath", "cp3_spawn")
	SetProperty("cp4", "AllyPath", "cp4_spawn")
	
	ClearAIGoals(1)
	ClearAIGoals(2)
	AddAIGoal(1, "Conquest", 100)
	AddAIGoal(2, "Conquest", 100)
	AddAIGoal(HuskTeam, "Deathmatch", 100)
	
	if not ScriptCB_InMultiplayer() then
		if ME5_SideVar == 1 then
			SSVxGTH_PostLoad()
		elseif ME5_SideVar == 2 then
			SSVxCOL_PostLoad()
		elseif ME5_SideVar == 3 then
			EVGxGTH_PostLoad()
		elseif ME5_SideVar == 4 then
			EVGxCOL_PostLoad()
		end
	else
		SSVxGTH_PostLoad()
	end
    
    conquest:Start()

    EnableSPHeroRules()
    
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
	--ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\Load\\t4e.lvl")
	
	SetMemoryPoolSize("ParticleTransformer::ColorTrans", 2367)
	SetMemoryPoolSize("ParticleTransformer::PositionTr", 1380)
	SetMemoryPoolSize("ParticleTransformer::SizeTransf", 1533)
	
	PreLoadStuff()
	
    SetMaxFlyHeight(30)
    SetMaxPlayerFlyHeight(30)
	AISnipeSuitabilityDist(35)
	SetAttackerSnipeRange(45)
	SetDefenderSnipeRange(70)
	
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\me5tur.lvl",
					"tur_bldg_mturret",
					"tur_bldg_laser")
	
	Init_SideSetup()
	
	-- TODO: create sound LVL 
	--ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_T4E_Streaming.lvl")
	
    --  Level Stats
    --  ClearWalkers()
    AddWalkerType(0, 0) -- special -> droidekas
    AddWalkerType(1, 0) -- 1x2 (1 pair of legs)
    AddWalkerType(2, 0) -- 2x2 (2 pairs of legs)
    AddWalkerType(3, 0) -- 3x2 (3 pairs of legs)
    local weaponCnt = 1024
    SetMemoryPoolSize("Aimer", 75)
    SetMemoryPoolSize("AmmoCounter", weaponCnt)
    SetMemoryPoolSize("BaseHint", 1024)
    SetMemoryPoolSize("EnergyBar", weaponCnt)
	SetMemoryPoolSize("EntityCloth", 32)
	SetMemoryPoolSize("EntityFlyer", 32)
    SetMemoryPoolSize("EntityHover", 32)
    SetMemoryPoolSize("EntityLight", 200)
    SetMemoryPoolSize("EntitySoundStream", 4)
    SetMemoryPoolSize("EntitySoundStatic", 32)
	SetMemoryPoolSize("FlagItem", 512)
    SetMemoryPoolSize("MountedTurret", 32)
	SetMemoryPoolSize("Navigator", 128)
    SetMemoryPoolSize("Obstacle", 1024)
	SetMemoryPoolSize("PathNode", 1024)
    SetMemoryPoolSize("SoldierAnimation", 417)
    SetMemoryPoolSize("SoundSpaceRegion", 64)
    SetMemoryPoolSize("TreeGridStack", 1024)
	SetMemoryPoolSize("UnitAgent", 128)
	SetMemoryPoolSize("UnitController", 128)
	SetMemoryPoolSize("Weapon", weaponCnt)
    
    SetSpawnDelay(10.0, 0.25)
    ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ME5\\T4E.lvl", "T4E_conquest")
    SetDenseEnvironment("false")
    
    
    --  Sound Stats
    
    -- TODO: create sound streams
	--OpenAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\Sound\\SFL_T4E_Streaming.lvl",  "T4E_ambiance")

	if not ScriptCB_InMultiplayer() then
		if ME5_SideVar == 1 then
			Music06()
		elseif ME5_SideVar == 2 then
			Music02()
		elseif ME5_SideVar == 3	then
			Music06()
		elseif ME5_SideVar == 4	then
			Music09()
		end
	else
		Music06()
	end
	
	SoundFX()
	
    --  Camera Stats
	AddCameraShot(-0.370814, 0.035046, -0.923929, -0.087320, -71.966255, 23.668301, 27.930090);
	AddCameraShot(0.991073, 0.002392, 0.133299, -0.000322, 84.069084, 23.668301, -95.802574);
	
	PostLoadStuff()
end
