RandomSide = math.random(1,2)
--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- load the gametype script
ScriptCB_DoFile("ObjectiveConquest")
ScriptCB_DoFile("setup_teams")
ScriptCB_DoFile("ME5_RandomSides")
	
	--  REP Attacking (attacker is always #1)
    REP = 1;
    CIS = 2;
	CD1 = 3;
    --  These variables do not change
    ATT = REP;
    DEF = CIS;
	
	--N7T = 3;


function ScriptPostLoad()	   
    
    
    --This defines the CPs.  These need to happen first
    cp1 = CommandPost:New{name = "cp1tdm"}
    cp2 = CommandPost:New{name = "cp2tdm"}
    
    
    
    --This sets up the actual objective.  This needs to happen after cp's are defined
    conquest = ObjectiveConquest:New{teamATT = ATT, teamDEF = DEF, 
                                     textATT = "game.modes.con", 
                                     textDEF = "game.modes.con2",
                                     multiplayerRules = true}
    
    --This adds the CPs to the objective.  This needs to happen after the objective is set up
    conquest:AddCommandPost(cp1)
    conquest:AddCommandPost(cp2)
    
    conquest:Start()
	
	ClearAIGoals(1)
	ClearAIGoals(2)
	--ClearAIGoals(3)
	AddAIGoal(1, "Deathmatch", 100)
	AddAIGoal(2, "Deathmatch", 100)
	--AddAIGoal(3, "Deathmatch", 100)

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
    
    ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\Load\\ME5n.lvl")
	if not ScriptCB_InMultiplayer() then
		if RandomSide == 1 then
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ingamessv.lvl")
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ingamegth.lvl")
		elseif RandomSide == 2 then
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ingamessv.lvl")
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ingamecol.lvl")
		end
	else
		ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ingamessv.lvl")
		ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ingamegth.lvl")
	end
	PreLoadStuff()
	
	AISnipeSuitabilityDist(75)
	SetDefenderSnipeRange(75)
	
	SetMaxFlyHeight(50)
	SetMaxPlayerFlyHeight (50)
    
    SetMemoryPoolSize ("ClothData",20)
    SetMemoryPoolSize ("Combo",50)              -- should be ~ 2x number of jedi classes
    SetMemoryPoolSize ("Combo::State",650)      -- should be ~12x #Combo
    SetMemoryPoolSize ("Combo::Transition",650) -- should be a bit bigger than #Combo::State
    SetMemoryPoolSize ("Combo::Condition",650)  -- should be a bit bigger than #Combo::State
    SetMemoryPoolSize ("Combo::Attack",550)     -- should be ~8-12x #Combo
    SetMemoryPoolSize ("Combo::DamageSample",6000)  -- should be ~8-12x #Combo::Attack
    SetMemoryPoolSize ("Combo::Deflect",100)     -- should be ~1x #combo  
    
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\Sound\\ME5.lvl;ME5n")
	ReadDataFile("dc:sound\\MR1.lvl;MR1cw")
    ReadDataFile("sound\\pol.lvl;pol1cw")
	--[[ReadDataFile("dc:SIDE\\all.lvl",
							 "loc_inf_sniper")]]
	ReadDataFile("dc:SIDE\\tur.lvl", 
							 "tur_bldg_tat_barge")
	
	if not ScriptCB_InMultiplayer() then
		if RandomSide == 1 then
			LoadSSV()
			LoadGTH()
			Setup_SSVxGTH_sm()
			DecideSSVHeroClass()
		elseif RandomSide == 2 then
			LoadSSV()
			LoadCOL()
			Setup_SSVxCOL_sm()
			DecideSSVHeroClass()
		end
	else
		LoadSSV()
		LoadGTH()
		Setup_SSVxGTH_sm()
		SetHeroClass(REP, "ssv_hero_shepard_engineer")
	end
	
	--[[SetTeamName(3, "locals")
	SetUnitCount(3, 2)
	AddUnitClass(3, "loc_inf_sniper", 2)
	
	SetTeamAsEnemy(1,3)
	SetTeamAsEnemy(3,1)
	SetTeamAsEnemy(2,3)
	SetTeamAsEnemy(3,2)]]
   

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
    SetMemoryPoolSize("MountedTurret", 32)
	SetMemoryPoolSize("Navigator", 128)
    SetMemoryPoolSize("Obstacle", 1024)
	SetMemoryPoolSize("PathNode", 1024)
	SetMemoryPoolSize("SoldierAnimation", 465)
    SetMemoryPoolSize("SoundSpaceRegion", 64)
    SetMemoryPoolSize("TreeGridStack", 1024)
	SetMemoryPoolSize("UnitAgent", 128)
	SetMemoryPoolSize("UnitController", 128)
	SetMemoryPoolSize("Weapon", weaponCnt)
    
    SetSpawnDelay(10.0, 0.25)
    --ReadDataFile("dc:MR1\\MR1.lvl", "MR1_conquest")
    ReadDataFile("dc:MR1\\MR1.lvl", "MR1_tdm")
    SetDenseEnvironment("false")




    --  Sound
    
    ScriptCB_EnableHeroMusic(0)
    
    OpenAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\Sound\\ME5.lvl",  "ME5n_music")
	OpenAudioStream("dc:sound\\mr1.lvl",  "mr1_music")
	OpenAudioStream("dc:sound\\mr1.lvl",  "mr1_ambiance")
    OpenAudioStream("sound\\pol.lvl",  "pol1")
    OpenAudioStream("sound\\pol.lvl",  "pol1")
	OpenAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\ME5.lvl",  "col_unit_vo_quick")

    SetAmbientMusic(REP, 1.0, "mr1_amb_earworm",  0,1)
    SetAmbientMusic(CIS, 1.0, "mr1_amb_earworm",  0,1)

	SetVictoryMusic(REP, "ssv_amb_01_victory")
	SetDefeatMusic (REP, "ssv_amb_01_defeat")
	SetVictoryMusic(CIS, "ssv_amb_01_victory")
	SetDefeatMusic (CIS, "ssv_amb_01_defeat")
	
	if not ScriptCB_InMultiplayer() then
		if RandomSide == 1 then
			SSVWorldVO()
			GTHWorldVO()
		elseif RandomSide == 2 then
			SSVWorldVO()
		end
	else
		SSVWorldVO()
		GTHWorldVO()
	end
	
	SoundFX()
	
	
--OpeningSatelliteShot
	AddCameraShot(0.860834, -0.066550, -0.503015, -0.038887, -156.444336, 26.008068, 375.989807);
	AddCameraShot(0.415989, -0.029820, -0.906554, -0.064987, -121.549095, 26.008068, 223.142822);
	AddCameraShot(-0.327677, 0.024227, -0.941908, -0.069639, 57.638302, 32.931034, 172.352127);
	AddCameraShot(0.771404, -0.020699, -0.635780, -0.017060, -86.801491, 13.656008, 306.767334);
	AddCameraShot(0.789378, -0.064580, 0.608469, 0.049779, 18.768763, 13.656008, 316.177277);

end

