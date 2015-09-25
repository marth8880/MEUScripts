ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\master.lvl")
RandomSide = math.random(1,4)
--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--
ScriptCB_DoFile("ME5_Master")
ScriptCB_DoFile("ME5_setup_teams")
ScriptCB_DoFile("ME5_ObjectiveConquest")

mapSize = med
EnvironmentType = 1
onlineSideVar = EVGxGTH
onlineHeroSSV = shep_sentinel
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

----------------------------------------------------------------------
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
			herosupport:AddSpawnCP("con_cp1","con_cp1spawn")
			herosupport:AddSpawnCP("con_cp1a","con_cp1aspawn")
			herosupport:AddSpawnCP("con_cp2","con_cp2spawn")
			herosupport:AddSpawnCP("con_cp5","con_cp5spawn")
			herosupport:AddSpawnCP("con_cp6","con_cp6spawn")
			herosupport:AddSpawnCP("con_cp7","con_cp7_spawn")
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
			herosupport:AddSpawnCP("con_cp1","con_cp1spawn")
			herosupport:AddSpawnCP("con_cp1a","con_cp1aspawn")
			herosupport:AddSpawnCP("con_cp2","con_cp2spawn")
			herosupport:AddSpawnCP("con_cp5","con_cp5spawn")
			herosupport:AddSpawnCP("con_cp6","con_cp6spawn")
			herosupport:AddSpawnCP("con_cp7","con_cp7_spawn")
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
			herosupport:AddSpawnCP("con_cp1","con_cp1spawn")
			herosupport:AddSpawnCP("con_cp1a","con_cp1aspawn")
			herosupport:AddSpawnCP("con_cp2","con_cp2spawn")
			herosupport:AddSpawnCP("con_cp5","con_cp5spawn")
			herosupport:AddSpawnCP("con_cp6","con_cp6spawn")
			herosupport:AddSpawnCP("con_cp7","con_cp7_spawn")
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
			herosupport:AddSpawnCP("con_cp1","con_cp1spawn")
			herosupport:AddSpawnCP("con_cp1a","con_cp1aspawn")
			herosupport:AddSpawnCP("con_cp2","con_cp2spawn")
			herosupport:AddSpawnCP("con_cp5","con_cp5spawn")
			herosupport:AddSpawnCP("con_cp6","con_cp6spawn")
			herosupport:AddSpawnCP("con_cp7","con_cp7_spawn")
			herosupport:Start()
		else end
	else end
end

function ScriptPostLoad()

    EnableSPHeroRules()
    
    --CP SETUP for CONQUEST

    cp1 = CommandPost:New{name = "CON_CP1"}
    cp2 = CommandPost:New{name = "con_CP1a"}
    cp3 = CommandPost:New{name = "CON_CP2"}
    cp4 = CommandPost:New{name = "CON_CP5"}
    cp5 = CommandPost:New{name = "CON_CP6"}
	cp6 = CommandPost:New{name = "CON_CP7"}

    conquest = ObjectiveConquest:New{teamATT = ATT, teamDEF = DEF, textATT = "game.modes.con", textDEF = "game.modes.con2", multiplayerRules = true}
    
    conquest:AddCommandPost(cp1)
    conquest:AddCommandPost(cp2)
    conquest:AddCommandPost(cp3)
    conquest:AddCommandPost(cp4)
    conquest:AddCommandPost(cp5)
    conquest:AddCommandPost(cp6)
	
    conquest:Start()
    DisableBarriers("Barrier445");
	
	
	SetProperty("CON_CP1", "AllyPath", "con_cp1spawn")
	SetProperty("con_CP1a", "AllyPath", "con_cp1aspawn")
	SetProperty("CON_CP2", "AllyPath", "con_cp2spawn")
	SetProperty("CON_CP5", "AllyPath", "con_cp5spawn")
	SetProperty("CON_CP6", "AllyPath", "con_cp6spawn")
	SetProperty("CON_CP7", "AllyPath", "con_cp7_spawn")
	
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
		EVGxGTH_PostLoad()
	end
	
	PostLoadStuff()
	
