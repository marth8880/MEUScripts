ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\master.lvl")
RandomSide = math.random(1,4)

isModMap = 1
--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- load the gametype script
-- ScriptCB_DoFile("ME5_ObjectiveTDM")
ScriptCB_DoFile("ME5_Master")
ScriptCB_DoFile("ME5_setup_teams")
ScriptCB_DoFile("ME5_ObjectiveConquest")

mapSize = xs
EnvironmentType = 4
onlineSideVar = SSVxGTH
onlineHeroSSV = shep_vanguard
onlineHeroGTH = gethprime_me2
onlineHeroCOL = colgeneral
onlineHeroEVG = gethprime_me3
isTDM = true
	
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
	end
end

function SSVxCOL_PostLoad()
	if not ScriptCB_InMultiplayer() then
		DecideSSVHeroClass()
		DecideCOLHeroClass()
	end
end

function EVGxGTH_PostLoad()
	if not ScriptCB_InMultiplayer() then
		DecideEVGHeroClass()
		DecideGTHHeroClass()
	end
end

function EVGxCOL_PostLoad()
	if not ScriptCB_InMultiplayer() then
		DecideEVGHeroClass()
		DecideCOLHeroClass()
	end
end

function ScriptPostLoad()
	
	--AllowAISpawn(REP, false)
	--AllowAISpawn(CIS, false)
    
    
    --This defines the CPs.  These need to happen first
    cp1 = CommandPost:New{name = "cp1_tdm"}
    cp2 = CommandPost:New{name = "cp2_tdm"}
    
    
    
    --This sets up the actual objective.  This needs to happen after cp's are defined
    conquest = ObjectiveConquest:New{teamATT = ATT, teamDEF = DEF, 
                                     textATT = "game.modes.tdm", textDEF = "game.modes.tdm2", 
                                     multiplayerRules = true}
    
    --This adds the CPs to the objective.  This needs to happen after the objective is set up
    -- conquest:AddCommandPost(cp1)
    -- conquest:AddCommandPost(cp2)
    
    conquest:Start()
	
    EnableSPHeroRules()
	
	-- This is the actual objective setup
	--[[TDM = ObjectiveTDM:New{teamATT = 1, teamDEF = 2, 
						multiplayerScoreLimit = 100,
						textATT = "game.modes.tdm", textDEF = "game.modes.tdm2",
						 multiplayerRules = true, isCelebrityDeathmatch = true}
	TDM:Start()]]
	
	SetProperty("cp1_tdm", "AllyPath", "cp1_tdm_spawn")
	SetProperty("cp2_tdm", "AllyPath", "cp2_tdm_spawn")
	
	ClearAIGoals(1)
	ClearAIGoals(2)
	AddAIGoal(1, "Deathmatch", 100)
	AddAIGoal(2, "Deathmatch", 100)
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
		SSVxGTH_PostLoad()
	end
    
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
    
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\Load\\pro.lvl")
	
	SetMemoryPoolSize("ParticleTransformer::ColorTrans", 2188)
	SetMemoryPoolSize("ParticleTransformer::PositionTr", 1293)
	SetMemoryPoolSize("ParticleTransformer::SizeTransf", 1409)
	
	PreLoadStuff()
   
    SetMaxFlyHeight(16)
    SetMaxPlayerFlyHeight(16)
	AISnipeSuitabilityDist(55)
	SetAttackerSnipeRange(75)
	SetDefenderSnipeRange(100)
    
    --[[SetMemoryPoolSize ("Combo",50)              -- should be ~ 2x number of jedi classes
    SetMemoryPoolSize ("Combo::State",650)      -- should be ~12x #Combo
    SetMemoryPoolSize ("Combo::Transition",650) -- should be a bit bigger than #Combo::State
    SetMemoryPoolSize ("Combo::Condition",650)  -- should be a bit bigger than #Combo::State
    SetMemoryPoolSize ("Combo::Attack",550)     -- should be ~8-12x #Combo
    SetMemoryPoolSize ("Combo::DamageSample",6000)  -- should be ~8-12x #Combo::Attack
    SetMemoryPoolSize ("Combo::Deflect",100)     -- should be ~1x #combo  ]]
    
	Init_SideSetup()
	
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_PRO_Streaming.lvl")
	
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
	SetMemoryPoolSize("EntityCloth", 0)
	SetMemoryPoolSize("EntityFlyer", 32)
    SetMemoryPoolSize("EntityHover", 32)
    SetMemoryPoolSize("EntityLight", 200)
    SetMemoryPoolSize("EntitySoundStream", 16)
    SetMemoryPoolSize("EntitySoundStatic", 32)
	SetMemoryPoolSize("FlagItem", 512)
    SetMemoryPoolSize("FLEffectObject::OffsetMatrix", 87)
    SetMemoryPoolSize("MountedTurret", 32)
    SetMemoryPoolSize("Music", 89)
	SetMemoryPoolSize("Navigator", 128)
    SetMemoryPoolSize("Obstacle", 1024)
	SetMemoryPoolSize("PathNode", 1024)
	SetMemoryPoolSize("SoldierAnimation", 348)
    SetMemoryPoolSize("SoundSpaceRegion", 64)
    SetMemoryPoolSize("TreeGridStack", 1024)
	SetMemoryPoolSize("UnitAgent", 128)
	SetMemoryPoolSize("UnitController", 128)
	SetMemoryPoolSize("Weapon", weaponCnt)
    
    SetSpawnDelay(10.0, 0.25)
    --ReadDataFile("dc:PRO\\PRO.lvl", "PRO_conquest")
    ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ME5\\PRO.lvl", "PRO_tdm")
    SetDenseEnvironment("false")
	
	
    -- Sound
    
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
		end
	else
		Music03()
	end
	
	OpenAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_PRO_Streaming.lvl",  "PRO_ambiance")
	--OpenAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_PRO_Streaming.lvl",  "PRO_ambiance")

    SoundFX()


-- Opening Satellite Shots
	AddCameraShot(0.978525, -0.037464, 0.202548, 0.007755, 25.577356, 5.990258, -14.311792);		-- south corner
	AddCameraShot(-0.227115, 0.008059, -0.973222, -0.034536, 26.382149, 5.990258, -122.364380);		-- north corner
	AddCameraShot(0.013350, -0.001503, -0.993636, -0.111838, -7.550848, 2.605920, -82.578865);		-- bunker
	AddCameraShot(0.459203, 0.042688, -0.883496, 0.082130, -19.666098, 7.762414, -125.828354);		-- towers wide
	AddCameraShot(-0.428738, -0.031436, -0.900465, 0.066023, 20.310499, 2.323809, -157.813171);		-- skyway tower interior
	
	PostLoadStuff()
end

