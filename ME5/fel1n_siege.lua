ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\master.lvl")
RandomSide = math.random(1,4)
--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- load the gametype script
ScriptCB_DoFile("ME5_Master")
ScriptCB_DoFile("ME5_setup_teams")
ScriptCB_DoFile("ME5_ObjectiveBFConquest")

mapSize = lg
EnvironmentType = 2
onlineSideVar = SSVxCOL
onlineHeroSSV = shep_infiltrator
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
			herosupport:AddSpawnCP("team1_permacp","cp1spawn")
			herosupport:AddSpawnCP("team2_permacp","cp2spawn")
			herosupport:AddSpawnCP("cp3-1","cp3spawn")
			herosupport:AddSpawnCP("cp4-1","cp4spawn")
			herosupport:AddSpawnCP("cp5-1","cp5spawn")
			herosupport:AddSpawnCP("cp6-1","cp6-1_spawn")
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
			herosupport:AddSpawnCP("team1_permacp","cp1spawn")
			herosupport:AddSpawnCP("team2_permacp","cp2spawn")
			herosupport:AddSpawnCP("cp3-1","cp3spawn")
			herosupport:AddSpawnCP("cp4-1","cp4spawn")
			herosupport:AddSpawnCP("cp5-1","cp5spawn")
			herosupport:AddSpawnCP("cp6-1","cp6-1_spawn")
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
			herosupport:AddSpawnCP("team1_permacp","cp1spawn")
			herosupport:AddSpawnCP("team2_permacp","cp2spawn")
			herosupport:AddSpawnCP("cp3-1","cp3spawn")
			herosupport:AddSpawnCP("cp4-1","cp4spawn")
			herosupport:AddSpawnCP("cp5-1","cp5spawn")
			herosupport:AddSpawnCP("cp6-1","cp6-1_spawn")
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
			herosupport:AddSpawnCP("team1_permacp","cp1spawn")
			herosupport:AddSpawnCP("team2_permacp","cp2spawn")
			herosupport:AddSpawnCP("cp3-1","cp3spawn")
			herosupport:AddSpawnCP("cp4-1","cp4spawn")
			herosupport:AddSpawnCP("cp5-1","cp5spawn")
			herosupport:AddSpawnCP("cp6-1","cp6-1_spawn")
			herosupport:Start()
		else end
	else end
end

 function ScriptPostLoad()
	SetObjectTeam("cp3-1", 0)
	SetObjectTeam("cp4-1", 0)
	SetObjectTeam("cp5-1", 0)
	SetObjectTeam("cp6-1", 0)
	KillObject("cp1-1")	-- team 1
	KillObject("cp2-1")	-- team 2
	
        --This defines the CPs.  These need to happen first
    --cp1 = CommandPost:New{name = "cp1-1"}
    --cp2 = CommandPost:New{name = "cp2-1"}
    cp3 = CommandPost:New{name = "cp3-1"}
    cp4 = CommandPost:New{name = "cp4-1"}
    cp5 = CommandPost:New{name = "cp5-1"}
    cp6 = CommandPost:New{name = "cp6-1"}

    
    --This sets up the actual objective.  This needs to happen after cp's are defined
    conquest = ObjectiveConquest:New{teamATT = ATT, teamDEF = DEF, textATT = "game.modes.siege", textDEF = "game.modes.siege2", multiplayerRules = true}
    
    --This adds the CPs to the objective.  This needs to happen after the objective is set up
    --conquest:AddCommandPost(cp1)
    --conquest:AddCommandPost(cp2)
    conquest:AddCommandPost(cp3)
    conquest:AddCommandPost(cp4)
    conquest:AddCommandPost(cp5)
    conquest:AddCommandPost(cp6)

conquest:Start()   
    EnableSPHeroRules()
	
	
	SetProperty("team1_permacp", "AllyPath", "cp1spawn")
	SetProperty("team2_permacp", "AllyPath", "cp2spawn")
	SetProperty("cp3-1", "AllyPath", "cp3spawn")
	SetProperty("cp4-1", "AllyPath", "cp4spawn")
	SetProperty("cp5-1", "AllyPath", "cp5spawn")
	SetProperty("cp6-1", "AllyPath", "cp6-1_spawn")
	
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
	
	SetReinforcementCount(REP, 600)
	SetReinforcementCount(CIS, 600)
	
	CP1Node = GetPathPoint("cp1spawn", 0) --gets the path point
	CP2Node = GetPathPoint("cp2spawn", 0)
	CP3Node = GetPathPoint("cp3spawn", 0)
	CP4Node = GetPathPoint("cp4spawn", 0)
	CP5Node = GetPathPoint("cp5spawn", 0)
	CP6Node = GetPathPoint("cp6-1_spawn", 0)
	
	--[[CreateTimer("artGameTimer")
	SetTimerValue("artGameTimer", 720)
	StartTimer("artGameTimer")
	OnTimerElapse(
		function(timer)]]
			--local team1pts = GetReinforcementCount(1)
			--if team1pts >= 100 then
				artMatrices = { CP1Node, CP2Node, CP3Node, CP4Node, CP5Node, CP6Node }
				goingthroughturrets = 0			
				
				artInitTimer = CreateTimer("artInitTimer")
				SetTimerValue("artInitTimer", 20.0)
				StartTimer("artInitTimer")
				----ShowTimer("artInitTimer")
				OnTimerElapse(
					function(timer)
						goingthroughturrets = goingthroughturrets + 1
						if goingthroughturrets == 7 then
							goingthroughturrets = 1
						end
						
						SetEntityMatrix( "artillery1", artMatrices[goingthroughturrets])
						--ShowMessageText("level.common.events.surv.artillery.msg"..goingthroughturrets)
							print("fel1n_con: Artillery transitioning to matrix: "..goingthroughturrets)
						SetTimerValue("artInitTimer", 20.0)
						StartTimer("artInitTimer")
					end,
				"artInitTimer"
				)
			--else
			--end
			
			--[[DestroyTimer(Timer)
		end,
	"artGameTimer"
	)]]
    