end
 
 
function ScriptInit()
    -- Designers, these two lines *MUST* be first!
    StealArtistHeap(1228*1024)
    SetPS2ModelMemory(4380000)
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\Load\\load.lvl;uta1")
	
	SetMemoryPoolSize("ParticleTransformer::ColorTrans", 2222)
	SetMemoryPoolSize("ParticleTransformer::PositionTr", 1309)
	SetMemoryPoolSize("ParticleTransformer::SizeTransf", 1430)
	
	PreLoadStuff()

    --  Republic Attacking (attacker is always #1)
   
    --SetTeamAggressiveness(REP, 0.95)
    --SetTeamAggressiveness(CIS, 0.95)
	
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\me5tur.lvl",
					"tur_bldg_mturret",
					"tur_bldg_laser")

	Init_SideSetup()
	
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_s_UTA_Streaming.lvl;uta1n")

    --  Level Stats
    ClearWalkers()
    AddWalkerType(0, 0)     -- droidekas
    AddWalkerType(1, 0) -- ATRTa (special case: 0 leg pairs)
    local weaponCnt = 220
    SetMemoryPoolSize("Aimer", 36)
    SetMemoryPoolSize("AmmoCounter", weaponCnt)
    SetMemoryPoolSize("BaseHint", 200)
    SetMemoryPoolSize("Combo::DamageSample", 610)
    SetMemoryPoolSize("EnergyBar", weaponCnt)
    SetMemoryPoolSize("EntityHover",6)
    SetMemoryPoolSize("EntityLight", 60)
    SetMemoryPoolSize("EntityFlyer", 8)
    SetMemoryPoolSize("EntitySoundStream", 8)
    SetMemoryPoolSize("EntitySoundStatic", 27)
	SetMemoryPoolSize("FlagItem", 512)
    SetMemoryPoolSize("MountedTurret", 20)
    SetMemoryPoolSize("Navigator", 40)
    SetMemoryPoolSize("Obstacle", 400)
    SetMemoryPoolSize("PathFollower", 40)
    SetMemoryPoolSize("PathNode", 180)
	SetMemoryPoolSize("SoldierAnimation", 348)
    SetMemoryPoolSize("TentacleSimulator", 0)
    SetMemoryPoolSize("TreeGridStack", 225)
    SetMemoryPoolSize("UnitAgent", 40)
    SetMemoryPoolSize("UnitController", 40)
    SetMemoryPoolSize("Weapon", weaponCnt)
    
    SetSpawnDelay(10.0, 0.25)
    ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ME5\\uta1.lvl", "uta1_Conquest")
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\minimap.lvl;uta1")
    AddDeathRegion("deathregion")
    SetDenseEnvironment("false")
	SetMaxFlyHeight(29.5)
	SetMaxPlayerFlyHeight(29.5)
	AISnipeSuitabilityDist(80)
	SetAttackerSnipeRange(105)
	SetDefenderSnipeRange(135)


    --  Sound Stats
	
	if not ScriptCB_InMultiplayer() then
		if ME5_SideVar == 0 then
			if RandomSide == 1 then
				Music04()
			elseif RandomSide == 2 then
				Music02()
			elseif RandomSide == 3 then
				Music09()
			elseif RandomSide == 4 then
				Music09()
			end
		elseif ME5_SideVar == 1 then
			Music04()
		elseif ME5_SideVar == 2 then
			Music02()
		elseif ME5_SideVar == 3	then
			Music09()
		elseif ME5_SideVar == 4	then
			Music09()
		else end
	else
		Music09()
	end
	
	OpenAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_s_UTA_Streaming.lvl",  "uta1")
	
	SoundFX()

--  Camera Stats - Utapau: Sinkhole
	AddCameraShot(-0.428091, 0.045649, -0.897494, -0.095703, 162.714951, 45.857063, 40.647118)
	AddCameraShot(-0.194861, -0.001600, -0.980796, 0.008055, -126.179787, 16.113789, 70.012894);
	AddCameraShot(-0.462548, -0.020922, -0.885442, 0.040050, -16.947638, 4.561796, 156.926956);
	AddCameraShot(0.995310, 0.024582, -0.093535, 0.002310, 38.288612, 4.561796, 243.298508);
	AddCameraShot(0.827070, 0.017093, 0.561719, -0.011609, -24.457638, 8.834146, 296.544586);
	AddCameraShot(0.998875, 0.004912, -0.047174, 0.000232, -45.868237, 2.978215, 216.217880);


end
