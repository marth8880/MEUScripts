ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\master.lvl")
if not ScriptCB_InMultiplayer() then
	RandomLayout = math.random(1,2)
else end
RandomSide = math.random(1,4)

isModMap = 1
--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- load the gametype script
ScriptCB_DoFile("ME5_Master")
ScriptCB_DoFile("ME5_setup_teams")
ScriptCB_DoFile("ME5_MapFunctions")
ScriptCB_DoFile("ME5_ObjectiveConquest")

mapSize = xs
EnvironmentType = 2
onlineSideVar = SSVxGTH
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

function SSVxGTH_PostLoad()
	if not ScriptCB_InMultiplayer() then
		if RandomLayout == 1 then
			DecideSSVHeroClass()
			DecideGTHHeroClass()
			if ME5_AIHeroes == 0 then
				SetHeroClass(REP, SSVHeroClass)
				SetHeroClass(CIS, GTHHeroClass)
			elseif ME5_AIHeroes == 1 then
				herosupport = AIHeroSupport:New{AIATTHeroHealth = 3000, AIDEFHeroHealth = 3000, gameMode = "NonConquest",}
				herosupport:SetHeroClass(REP, SSVHeroClass)
				herosupport:SetHeroClass(CIS, GTHHeroClass)
				herosupport:AddSpawnCP("cp1_1","cp1_spawn1")
				herosupport:AddSpawnCP("cp2_1","cp2_spawn1")
				herosupport:AddSpawnCP("cp3_1","cp3_spawn1")
				herosupport:AddSpawnCP("cp4_1","cp4_spawn1")
				herosupport:AddSpawnCP("cp5_1","cp5_spawn1")
				herosupport:AddSpawnCP("cp6_1","cp6_spawn1")
				herosupport:Start()
			else end
		elseif RandomLayout == 2 then
			DecideSSVHeroClass()
			DecideGTHHeroClass()
			if ME5_AIHeroes == 0 then
				SetHeroClass(REP, SSVHeroClass)
				SetHeroClass(CIS, GTHHeroClass)
			elseif ME5_AIHeroes == 1 then
				herosupport = AIHeroSupport:New{AIATTHeroHealth = 3000, AIDEFHeroHealth = 3000, gameMode = "NonConquest",}
				herosupport:SetHeroClass(REP, SSVHeroClass)
				herosupport:SetHeroClass(CIS, GTHHeroClass)
				herosupport:AddSpawnCP("cp1_2","cp1_spawn2")
				herosupport:AddSpawnCP("cp2_2","cp2_spawn2")
				herosupport:AddSpawnCP("cp3_2","cp3_spawn2")
				herosupport:AddSpawnCP("cp4_2","cp4_spawn2")
				herosupport:AddSpawnCP("cp5_2","cp5_spawn2")
				herosupport:AddSpawnCP("cp6_2","cp6_spawn2")
				herosupport:Start()
			else end
		end
	else
	end
end

function SSVxCOL_PostLoad()
	if not ScriptCB_InMultiplayer() then
		if RandomLayout == 1 then
			DecideSSVHeroClass()
			DecideCOLHeroClass()
			if ME5_AIHeroes == 0 then
				SetHeroClass(REP, SSVHeroClass)
				SetHeroClass(CIS, COLHeroClass)
			elseif ME5_AIHeroes == 1 then
				herosupport = AIHeroSupport:New{AIATTHeroHealth = 3000, AIDEFHeroHealth = 3000, gameMode = "NonConquest",}
				herosupport:SetHeroClass(REP, SSVHeroClass)
				herosupport:SetHeroClass(CIS, COLHeroClass)
				herosupport:AddSpawnCP("cp1_1","cp1_spawn1")
				herosupport:AddSpawnCP("cp2_1","cp2_spawn1")
				herosupport:AddSpawnCP("cp3_1","cp3_spawn1")
				herosupport:AddSpawnCP("cp4_1","cp4_spawn1")
				herosupport:AddSpawnCP("cp5_1","cp5_spawn1")
				herosupport:AddSpawnCP("cp6_1","cp6_spawn1")
				herosupport:Start()
			else end
		elseif RandomLayout == 2 then
			DecideSSVHeroClass()
			DecideCOLHeroClass()
			if ME5_AIHeroes == 0 then
				SetHeroClass(REP, SSVHeroClass)
				SetHeroClass(CIS, COLHeroClass)
			elseif ME5_AIHeroes == 1 then
				herosupport = AIHeroSupport:New{AIATTHeroHealth = 3000, AIDEFHeroHealth = 3000, gameMode = "NonConquest",}
				herosupport:SetHeroClass(REP, SSVHeroClass)
				herosupport:SetHeroClass(CIS, COLHeroClass)
				herosupport:AddSpawnCP("cp1_2","cp1_spawn2")
				herosupport:AddSpawnCP("cp2_2","cp2_spawn2")
				herosupport:AddSpawnCP("cp3_2","cp3_spawn2")
				herosupport:AddSpawnCP("cp4_2","cp4_spawn2")
				herosupport:AddSpawnCP("cp5_2","cp5_spawn2")
				herosupport:AddSpawnCP("cp6_2","cp6_spawn2")
				herosupport:Start()
			else end
		end
	else
	end
