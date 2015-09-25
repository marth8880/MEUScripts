ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\master.lvl")
isModMap = 1
--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- load the gametype script
ScriptCB_DoFile("ME5_Master")
ScriptCB_DoFile("ME5_setup_teams")
ScriptCB_DoFile("ME5_ObjectiveConquest")
ScriptCB_DoFile("ambush")
	
	--  REP Attacking (attacker is always #1)
    REP = 1;
    CIS = 2;
	SQD = 3;
	ROC = 4;
	SNI = 5;
	DST = 6;
	PRI = 7;
	
    --  These variables do not change
    ATT = REP;
    DEF = CIS;

function ScriptPostLoad()	   
	ScriptCB_SetGameRules("campaign")
	AllowAISpawn(REP, false)
    
    
    --This defines the CPs.  These need to happen first
    cp1 = CommandPost:New{name = "cp1_c"}
	cp3 = CommandPost:New{name = "cp3_c"}
    
    
    
    --This sets up the actual objective.  This needs to happen after cp's are defined
    conquest = ObjectiveConquest:New{teamATT = ATT, teamDEF = DEF, 
                                     textATT = "game.modes.con", 
                                     textDEF = "game.modes.con2",
                                     multiplayerRules = true}
    
    --This adds the CPs to the objective.  This needs to happen after the objective is set up
    conquest:AddCommandPost(cp1)
	conquest:AddCommandPost(cp3)
    
    conquest:Start()
	
	ClearAIGoals(3)
	AddAIGoal(3, "Follow", 100, 0)

    EnableSPHeroRules()
	
	
	SetClassProperty("ssv_inf_shepard", "AddShield", "11.0")
	SetClassProperty("ssv_inf_shepard", "MaxShield", "650.0")
	
	-- SetClassProperty("ssv_hero_samara", "UnitType", "scout")
	SetClassProperty("ssv_hero_samara", "MaxHealth", "550.0")
	SetClassProperty("ssv_hero_samara", "MaxShield", "350.0")
	
	-- SetClassProperty("ssv_hero_jack", "UnitType", "scout")
	SetClassProperty("ssv_hero_jack", "MaxHealth", "600.0")
	SetClassProperty("ssv_hero_jack", "MaxShield", "350.0")
	
	SetClassProperty("gth_inf_trooper", "MaxHealth", "400.0")
	SetClassProperty("gth_inf_trooper", "MaxShield", "500.0")
	SetClassProperty("gth_inf_trooper", "MaxSpeed", "3.6")
	SetClassProperty("gth_inf_trooper", "MaxStrafeSpeed", "3.0")
	-- SetClassProperty("gth_inf_trooper", "UnitType", "scout")
	
	SetClassProperty("gth_inf_rocketeer", "MaxHealth", "400.0")
	SetClassProperty("gth_inf_rocketeer", "MaxShield", "500.0")
	SetClassProperty("gth_inf_rocketeer", "MaxSpeed", "3.6")
	SetClassProperty("gth_inf_rocketeer", "MaxStrafeSpeed", "3.0")
	-- SetClassProperty("gth_inf_rocketeer", "UnitType", "scout")
	
	SetClassProperty("gth_inf_sniper", "MaxHealth", "350.0")
	SetClassProperty("gth_inf_sniper", "MaxShield", "450.0")
	SetClassProperty("gth_inf_sniper", "MaxSpeed", "3.6")
	SetClassProperty("gth_inf_sniper", "MaxStrafeSpeed", "3.0")
	-- SetClassProperty("gth_inf_sniper", "UnitType", "scout")
	
	-- SetClassProperty("gth_inf_destroyer", "UnitType", "scout")
	
	-- SetClassProperty("gth_inf_prime", "UnitType", "scout")
	
	
	ActivateRegion("ambush_1")
	ambushSquad1 = OnEnterRegion(
		function(region, player)
				print("AIGoal -- ambush_1")
			ClearAIGoals(3)
			AddAIGoal(3, "Defend", 200, 0)
			
			ClearAIGoals(2)
			ClearAIGoals(4)
			ClearAIGoals(5)
			-- ClearAIGoals(6)
			-- ClearAIGoals(7)
			AddAIGoal(2, "Deathmatch", 300)
			AddAIGoal(4, "Deathmatch", 300)
			AddAIGoal(5, "Deathmatch", 300)
			-- AddAIGoal(6, "Deathmatch", 100)
			-- AddAIGoal(7, "Deathmatch", 100)
			
			-- BlockPlanningGraphArcs("connection44")
			-- BlockPlanningGraphArcs("connection45")
			-- BlockPlanningGraphArcs("connection46")
			-- BlockPlanningGraphArcs("connection47")
			-- BlockPlanningGraphArcs("connection48")
			-- BlockPlanningGraphArcs("connection49")
			-- BlockPlanningGraphArcs("connection50")
			-- BlockPlanningGraphArcs("connection51")
			-- BlockPlanningGraphArcs("connection52")
			-- BlockPlanningGraphArcs("connection53")
			-- BlockPlanningGraphArcs("connection54")
			-- BlockPlanningGraphArcs("connection55")
			-- BlockPlanningGraphArcs("connection56")
			-- BlockPlanningGraphArcs("connection59")
			-- BlockPlanningGraphArcs("connection60")
			-- BlockPlanningGraphArcs("connection61")
			-- BlockPlanningGraphArcs("connection62")
			-- BlockPlanningGraphArcs("connection63")
		end,
	"ambush_1"
	)
	
	SetupAmbushTrigger("ambush_1", "gth_troop_1", 5, 2)
	SetupAmbushTrigger("ambush_1", "gth_rocket_1", 5, 4)
	SetupAmbushTrigger("ambush_1", "gth_sniper_1", 2, 5)
	
	DisableAIAutoBalance()
    
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
    
	PreLoadStuff()
	
	-- This sets the agressiveness for each team.
	-- SetTeamAggressiveness(1,(0.99))
	SetTeamAggressiveness(2,(0.99))
	SetTeamAggressiveness(4,(0.99))
	SetTeamAggressiveness(5,(0.99))
	
	AISnipeSuitabilityDist(30)
	SetDefenderSnipeRange(50)
    SetMaxFlyHeight(30)
    SetMaxPlayerFlyHeight (30)
    
    SetMemoryPoolSize ("ClothData",20)
    SetMemoryPoolSize ("Combo",50)              -- should be ~ 2x number of jedi classes
    SetMemoryPoolSize ("Combo::State",650)      -- should be ~12x #Combo
    SetMemoryPoolSize ("Combo::Transition",650) -- should be a bit bigger than #Combo::State
    SetMemoryPoolSize ("Combo::Condition",650)  -- should be a bit bigger than #Combo::State
    SetMemoryPoolSize ("Combo::Attack",550)     -- should be ~8-12x #Combo
    SetMemoryPoolSize ("Combo::DamageSample",6000)  -- should be ~8-12x #Combo::Attack
    SetMemoryPoolSize ("Combo::Deflect",100)     -- should be ~1x #combo  
	
		ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\ME5.lvl;ME5n")
		ReadDataFile("sound\\kas.lvl;kas2cw")
		ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\ssv.lvl",
							 "ssv_hero_jack",
							 "ssv_hero_samara",
							 "ssv_inf_shepard")
		ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\gth.lvl",
                             "gth_inf_trooper",
                             "gth_inf_rocketeer",
                             "gth_inf_sniper",
                             "gth_inf_destroyer",
                             "gth_inf_prime")		
		ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\krogan.lvl",
							 "krogan_inf_warrior")
	
		SetupTeams{
		rep = {
			team = REP,
			units = 1,
			reinforcements = 1,
			soldier  = { "ssv_inf_shepard",0, 1},
	        
		}
		}
		
			SetTeamName(2, CIS)
			AddUnitClass(2, "gth_inf_trooper", 5)
			SetUnitCount(2, 5)
			
			SetTeamName(3, REP)
			AddUnitClass(3, "ssv_hero_jack", 1)
			AddUnitClass(3, "ssv_hero_samara", 1)
			SetUnitCount(3, 2)
			
			SetTeamName(4, CIS)
			AddUnitClass(4, "gth_inf_rocketeer", 5)
			SetUnitCount(4, 5)
			
			SetTeamName(5, CIS)
			AddUnitClass(5, "gth_inf_sniper", 2)
			SetUnitCount(5, 2)
			
			
			SetTeamAsFriend(1,3)
			SetTeamAsFriend(3,1)
			
			SetTeamAsFriend(2,4)
			SetTeamAsFriend(2,5)
			SetTeamAsFriend(2,6)
			SetTeamAsFriend(2,7)
			SetTeamAsFriend(4,2)
			SetTeamAsFriend(4,5)
			SetTeamAsFriend(4,6)
			SetTeamAsFriend(4,7)
			SetTeamAsFriend(5,2)
			SetTeamAsFriend(5,4)
			SetTeamAsFriend(5,6)
			SetTeamAsFriend(5,7)
			
			
			SetTeamAsEnemy(1,2)
			SetTeamAsEnemy(1,4)
			SetTeamAsEnemy(1,5)
			SetTeamAsEnemy(1,6)
			SetTeamAsEnemy(1,7)
			SetTeamAsEnemy(3,2)
			SetTeamAsEnemy(3,4)
			SetTeamAsEnemy(3,5)
			SetTeamAsEnemy(3,6)
			SetTeamAsEnemy(3,7)
			
			SetTeamAsEnemy(2,1)
			SetTeamAsEnemy(2,3)
			SetTeamAsEnemy(4,1)
			SetTeamAsEnemy(4,3)
			SetTeamAsEnemy(5,1)
			SetTeamAsEnemy(5,3)
			SetTeamAsEnemy(6,1)
			SetTeamAsEnemy(6,3)
			SetTeamAsEnemy(7,1)
			SetTeamAsEnemy(7,3)
   

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
	SetMemoryPoolSize("SoldierAnimation", 230)
    SetMemoryPoolSize("SoundSpaceRegion", 64)
    SetMemoryPoolSize("TreeGridStack", 1024)
	SetMemoryPoolSize("UnitAgent", 128)
	SetMemoryPoolSize("UnitController", 128)
	SetMemoryPoolSize("Weapon", weaponCnt)
    
    SetSpawnDelay(10.0, 0.25)
    --ReadDataFile("dc:TST\\TST.lvl", "TST_conquest")
    ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ME5\\TST.lvl", "TST_campaign")
    SetDenseEnvironment("false")




    --  Sound
	
	ScriptCB_EnableHeroMusic(0)
    
    OpenAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\ME5.lvl",  "ME5n_music")
    OpenAudioStream("sound\\kas.lvl",  "kas")
    OpenAudioStream("sound\\kas.lvl",  "kas")
	OpenAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\ME5.lvl",  "col_unit_vo_quick")
	OpenAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\ME5.lvl",  "gth_unit_vo_quick")
	OpenAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\ME5.lvl",  "ssv_unit_vo_quick")

    SetBleedingVoiceOver(REP, REP, "rep_off_com_report_us_overwhelmed", 1)
    SetBleedingVoiceOver(REP, CIS, "rep_off_com_report_enemy_losing",   1)
    SetBleedingVoiceOver(CIS, REP, "cis_off_com_report_enemy_losing",   1)
    SetBleedingVoiceOver(CIS, CIS, "cis_off_com_report_us_overwhelmed", 1)

    SetOutOfBoundsVoiceOver(2, "cisleaving")
    SetOutOfBoundsVoiceOver(1, "repleaving")

	Music06()
	
	SoundFX()


