ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\master.lvl")
RandomSide = math.random(1,4)
--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- load the gametype script --
ScriptCB_DoFile("ME5_Master")
ScriptCB_DoFile("ME5_setup_teams")
ScriptCB_DoFile("ME5_ObjectiveBFConquest")

mapSize = med
EnvironmentType = 3
onlineSideVar = SSVxGTH
onlineHeroSSV = shep_sentinel
onlineHeroGTH = gethprime_me2
onlineHeroCOL = colgeneral
onlineHeroEVG = gethprime_me3

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
			herosupport:AddSpawnCP("team1_permacp","CP1JERKPATH")
			herosupport:AddSpawnCP("team2_permacp","CP2JERKPATH")
			herosupport:AddSpawnCP("CP4_CON","CP4JERKPATH")
			herosupport:AddSpawnCP("CP5_CON","CP5JERKPATH")
			herosupport:AddSpawnCP("CP7_CON","CP7JERKPATH")
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
			herosupport:AddSpawnCP("team1_permacp","CP1JERKPATH")
			herosupport:AddSpawnCP("team2_permacp","CP2JERKPATH")
			herosupport:AddSpawnCP("CP4_CON","CP4JERKPATH")
			herosupport:AddSpawnCP("CP5_CON","CP5JERKPATH")
			herosupport:AddSpawnCP("CP7_CON","CP7JERKPATH")
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
			herosupport:AddSpawnCP("team1_permacp","CP1JERKPATH")
			herosupport:AddSpawnCP("team2_permacp","CP2JERKPATH")
			herosupport:AddSpawnCP("CP4_CON","CP4JERKPATH")
			herosupport:AddSpawnCP("CP5_CON","CP5JERKPATH")
			herosupport:AddSpawnCP("CP7_CON","CP7JERKPATH")
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
			herosupport:AddSpawnCP("team1_permacp","CP1JERKPATH")
			herosupport:AddSpawnCP("team2_permacp","CP2JERKPATH")
			herosupport:AddSpawnCP("CP4_CON","CP4JERKPATH")
			herosupport:AddSpawnCP("CP5_CON","CP5JERKPATH")
			herosupport:AddSpawnCP("CP7_CON","CP7JERKPATH")
			herosupport:Start()
		else end
	else end
end

function ScriptPostLoad()
	SetObjectTeam("CP4_CON", 0)
	SetObjectTeam("CP5_CON", 0)
	SetObjectTeam("CP7_CON", 0)
	KillObject("CP1_CON")	-- team 1
	KillObject("CP2_CON")	-- team 2
 
    DisableBarriers("dropship")
    DisableBarriers("shield_03")
    DisableBarriers("shield_02")
    DisableBarriers("shield_01")
    DisableBarriers("ctf")
    DisableBarriers("ctf1")
    DisableBarriers("ctf2")
    DisableBarriers("ctf3")
    DisableBarriers("coresh1")

    EnableSPHeroRules()
    
    --cp1 = CommandPost:New{name = "CP1_CON"}
    --cp2 = CommandPost:New{name = "CP2_CON"}
    --cp3 = CommandPost:New{name = "CP3_CON"}
    cp4 = CommandPost:New{name = "CP4_CON"}
    cp5 = CommandPost:New{name = "CP5_CON"}
    cp7 = CommandPost:New{name = "CP7_CON"}
    --cp8 = CommandPost:New{name = "CP8_CON"}
    
    conquest = ObjectiveConquest:New{teamATT = ATT, teamDEF = DEF, textATT = "game.modes.con", textDEF = "game.modes.con2", multiplayerRules = true}
	
    --conquest:AddCommandPost(cp1)
    --conquest:AddCommandPost(cp2)
    --conquest:AddCommandPost(cp3)
    conquest:AddCommandPost(cp4)
    conquest:AddCommandPost(cp5)
    conquest:AddCommandPost(cp7)
    --conquest:AddCommandPost(cp8)
    
    conquest:Start()
	
	SetProperty("team1_permacp", "AllyPath", "CP1JERKPATH")
	SetProperty("team2_permacp", "AllyPath", "CP2JERKPATH")
	SetProperty("CP4_CON", "AllyPath", "CP4JERKPATH")
	SetProperty("CP5_CON", "AllyPath", "CP5JERKPATH")
	SetProperty("CP7_CON", "AllyPath", "CP7JERKPATH")
	
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
		SSVxGTH_PostLoad()
	end
	
	SetReinforcementCount(REP, 250)
	SetReinforcementCount(CIS, 250)
	
	PostLoadStuff()
    
