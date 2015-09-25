ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\master.lvl")
isModMap = 1
--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- load the gametype script
ScriptCB_DoFile("ME5_Master")
ScriptCB_DoFile("ME5_setup_teams")
ScriptCB_DoFile("ME5_ObjectiveConquest")
	
	--  REP Attacking (attacker is always #1)
    REP = 1;
    CIS = 2;
	CD1 = 3;
    --  These variables do not change
    ATT = REP;
    DEF = CIS;


function ScriptPostLoad()	   
    
    
    --This defines the CPs.  These need to happen first
    cp1 = CommandPost:New{name = "cp1"}
    cp2 = CommandPost:New{name = "cp2"}
    
    
    --This sets up the actual objective.  This needs to happen after cp's are defined
    conquest = ObjectiveConquest:New{teamATT = ATT, teamDEF = DEF, 
                                     textATT = "game.modes.con", 
                                     textDEF = "game.modes.con2",
                                     multiplayerRules = true}
    
    --This adds the CPs to the objective.  This needs to happen after the objective is set up
    conquest:AddCommandPost(cp1)
    conquest:AddCommandPost(cp2)
    
    conquest:Start()

    EnableSPHeroRules()
	
	
end

function ScriptPreInit()
   SetWorldExtents(2500)
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
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ingamessv.lvl")
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ingamegth.lvl")
	PreLoadStuff()
    
   
    SetMinFlyHeight(-2500)
    SetMaxFlyHeight(2500)
    SetMinPlayerFlyHeight(-2500)
    SetMaxPlayerFlyHeight(2500)
    SetAIVehicleNotifyRadius(100)
    
    SetMemoryPoolSize ("ClothData",20)
    SetMemoryPoolSize ("Combo",50)              -- should be ~ 2x number of jedi classes
    SetMemoryPoolSize ("Combo::State",650)      -- should be ~12x #Combo
    SetMemoryPoolSize ("Combo::Transition",650) -- should be a bit bigger than #Combo::State
    SetMemoryPoolSize ("Combo::Condition",650)  -- should be a bit bigger than #Combo::State
    SetMemoryPoolSize ("Combo::Attack",550)     -- should be ~8-12x #Combo
    SetMemoryPoolSize ("Combo::DamageSample",6000)  -- should be ~8-12x #Combo::Attack
    SetMemoryPoolSize ("Combo::Deflect",100)     -- should be ~1x #combo      

	
	ReadDataFile("sound\\spa.lvl;spa2cw")
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\ME5.lvl;ME5n")
	ScaleSoundParameter("tur_weapons",   "MinDistance",   3.0);
	ScaleSoundParameter("tur_weapons",   "MaxDistance",   3.0);
	ScaleSoundParameter("tur_weapons",   "MuteDistance",   3.0);
	ScaleSoundParameter("Ordnance_Large",   "MinDistance",   3.0);
	ScaleSoundParameter("Ordnance_Large",   "MaxDistance",   3.0);
	ScaleSoundParameter("Ordnance_Large",   "MuteDistance",   3.0);
	ScaleSoundParameter("explosion",   "MaxDistance",   5.0);
	ScaleSoundParameter("explosion",   "MuteDistance",  5.0);
	
	ReadDataFile("SIDE\\tur.lvl",
					"tur_bldg_spa_cis_beam",
					"tur_bldg_spa_cis_chaingun",
					"tur_bldg_spa_rep_beam",
					"tur_bldg_spa_rep_chaingun",
					"tur_bldg_chaingun_roof")
	
	LoadCOL()
	LoadSSVspa()
	Setup_SSVxSUN_spa()
			print("Load/setup SSV versus SUN")
	
		-- SetHeroClass(REP, "ssv_hero_shepard")
		
    --  Level Stats
    ClearWalkers()
    local weaponCnt = 1024
    -- local guyCnt = 32
    -- local units = 72
    SetMemoryPoolSize("Aimer", 200)
    SetMemoryPoolSize("AmmoCounter", weaponCnt)
    SetMemoryPoolSize("BaseHint", 73)
    SetMemoryPoolSize("EnergyBar", weaponCnt)
    SetMemoryPoolSize("EntityCloth", 0)
    SetMemoryPoolSize("EntityDroideka",0)
    SetMemoryPoolSize("EntityDroid",0)
    SetMemoryPoolSize("EntityHover", 0)
    SetMemoryPoolSize("EntityFlyer", 48)
	SetMemoryPoolSize("EntitySoundStatic", 64)
    SetMemoryPoolSize("EntitySoundStream", 16)
    SetMemoryPoolSize("ParticleTransformer::SizeTransf", 1500)
    SetMemoryPoolSize("ParticleTransformer::ColorTrans" , 1784)
    SetMemoryPoolSize("ParticleTransformer::PositionTr", 1500)
    SetMemoryPoolSize("EntityLight", 100)
    SetMemoryPoolSize("EntityRemoteTerminal", 12)
    SetMemoryPoolSize("EntitySoldier",128)
    SetMemoryPoolSize("SoldierAnimation", 336)
    SetMemoryPoolSize("FLEffectObject::OffsetMatrix", 120)
    SetMemoryPoolSize("MountedTurret", 70)
    SetMemoryPoolSize("Navigator", 128)
    SetMemoryPoolSize("Obstacle", 150)
    SetMemoryPoolSize("PassengerSlot", 0)
    SetMemoryPoolSize("PathNode", 92)
    SetMemoryPoolSize("UnitAgent", 128)
    SetMemoryPoolSize("UnitController", 128)
    SetMemoryPoolSize("Weapon", weaponCnt)  
    SetMemoryPoolSize("TentacleSimulator", 0)
    SetMemoryPoolSize("Combo::DamageSample", 0)
    
    SetSpawnDelay(10.0, 0.25)
    ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ME5\\MSO.lvl", "MSO_conquest")
    SetDenseEnvironment("false")

	
	SetParticleLODBias(15000)   
	
    --  Sound
    
    OpenAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\ME5.lvl",  "ME5n_music")
	OpenAudioStream("sound\\spa.lvl",  "spa")
    OpenAudioStream("sound\\spa.lvl",  "spa")
	OpenAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\ME5.lvl",  "col_unit_vo_quick")

	Music02()
	
	SSVWorldVO()

    SoundFX()


	--  Camera Stats
    AddCameraShot(0.914811, -0.054627, 0.399460, 0.023853, 186.374527, 41.910858, 230.153229);
	AddCameraShot(0.916782, -0.053201, -0.395164, -0.022931, -152.424011, 41.910858, 254.628479);
	AddCameraShot(0.930269, -0.128603, 0.340362, 0.047053, 126.493584, 41.285267, 292.892517);
	AddCameraShot(0.052319, -0.005925, -0.992270, -0.112373, 37.337471, 17.794003, -21.383820);
	AddCameraShot(-0.158184, 0.028947, -0.970864, -0.177661, 41.519318, 17.794003, 70.238647);
	AddCameraShot(0.800253, -0.176717, 0.559552, 0.123564, 155.195282, 17.794003, 116.095673);
	
	AddLandingRegion("cp1-land")
	AddLandingRegion("cp2-land")
end

