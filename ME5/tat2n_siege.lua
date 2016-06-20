ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\master.lvl")
RandomSide = math.random(1,4)
--DecideShepClass = math.random(1,6)
--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--
ScriptCB_DoFile("ME5_Master")
ScriptCB_DoFile("ME5_setup_teams")
ScriptCB_DoFile("ME5_ObjectiveBFConquest")

mapSize = lg
EnvironmentType = 1
onlineSideVar = SSVxCOL
onlineHeroSSV = shep_adept
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
			herosupport:AddSpawnCP("team1_permacp","CP1_SpawnPath")
			herosupport:AddSpawnCP("cp2","CP2_SpawnPath")
			herosupport:AddSpawnCP("cp3","CP3_SpawnPath")
			herosupport:AddSpawnCP("team2_permacp","CP6_SpawnPath")
			herosupport:AddSpawnCP("cp7","CP9SpawnPath")
			herosupport:AddSpawnCP("cp8","CP8SpawnPath")
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
			herosupport:AddSpawnCP("team1_permacp","CP1_SpawnPath")
			herosupport:AddSpawnCP("cp2","CP2_SpawnPath")
			herosupport:AddSpawnCP("cp3","CP3_SpawnPath")
			herosupport:AddSpawnCP("team2_permacp","CP6_SpawnPath")
			herosupport:AddSpawnCP("cp7","CP9SpawnPath")
			herosupport:AddSpawnCP("cp8","CP8SpawnPath")
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
			herosupport:AddSpawnCP("team1_permacp","CP1_SpawnPath")
			herosupport:AddSpawnCP("cp2","CP2_SpawnPath")
			herosupport:AddSpawnCP("cp3","CP3_SpawnPath")
			herosupport:AddSpawnCP("team2_permacp","CP6_SpawnPath")
			herosupport:AddSpawnCP("cp7","CP9SpawnPath")
			herosupport:AddSpawnCP("cp8","CP8SpawnPath")
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
			herosupport:AddSpawnCP("team1_permacp","CP1_SpawnPath")
			herosupport:AddSpawnCP("cp2","CP2_SpawnPath")
			herosupport:AddSpawnCP("cp3","CP3_SpawnPath")
			herosupport:AddSpawnCP("team2_permacp","CP6_SpawnPath")
			herosupport:AddSpawnCP("cp7","CP9SpawnPath")
			herosupport:AddSpawnCP("cp8","CP8SpawnPath")
			herosupport:Start()
		end
	end
end