end

function EVGxGTH_PostLoad()
	if not ScriptCB_InMultiplayer() then
		if RandomLayout == 1 then
			DecideEVGHeroClass()
			DecideGTHHeroClass()
			if ME5_AIHeroes == 0 then
				SetHeroClass(REP, EVGHeroClass)
				SetHeroClass(CIS, GTHHeroClass)
			elseif ME5_AIHeroes == 1 then
				herosupport = AIHeroSupport:New{AIATTHeroHealth = 3000, AIDEFHeroHealth = 3000, gameMode = "NonConquest",}
				herosupport:SetHeroClass(REP, EVGHeroClass)
				herosupport:SetHeroClass(CIS, GTHHeroClass)
				herosupport:AddSpawnCP("cp1_1","cp1_spawn1")
				herosupport:AddSpawnCP("cp2_1","cp2_spawn1")
				herosupport:AddSpawnCP("cp3_1","cp3_spawn1")
				herosupport:AddSpawnCP("cp4_1","cp4_spawn1")
				herosupport:AddSpawnCP("cp5_1","cp5_spawn1")
				herosupport:AddSpawnCP("cp6_1","cp6_spawn1")
				herosupport:Start()
			else end
		elseif RandomLayout == 2 then
			DecideEVGHeroClass()
			DecideGTHHeroClass()
			if ME5_AIHeroes == 0 then
				SetHeroClass(REP, EVGHeroClass)
				SetHeroClass(CIS, GTHHeroClass)
			elseif ME5_AIHeroes == 1 then
				herosupport = AIHeroSupport:New{AIATTHeroHealth = 3000, AIDEFHeroHealth = 3000, gameMode = "NonConquest",}
				herosupport:SetHeroClass(REP, EVGHeroClass)
				herosupport:SetHeroClass(CIS, GTHHeroClass)
				herosupport:AddSpawnCP("cp1_2","cp1_spawn2")
				herosupport:AddSpawnCP("cp2_2","cp2_spawn2")
				herosupport:AddSpawnCP("cp3_2","cp3_spawn2")
				herosupport:AddSpawnCP("cp4_2","cp4_spawn2")
				herosupport:AddSpawnCP("cp5_2","cp5_spawn2")
				herosupport:AddSpawnCP("cp6_2","cp6_spawn2")
				herosupport:Start()
			else end
		end
	else
	end
end