end

function ScriptInit()
	StealArtistHeap(132*1024)
    -- Designers, these two lines *MUST* be first.
    SetPS2ModelMemory(3200000)
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\Load\\load.lvl;fel1")
	
	SetMemoryPoolSize("ParticleTransformer::ColorTrans", 2213)
	SetMemoryPoolSize("ParticleTransformer::PositionTr", 1318)
	SetMemoryPoolSize("ParticleTransformer::SizeTransf", 1468)
	
	PreLoadStuff()
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\PFX_SSV_Veh.lvl;vehcommon")
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\PFX_SSV_Veh.lvl;vehnormal")
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ME5\\artillery_dirt.lvl")

    SetMemoryPoolSize("Music", 99)


    SetMaxFlyHeight(53)
    SetMaxPlayerFlyHeight (53)
	AISnipeSuitabilityDist(55)
	SetAttackerSnipeRange(70)
	SetDefenderSnipeRange(100)
    
    SetAttackingTeam(ATT)
	
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\me5tur.lvl",
					"tur_bldg_mturret")
	
	Init_SideSetup()
	
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_s_FEL_Streaming.lvl;fel1n")


    --  Level Stats 
    ClearWalkers()
    -- AddWalkerType(0, 8)
    --AddWalkerType(5, 2) -- 2 attes with 2 leg pairs each
    --AddWalkerType(3, 1) -- 3 acklays with 3 leg pairs each
    -- AddWalkerType(1, 2)
    -- AddWalkerType(0, 4)
    local weaponCnt = 260
    SetMemoryPoolSize("Aimer", 20)
    SetMemoryPoolSize("AmmoCounter", weaponCnt)
    SetMemoryPoolSize("BaseHint", 200)
    SetMemoryPoolSize("EnergyBar", weaponCnt)
    SetMemoryPoolSize("EntityHover", 3)
    SetMemoryPoolSize("EntityFlyer", 6)
    SetMemoryPoolSize("EntitySoundStream", 1)
    SetMemoryPoolSize("EntitySoundStatic", 0)
    SetMemoryPoolSize("EntityWalker", 5)
	SetMemoryPoolSize("FlagItem", 512)
    SetMemoryPoolSize("MountedTurret", 15)
    SetMemoryPoolSize("Obstacle", 400)
    SetMemoryPoolSize("PathNode", 512)
	SetMemoryPoolSize("SoldierAnimation", 371)
    SetMemoryPoolSize("TreeGridStack", 280)
    SetMemoryPoolSize("Weapon", weaponCnt)
    
    SetSpawnDelay(10.0, 0.25)
    ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ME5\\fel1.lvl", "fel1_siege")
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ME5\\artillery.lvl")
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\minimap.lvl;fel1")
    SetDenseEnvironment("false")
    SetAIViewMultiplier(0.65)
    --AddDeathRegion("Sarlac01")

    --  Birdies
    SetNumBirdTypes(1)
    SetBirdType(0,1.0,"bird")
    

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
		Music05()
	end
	
	OpenAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_s_FEL_Streaming.lvl",  "fel1")
	
	SoundFX()
	
	
	
    --  Camera Stats
    AddCameraShot(0.896307, -0.171348, -0.401716, -0.076796, -116.306931, 31.039505, 20.757469)
    AddCameraShot(0.909343, -0.201967, -0.355083, -0.078865, -116.306931, 31.039505, 20.757469)
    AddCameraShot(0.543199, 0.115521, -0.813428, 0.172990, -108.378189, 13.564240, -40.644150)
    AddCameraShot(0.970610, 0.135659, 0.196866, -0.027515, -3.214346, 11.924586, -44.687294)
    AddCameraShot(0.346130, 0.046311, -0.928766, 0.124267, 87.431061, 20.881388, 13.070729)
    AddCameraShot(0.468084, 0.095611, -0.860724, 0.175812, 18.063482, 19.360580, 18.178158)
	
	PostLoadStuff()
end
