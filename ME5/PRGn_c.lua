--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- load the gametype script
ScriptCB_DoFile("ME5_Master")
ScriptCB_DoFile("ME5_setup_teams")
ScriptCB_DoFile("ME5_MultiObjectiveContainer")
ScriptCB_DoFile("ME5_ObjectiveAssault")
ScriptCB_DoFile("ME5_ObjectiveConquest")
ScriptCB_DoFile("ME5_ObjectiveGoto")
ScriptCB_DoFile("ME5_ObjectiveCTF")
ScriptCB_DoFile("ME5_ObjectiveTDM")
ScriptCB_DoFile("Ambush")
	
	--  REP Attacking (attacker is always #1)
    REP = 1;
    CIS = 2;
	TRP = 3;
	ROC = 4;
	SNI = 5;
	ENG = 6;
	SHK = 7;
	DST = 8;
	JUG = 9;
    --  These variables do not change
    ATT = REP;
    DEF = CIS;
	
function ScriptPostLoad()
	
	ScriptCB_SetGameRules("campaign")
	AllowAISpawn(1, false)
	
	PlayerDeathDefeat = OnObjectKill(
		function(object, killer)
			if GetObjectTeam(object) == 1 then
				AddReinforcements(1, -1)
				
				PlayerLifeCount = GetReinforcementCount(1)
				if PlayerLifeCount == 0 then
					PlayerDeathDefeatTimer = CreateTimer("PlayerDeathDefeatTimer")
					SetTimerValue("PlayerDeathDefeatTimer", 1)
					OnTimerElapse(
						function(timer)
							MissionDefeat(1)
							MissionVictory(2)
						end,
					"PlayerDeathDefeatTimer"
				)
					
				else
				end
			end
		end
	)
	
	ShieldRegenDelay = OnObjectDamage(
		function(character, damager)
			if IsCharacterHuman(character) then
				local CharacterClass = GetCharacterClass(character)
				local CharacterShield = GetObjectShield(CharacterClass)
				local ShieldRegenFlagOn = 1
				local ShieldRegenFlagOff = 2
				
				ShieldRegenTimer = CreateTimer("ShieldRegenTimer")
					SetTimerValue("ShieldRegenTimer", 5)
					ShowTimer("ShieldRegenTimer")
					OnTimerElapse(
						function(timer)
							SetProperty(CharacterClass, "AddShield", "50.0")
							--DestroyTimer(Timer)
						end,
					"ShieldRegenTimer"
				)
				ShieldRegenCheck = CreateTimer("ShieldRegenCheck")
					SetTimerValue("ShieldRegenCheck", 1)
					OnTimerElapse(
						function(timer)
							if ShieldRegenFlagOn then
								StartTimer("ShieldRegenTimer")
							elseif ShieldRegenFlagOff then
								SetProperty(CharacterClass, "AddShield", "0.0")
							end
							
							SetTimerValue("ShieldRegenCheck", 1)
							StartTimer("ShieldRegenCheck")
						end,
					"ShieldRegenCheck"
				)
			else
			end
		end
	)
	
    
	--[[onfirstspawn = OnCharacterSpawn(
		function(character)
			if character == 0 then
				ShowPopup("level.geo1.hints.hints")
				ReleaseCharacterSpawn(onfirstspawn)
				onfirstspawn = nil
				BeginObjectivesTimer()
				ScriptCB_EnableCommandPostVO(0)
				BroadcastVoiceOver("GEO_obj_18", ATT)
				ScriptCB_PlayInGameMusic("ssv_amb_01_start")
			end
		end)]]
	
    ScriptCB_PlayInGameMusic("ssv_prg_amb_obj1_1_explore")	-- begin playing first spawn music
	
	ClearAIGoals(2)
	AddAIGoal(2, "Follow", 200, 0)
	
	ClearAIGoals(3)
	ClearAIGoals(4)
	ClearAIGoals(5)
	ClearAIGoals(6)
	ClearAIGoals(7)
	AddAIGoal(3, "Destroy", 500, 0)
	AddAIGoal(4, "Destroy", 500, 0)
	AddAIGoal(5, "Destroy", 500, 0)
	AddAIGoal(6, "Destroy", 500, 0)
	AddAIGoal(7, "Destroy", 500, 0)
	AddAIGoal(3, "Deathmatch", 500)
	AddAIGoal(4, "Deathmatch", 500)
	AddAIGoal(5, "Deathmatch", 500)
	AddAIGoal(6, "Deathmatch", 500)
	AddAIGoal(7, "Deathmatch", 500)
	
	SetClassProperty("ssv_inf_trooper", "MaxHealth", "640.0")
	SetClassProperty("ssv_inf_infiltrator", "MaxHealth", "540.0")
	SetClassProperty("ssv_inf_engineer", "MaxHealth", "540.0")
	SetClassProperty("ssv_inf_adept", "MaxHealth", "475.0")
	SetClassProperty("ssv_inf_sentinel", "MaxHealth", "510.0")
	SetClassProperty("ssv_inf_vanguard", "MaxHealth", "580.0")
	
	SetClassProperty("ssv_inf_trooper", "MaxShield", "460.0")
	SetClassProperty("ssv_inf_infiltrator", "MaxShield", "520.0")
	SetClassProperty("ssv_inf_engineer", "MaxShield", "585.0")
	SetClassProperty("ssv_inf_adept", "MaxShield", "620.0")
	SetClassProperty("ssv_inf_sentinel", "MaxShield", "620.0")
	SetClassProperty("ssv_inf_vanguard", "MaxShield", "750.0")
	
	SetClassProperty("ssv_inf_default", "AddShield", "13.0")
	
	SetClassProperty("gth_inf_trooper", "MaxHealth", "400.0")
	SetClassProperty("gth_inf_rocketeer", "MaxHealth", "400.0")
	SetClassProperty("gth_inf_sniper", "MaxHealth", "400.0")
	SetClassProperty("gth_inf_machinist", "MaxHealth", "430.0")
	SetClassProperty("gth_inf_shock", "MaxHealth", "600.0")
	SetClassProperty("gth_inf_hunter", "MaxHealth", "500.0")
	SetClassProperty("gth_inf_destroyer", "MaxHealth", "600.0")
	SetClassProperty("gth_inf_juggernaut", "MaxHealth", "700.0")
	SetClassProperty("gth_inf_prime", "MaxHealth", "700.0")
	
	SetClassProperty("gth_inf_trooper", "MaxShield", "500.0")
	SetClassProperty("gth_inf_rocketeer", "MaxShield", "500.0")
	SetClassProperty("gth_inf_sniper", "MaxShield", "470.0")
	SetClassProperty("gth_inf_machinist", "MaxShield", "700.0")
	SetClassProperty("gth_inf_shock", "MaxShield", "600.0")
	SetClassProperty("gth_inf_hunter", "MaxShield", "600.0")
	SetClassProperty("gth_inf_destroyer", "MaxShield", "775.0")
	SetClassProperty("gth_inf_juggernaut", "MaxShield", "775.0")
	SetClassProperty("gth_inf_prime", "MaxShield", "850.0")
	
	SetClassProperty("gth_inf_default", "AddShield", "15.0")
		
		
	DisableBarriers("Ambush1_1");	-- make it so friendly ai can enter ambush arena
	DisableBarriers("Ambush1_2");
	
	ActivateRegion("ambush_1") -- begin first ambush wave
	AmbushWave1 = OnEnterRegion(
		function(region, player)
				print("AIGoal:: ambush_1")	-- ai goals
			ClearAIGoals(2)
			AddAIGoal(2, "Defend", 200, 0)
			
			SetReinforcementCount(3, 4)
			--geth_count_1a = 4
			
			BlockPlanningGraphArcs("Connection42");	-- ai aren't supposed to wander out of their closed-off positions
			BlockPlanningGraphArcs("Connection43");
			BlockPlanningGraphArcs("Connection44");
			BlockPlanningGraphArcs("Connection45");
			BlockPlanningGraphArcs("Connection46");
			BlockPlanningGraphArcs("Connection47");
			
			EnableBarriers("Ambush1_1");	-- enclose ambush arena so ai can't run away
			EnableBarriers("Ambush1_2");
			
			ScriptCB_PlayInGameMusic("ssv_prg_amb_obj1_1_combat")	-- begin playing combat music on ambush
			
			ShowMessageText("level.PRG.debug.ambush1a")
			
			--[[local gethTrooperIndex = GetTeamMember(2, 0)       
			local gethTrooperUnit = GetCharacterUnit(gethTrooperIndex)
			SetAIDamageThreshold(gethTrooperUnit, 0.0)]]
			
			Ambush1RegionTimer = CreateTimer("Ambush1RegionTimer")
				SetTimerValue("Ambush1RegionTimer", 1)
				StartTimer("Ambush1RegionTimer")
				OnTimerElapse(
					function(timer)
						DeactivateRegion("ambush_1")	-- make it so ambush region can only be entered once
						
						DestroyTimer(Timer)
					end,
				"Ambush1RegionTimer"
			)
		end,
	"ambush_1"
	)
	
	SetupAmbushTrigger("ambush_1", "gth_amb1", 4, 3)	-- ambush1a trigger: regionName=ambush_1, pathName=gth_amb1, numDudes=4, teamNum=3
	
	Ambush1aGethKill = OnObjectKill(
		function(object, killer)
			local Ambush1a_ReinforcementCount = GetReinforcementCount(3)
			if GetObjectTeam(object) == 3 then
				AddReinforcements(3, -1)
				--geth_count_1a = geth_count_1a - 1
				ShowMessageText("level.PRG.debug.ambushkill1")
			end
			
			if Ambush1a_ReinforcementCount == 1 then
				Ambush("gth_amb1", 4, 4)	-- ambush1b: pathName=gth_amb1, numDudes=4, teamNum=4
				
				SetReinforcementCount(4, 4)
				--local geth_count_1b = 4
				ShowMessageText("level.PRG.debug.ambush1b")
				
				Ambush1bGethKill = OnObjectKill(
					function(object, killer)
						local Ambush1b_ReinforcementCount = GetReinforcementCount(4)
						if GetObjectTeam(object) == 4 then
							AddReinforcements(4, -1)
							--geth_count_1b = geth_count_1b - 1
							ShowMessageText("level.PRG.debug.ambushkill1")
						end
						
						if Ambush1b_ReinforcementCount == 2 then
							Ambush("gth_amb1", 3, 3)	-- ambush1c: pathName=gth_amb1, numDudes=3, teamNum=3
							Ambush("gth_amb1", 1, 4)	-- ambush1c: pathName=gth_amb1, numDudes=1, teamNum=4
							
							SetReinforcementCount(5, 4)
							--local geth_count_1c = 4
							ShowMessageText("level.PRG.debug.ambush1c")
							
							Ambush1cGethKill = OnObjectKill(
								function(object, killer)
									local Ambush1c_ReinforcementCount = GetReinforcementCount(5) --GetReinforcementCount(2) + GetReinforcementCount(4)
									if GetObjectTeam(object) == 3 then
										AddReinforcements(5, -1)
										--geth_count_1c = geth_count_1c - 1
										ShowMessageText("level.PRG.debug.ambushkill1")
									elseif GetObjectTeam(object) == 4 then
										AddReinforcements(5, -1)
										--geth_count_1c = geth_count_1c - 1
										ShowMessageText("level.PRG.debug.ambushkill1")
									end
									
									if Ambush1c_ReinforcementCount == 0 then
										ShowMessageText("level.PRG.debug.ambush1end")
										
										Ambush1EndTimer = CreateTimer("Ambush1EndTimer")
											SetTimerValue("Ambush1EndTimer", 1)
											StartTimer("Ambush1EndTimer")
											OnTimerElapse(
												function(timer)
													ScriptCB_PlayInGameMusic("ssv_prg_amb_obj1_2_explore")	-- begin playing explore music
													
													ClearAIGoals(2)
													AddAIGoal(2, "Follow", 200, 0)
													
													UnblockPlanningGraphArcs("Connection42");	-- friendly ai need to be able to traverse forest "intelligently" :p
													UnblockPlanningGraphArcs("Connection43");
													UnblockPlanningGraphArcs("Connection44");
													UnblockPlanningGraphArcs("Connection45");
													UnblockPlanningGraphArcs("Connection46");
													UnblockPlanningGraphArcs("Connection47");
													
													DisableBarriers("Ambush1_1");	-- make it so friendly ai can leave ambush arena
													DisableBarriers("Ambush1_2");
													
													DestroyTimer(Timer)
												end,
											"Ambush1EndTimer"
										)
									end
								end
							)
						end
					end
				)
			end
		end
	)
	
	DisableBarriers("Ambush2_1");	-- make it so friendly ai can enter ambush arena
	DisableBarriers("Ambush2_2");
	
	ActivateRegion("ambush_2a") -- begin first part of second ambush wave
	AmbushWave2a = OnEnterRegion(
		function(region, player)
				print("AIGoal:: ambush_1")	-- ai goals
			ClearAIGoals(2)
			AddAIGoal(2, "Defend", 200, 0)
			
			SetReinforcementCount(4, 3)
			--geth_count_2a = 3
			
			BlockPlanningGraphArcs("Connection59");	-- ai aren't supposed to wander out of their closed-off positions
			BlockPlanningGraphArcs("Connection60");
			BlockPlanningGraphArcs("Connection61");
			BlockPlanningGraphArcs("Connection62");
			BlockPlanningGraphArcs("Connection63");
			BlockPlanningGraphArcs("Connection64");
			BlockPlanningGraphArcs("Connection65");
			BlockPlanningGraphArcs("Connection66");
			
			EnableBarriers("Ambush2_1");	-- enclose ambush arena so ai can't run away
			EnableBarriers("Ambush2_2");
			
			Ambush("gth_amb2a_roc", 2, 4)	-- ambush1a: pathName=gth_amb2a_roc, numDudes=2, teamNum=4
			Ambush("gth_amb2a_shk", 1, 7)	-- ambush1a: pathName=gth_amb2a_shk, numDudes=1, teamNum=7
			
			ScriptCB_PlayInGameMusic("ssv_prg_amb_obj1_2_combat")	-- begin playing combat music on ambush
			
			ShowMessageText("level.PRG.debug.ambush2a")
			
			Ambush2aRegionTimer = CreateTimer("Ambush2aRegionTimer")
				SetTimerValue("Ambush2aRegionTimer", 1)
				StartTimer("Ambush2aRegionTimer")
				OnTimerElapse(
					function(timer)
						DeactivateRegion("ambush_2a")	-- make it so ambush region can only be entered once
						
						DestroyTimer(Timer)
					end,
				"Ambush2aRegionTimer"
			)
		end,
	"ambush_2a"
	)
	
	--SetupAmbushTrigger("ambush_2a", "gth_amb2a_shk", 1, 7)	-- ambush1a trigger: regionName=ambush_2a, pathName=gth_amb2a_shk, numDudes=1, teamNum=7
	
	ActivateRegion("ambush_2b") -- begin second part of second ambush wave
	AmbushWave2b = OnEnterRegion(
		function(region, player)
			--geth_count_2b = 3
			SetReinforcementCount(7, 3)
			
			Ambush("gth_amb2b_shk", 2, 7)	-- ambush1a: pathName=gth_amb2b_shk, numDudes=2, teamNum=7
			Ambush("gth_amb2b_eng", 1, 6)	-- ambush2b: pathName=gth_amb2b_eng, numDudes=1, teamNum=6
			
			ShowMessageText("level.PRG.debug.ambush2b")
			
			Ambush2bRegionTimer = CreateTimer("Ambush2bRegionTimer")
				SetTimerValue("Ambush2bRegionTimer", 1)
				StartTimer("Ambush2bRegionTimer")
				OnTimerElapse(
					function(timer)
						DeactivateRegion("ambush_2b")	-- make it so ambush region can only be entered once
						
						DestroyTimer(Timer)
					end,
				"Ambush2bRegionTimer"
			)
		end,
	"ambush_2b"
	)
	
	--SetupAmbushTrigger("ambush_2b", "gth_amb2b_eng", 1, 6)	-- ambush2b trigger: regionName=ambush_2b, pathName=gth_amb2b_eng, numDudes=1, teamNum=6
	
	Ambush2aGethKill = OnObjectKill(
		function(object, killer)
			local Ambush2a_ReinforcementCount = GetReinforcementCount(4)
			if GetObjectTeam(object) == 7 then
				--geth_count_2a = geth_count_2a - 1
				AddReinforcements(4, -1)
				ShowMessageText("level.PRG.debug.ambushkill1")
			elseif GetObjectTeam(object) == 4 then
				--geth_count_2a = geth_count_2a - 1
				AddReinforcements(4, -1)
				ShowMessageText("level.PRG.debug.ambushkill1")
			end
			
			Ambush2bGethKill = OnObjectKill(
				function(object, killer)
					local Ambush2b_ReinforcementCount = GetReinforcementCount(7)
					if GetObjectTeam(object) == 7 then
						--geth_count_2b = geth_count_2b - 1
						AddReinforcements(7, -1)
						ShowMessageText("level.PRG.debug.ambushkill1")
					elseif GetObjectTeam(object) == 6 then
						--geth_count_2b = geth_count_2b - 1
						AddReinforcements(7, -1)
						ShowMessageText("level.PRG.debug.ambushkill1")
					end
					
					if Ambush2b_ReinforcementCount == 0 then
						ShowMessageText("level.PRG.debug.ambush2end")
						
						Ambush2EndTimer = CreateTimer("Ambush2EndTimer")
							SetTimerValue("Ambush2EndTimer", 1)
							StartTimer("Ambush2EndTimer")
							OnTimerElapse(
								function(timer)
									ScriptCB_PlayInGameMusic("ssv_prg_amb_obj1_2_explore")	-- begin playing explore music
									
									ClearAIGoals(2)
									AddAIGoal(2, "Follow", 200, 0)
									
									UnblockPlanningGraphArcs("Connection59");	-- friendly ai need to be able to traverse forest "intelligently" :P
									UnblockPlanningGraphArcs("Connection60");
									UnblockPlanningGraphArcs("Connection61");
									UnblockPlanningGraphArcs("Connection62");
									UnblockPlanningGraphArcs("Connection63");
									UnblockPlanningGraphArcs("Connection64");
									UnblockPlanningGraphArcs("Connection65");
									UnblockPlanningGraphArcs("Connection66");
									
									DisableBarriers("Ambush2_1");	-- make it so friendly ai can leave ambush arena
									DisableBarriers("Ambush2_2");
									
									DestroyTimer(Timer)
								end,
							"Ambush2EndTimer"
						)
					end
				end
			)
		end
	)
	
	
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
    
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\Load\\ME5n.lvl")
	manager:Proc_ScriptInit_Begin()
    
	-- This sets the agressiveness for each team.
	-- SetTeamAggressiveness(1,(0.99))
	SetTeamAggressiveness(2,(0.99))
	SetTeamAggressiveness(4,(0.99))
	SetTeamAggressiveness(5,(0.99))
	
	AISnipeSuitabilityDist(30)
	SetDefenderSnipeRange(50)
	
    SetMaxFlyHeight(150)
    SetMaxPlayerFlyHeight (150)
    
    SetMemoryPoolSize ("ClothData",20)
    SetMemoryPoolSize ("Combo",50)              -- should be ~ 2x number of jedi classes
    SetMemoryPoolSize ("Combo::State",650)      -- should be ~12x #Combo
    SetMemoryPoolSize ("Combo::Transition",650) -- should be a bit bigger than #Combo::State
    SetMemoryPoolSize ("Combo::Condition",650)  -- should be a bit bigger than #Combo::State
    SetMemoryPoolSize ("Combo::Attack",550)     -- should be ~8-12x #Combo
    SetMemoryPoolSize ("Combo::DamageSample",6000)  -- should be ~8-12x #Combo::Attack
    SetMemoryPoolSize ("Combo::Deflect",100)     -- should be ~1x #combo  
    
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\ME5.lvl;ME5n")
    ReadDataFile("sound\\kam.lvl;kam1cw")
	
    Load_SSV()
	Load_GTH()
	SetupTeams{
		rep = {
			team = REP,
			units = 1,
			reinforcements = 1,
			soldier  = { "ssv_inf_soldier",0, 1},
			sniper  = { "ssv_inf_infiltrator",0, 1},
			adept = { "ssv_inf_adept",0, 1},
			engineer   = { "ssv_inf_engineer",0, 1},
			sentinel = { "ssv_inf_sentinel",0, 1},
			vanguard = { "ssv_inf_vanguard",0, 1},	
	        
		}
		}
		
		--[[SetTeamName(2, REP)
		AddUnitClass(2, "ssv_inf_soldier", 1)
		AddUnitClass(2, "ssv_inf_infiltrator", 1)
		AddUnitClass(2, "ssv_inf_engineer", 1)
		AddUnitClass(2, "ssv_inf_adept", 1)
		SetUnitCount(2, 4)
		SetReinforcementCount(2, -1)]]
		
		SetTeamName(3, CIS)
		AddUnitClass(3, "gth_inf_trooper", 10)
		SetUnitCount(3, 10)
		
		SetTeamName(4, ROC)
		AddUnitClass(4, "gth_inf_rocketeer", 10)
		SetUnitCount(4, 10)
		
		SetTeamName(5, SNI)
		AddUnitClass(5, "gth_inf_sniper", 10)
		SetUnitCount(5, 10)
		
		SetTeamName(6, ENG)
		AddUnitClass(6, "gth_inf_machinist", 10)
		SetUnitCount(6, 10)
		
		SetTeamName(7, SHK)
		AddUnitClass(7, "gth_inf_shock", 10)
		SetUnitCount(7, 10)
		
		
		SetTeamAsFriend(1,2)
		SetTeamAsFriend(2,1)
		
		SetTeamAsFriend(3,4)
		SetTeamAsFriend(3,5)
		SetTeamAsFriend(3,6)
		SetTeamAsFriend(3,7)
		SetTeamAsFriend(4,3)
		SetTeamAsFriend(4,5)
		SetTeamAsFriend(4,6)
		SetTeamAsFriend(4,7)
		SetTeamAsFriend(5,3)
		SetTeamAsFriend(5,4)
		SetTeamAsFriend(5,6)
		SetTeamAsFriend(5,7)
		
		
		SetTeamAsEnemy(1,3)
		SetTeamAsEnemy(1,4)
		SetTeamAsEnemy(1,5)
		SetTeamAsEnemy(1,6)
		SetTeamAsEnemy(1,7)
		SetTeamAsEnemy(2,3)
		SetTeamAsEnemy(2,4)
		SetTeamAsEnemy(2,5)
		SetTeamAsEnemy(2,6)
		SetTeamAsEnemy(2,7)
		
		SetTeamAsEnemy(3,1)
		SetTeamAsEnemy(3,2)
		SetTeamAsEnemy(4,1)
		SetTeamAsEnemy(4,2)
		SetTeamAsEnemy(5,1)
		SetTeamAsEnemy(5,2)
		SetTeamAsEnemy(6,1)
		SetTeamAsEnemy(6,2)
		SetTeamAsEnemy(7,1)
		SetTeamAsEnemy(7,2)
			
			print("Load/setup SSV versus GTH")
   

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
    SetMemoryPoolSize("Music", 85)
	SetMemoryPoolSize("Navigator", 128)
    SetMemoryPoolSize("Obstacle", 1024)
	SetMemoryPoolSize("PathNode", 1024)
	SetMemoryPoolSize("SoldierAnimation", 276)
    SetMemoryPoolSize("SoundSpaceRegion", 64)
    SetMemoryPoolSize("TreeGridStack", 1884)
	SetMemoryPoolSize("UnitAgent", 128)
	SetMemoryPoolSize("UnitController", 128)
	SetMemoryPoolSize("Weapon", weaponCnt)
    
    SetSpawnDelay(10.0, 0.25)
    --ReadDataFile("dc:PRG\\PRG.lvl", "PRG_conquest")
    ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ME5\\PRG.lvl", "PRG_campaign")
    SetDenseEnvironment("false")




    --  Sound
    
    OpenAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\ME5.lvl",  "ME5n_music")
	OpenAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\ME5.lvl",  "ME5_ambiance")
	OpenAudioStream("sound\\kam.lvl",  "kam1")
	OpenAudioStream("sound\\kam.lvl",  "kam1")
	OpenAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\ME5.lvl",  "col_unit_vo_quick")

    SetOutOfBoundsVoiceOver(2, "gth_ann_com_report_hiatus")
    SetOutOfBoundsVoiceOver(1, "ssv_adm_com_report_hiatus")
	
	SetVictoryMusic(REP, "ssv_amb_01_victory")
	SetDefeatMusic (REP, "ssv_amb_01_defeat")
	SetVictoryMusic(CIS, "ssv_amb_01_victory")
	SetDefeatMusic (CIS, "ssv_amb_01_defeat")
	
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