function EVGxCOL_PostLoad()
	if not ScriptCB_InMultiplayer() then
		if RandomLayout == 1 then
			DecideEVGHeroClass()
			DecideCOLHeroClass()
			if ME5_AIHeroes == 0 then
				SetHeroClass(REP, EVGHeroClass)
				SetHeroClass(CIS, COLHeroClass)
			elseif ME5_AIHeroes == 1 then
				herosupport = AIHeroSupport:New{AIATTHeroHealth = 3000, AIDEFHeroHealth = 3000, gameMode = "NonConquest",}
				herosupport:SetHeroClass(REP, EVGHeroClass)
				herosupport:SetHeroClass(CIS, COLHeroClass)
				herosupport:AddSpawnCP("cp1_1","cp1_spawn1")
				herosupport:AddSpawnCP("cp2_1","cp2_spawn1")
				herosupport:AddSpawnCP("cp3_1","cp3_spawn1")
				herosupport:AddSpawnCP("cp4_1","cp4_spawn1")
				herosupport:AddSpawnCP("cp5_1","cp5_spawn1")
				herosupport:AddSpawnCP("cp6_1","cp6_spawn1")
				herosupport:Start()
			else end
		elseif RandomLayout == 2 then
			DecideEVGHeroClass()
			DecideCOLHeroClass()
			if ME5_AIHeroes == 0 then
				SetHeroClass(REP, EVGHeroClass)
				SetHeroClass(CIS, COLHeroClass)
			elseif ME5_AIHeroes == 1 then
				herosupport = AIHeroSupport:New{AIATTHeroHealth = 3000, AIDEFHeroHealth = 3000, gameMode = "NonConquest",}
				herosupport:SetHeroClass(REP, EVGHeroClass)
				herosupport:SetHeroClass(CIS, COLHeroClass)
				herosupport:AddSpawnCP("cp1_2","cp1_spawn2")
				herosupport:AddSpawnCP("cp2_2","cp2_spawn2")
				herosupport:AddSpawnCP("cp3_2","cp3_spawn2")
				herosupport:AddSpawnCP("cp4_2","cp4_spawn2")
				herosupport:AddSpawnCP("cp5_2","cp5_spawn2")
				herosupport:AddSpawnCP("cp6_2","cp6_spawn2")
				herosupport:Start()
			else end
		end
	else
	end
end

	
	
