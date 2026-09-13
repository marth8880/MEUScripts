-- SupportsCustomEraTeams = true

-- CustomEraTeam2 = "Geth"		-- Multiplayer match is Geth versus N7
-- CustomEraTeam1 = "N7 Special Forces"

--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- load the gametype script
ScriptCB_DoFile("ObjectiveTDM")
ScriptCB_DoFile("setup_teams")
ScriptCB_DoFile("ambush")
	
	--  REP Attacking (attacker is always #1)
    REP = 1;
    CIS = 2;
    --  These variables do not change
    ATT = REP;
    DEF = CIS;


function ScriptPostLoad()

	AllowAISpawn(REP, false)
	
	SkyMode = math.random(1,2)
	
	if SkyMode == 1 then
	ReadDataFile("dc:VEN\\sky.lvl", "daytime")
	elseif SkyMode == 2 then
    	ReadDataFile("dc:SIDE\\mist.lvl", "myg1_sky_mist") 
	ReadDataFile("dc:VEN\\sky.lvl", "nighttime")
	end	   

	 CreateTimer("globalhawk1_timer")
    	 SetTimerValue("globalhawk1_timer", 28)
    	 StartTimer("globalhawk1_timer")
    	 OnTimerElapse(
    	     function(timer)
		ScriptCB_SndPlaySound("globalhawk_flyby")
        	DestroyTimer("globalhawk1_timer")
	 	CreateTimer("globalhawk2_timer")
    	 	SetTimerValue("globalhawk2_timer", 60)
    	 	StartTimer("globalhawk2_timer")
    	 	OnTimerElapse(
    	     	function(timer)
		 	ScriptCB_SndPlaySound("globalhawk_flyby")
			SetTimerValue("globalhawk2_timer", 60)
    	 		StartTimer("globalhawk2_timer")
    	     	end,
    	     	"globalhawk2_timer"
    	 	)
    	     end,
    	     "globalhawk1_timer"
    	 )    
    
	-- handle reinforcment loss and defeat condition
    --OnCharacterDeathTeam(function(character, killer) AddReinforcements(1, -1) end, 1)
    --OnTicketCountChange(function(team, count) if count == 0 then MissionDefeat(team) end end)
    ScriptCB_SetGameRules("campaign")
    
    EnableSPHeroRules()
    --Kill the capture regions
    SetProperty("cp1", "captureregion", " ") 
    SetProperty("cp2", "captureregion", " ") 
    SetProperty("cp3", "captureregion", " ") 
    SetProperty("cp4", "captureregion", " ") 
    SetProperty("cp5", "captureregion", " ") 
	--Change up teams
	
    -- KillObject("cp1")  
	KillObject("cp2")  
	KillObject("cp3")  
	KillObject("cp4")  
	KillObject("cp5")
    
    AddAIGoal(1, "Deathmatch", 100)
    AddAIGoal(2, "Deathmatch", 100)

    EnableSPHeroRules()

    AddDeathRegion("deathregion")

	SetClassProperty("ven_inf_astronaut", "HurtSound", "rep_inf_com_chatter_wound")
	SetClassProperty("ven_inf_astronaut", "DeathSound", "rep_inf_com_chatter_death")
	SetClassProperty("ven_inf_astronaut", "DamageRegionSound", "repmalechoke")
	SetClassProperty("ven_inf_astronaut", "FoleyFXClass", "rep_inf_trooper")
	
	SetClassProperty("ssv_hero_shepard", "MaxHealth", "1000")
	SetClassProperty("ssv_hero_shepard", "MaxShield", "1500")
	SetClassProperty("ssv_hero_shepard", "AddShield", "50")
	
	
--WAVES

	totalkills = 0
	yesprime = 0
	prime = 0
	spawnonce = 0
	SetReinforcementCount(DEF, totalkills)

	tally = OnObjectKill(
		function(object, killer)
			
			if GetEntityClass(object) == FindEntityClass("gth_inf_prime") and prime < 14 then
				prime = prime + 1
				SetReinforcementCount(DEF, prime)
			end
				
		end
	)
	
	dying = OnCharacterDeath(
		function(character)
			if IsCharacterHuman(character) then
			    MapRemoveClassMarker("gth_inf_prime")
				MissionDefeat(ATT)
			end
		end
	)
		   
    
    wavetimer1 = CreateTimer("waves1")
    SetTimerValue(wavetimer1, 120)
    
    wavetimer2 = CreateTimer("waves2")
    SetTimerValue(wavetimer2, 110)    
    
    wavetimer3 = CreateTimer("waves3")
    SetTimerValue(wavetimer3, 150)    

    wavetimer4 = CreateTimer("waves4")
    SetTimerValue(wavetimer4, 100)
	
    wavetimer5 = CreateTimer("waves5")
    SetTimerValue(wavetimer5, 90) 
	
    wavetimer6 = CreateTimer("waves6")
    SetTimerValue(wavetimer6, 100)
	
    wavetimer7 = CreateTimer("waves7")
    SetTimerValue(wavetimer7, 120)
	
    firstspawn = OnCharacterSpawn(
    	function(player)
    		if GetCharacterTeam(player) == 1 and spawnonce == 0 then
				ShowObjectiveTextPopup("level.ven.wavemode", ATT)	
				StartTimer(wavetimer1)
				ShowTimer(nil)
				ShowTimer(wavetimer1)
				ShowMessageText("level.ven.wave")
				Ambush("cp2_spawn", 10, 2)
				Ambush("cp3_spawn", 10, 2)
				Ambush("cp4_spawn", 10, 2)
				SetReinforcementCount(ATT, 1)
				spawnonce = 1
    		end
    	end
    )

    wtime0 = OnTimerElapse(
    	function(timer)
    		StartTimer(wavetimer2)
    		ShowTimer(nil)
    		ShowTimer(wavetimer2)
    		ShowMessageText("level.ven.wave")
    		Ambush("cp2_spawn", 9, 3)
    		Ambush("cp3_spawn", 9, 3)
    		Ambush("cp4_spawn", 9, 3)
    		SetReinforcementCount(ATT, 2)
			DestroyTimer(timer)	
            end,
        wavetimer1
        )
    
    wtime1 = OnTimerElapse(
    	function(timer)
    		StartTimer(wavetimer3)
    		ShowTimer(nil)
    		ShowTimer(wavetimer3)
    		ShowMessageText("level.ven.wave")
    		Ambush("cp2_spawn", 12, 4)
    		Ambush("cp3_spawn", 12, 4)
    		Ambush("cp4_spawn", 12, 4)
    		
    		SetReinforcementCount(ATT, 3)
			DestroyTimer(timer)	
            end,
        wavetimer2
        )
		
	wtime2 = OnTimerElapse(
    	function(timer)
    		StartTimer(wavetimer4)
    		ShowTimer(nil)
    		ShowTimer(wavetimer4)
    		ShowMessageText("level.ven.wave")
    		Ambush("cp2_spawn", 5, 5)
    		Ambush("cp3_spawn", 5, 5)
    		Ambush("cp4_spawn", 5, 5)
    		
    		SetReinforcementCount(ATT, 4)
			DestroyTimer(timer)	
            end,
        wavetimer3
        )	
		
	wtime3 = OnTimerElapse(
    	function(timer)
    		if yesprime == 1 then
			    MapRemoveClassMarker("gth_inf_prime")
    			MissionVictory(ATT)
			elseif yesprime == 0 then
			    MapRemoveClassMarker("gth_inf_prime")
				MissionDefeat(ATT)
			end	
            end,
        wavetimer4
        )								        
		
		
    
    
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

    ReadDataFile("dc:Load\\ven.lvl")
    ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\common.lvl")
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ingame.lvl")
    ReadDataFile("ingame.lvl")
	
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\core.lvl")
	
	SetUberMode(1);
       
    SetMaxFlyHeight(60)
    SetMaxPlayerFlyHeight (60)
    
    SetMemoryPoolSize ("ClothData",20)
    SetMemoryPoolSize ("Combo",50)              -- should be ~ 2x number of jedi classes
    SetMemoryPoolSize ("Combo::State",650)      -- should be ~12x #Combo
    SetMemoryPoolSize ("Combo::Transition",650) -- should be a bit bigger than #Combo::State
    SetMemoryPoolSize ("Combo::Condition",650)  -- should be a bit bigger than #Combo::State
    SetMemoryPoolSize ("Combo::Attack",550)     -- should be ~8-12x #Combo
    SetMemoryPoolSize ("Combo::DamageSample",6000)  -- should be ~8-12x #Combo::Attack
    SetMemoryPoolSize ("Combo::Deflect",100)     -- should be ~1x #combo  
	
	
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\ME5.lvl;ME5n")
			ReadDataFile("dc:sound\\ven.lvl;venus")
			ReadDataFile("sound\\tan.lvl;tan1cw")
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\ssv.lvl",
								"ssv_hero_shepard")
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\gth.lvl",
								"gth_inf_trooper",
								"gth_inf_rocketeer",
								"gth_inf_sniper",
								"gth_inf_destroyer",
								"gth_inf_prime")
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\krogan.lvl",
								"krogan_inf_warrior")
			ReadDataFile("dc:SIDE\\ven.lvl",
								"ven_inf_astronaut")
								
			
			SetupTeams{
			rep = {
				team = REP,
				units = 1,
				reinforcements = -1,
				soldier  = { "ssv_hero_shepard",0, 1},
				
			},
			cis = {
				team = CIS,
				units = 30,
				reinforcements = -1,
				soldier  = { "gth_inf_trooper",15, 15},
				assault  = { "gth_inf_rocketeer",10, 10},
				sniper = { "gth_inf_sniper",5, 5},
			}
			}
				
				-- SetTeamName (3, "nasa") 
				-- AddUnitClass (3, "ven_inf_astronaut", 8,8)
				-- SetUnitCount (3, 8)
				-- AddAIGoal(3, "Deathmatch", 100)
				
				-- SetTeamAsNeutral(ATT,3)
				-- SetTeamAsNeutral(3,ATT)
				-- SetTeamAsNeutral(DEF,3)
				-- SetTeamAsNeutral(3,DEF)   
				
	SetTeamName(3, "cis")
    		AddUnitClass(3, "gth_inf_rocketeer",15,15)
    		AddUnitClass(3, "krogan_inf_warrior",12,12)
   	SetUnitCount (3, 27)
   	--first number is numteam, second is numunits
   	AddAIGoal(3, "Deathmatch", 27) 
	
	SetTeamName(4, "cis")
    		AddUnitClass(4, "gth_inf_rocketeer",20,20)
    		AddUnitClass(4, "krogan_inf_warrior",16,16)
   	SetUnitCount (4, 36)
   	--first number is numteam, second is numunits
   	AddAIGoal(4, "Deathmatch", 36) 
	
	SetTeamName(5, "cis")
    		AddUnitClass(5, "gth_inf_destroyer",15,15)
   	SetUnitCount (5, 15)
   	--first number is numteam, second is numunits
   	AddAIGoal(5, "Deathmatch", 15) 
	
	SetTeamName(6, "cis")
    		AddUnitClass(6, "gth_inf_prime",5,5)
   	SetUnitCount (6, 5)
   	--first number is numteam, second is numunits
   	AddAIGoal(6, "Deathmatch", 5) 
	
	SetTeamAsEnemy(ATT,3)
   	SetTeamAsEnemy(3,ATT)
   	SetTeamAsFriend(DEF,3)
   	SetTeamAsFriend(3,DEF)
	   
	SetTeamAsEnemy(ATT,4)
   	SetTeamAsEnemy(4,ATT)
   	SetTeamAsFriend(DEF,4)
   	SetTeamAsFriend(4,DEF)
   	SetTeamAsFriend(3,4)
   	SetTeamAsFriend(4,3)
	   
	SetTeamAsEnemy(ATT,5)
   	SetTeamAsEnemy(5,ATT)
   	SetTeamAsFriend(DEF,5)
   	SetTeamAsFriend(5,DEF)
   	SetTeamAsFriend(4,5)
   	SetTeamAsFriend(5,4)
   	SetTeamAsFriend(3,5)
   	SetTeamAsFriend(5,3)
	   
	SetTeamAsEnemy(ATT,6)
   	SetTeamAsEnemy(6,ATT)
   	SetTeamAsFriend(DEF,6)
   	SetTeamAsFriend(6,DEF)
   	SetTeamAsFriend(5,6)
   	SetTeamAsFriend(6,5)
   	SetTeamAsFriend(4,6)
   	SetTeamAsFriend(6,4)
   	SetTeamAsFriend(3,6)
   	SetTeamAsFriend(6,3)
			

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
    SetMemoryPoolSize("EntitySoundStatic", 512)
    SetMemoryPoolSize("MountedTurret", 32)
	SetMemoryPoolSize("Navigator", 128)
    SetMemoryPoolSize("Obstacle", 1024)
	SetMemoryPoolSize("PathNode", 1024)
    SetMemoryPoolSize("SoldierAnimation", 410)
    SetMemoryPoolSize("SoundSpaceRegion", 64)
    SetMemoryPoolSize("TreeGridStack", 1024)
	SetMemoryPoolSize("UnitAgent", 128)
	SetMemoryPoolSize("UnitController", 128)
	SetMemoryPoolSize("Weapon", weaponCnt)
    
    SetSpawnDelay(10.0, 0.25)
    --ReadDataFile("dc:VEN\\VEN.lvl", "VEN_conquest")
    ReadDataFile("dc:VEN\\VEN.lvl", "VEN_conquest")
    SetDenseEnvironment("false")

    --  Sound Stats
	
	ScriptCB_EnableHeroMusic(0)
    
    voiceSlow = OpenAudioStream("sound\\global.lvl", "rep_unit_vo_slow")
    AudioStreamAppendSegments("sound\\global.lvl", "cis_unit_vo_slow", voiceSlow)
    AudioStreamAppendSegments("sound\\global.lvl", "global_vo_slow", voiceSlow)
    
    voiceQuick = OpenAudioStream("sound\\global.lvl", "rep_unit_vo_quick")
    AudioStreamAppendSegments("sound\\global.lvl", "cis_unit_vo_quick", voiceQuick)   
	
	OpenAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\ME5.lvl",  "ME5n_music")
    OpenAudioStream("dc:sound\\ven.lvl",  "venus_music")    
    OpenAudioStream("dc:sound\\ven.lvl",  "ven")
    OpenAudioStream("sound\\tan.lvl",  "tan1")
	OpenAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\ME5.lvl",  "col_unit_vo_quick")
	OpenAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\ME5.lvl",  "gth_unit_vo_quick")
	OpenAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\ME5.lvl",  "ssv_unit_vo_quick")

    SetBleedingVoiceOver(REP, REP, "rep_off_com_report_us_overwhelmed", 1)
    SetBleedingVoiceOver(REP, CIS, "rep_off_com_report_enemy_losing",   1)
    SetBleedingVoiceOver(CIS, REP, "cis_off_com_report_enemy_losing",   1)
    SetBleedingVoiceOver(CIS, CIS, "cis_off_com_report_us_overwhelmed", 1)
    
    SetLowReinforcementsVoiceOver(REP, REP, "rep_off_defeat_im", .1, 1)
    SetLowReinforcementsVoiceOver(REP, CIS, "rep_off_victory_im", .1, 1)
    SetLowReinforcementsVoiceOver(CIS, CIS, "cis_off_defeat_im", .1, 1)
    SetLowReinforcementsVoiceOver(CIS, REP, "cis_off_victory_im", .1, 1)    

    SetOutOfBoundsVoiceOver(1, "Repleaving")
    SetOutOfBoundsVoiceOver(2, "Cisleaving")

    SetAmbientMusic(REP, 1.0, "ven_amb_earworm",  0,1)
    SetAmbientMusic(CIS, 1.0, "ven_amb_earworm",  0,1)
	
	SetVictoryMusic(REP, "ssv_amb_01_victory")
	SetDefeatMusic (REP, "ssv_amb_01_defeat")
	SetVictoryMusic(CIS, "ssv_amb_01_victory")
	SetDefeatMusic (CIS, "ssv_amb_01_defeat")

	SetSoundEffect("ScopeDisplayAmbient",  "me5_sniper_scope_ambient")
    SetSoundEffect("ScopeDisplayZoomIn",  "me5_sniper_scope_zoomin")
    SetSoundEffect("ScopeDisplayZoomOut", "me5_sniper_scope_zoomout")
    --SetSoundEffect("WeaponUnableSelect",  "com_weap_inf_weaponchange_null")
    --SetSoundEffect("WeaponModeUnableSelect",  "com_weap_inf_modechange_null")
    SetSoundEffect("SpawnDisplayUnitChange",       "me5_shell_select_unit")
    SetSoundEffect("SpawnDisplayUnitAccept",       "me5_shell_menu_enter")
    SetSoundEffect("SpawnDisplaySpawnPointChange", "me5_shell_select_change")
    SetSoundEffect("SpawnDisplaySpawnPointAccept", "me5_shell_menu_enter")
    SetSoundEffect("SpawnDisplayBack",             "me5_shell_menu_exit")
	
	SetAttackingTeam(ATT)
	

    --  Camera Stats
	AddCameraShot(0.833753, -0.041111, -0.549937, -0.027117, -59.834293, 7.632715, 26.208221);
	AddCameraShot(-0.247927, 0.000648, -0.968775, -0.002532, 14.313373, 3.652352, 33.439255);

end