function ScriptPostLoad()
	SetObjectTeam("CP2", 0)
	SetObjectTeam("CP3", 0)
	SetObjectTeam("CP7", 0)
	SetObjectTeam("CP8", 0)
	KillObject("CP1")	-- team 1
	KillObject("CP6")	-- team 2
	
        --This defines the CPs.  These need to happen first
    --cp1 = CommandPost:New{name = "cp1"}
    cp2 = CommandPost:New{name = "cp2"}
    cp3 = CommandPost:New{name = "cp3"}

	--cp6 = CommandPost:New{name = "cp6"}
	cp7 = CommandPost:New{name = "cp7"}
	cp8 = CommandPost:New{name = "cp8"}

    
    --This sets up the actual objective.  This needs to happen after cp's are defined
    conquest = ObjectiveConquest:New{teamATT = ATT, teamDEF = DEF, textATT = "game.modes.siege", textDEF = "game.modes.siege2", multiplayerRules = true}
    
    --This adds the CPs to the objective.  This needs to happen after the objective is set up
	--conquest:AddCommandPost(cp1)
	conquest:AddCommandPost(cp2)
	conquest:AddCommandPost(cp3)

	--conquest:AddCommandPost(cp6)
	conquest:AddCommandPost(cp7)
	conquest:AddCommandPost(cp8)
	
	--[[if RandomSide < 4 then
		-- This sets up the AI hero script
		if not ScriptCB_InMultiplayer() then   
			herosupport = AIHeroSupport:New{AIATTHeroHealth = 3500,	gameMode = "NonConquest",}
			herosupport:SetHeroClass(REP, "ssv_hero_shepard")
			herosupport:AddSpawnCP("cp1","CP1_SpawnPath")
			herosupport:AddSpawnCP("cp2","CP2_SpawnPath")
			herosupport:AddSpawnCP("cp3","CP3_SpawnPath")
			herosupport:AddSpawnCP("cp6","CP6_SpawnPath")
			herosupport:AddSpawnCP("cp7","CP9SpawnPath")
			herosupport:AddSpawnCP("cp8","CP8SpawnPath")
			herosupport:Start()
			else
		end
	end]]
	
	SetProperty("team1_permacp", "AllyPath", "CP1_SpawnPath")
	SetProperty("cp2", "AllyPath", "CP2_SpawnPath")
	SetProperty("cp3", "AllyPath", "CP3_SpawnPath")
	SetProperty("team2_permacp", "AllyPath", "CP6_SpawnPath")
	SetProperty("cp7", "AllyPath", "CP9SpawnPath")
	SetProperty("cp8", "AllyPath", "CP8SpawnPath")
	
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
		end
	else
		SSVxCOL_PostLoad()
	end
	
	SetReinforcementCount(REP, 400)
	SetReinforcementCount(CIS, 400)
	
	CP1Node = GetPathPoint("CP1_SpawnPath", 0) --gets the path point
	CP2Node = GetPathPoint("CP2_SpawnPath", 0)
	--CP3Node = GetPathPoint("CP3_SpawnPath", 0)
	CP6Node = GetPathPoint("CP6_SpawnPath", 0)
	CP7Node = GetPathPoint("CP9SpawnPath", 0)
	CP8Node = GetPathPoint("CP8SpawnPath", 0)
	
	--[[CreateTimer("artGameTimer")
	SetTimerValue("artGameTimer", 720)
	StartTimer("artGameTimer")
	OnTimerElapse(
		function(timer)]]
			--local team1pts = GetReinforcementCount(1)
			--if team1pts >= 100 then
				artMatrices = { CP1Node, CP2Node, CP6Node, CP7Node, CP8Node }
				goingthroughturrets = 0
				
				artInitTimer = CreateTimer("artInitTimer")
				SetTimerValue("artInitTimer", 20.0)
				StartTimer("artInitTimer")
				--ShowTimer("artInitTimer")
				OnTimerElapse(
					function(timer)
						goingthroughturrets = goingthroughturrets + 1
						if goingthroughturrets == 6 then
							goingthroughturrets = 1
						end
						
						SetEntityMatrix( "artillery1", artMatrices[goingthroughturrets])
						--ShowMessageText("level.common.events.surv.artillery.msg"..goingthroughturrets)
							print("tat2n_siege: Artillery transitioning to matrix: "..goingthroughturrets)
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
	
conquest:Start()
  AddAIGoal(1, "conquest", 100)
 AddAIGoal(2, "conquest", 100)
 --AddAIGoal(3, "conquest", 1000)
EnableSPHeroRules()    

KillObject("jawa_cp")
	
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
    -- Designers, these two lines *MUST* be first!
    StealArtistHeap(256*1024)
    SetPS2ModelMemory(2097152 + 65536 * 10)
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\Load\\load.lvl;tat2")
	
	SetMemoryPoolSize("ParticleTransformer::ColorTrans", 2541)
	SetMemoryPoolSize("ParticleTransformer::PositionTr", 1494)
	SetMemoryPoolSize("ParticleTransformer::SizeTransf", 1645)
	
	PreLoadStuff()
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ME5\\artillery_dirt.lvl")
	
    SetMaxFlyHeight(40)
	SetMaxPlayerFlyHeight(40)
	AISnipeSuitabilityDist(80)
	SetAttackerSnipeRange(100)
	SetDefenderSnipeRange(140)
	
	SetAIVehicleNotifyRadius(7)
    
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\me5tur.lvl",
					"tur_bldg_laser",
					"tur_bldg_mturret",
					"tur_bldg_tat_barge")
	
	Init_SideSetup()
	
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_TAT2_Streaming.lvl")
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_s_TAT_Streaming.lvl;tat2n")

    --  Level Stats
    ClearWalkers()
    AddWalkerType(0, 0) -- special -> droidekas
    AddWalkerType(1, 0) -- 1x2 (1 pair of legs)
    AddWalkerType(2, 0) -- 2x2 (2 pairs of legs)
    AddWalkerType(3, 0) -- 3x2 (3 pairs of legs)
    
    local weaponCnt = 230
    SetMemoryPoolSize("Aimer", 23)
    SetMemoryPoolSize("AmmoCounter", weaponCnt)
    SetMemoryPoolSize("BaseHint", 379)
    SetMemoryPoolSize("EnergyBar", weaponCnt)
    SetMemoryPoolSize("EntityCloth", 19)
	SetMemoryPoolSize("EntityFlyer", 6) -- to account for rocket upgrade
    SetMemoryPoolSize("EntityHover", 1)
    SetMemoryPoolSize("EntitySoundStream", 12)
    SetMemoryPoolSize("EntitySoundStatic", 43)
	SetMemoryPoolSize("FlagItem", 512)
    SetMemoryPoolSize("MountedTurret", 20)
    SetMemoryPoolSize("Navigator", 50)
    SetMemoryPoolSize("Obstacle", 788)
    SetMemoryPoolSize("PathFollower", 50)
    SetMemoryPoolSize("PathNode", 256)
	SetMemoryPoolSize("SoldierAnimation", 382)
    SetMemoryPoolSize("TreeGridStack", 325)
    SetMemoryPoolSize("UnitAgent", 50)
    SetMemoryPoolSize("UnitController", 50)
    SetMemoryPoolSize("Weapon", weaponCnt)

    SetSpawnDelay(10.0, 0.25)
    ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ME5\\tat2.lvl", "tat2_siege")
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ME5\\artillery.lvl")
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\minimap.lvl;tat2")
    SetDenseEnvironment("false")


    --  Sound Stats
    
    OpenAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\Sound\\SFL_TAT2_Streaming.lvl",  "TAT_ambiance")

	if not ScriptCB_InMultiplayer() then
		if ME5_SideVar == 0 then
			if RandomSide == 1 then
				Music01()
			elseif RandomSide == 2 then
				Music05()
			elseif RandomSide == 3 then
				Music09()
			elseif RandomSide == 4 then
				Music09()
			end
		elseif ME5_SideVar == 1 then
			Music01()
		elseif ME5_SideVar == 2 then
			Music05()
		elseif ME5_SideVar == 3	then
			Music09()
		elseif ME5_SideVar == 4	then
			Music09()
		end
	else
		Music05()
	end
	
	OpenAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_s_TAT_Streaming.lvl",  "tat2")
	
	SoundFX()


    SetAttackingTeam(ATT)

    --  Camera Stats
    --Tat2 Mos Eisley
	AddCameraShot(0.974338, -0.222180, 0.035172, 0.008020, -82.664650, 23.668301, 43.955681);
	AddCameraShot(0.390197, -0.089729, -0.893040, -0.205362, 23.563562, 12.914885, -101.465561);
	AddCameraShot(0.169759, 0.002225, -0.985398, 0.012916, 126.972809, 4.039628, -22.020613);
	AddCameraShot(0.677453, -0.041535, 0.733016, 0.044942, 97.517807, 4.039628, 36.853477);
	AddCameraShot(0.866029, -0.156506, 0.467299, 0.084449, 7.685640, 7.130688, -10.895234);
	
	PostLoadStuff()
end