function ScriptPostLoad()	   
	
	if not ScriptCB_InMultiplayer() then
		--This defines the CPs.  These need to happen first
		if RandomLayout == 1 then
			--[[KillObject("cp1_2")
			KillObject("cp2_2")
			KillObject("cp3_2")
			KillObject("cp4_2")
			KillObject("cp5_2")
			KillObject("cp6_2")]]
			
			--VRM_DisablePlanningGraphArcs1()
			VRM_DisableBarriers1()
			
			cp1 = CommandPost:New{name = "cp1_1"}
			cp2 = CommandPost:New{name = "cp2_1"}
			cp3 = CommandPost:New{name = "cp3_1"}
			cp4 = CommandPost:New{name = "cp4_1"}
			cp5 = CommandPost:New{name = "cp5_1"}
			cp6 = CommandPost:New{name = "cp6_1"}
			
			SetProperty("cp1_1", "AllyPath", "cp1_spawn1")
			SetProperty("cp2_1", "AllyPath", "cp2_spawn1")
			SetProperty("cp3_1", "AllyPath", "cp3_spawn1")
			SetProperty("cp4_1", "AllyPath", "cp4_spawn1")
			SetProperty("cp5_1", "AllyPath", "cp5_spawn1")
			SetProperty("cp6_1", "AllyPath", "cp6_spawn1")
			
		elseif RandomLayout == 2 then
			--[[KillObject("cp1_1")
			KillObject("cp2_1")
			KillObject("cp3_1")
			KillObject("cp4_1")
			KillObject("cp5_1")
			KillObject("cp6_1")]]
			
			--VRM_DisablePlanningGraphArcs2()
			VRM_DisableBarriers2()
			
			cp1 = CommandPost:New{name = "cp1_2"}
			cp2 = CommandPost:New{name = "cp2_2"}
			cp3 = CommandPost:New{name = "cp3_2"}
			cp4 = CommandPost:New{name = "cp4_2"}
			cp5 = CommandPost:New{name = "cp5_2"}
			cp6 = CommandPost:New{name = "cp6_2"}
			
			SetProperty("cp1_2", "AllyPath", "cp1_spawn2")
			SetProperty("cp2_2", "AllyPath", "cp2_spawn2")
			SetProperty("cp3_2", "AllyPath", "cp3_spawn2")
			SetProperty("cp4_2", "AllyPath", "cp4_spawn2")
			SetProperty("cp5_2", "AllyPath", "cp5_spawn2")
			SetProperty("cp6_2", "AllyPath", "cp6_spawn2")
			
		end
	else
		--[[KillObject("cp1_2")
		KillObject("cp2_2")
		KillObject("cp3_2")
		KillObject("cp4_2")
		KillObject("cp5_2")
		KillObject("cp6_2")]]
		
		VRM_DisableBarriers1()
		
		cp1 = CommandPost:New{name = "cp1_1"}
		cp2 = CommandPost:New{name = "cp2_1"}
		cp3 = CommandPost:New{name = "cp3_1"}
		cp4 = CommandPost:New{name = "cp4_1"}
		cp5 = CommandPost:New{name = "cp5_1"}
		cp6 = CommandPost:New{name = "cp6_1"}
			
		SetProperty("cp1_1", "AllyPath", "cp1_spawn1")
		SetProperty("cp2_1", "AllyPath", "cp2_spawn1")
		SetProperty("cp3_1", "AllyPath", "cp3_spawn1")
		SetProperty("cp4_1", "AllyPath", "cp4_spawn1")
		SetProperty("cp5_1", "AllyPath", "cp5_spawn1")
		SetProperty("cp6_1", "AllyPath", "cp6_spawn1")
	end
	
	
    --This sets up the actual objective.  This needs to happen after cp's are defined
    conquest = ObjectiveConquest:New{teamATT = ATT, teamDEF = DEF, 
                                     textATT = "game.modes.con", textDEF = "game.modes.con2", 
                                     
                                     multiplayerRules = true}
    
    --This adds the CPs to the objective.  This needs to happen after the objective is set up
    conquest:AddCommandPost(cp1)
    conquest:AddCommandPost(cp2)
    conquest:AddCommandPost(cp3)
	conquest:AddCommandPost(cp4)
	conquest:AddCommandPost(cp5)
	conquest:AddCommandPost(cp6)
    
    conquest:Start()

    EnableSPHeroRules()
	
	ClearAIGoals(1)
	ClearAIGoals(2)
	AddAIGoal(1, "Conquest", 100)
	AddAIGoal(2, "Conquest", 100)
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
	
	PostLoadStuff()
	
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
    
	if not ScriptCB_InMultiplayer() then
		if RandomLayout == 1 then
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\Load\\vrm1.lvl")
			
			SetMaxFlyHeight(18)
			SetMaxPlayerFlyHeight(18)
		elseif RandomLayout == 2 then
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\Load\\vrm2.lvl")
			
			SetMaxFlyHeight(12)
			SetMaxPlayerFlyHeight(12)
		end
	else
		ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\Load\\vrm1.lvl")
		
		SetMaxFlyHeight(18)
		SetMaxPlayerFlyHeight(18)
	end
	
	AISnipeSuitabilityDist(80)
	SetAttackerSnipeRange(60)
	SetDefenderSnipeRange(85)
	
	SetMemoryPoolSize("ParticleTransformer::ColorTrans", 2574)
	SetMemoryPoolSize("ParticleTransformer::PositionTr", 1513)
	SetMemoryPoolSize("ParticleTransformer::SizeTransf", 1659)
	
	PreLoadStuff()
	
	Init_SideSetup()
	
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_VRM_Streaming.lvl")
	
    --  Level Stats
	ClearWalkers()
    local weaponCnt = 1024
    SetMemoryPoolSize("Aimer", 128)
    SetMemoryPoolSize("AmmoCounter", weaponCnt)
    SetMemoryPoolSize("BaseHint", 1024)
    SetMemoryPoolSize("EnergyBar", weaponCnt)
    SetMemoryPoolSize("EntityHover", 32)
    SetMemoryPoolSize("EntityLight", 200)
    SetMemoryPoolSize("EntitySoundStatic", 64)
	SetMemoryPoolSize("FlagItem", 512)
    --SetMemoryPoolSize("FLEffectObject::OffsetMatrix", 128)
    SetMemoryPoolSize("MountedTurret", 32)
	SetMemoryPoolSize("Music", 99)
	SetMemoryPoolSize("Navigator", 128)
    SetMemoryPoolSize("Obstacle", 1024)
	SetMemoryPoolSize("PathFollower", 128)
	SetMemoryPoolSize("PathNode", 1024)
	SetMemoryPoolSize("RedOmniLight", 213)
	SetMemoryPoolSize("SoldierAnimation", 414)
    SetMemoryPoolSize("SoundSpaceRegion", 64)
    SetMemoryPoolSize("TreeGridStack", 1024)
	SetMemoryPoolSize("UnitAgent", 128)
	SetMemoryPoolSize("UnitController", 128)
	SetMemoryPoolSize("Weapon", weaponCnt)
    
    SetSpawnDelay(10.0, 0.25)
    --ReadDataFile("dc:VRM\\VRM.lvl", "VRM_conquest")
	if not ScriptCB_InMultiplayer() then
		if RandomLayout == 1 then
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ME5\\VRM.lvl", "VRM_conquest1")
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ME5\\VRM_CONGRAPH_1.lvl")
			SetAIViewMultiplier(0.82)
		elseif RandomLayout == 2 then
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ME5\\VRM.lvl", "VRM_conquest2")
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ME5\\VRM_CONGRAPH_2.lvl")
			SetAIViewMultiplier(0.6)
		end
	else
		ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ME5\\VRM.lvl", "VRM_conquest1")
		ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ME5\\VRM_CONGRAPH_1.lvl")
		SetAIViewMultiplier(0.82)
	end
	
	SetDenseEnvironment("true")
	
	
    --  Sound
	
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
	
	OpenAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_VRM_Streaming.lvl",  "VRM_ambiance")
	--OpenAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_VRM_Streaming.lvl",  "VRM_ambiance")
	
	SoundFX()