end
 
function ScriptInit()
    -- Designers, these two lines *MUST* be first!
    StealArtistHeap(2048 * 1024)
    SetPS2ModelMemory(4000000)
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\Load\\load.lvl;myg1")
	
	SetMemoryPoolSize("ParticleTransformer::ColorTrans", 2192)
	SetMemoryPoolSize("ParticleTransformer::PositionTr", 1295)
	SetMemoryPoolSize("ParticleTransformer::SizeTransf", 1413)
	
	PreLoadStuff()
	
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\me5tur.lvl",
					"tur_bldg_mturret")
	
	Init_SideSetup()
	
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_s_MYG_Streaming.lvl;myg1n")
	
    --  Level Stats
    ClearWalkers()
    AddWalkerType(0, 0)
    AddWalkerType(2, 0)
    local weaponCnt = 230
    SetMemoryPoolSize("Aimer", 60)
    SetMemoryPoolSize("AmmoCounter", weaponCnt)
    SetMemoryPoolSize("BaseHint", 250)
    SetMemoryPoolSize("EnergyBar", weaponCnt)
	SetMemoryPoolSize("EntityCloth", 19)
    SetMemoryPoolSize("EntityHover", 7)
    SetMemoryPoolSize("EntityFlyer", 6)
    SetMemoryPoolSize("EntitySoundStream", 32)
    SetMemoryPoolSize("EntitySoundStatic", 76)
	SetMemoryPoolSize("FlagItem", 512)
    SetMemoryPoolSize("MountedTurret", 20)
    SetMemoryPoolSize("Navigator", 50)
    SetMemoryPoolSize("Obstacle", 500)
    SetMemoryPoolSize("PathNode", 256)
	SetMemoryPoolSize("SoldierAnimation", 313)
    SetMemoryPoolSize("TreeGridStack", 275)
    SetMemoryPoolSize("UnitAgent", 50)
    SetMemoryPoolSize("UnitController", 50)
    SetMemoryPoolSize("Weapon", weaponCnt)
    
    SetSpawnDelay(10.0, 0.25)
    ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ME5\\myg1.lvl", "myg1_Siege")
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\minimap.lvl;myg1")
    SetDenseEnvironment("false")
    AddDeathRegion("deathregion")
    SetMaxFlyHeight(20)
    SetMaxPlayerFlyHeight(20)
	AISnipeSuitabilityDist(85)
	SetAttackerSnipeRange(100)
	SetDefenderSnipeRange(160)

    --  Sound Stats
	
	if not ScriptCB_InMultiplayer() then
		if ME5_SideVar == 0 then
			if RandomSide == 1 then
				Music03()
			elseif RandomSide == 2 then
				Music05()
			elseif RandomSide == 3 then
				Music09()
			elseif RandomSide == 4 then
				Music09()
			end
		elseif ME5_SideVar == 1 then
			Music03()
		elseif ME5_SideVar == 2 then
			Music05()
		elseif ME5_SideVar == 3	then
			Music09()
		elseif ME5_SideVar == 4	then
			Music09()
		else end
	else
		Music03()
	end
	
	OpenAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_s_MYG_Streaming.lvl",  "myg1")
	
	SoundFX()


        --Camera Shizzle--
        
        -- Collector Shot
    AddCameraShot(0.008315, 0.000001, -0.999965, 0.000074, -64.894348, 5.541570, 201.711090);
	AddCameraShot(0.633584, -0.048454, -0.769907, -0.058879, -171.257629, 7.728924, 28.249359);
	AddCameraShot(-0.001735, -0.000089, -0.998692, 0.051092, -146.093109, 4.418306, -167.739212);
	AddCameraShot(0.984182, -0.048488, 0.170190, 0.008385, 1.725611, 8.877428, 88.413887);
	AddCameraShot(0.141407, -0.012274, -0.986168, -0.085598, -77.743042, 8.067328, 42.336128);
	AddCameraShot(0.797017, 0.029661, 0.602810, -0.022434, -45.726467, 7.754435, -47.544712);
	AddCameraShot(0.998764, 0.044818, -0.021459, 0.000963, -71.276566, 4.417432, 221.054550);
end
