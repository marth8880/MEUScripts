ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\master.lvl")
-- SupportsCustomEraTeams = true

-- CustomEraTeam2 = "Geth"
-- CustomEraTeam1 = "N7 Special Forces"
--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- load the gametype script -- 
ScriptCB_DoFile("ME5_Master")
ScriptCB_DoFile("ME5_setup_teams")
ScriptCB_DoFile("ME5_ObjectiveTDM")
ScriptCB_DoFile("ambush")

    --  Republic Attacking (attacker is always #1)
    REP = 1
    CIS = 2
    --  These variables do not change
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
function ScriptPostLoad()

	AllowAISpawn(REP, false)
 
    DisableBarriers("dropship")
    DisableBarriers("shield_03")
    DisableBarriers("shield_02")
    DisableBarriers("shield_01")
    DisableBarriers("ctf")
    DisableBarriers("ctf1")
    DisableBarriers("ctf2")
    DisableBarriers("ctf3")
    DisableBarriers("coresh1")
	
    
	--Kill the capture regions
    SetProperty("CP1_CON", "captureregion", " ") 
    SetProperty("CP2_CON", "captureregion", " ") 
    SetProperty("CP4_CON", "captureregion", " ") 
    SetProperty("CP5_CON", "captureregion", " ") 
    SetProperty("CP7_CON", "captureregion", " ") 
	--Change up teams
	
    -- KillObject("CP1_CON")  
	KillObject("CP2_CON")  
	KillObject("CP4_CON")  
	KillObject("CP5_CON")  
	KillObject("CP7_CON")
    
    AddAIGoal(1, "Deathmatch", 100)
    AddAIGoal(2, "Deathmatch", 100)
	
	EnableSPHeroRules()
	
	SetClassProperty("ssv_hero_shepard", "MaxHealth", "1000")
	SetClassProperty("ssv_hero_shepard", "MaxShield", "1300")
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
    SetTimerValue(wavetimer1, 70)
    
    wavetimer2 = CreateTimer("waves2")
    SetTimerValue(wavetimer2, 115)
	
	wavetimer3 = CreateTimer("waves3")
    SetTimerValue(wavetimer3, 90)
	
    firstspawn = OnCharacterSpawn(
    	function(player)
    		if GetCharacterTeam(player) == 1 and spawnonce == 0 then
				ShowObjectiveTextPopup("level.myg1.wavemode", ATT)	
				StartTimer(wavetimer1)
				ShowTimer(nil)
				ShowTimer(wavetimer1)
				ShowMessageText("level.myg1.wave")
				Ambush("CP7JERKPATH", 7, 2)
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
    		ShowMessageText("level.myg1.wave")
    		Ambush("CP7JERKPATH", 13, 3)
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
    		ShowMessageText("level.myg1.wave")
    		Ambush("CP7JERKPATH", 3, 4)
    		SetReinforcementCount(ATT, 3)
			DestroyTimer(timer)	
            end,
        wavetimer2
        )
		
	wtime2 = OnTimerElapse(
    	function(timer)
    		if yesprime == 1 then
			    MapRemoveClassMarker("gth_inf_prime")
    			MissionVictory(ATT)
			elseif yesprime == 0 then
			    MapRemoveClassMarker("gth_inf_prime")
				MissionDefeat(ATT)
			end	
            end,
        wavetimer3
        )
		
		
		
		
end
 
function ScriptInit()
    -- Designers, these two lines *MUST* be first!
    StealArtistHeap(2048 * 1024)
    SetPS2ModelMemory(4000000)
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\Load\\load.lvl;myg1")
	manager:Proc_ScriptInit_Begin()


    -- RandomSide = math.random(1,2)
				
	-- if RandomSide == 1 then
		ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\ME5.lvl;ME5n")
		ReadDataFile("sound\\myg.lvl;myg1cw")
		ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\ssv.lvl",
							 "ssv_hero_shepard")
		ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\gth.lvl",
                             "gth_inf_prime")	
		ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\indoc.lvl",
                             "indoc_inf_husk")
	
		SetupTeams{
			rep = {
				team = REP,
				units = 1,
				reinforcements = -1,
				soldier  = { "ssv_hero_shepard",0, 1},
				
			},
			cis = {
				team = CIS,
				units = 7,
				reinforcements = -1,
				soldier  = { "indoc_inf_husk",7, 7},
			}
			} 
				
	SetTeamName(3, "cis")
    		AddUnitClass(3, "indoc_inf_husk",13,13)
   	SetUnitCount (3, 13)
   	--first number is numteam, second is numunits
   	AddAIGoal(3, "Deathmatch", 13) 
	
	SetTeamName(4, "cis")
    		AddUnitClass(4, "gth_inf_prime",3,3)
   	SetUnitCount (4, 3)
   	--first number is numteam, second is numunits
   	AddAIGoal(4, "Deathmatch", 3)
	
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

    --  Level Stats
    ClearWalkers()
    AddWalkerType(0, 4)
    AddWalkerType(2, 0)
    local weaponCnt = 230
    SetMemoryPoolSize("Aimer", 60)
    SetMemoryPoolSize("AmmoCounter", weaponCnt)
    SetMemoryPoolSize("BaseHint", 250)
    SetMemoryPoolSize("EnergyBar", weaponCnt)
	SetMemoryPoolSize("EntityCloth", 19)
    SetMemoryPoolSize("EntityHover", 7)
    SetMemoryPoolSize("EntityFlyer", 6)
    SetMemoryPoolSize("EntitySoundStream", 1)
    SetMemoryPoolSize("EntitySoundStatic", 76)
    SetMemoryPoolSize("MountedTurret", 16)
    SetMemoryPoolSize("Navigator", 50)
    SetMemoryPoolSize("Obstacle", 500)
    SetMemoryPoolSize("PathNode", 256)
    SetMemoryPoolSize("TreeGridStack", 275)
    SetMemoryPoolSize("UnitAgent", 50)
    SetMemoryPoolSize("UnitController", 50)
    SetMemoryPoolSize("Weapon", weaponCnt)
    
    SetSpawnDelay(10.0, 0.25)
    ReadDataFile("myg\\myg1.lvl", "myg1_conquest")
    SetDenseEnvironment("false")
    AddDeathRegion("deathregion")
    SetMaxFlyHeight(20)
    SetMaxPlayerFlyHeight(20)

	
    --  Sound Stats
	
	ScriptCB_EnableHeroMusic(0)
    
    OpenAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\ME5.lvl",  "ME5n_music")
    OpenAudioStream("sound\\myg.lvl",  "myg1")
    OpenAudioStream("sound\\myg.lvl",  "myg1")
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

    SetAmbientMusic(REP, 1.0, "ssv_amb_03_start",  0,1)
    SetAmbientMusic(REP, 0.9, "ssv_amb_03_mid",    1,1)
    SetAmbientMusic(REP, 0.3, "ssv_amb_03_end",    2,1)
    SetAmbientMusic(CIS, 1.0, "ssv_amb_03_start",  0,1)
    SetAmbientMusic(CIS, 0.9, "ssv_amb_03_mid",    1,1)
    SetAmbientMusic(CIS, 0.3, "ssv_amb_03_end",    2,1)

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