--OpeningSatelliteShot
	if not ScriptCB_InMultiplayer() then
		if RandomLayout == 1 then
			AddCameraShot(0.993154, -0.116802, 0.001835, 0.000216, -143.903946, 12.305380, 101.522842);
			AddCameraShot(0.707762, -0.112961, -0.688645, -0.109910, -161.605255, 14.998523, 18.431583);
			AddCameraShot(0.222791, -0.008352, -0.974146, -0.036519, -183.190247, 9.291689, 59.143932);
			AddCameraShot(-0.154474, 0.007898, -0.986676, -0.050449, -110.086807, 9.291689, 44.245838);
			AddCameraShot(-0.000125, 0.000012, -0.995739, -0.092222, -143.904007, 12.051621, 3.480039);
			AddCameraShot(-0.000125, 0.000012, -0.995739, -0.092222, -143.920197, 12.051621, 69.605141);
		elseif RandomLayout == 2 then	
			AddCameraShot(0.990136, -0.140112, -0.000468, -0.000066, -143.856201, 3.635850, 101.018425);
			AddCameraShot(0.772870, -0.045845, -0.631796, -0.037476, -190.944290, 3.486598, 87.565483);
			AddCameraShot(0.690405, -0.032545, 0.721889, 0.034029, -101.443878, 3.486598, 74.323532);
			AddCameraShot(-0.185411, -0.002115, -0.982595, 0.011208, -139.876694, 1.589272, 4.779917);
			AddCameraShot(-0.001765, 0.000128, -0.997398, -0.072065, -144.066025, 3.884599, 44.273586);
		end
	else
		AddCameraShot(0.993154, -0.116802, 0.001835, 0.000216, -143.903946, 12.305380, 101.522842);
		AddCameraShot(0.707762, -0.112961, -0.688645, -0.109910, -161.605255, 14.998523, 18.431583);
		AddCameraShot(0.222791, -0.008352, -0.974146, -0.036519, -183.190247, 9.291689, 59.143932);
		AddCameraShot(-0.154474, 0.007898, -0.986676, -0.050449, -110.086807, 9.291689, 44.245838);
		AddCameraShot(-0.000125, 0.000012, -0.995739, -0.092222, -143.904007, 12.051621, 3.480039);
		AddCameraShot(-0.000125, 0.000012, -0.995739, -0.092222, -143.920197, 12.051621, 69.605141);
	end
end