--OpeningSateliteShot
    AddCameraShot(0.908386, -0.209095, -0.352873, -0.081226, -45.922508, -19.114113, 77.022636);

    AddCameraShot(-0.481173, 0.024248, -0.875181, -0.044103, 14.767292, -30.602322, -144.506851);
    AddCameraShot(0.999914, -0.012495, -0.004416, -0.000055, 1.143253, -33.602314, -76.884430);
    AddCameraShot(0.839161, 0.012048, -0.543698, 0.007806, 19.152437, -49.802273, 24.337317);
    AddCameraShot(0.467324, 0.006709, -0.883972, 0.012691, 11.825212, -49.802273, -7.000720);
    AddCameraShot(0.861797, 0.001786, -0.507253, 0.001051, -11.986043, -59.702248, 23.263165);
    AddCameraShot(0.628546, -0.042609, -0.774831, -0.052525, 20.429928, -48.302277, 9.771714);
    AddCameraShot(0.765213, -0.051873, 0.640215, 0.043400, 57.692474, -48.302277, 16.540724);
    AddCameraShot(0.264032, -0.015285, -0.962782, -0.055734, -16.681797, -42.902290, 129.553268);
    AddCameraShot(-0.382320, 0.022132, -0.922222, -0.053386, 20.670977, -42.902290, 135.513001);
end

