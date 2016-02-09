ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\master.lvl")
RandomSide = 1

isModMap = 1
isCampaign = true
--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- load the gametype script
ScriptCB_DoFile("ME5_Master")
ScriptCB_DoFile("ME5_setup_teams")
ScriptCB_DoFile("ME5_MultiObjectiveContainer")
ScriptCB_DoFile("ME5_ObjectiveConquest")
ScriptCB_DoFile("ME5_ObjectiveGoto")
ScriptCB_DoFile("Ambush")

mapSize = xs
EnvironmentType = 4
--[[onlineSideVar = SSVxGTH
onlineHeroSSV = shep_vanguard
onlineHeroGTH = gethprime_me2
onlineHeroCOL = colgeneral
onlineHeroEVG = gethprime_me3]]

REP = 1
CIS = 2	-- Team for the Geth Troopers and Rocketeers. Note: synonymous with teamID 'GethPawns'.
SQD = 3	-- Team for the player's squad.
GethPawns = CIS	-- Team for the Geth Troopers and Rocketeers. Note: synonymous with teamID 'CIS'.
GethTacticals = 4	-- Team for the Geth Snipers and Hunters.
GethSpecials = 5	-- Team for the Geth Machinists and Shock Troopers.
GethHeavys = 6	-- Team for the Geth Destroyers and Juggernauts.
GethPrimes = 7	-- Team for the Geth Primes.

ATT = 1
DEF = 2

-- Table of all allied teams.
allyTeams	= { REP, 
				SQD }

-- Table of all enemy teams.
enemyTeams	= { GethPawns, 
				GethTacticals, 
				GethSpecials, 
				GethHeavys, 
				GethPrimes }

---
-- Locks the doors, enables the barriers, and blocks the planning connections in given sublevel 'sublevelID'.
-- @param #int sublevelID The numerical ID of the sublevel to block.
function BlockCombatZoneExits(sublevelID)
	print("EURn_c.BlockCombatZoneExits("..sublevelID.."): Entered")
	
	if sublevelID == 0 then
		-- Barriers
    	EnableBarrier("Bar_Hangar1")
    	EnableBarrier("Bar_Cargo1")
    	EnableBarrier("Bar_Reception1")
    	EnableBarrier("Bar_Reception1")
    	EnableBarrier("Bar_Management1")
    	EnableBarrier("Bar_Management2")
    	EnableBarrier("Bar_Comms1")
    	EnableBarrier("Bar_Power1")
    	
    	-- Planning connections
    	BlockPlanningGraphArcs(1)
		
		-- Doors
		-- Hangar
		SetProperty("hangar_doors_enter", "IsLocked", "1")
		SetProperty("hangar_doors_exit", "IsLocked", "1")
		
		-- Cargo Bay
		SetProperty("cargo_doors_enter", "IsLocked", "1")
		SetProperty("cargo_doors_exit", "IsLocked", "1")
		
		-- Reception
		SetProperty("reception_doors_enter", "IsLocked", "1")
		SetProperty("reception_doors_exit", "IsLocked", "1")
		
		-- Management
		SetProperty("management_doors_enter", "IsLocked", "1")
		SetProperty("management_doors_exit", "IsLocked", "1")
		
		-- Comms Control
		SetProperty("comms_doors_enter", "IsLocked", "1")
		
		-- Power Control
		SetProperty("power_doors_enter", "IsLocked", "1")
    	
	elseif sublevelID == 1 then
		
	elseif sublevelID == 2 then
		
	elseif sublevelID == 3 then
		
	else
		print("EURn_c.BlockCombatZoneExits(): Argument #0  sublevelID  out of range!")
	end
end

---
-- Unlocks the doors, disables the barriers, and unblocks the planning connections in given sublevel 'sublevelID'.
-- @param #int sublevelID The numerical ID of the sublevel to unblock.
function UnblockCombatZoneExits(sublevelID)
	print("EURn_c.UnblockCombatZoneExits("..sublevelID.."): Entered")
	
	if sublevelID == 0 then
		-- Barriers
    	DisableBarrier("Bar_Hangar1")
    	DisableBarrier("Bar_Cargo1")
    	DisableBarrier("Bar_Reception1")
    	DisableBarrier("Bar_Reception1")
    	DisableBarrier("Bar_Management1")
    	DisableBarrier("Bar_Management2")
    	DisableBarrier("Bar_Comms1")
    	DisableBarrier("Bar_Power1")
    	
    	-- Planning connections
    	UnblockPlanningGraphArcs(1)
		
		-- Doors
		-- Hangar
		SetProperty("hangar_doors_enter", "IsLocked", "0")
		SetProperty("hangar_doors_exit", "IsLocked", "0")
		
		-- Cargo Bay
		SetProperty("cargo_doors_enter", "IsLocked", "0")
		SetProperty("cargo_doors_exit", "IsLocked", "0")
		
		-- Reception
		SetProperty("reception_doors_enter", "IsLocked", "0")
		SetProperty("reception_doors_exit", "IsLocked", "0")
		
		-- Management
		SetProperty("management_doors_enter", "IsLocked", "0")
		SetProperty("management_doors_exit", "IsLocked", "0")
		
		-- Comms Control
		SetProperty("comms_doors_enter", "IsLocked", "0")
		
		-- Power Control
		SetProperty("power_doors_enter", "IsLocked", "0")
    	
	elseif sublevelID == 1 then
		
	elseif sublevelID == 2 then
		
	elseif sublevelID == 3 then
		
	else
		print("EURn_c.UnblockCombatZoneExits(): Argument #0  sublevelID  out of range!")
	end
end

---
-- Sets the path 'spawnPathName' that the player and allied teams should respawn at.
-- @param #string spawnPathName The name of the path to spawn at.
function SetRespawnPoint(spawnPathName)
		print("EURn_c.SetRespawnPoint(): Entered")
		
	local pathName = spawnPathName
	
	-- Quit function if pathName is nil
	if pathName == nil then
		print("EURn_c.SetRespawnPoint(): Failed! Argument #0 'spawnPathName' cannot be nil!")
	return end
	
	print("EURn_c.SetRespawnPoint(): Setting player respawn point to "..pathName)
	
	SetProperty("cp1", "SpawnPath", pathName)
	SetProperty("cp1", "AllyPath", pathName)
end

---
-- Sets up the combat zone 'zoneID'.
-- @param #string combatZoneID The name of the zone ID to set up.
function SetupCombatZoneInit(combatZoneID)
		print("EURn_c.SetupCombatZoneInit(): Entered")
	
	local zoneID = combatZoneID
	
		print("EURn_c.SetupCombatZoneInit(): Setting up combat zone "..zoneID)
		
	--==========================
	-- Variable Initialization
	--==========================
	currentWave = 1			-- The current wave.
	totalEnemies = 0		-- The total number of enemies in this wave.
	totalWaves = 0			-- The total number of waves in the combat zone.
	enemiesRemaining = 0	-- The number of enemies still alive.
	numKilled = 0			-- The number of enemies killed in the wave.
	bIsFinalWave = false	-- Whether or not we're on the final wave.
	
	---
	-- This is a constructor for a combat zone's waves.
	-- @param #int team			The team to spawn enemies from.
	-- @param #int numDudes		Must be greater than 0. Number of enemies to spawn from team.
	-- @param #int spawnValue	Must be greater than 0. If bIsTimerSpawnActive, this is the timer value to input to the timer that spawns the next wave. If not bIsTimerSpawnActive, this is the required number of dead enemies to trigger the next wave.
	spawnClasses = nil
	spawnClasses = {}
	
	
	if zoneID == "S0_Hangar" then
		
		waveToStopTiming = 0	-- The wave index (int) to switch from timer-based spawning to killcount-based.
		bIsTimerSpawnActive = true	-- True, wave spawning is timer-based. False, wave spawning is killcount-based.
		
		spawnClasses[1] = {team = GethPawns,	numDudes = 4,	spawnValue = 3, spawnPath = "cz_hangar_enemyspawn"}
		spawnClasses[2] = {team = GethPawns,	numDudes = 3, 	spawnValue = 3, spawnPath = "cz_hangar_enemyspawn"}
		spawnClasses[3] = {team = GethPawns,	numDudes = 3, 	spawnValue = 3, spawnPath = "cz_hangar_enemyspawn"}
		spawnClasses[4] = {team = GethPawns,	numDudes = 3, 	spawnValue = 3, spawnPath = "cz_hangar_enemyspawn"}
		spawnClasses[5] = {team = GethPawns,	numDudes = 3, 	spawnValue = 3, spawnPath = "cz_hangar_enemyspawn"}
		spawnClasses[6] = {team = GethTacticals,numDudes = 3, 	spawnValue = 3, spawnPath = "cz_hangar_enemyspawn"}
		
		BlockCombatZoneExits(0)
		
	elseif zoneID == "S0_CargoBay" then
		
		waveToStopTiming = 0	-- The wave index (int) to switch from timer-based spawning to killcount-based.
		bIsTimerSpawnActive = true	-- True, wave spawning is timer-based. False, wave spawning is killcount-based.
		
		spawnClasses[1] = {team = GethPawns,	numDudes = 4, 	spawnValue = 3, spawnPath = "cz_cargo_enemyspawn"}
		spawnClasses[2] = {team = GethPawns,	numDudes = 3, 	spawnValue = 3, spawnPath = "cz_cargo_enemyspawn"}
		spawnClasses[3] = {team = GethTacticals,numDudes = 3, 	spawnValue = 3, spawnPath = "cz_cargo_enemyspawn"}
		spawnClasses[4] = {team = GethTacticals,numDudes = 3, 	spawnValue = 3, spawnPath = "cz_cargo_enemyspawn"}
		spawnClasses[5] = {team = GethSpecials,	numDudes = 3, 	spawnValue = 3, spawnPath = "cz_cargo_enemyspawn"}
		spawnClasses[6] = {team = GethSpecials,	numDudes = 3, 	spawnValue = 3, spawnPath = "cz_cargo_enemyspawn"}
		spawnClasses[7] = {team = GethSpecials,	numDudes = 3, 	spawnValue = 3, spawnPath = "cz_cargo_enemyspawn"}
		
		BlockCombatZoneExits(0)
		
	elseif zoneID == "S0_Reception" then
		
		waveToStopTiming = 0	-- The wave index (int) to switch from timer-based spawning to killcount-based.
		bIsTimerSpawnActive = true	-- True, wave spawning is timer-based. False, wave spawning is killcount-based.
		
		spawnClasses[1] = {team = GethPawns,	numDudes = 4,	spawnValue = 3, spawnPath = "cz_reception_enemyspawn"}
		spawnClasses[2] = {team = GethPawns,	numDudes = 3, 	spawnValue = 3, spawnPath = "cz_reception_enemyspawn"}
		spawnClasses[3] = {team = GethPawns,	numDudes = 3, 	spawnValue = 3, spawnPath = "cz_reception_enemyspawn"}
		spawnClasses[4] = {team = GethPawns,	numDudes = 3, 	spawnValue = 3, spawnPath = "cz_reception_enemyspawn"}
		spawnClasses[5] = {team = GethTacticals,numDudes = 3, 	spawnValue = 3, spawnPath = "cz_reception_enemyspawn"}
		spawnClasses[6] = {team = GethTacticals,numDudes = 3, 	spawnValue = 3, spawnPath = "cz_reception_enemyspawn"}
		spawnClasses[7] = {team = GethSpecials,	numDudes = 3, 	spawnValue = 3, spawnPath = "cz_reception_enemyspawn"}
		spawnClasses[8] = {team = GethSpecials,	numDudes = 3, 	spawnValue = 3, spawnPath = "cz_reception_enemyspawn"}
		spawnClasses[9] = {team = GethSpecials,	numDudes = 2, 	spawnValue = 3, spawnPath = "cz_reception_enemyspawn"}
		
		BlockCombatZoneExits(0)
		
	elseif zoneID == "S0_Management" then
		
		waveToStopTiming = 0	-- The wave index (int) to switch from timer-based spawning to killcount-based.
		bIsTimerSpawnActive = true	-- True, wave spawning is timer-based. False, wave spawning is killcount-based.
		
		spawnClasses[1] = {team = GethPawns,	numDudes = 4,	spawnValue = 3, spawnPath = "cz_management_enemyspawn"}
		spawnClasses[2] = {team = GethPawns,	numDudes = 3, 	spawnValue = 3, spawnPath = "cz_management_enemyspawn"}
		spawnClasses[3] = {team = GethPawns,	numDudes = 3, 	spawnValue = 3, spawnPath = "cz_management_enemyspawn"}
		spawnClasses[4] = {team = GethPawns,	numDudes = 3, 	spawnValue = 3, spawnPath = "cz_management_enemyspawn"}
		spawnClasses[5] = {team = GethTacticals,numDudes = 3, 	spawnValue = 3, spawnPath = "cz_management_enemyspawn"}
		spawnClasses[6] = {team = GethTacticals,numDudes = 3, 	spawnValue = 3, spawnPath = "cz_management_enemyspawn"}
		spawnClasses[7] = {team = GethTacticals,numDudes = 3, 	spawnValue = 3, spawnPath = "cz_management_enemyspawn"}
		spawnClasses[8] = {team = GethSpecials,	numDudes = 3, 	spawnValue = 3, spawnPath = "cz_management_enemyspawn"}
		spawnClasses[9] = {team = GethSpecials,	numDudes = 3, 	spawnValue = 3, spawnPath = "cz_management_enemyspawn"}
		spawnClasses[10] = {team = GethSpecials,	numDudes = 3, 	spawnValue = 3, spawnPath = "cz_management_enemyspawn"}
		spawnClasses[11] = {team = GethHeavys,	numDudes = 2, 	spawnValue = 3, spawnPath = "cz_management_enemyspawn"}
		
		BlockCombatZoneExits(0)
		
	elseif zoneID == "S0_CommsControl" then
		
		waveToStopTiming = 0	-- The wave index (int) to switch from timer-based spawning to killcount-based.
		bIsTimerSpawnActive = true	-- True, wave spawning is timer-based. False, wave spawning is killcount-based.
		
		spawnClasses[1] = {team = GethSpecials,	numDudes = 4, 	spawnValue = 3, spawnPath = "cz_comms_enemyspawn"}
		spawnClasses[2] = {team = GethSpecials,	numDudes = 3, 	spawnValue = 3, spawnPath = "cz_comms_enemyspawn"}
		spawnClasses[3] = {team = GethSpecials,	numDudes = 3, 	spawnValue = 3, spawnPath = "cz_comms_enemyspawn"}
		spawnClasses[4] = {team = GethSpecials,	numDudes = 3, 	spawnValue = 3, spawnPath = "cz_comms_enemyspawn"}
		spawnClasses[5] = {team = GethSpecials,	numDudes = 3, 	spawnValue = 3, spawnPath = "cz_comms_enemyspawn"}
		spawnClasses[6] = {team = GethHeavys,	numDudes = 3, 	spawnValue = 3, spawnPath = "cz_comms_enemyspawn"}
		
		BlockCombatZoneExits(0)
		
	elseif zoneID == "S0_PowerControl" then
		
		waveToStopTiming = 0	-- The wave index (int) to switch from timer-based spawning to killcount-based.
		bIsTimerSpawnActive = true	-- True, wave spawning is timer-based. False, wave spawning is killcount-based.
		
		spawnClasses[1] = {team = GethPawns,	numDudes = 3,	spawnValue = 3, spawnPath = "cz_power_enemyspawn"}
		spawnClasses[2] = {team = GethPawns,	numDudes = 3, 	spawnValue = 3, spawnPath = "cz_power_enemyspawn"}
		spawnClasses[3] = {team = GethPawns,	numDudes = 3, 	spawnValue = 3, spawnPath = "cz_power_enemyspawn"}
		spawnClasses[4] = {team = GethTacticals,numDudes = 3, 	spawnValue = 3, spawnPath = "cz_power_enemyspawn"}
		spawnClasses[5] = {team = GethSpecials,	numDudes = 3, 	spawnValue = 3, spawnPath = "cz_power_enemyspawn"}
		spawnClasses[6] = {team = GethSpecials,	numDudes = 3, 	spawnValue = 3, spawnPath = "cz_power_enemyspawn"}
		spawnClasses[7] = {team = GethHeavys,	numDudes = 2, 	spawnValue = 3, spawnPath = "cz_power_enemyspawn"}
		
		BlockCombatZoneExits(0)
		
	else
		print("EURn_c.SetupCombatZoneInit(): Argument #0  combatZoneID  invalid!")
	end
end

---
-- This is called when all the enemies in combat zone 'combatZoneID' are dead.
-- @param #string combatZoneID The number of the zone ID to set up.
function ReleaseCombatZone(combatZoneID)
		print("EURn_c.ReleaseCombatZone(): Entered")
	
	local zoneID = combatZoneID
	
		print("EURn_c.ReleaseCombatZone(): Releasing combat zone "..zoneID)
		
	if zoneID == "S0_Hangar" then
		-- Switch back to exploration music
		ScriptCB_PlayInGameMusic("eur_amb_explore_01a")
		
		UnblockCombatZoneExits(0)
		
	elseif zoneID == "S0_CargoBay" then
		-- Switch back to exploration music
		ScriptCB_PlayInGameMusic("eur_amb_explore_01a")
		
		UnblockCombatZoneExits(0)
		
	elseif zoneID == "S0_Reception" then
		-- Switch back to exploration music
		ScriptCB_PlayInGameMusic("eur_amb_explore_01a")
		
		UnblockCombatZoneExits(0)
		
	elseif zoneID == "S0_Management" then
		-- Switch back to exploration music
		ScriptCB_PlayInGameMusic("eur_amb_explore_01a")
		
		UnblockCombatZoneExits(0)
		
	elseif zoneID == "S0_CommsControl" then
		-- Switch back to exploration music
		ScriptCB_PlayInGameMusic("eur_amb_explore_01a")
		
		UnblockCombatZoneExits(0)
		
	elseif zoneID == "S0_PowerControl" then
		-- Switch back to exploration music
		ScriptCB_PlayInGameMusic("eur_amb_explore_01a")
		
		UnblockCombatZoneExits(0)
		
		SetTimerValue(ObjectivesTimer, 5.0)
		StartTimer(ObjectivesTimer)
		
		ObjectivesTimerElapse = OnTimerElapse(
			function(timer)
	    		MissionVictory(REP)
				StopTimer(ObjectivesTimer)
			end,
		ObjectivesTimer
		)
		
	end
end

---
-- Starts and sets up the event logic for combat zone 'combatZoneID'.
-- @param #string combatZoneID The name of the zone ID to set up.
-- @param #string combatMusicID The music ID to start playing.
function StartCombatZone(combatZoneID, combatMusicID)
		print("EURn_c.StartCombatZone(\""..combatZoneID.."\", \""..combatMusicID.."\"): Entered")
		
	local zoneID = combatZoneID
	--local spawnPathName = enemySpawnPathName
	local musicID = combatMusicID
	
		print("EURn_c.StartCombatZone(): Starting combat zone "..zoneID)
		--print("EURn_c.StartCombatZone(): enemySpawnPathName:", spawnPathName)
	
	-- debug text
	ShowMessageText("level.EUR.debug.comzone_entered", REP)
	ShowMessageText("level.EUR.debug.comzone_spawning", REP)
	
	bIsTimerSpawnActive = true
	waveToStopTiming = 3
	
	
	-- Reset the total enemy counter
	totalEnemies = 0
	
	-- Reset the number of waves for this combat zone
	totalWaves = 0
	
	
	-- Count the total number of enemies and store it
	for i in pairs(spawnClasses) do
		-- Which wave are we looking at?
		totalWaves = totalWaves + 1
		
		-- Count the total number of enemies for OnObjectKill in the future
		totalEnemies = totalEnemies + spawnClasses[i]['numDudes']
		
		-- Print the results
		print("EURn_c.StartCombatZone(): table values:", spawnClasses[i]['team'], spawnClasses[i]['numDudes'])
	end
	
	print("EURn_c.StartCombatZone(): totalEnemies:", totalEnemies)
	
	
	-- Set enemiesRemaining to keep track of the remaining enemies
	enemiesRemaining = totalEnemies
	print("EURn_c.StartCombatZone(): enemiesRemaining:", enemiesRemaining)
	
	-- Set the AI goals
	ClearAIGoals(GethPawns)
	ClearAIGoals(GethTacticals)
	ClearAIGoals(GethSpecials)
	ClearAIGoals(GethHeavys)
	ClearAIGoals(GethPrimes)
	
	AddAIGoal(GethPawns, "Deathmatch", 20)
	AddAIGoal(GethPawns, "Destroy", 100, 0)
	
	AddAIGoal(GethTacticals, "Deathmatch", 20)
	AddAIGoal(GethTacticals, "Destroy", 100, 0)
	
	AddAIGoal(GethSpecials, "Deathmatch", 20)
	AddAIGoal(GethSpecials, "Destroy", 100, 0)
	
	AddAIGoal(GethHeavys, "Deathmatch", 20)
	AddAIGoal(GethHeavys, "Destroy", 100, 0)
	
	AddAIGoal(GethPrimes, "Destroy", 100, 0)
	
	-- Are we starting with a timer spawn?
	if bIsTimerSpawnActive == true then
		-- Set and start the timer
		SetTimerValue(spawnDelayTimer, spawnClasses[currentWave]['spawnValue'])
		StartTimer(spawnDelayTimer)
	end
	
	-- Start playing combat music
	ScriptCB_PlayInGameMusic(musicID)
	
	print("EURn_c.StartCombatZone(): Spawning "..spawnClasses[currentWave]['numDudes'].." enemies from team "..spawnClasses[currentWave]['team'].." at spawnPath:", spawnClasses[currentWave]['spawnPath'])
	Ambush(spawnClasses[currentWave]['spawnPath'], spawnClasses[currentWave]['numDudes'], spawnClasses[currentWave]['team'])
	
	
	
	killCount = 0
	numEnemiesAlive = 0
	
	-- Spawn delay timer
	OnTimerElapse(
		function(timer)
			-- If there's any enemies remaining
			if enemiesRemaining > 0 then
				if currentWave < (totalWaves + 1) then
					--print("EURn_c.StartCombatZone(): Running SpawnNextWave("..spawnClasses[currentWave]['spawnPath']..")")
					-- Spawn the next wave of enemies
					SpawnNextWave()
					
					if bIsTimerSpawnActive == true then
						SetTimerValue(spawnDelayTimer, spawnClasses[currentWave]['spawnValue'])
						StartTimer(spawnDelayTimer)
					end
				else
					StopTimer(spawnDelayTimer)
				end
			end
		end,
	spawnDelayTimer
	)
	
	CombatZoneEnemyKill = OnObjectKill(
	function(object, killer)
	
		numEnemiesAlive = GetNumTeamMembersAliveInTable(enemyTeams)
		
		print("EURn_c.StartCombatZone(): numEnemiesAlive: "..numEnemiesAlive, "currentWave: "..currentWave, "totalWaves: "..totalWaves)
    		
		-- Are all the enemies gone?
		if (numEnemiesAlive == 0) and (currentWave >= totalWaves) then
			print("EURn_c.StartCombatZone(): Combat zone cleared")
			ShowMessageText("level.EUR.debug.comzone_done", REP)
			
			-- Finish up the combat zone
			ReleaseCombatZone(zoneID)
			
			-- Garbage collection
			ReleaseObjectKill(CombatZoneEnemyKill)
			CombatZoneEnemyKill = nil
		return end
		
    	if killer and ((GetObjectTeam(object) == GethPawns) or (GetObjectTeam(object) == GethTacticals) or (GetObjectTeam(object) == GethHeavys) or (GetObjectTeam(object) == GethSpecials) or (GetObjectTeam(object) == GethPrimes)) then
    		ShowMessageText("level.EUR.debug.comzone_kill", REP)
    		
    		enemiesRemaining = enemiesRemaining - 1
    		numKilled = numKilled + 1
    		killCount = killCount + 1
    		print("EURn_c.StartCombatZone(): enemiesRemaining:", enemiesRemaining)
    		print("EURn_c.StartCombatZone(): killCount:", killCount)
    		
    		-- Killcount
    		if bIsTimerSpawnActive == false then
    			
    			-- If there's any enemies remaining
    			if enemiesRemaining > 0 then
					-- If the current wave is less than the total number of waves+1
					if currentWave < (totalWaves + 1) then
						-- Is the # enemies killed the same as 
			    		if numKilled == spawnClasses[currentWave]['spawnValue'] then
			    			--print("EURn_c.StartCombatZone().Killcount: Running SpawnNextWave("..spawnPathName..")")
			    			
							-- Spawn the next wave of enemies
							SpawnNextWave()
						end
					end
				end
			
			-- Timer
			else
    			-- If there's any enemies remaining
    			if enemiesRemaining > 0 then
					-- Are we still within the range of waves?
					if currentWave < (totalWaves + 1) then
		    			--print("EURn_c.StartCombatZone().Timer: Running SpawnNextWave("..spawnPathName..")")
		    			
						-- Spawn the next wave of enemies
						SpawnNextWave()
						
						SetTimerValue(spawnDelayTimer, spawnClasses[currentWave]['spawnValue'])
						StartTimer(spawnDelayTimer)
					else
						StopTimer(spawnDelayTimer)
					end
				end
			end
			
    	end
	end
	)
end

---
-- Spawns the next wave.
function SpawnNextWave()
		print("EURn_c.SpawnNextWave(): Entered")
		
	--local spawnPathName = enemySpawnPath
	
	-- Are there any enemies remaining?
	if enemiesRemaining > 0 then
		
		-- Are we on the final wave?
		if bIsFinalWave == false then
			print("EURn_c.SpawnNextWave(): Incrementing wave")
			
			-- Update the wave index
			currentWave = currentWave + 1
			
			-- Is the current wave greater than or equal to the total number of waves?
			if currentWave >= totalWaves then
				print("EURn_c.SpawnNextWave(): NOTICE: Final wave")
				
				-- Let the player know they're on the final wave
				ShowMessageText("level.EUR.debug.comzone_finalwave", REP)
				
				-- If so, set this to true
				bIsFinalWave = true
			end
			
			-- Spawn the next wave
			print("EURn_c.SpawnNextWave(): Spawning wave "..currentWave)
			ShowMessageText("level.EUR.debug.comzone_spawning", REP)
			
			print("EURn_c.SpawnNextWave(): Spawning "..spawnClasses[currentWave]['numDudes'].." enemies from team "..spawnClasses[currentWave]['team'].." at spawnPath:", spawnClasses[currentWave]['spawnPath'])
			
			Ambush(spawnClasses[currentWave]['spawnPath'], spawnClasses[currentWave]['numDudes'], spawnClasses[currentWave]['team'])
		else
			print("EURn_c.SpawnNextWave(): Final wave complete! Exiting function...")
		return end
		
		-- And reset the killcount for the next wave
		numKilled = 0
		
		-- Are we on the right wave to switch from timer trigger to killcount trigger?
		if currentWave == waveToStopTiming then
				print("EURn_c.SpawnNextWave(): Switching from timer to killcount")
			ShowMessageText("level.EUR.debug.comzone_timeroff")
			bIsTimerSpawnActive = false
		end
	else
		print("EURn_c.SpawnNextWave(): No enemies remaining!")
	return end
end

function ScriptPostLoad()
	ScriptCB_SetGameRules("campaign")
	AllowAISpawn(REP, false)	-- Only the player can spawn from REP team
	AllowAISpawn(SQD, false)	-- Squad isn't allowed to spawn before the player's first spawn
	--[[AllowAISpawn(2, false)
	AllowAISpawn(3, false)
	AllowAISpawn(4, false)
	AllowAISpawn(5, false)
	AllowAISpawn(6, false)
	AllowAISpawn(7, false)]]
	SetReinforcementCount(CIS, -1)
	
	SetProperty("testconsole", "MaxHealth", 999999)
	SetProperty("testconsole", "CurHealth", 0)
	KillObject("testconsole")
	
	SetProperty("hangar_console", "MaxHealth", 999999)
	SetProperty("hangar_console", "CurHealth", 0)
	KillObject("hangar_console")
	
	SetProperty("elevator_1_doors_top", "IsLocked", "1")
	SetProperty("elevator_1_doors_bottom", "IsLocked", "1")
	SetProperty("start_doors", "IsLocked", "1")
	
	-- Elevator 1 plans
	BlockPlanningGraphArcs(1)
    
    
    --This defines the CPs.  These need to happen first
    --cp1 = CommandPost:New{name = "cp1"}
    --cp2 = CommandPost:New{name = "cp2"}
    
    --This sets up the actual objective.  This needs to happen after cp's are defined
    ObjectiveCampaign = Objective:New{teamATT = ATT, teamDEF = DEF, 
                                     text = "level.eur.objectives.1", 
                                     popupText = "level.eur.objectives.1_popup", 
                                     multiplayerRules = false }
    
    --This adds the CPs to the objective.  This needs to happen after the objective is set up
    --ObjectiveCampaign:AddCommandPost(cp1)
    --ObjectiveCampaign:AddCommandPost(cp2)
	
    EnableSPScriptedHeroes()
    ScriptCB_EnableHeroMusic(0)
    
    
    defenseBuff = 1.75
    
    SetClassProperty(gth_inf_trooper, "MaxHealth", 230*defenseBuff)
    SetClassProperty(gth_inf_trooper, "MaxShields", 520*defenseBuff)
    SetClassProperty(gth_inf_trooper, "MaxSpeed", "4.1")
    SetClassProperty(gth_inf_trooper, "MaxStrafeSpeed", "4.1")
    
    SetClassProperty(gth_inf_rocketeer, "MaxHealth", 250*defenseBuff)
    SetClassProperty(gth_inf_rocketeer, "MaxShields", 480*defenseBuff)
    SetClassProperty(gth_inf_rocketeer, "MaxSpeed", "4.1")
    SetClassProperty(gth_inf_rocketeer, "MaxStrafeSpeed", "4.1")
    
    SetClassProperty(gth_inf_sniper, "MaxHealth", 230*defenseBuff)
    SetClassProperty(gth_inf_sniper, "MaxShields", 500*defenseBuff)
    SetClassProperty(gth_inf_sniper, "MaxSpeed", "4.1")
    SetClassProperty(gth_inf_sniper, "MaxStrafeSpeed", "4.1")
    
    SetClassProperty(gth_inf_machinist, "MaxHealth", 230*defenseBuff)
    SetClassProperty(gth_inf_machinist, "MaxShields", 660*defenseBuff)
    SetClassProperty(gth_inf_machinist, "MaxSpeed", "4.1")
    SetClassProperty(gth_inf_machinist, "MaxStrafeSpeed", "4.1")
    
    SetClassProperty(gth_inf_shock, "MaxHealth", 400*defenseBuff)
    SetClassProperty(gth_inf_shock, "MaxShields", 550*defenseBuff)
    SetClassProperty(gth_inf_shock, "MaxSpeed", "3.45")
    SetClassProperty(gth_inf_shock, "MaxStrafeSpeed", "3.45")
    
    SetClassProperty(gth_inf_hunter, "MaxHealth", 300*defenseBuff)
    SetClassProperty(gth_inf_hunter, "MaxShields", 720*defenseBuff)
    SetClassProperty(gth_inf_hunter, "MaxSpeed", "3.5")
    SetClassProperty(gth_inf_hunter, "MaxStrafeSpeed", "3.5")
    
    SetClassProperty(gth_inf_destroyer, "MaxHealth", 700*defenseBuff)
    SetClassProperty(gth_inf_destroyer, "MaxShields", 720*defenseBuff)
    SetClassProperty(gth_inf_destroyer, "MaxSpeed", "2.55")
    SetClassProperty(gth_inf_destroyer, "MaxStrafeSpeed", "2.55")
    
    SetClassProperty(gth_inf_juggernaut, "MaxHealth", 900*defenseBuff)
    SetClassProperty(gth_inf_juggernaut, "MaxShields", 840*defenseBuff)
    SetClassProperty(gth_inf_juggernaut, "MaxSpeed", "2.4")
    SetClassProperty(gth_inf_juggernaut, "MaxStrafeSpeed", "2.4")
    
    
	ClearAIGoals(SQD)
	AddAIGoal(SQD, "Defend", 100, 0)	-- Player's squad defends the player.
	
	-- Set up spawn delay timer
	spawnDelayTimer = CreateTimer("spawnDelayTimer")
	SetTimerValue(spawnDelayTimer, 4)
	ShowTimer(spawnDelayTimer)
    
    SetRespawnPoint("playerspawn_start")
	
	
	--==========================
	-- FIRST SPAWN
	--==========================
	
	ObjectivesTimerElapse = OnTimerElapse(
		function(timer)
			ReleaseTimerElapse(ObjectivesTimerElapse)
			ObjectivesTimerElapse = nil
    		ObjectiveCampaign:Start()
    		
    		--PlayCinematic("cinematic_test", "eur_prop_camera")
    		--StartTimer(CinematicTimer)
    		--StartTimer(ZoomTimer)
    		
			StopTimer(ObjectivesTimer)
		end,
	ObjectivesTimer
	)
	
    onfirstspawn = OnCharacterSpawn(
    function(character)
        if character == 0 then
            ReleaseCharacterSpawn(onfirstspawn)
            onfirstspawn = nil
            
            -- Start the objectives delay
        	StartTimer(ObjectivesTimer)
            
            ScriptCB_EnableCommandPostVO(0)
            ScriptCB_PlayInGameMusic("eur_amb_explore_01a")
            
            -- Allow the player's squad to spawn
            AllowAISpawn(SQD, true)
        end
    end
    )
	
	
	--==========================
	-- COMBAT ZONE : HANGAR
	--==========================
    
    MapAddEntityMarker("hangar_console", "hud_objective_icon", 3.0, ATT, "YELLOW", true)
	HangarConsoleActivate = OnObjectRepairName(
		function(objPtr, characterId)
			-- Test output
			print("EURn_c.HangarConsoleActivate: Interaction received")
			ShowMessageText("level.EUR.interactions.test.received")
			
			
			-- Set up init params for combat zone 1
			SetupCombatZoneInit("S0_Hangar")
			
			-- Start combat zone 1
			StartCombatZone("S0_Hangar", "eur_amb_combat_01a")
			
			-- Update the player's respawn point
			SetRespawnPoint("ps_s0_hangar")
			
			
			MapRemoveEntityMarker("hangar_console")
			ReleaseObjectRepair(HangarConsoleActivate)
			HangarConsoleActivate = nil
		end,
	"hangar_console"
	)
	
	
	--==========================
	-- COMBAT ZONE : CARGO BAY
	--==========================
	
	ActivateRegion("cz_s0_cargo")
	CZ_CargoBay = OnEnterRegion(
		function(region, player)
			if IsCharacterHuman(player) then
				print("EURn_c.CZ_CargoBay: Entered region")
				
				-- Set up init params for combat zone 2
				SetupCombatZoneInit(2)
				
				-- Start combat zone 2
				StartCombatZone(2, "eur_amb_combat_01a")
				
				-- Update the player's respawn point
				SetRespawnPoint("ps_s0_cargo")
				
				ReleaseEnterRegion(CZ_CargoBay)
				CZ_CargoBay = nil
				
				DeactivateRegion("cz_s0_cargo")
			end
		end,
	"cz_s0_cargo"
	)
	
	-- Spawn the first wave
	--SetupAmbushTrigger("comzone_1", "enemyspawn_1", spawnClasses[currentWave]['numDudes'], spawnClasses[currentWave]['team'])
	
	
	
	Elevator1_Timer = CreateTimer("elevator_1_timer")
	SetTimerValue(Elevator1_Timer, 25)
	
	OnTimerElapse(
		function(timer)
			-- Unlock the doors
			SetProperty("elevator_1_doors_top", "IsLocked", "1")
			SetProperty("elevator_1_doors_bottom", "IsLocked", "0")
		
			DisableBarriers("elevator1_1")
			DisableBarriers("elevator1_2")
			
			UnblockPlanningGraphArcs(1)
			
			StopTimer(Elevator1_Timer)
		end,
	Elevator1_Timer
	)
	
	ActivateRegion("elevator_1_trigger")
	Elevator1_Trigger = OnEnterRegion(
		function(region, player)
			if IsCharacterHuman(player) then
			
				-- Close and lock the doors
				SetProperty("elevator_1_doors_top", "IsLocked", "1")
				SetProperty("elevator_1_doors_bottom", "IsLocked", "1")
			
				EnableBarriers("elevator1_1")
				EnableBarriers("elevator1_2")
				
				BlockPlanningGraphArcs(1)
				
				-- Start moving the elevator car
				PlayAnimation("elevator_1")
				
				StartTimer(Elevator1_Timer)
				
				ReleaseEnterRegion(Elevator1_Trigger)
				DeactivateRegion("elevator_1_trigger")
			end
		end,
	"elevator_1_trigger"
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
    
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\Load\\eur.lvl")
	
	SetMemoryPoolSize("ParticleTransformer::ColorTrans", 2188)
	SetMemoryPoolSize("ParticleTransformer::PositionTr", 1293)
	SetMemoryPoolSize("ParticleTransformer::SizeTransf", 1409)
	
	PreLoadStuff()
	
	-- Player's teammates' aggressiveness
	SetTeamAggressiveness(3, (0.94))
	
	-- The enemies' aggressiveness
	SetTeamAggressiveness(2, (0.98))
	SetTeamAggressiveness(4, (0.98))
	SetTeamAggressiveness(5, (0.98))
	SetTeamAggressiveness(6, (0.98))
	SetTeamAggressiveness(7, (0.98))
	
	SetMinFlyHeight(-300)
	SetMinPlayerFlyHeight(-300)
    SetMaxFlyHeight(16)
    SetMaxPlayerFlyHeight(16)
	AISnipeSuitabilityDist(45)
	SetAttackerSnipeRange(35)
	SetDefenderSnipeRange(55)
    
    --
    -- Sides setup begin
    --
    
	LoadSSV(true)
	LoadGTH()
	
	-- Player classes
	
	SetupTeams{
	rep = {
		team = REP,
		units = 1,
		reinforcements = -1,	-- 5
		soldier  = { "ssv_inf_cooper_soldier",0, 1},
		sniper  = { "ssv_inf_cooper_infiltrator",0, 1},
		adept = { "ssv_inf_cooper_adept",0, 1},
		engineer   = { "ssv_inf_cooper_engineer",0, 1},
		sentinel = { "ssv_inf_cooper_sentinel",0, 1},
		vanguard = { "ssv_inf_cooper_vanguard",0, 1},
		}
	}
	
	-- Player squad team classes
	
	SetTeamName(3, REP)
	AddUnitClass(3, ssv_inf_soldier, 1)
	AddUnitClass(3, ssv_inf_infiltrator, 1)
	AddUnitClass(3, ssv_inf_engineer, 1)
	AddUnitClass(3, ssv_inf_adept, 1)
	--AddUnitClass(3, ssv_inf_sentinel, 1)
	--AddUnitClass(3, ssv_inf_vanguard, 1)
	SetUnitCount(3, 4)
    
    -- Geth classes
    
    SetTeamName(GethPawns, CIS)
	SetTeamIcon(GethPawns, "cis_icon")
    AddUnitClass(GethPawns, gth_inf_trooper, 7)
    AddUnitClass(GethPawns, gth_inf_rocketeer, 3)
    SetUnitCount(GethPawns, 20)
    
    SetTeamName(GethTacticals, CIS)
	SetTeamIcon(GethTacticals, "cis_icon")
    AddUnitClass(GethTacticals, gth_inf_sniper, 4)
    AddUnitClass(GethTacticals, gth_inf_hunter, 3)
    SetUnitCount(GethTacticals, 20)
    
    SetTeamName(GethSpecials, CIS)
	SetTeamIcon(GethSpecials, "cis_icon")
    AddUnitClass(GethSpecials, gth_inf_machinist, 4)
    AddUnitClass(GethSpecials, gth_inf_shock, 4)
    SetUnitCount(GethSpecials, 20)
    
    SetTeamName(GethHeavys, CIS)
	SetTeamIcon(GethHeavys, "cis_icon")
    AddUnitClass(GethHeavys, gth_inf_destroyer, 3)
    AddUnitClass(GethHeavys, gth_inf_juggernaut, 2)
    SetUnitCount(GethHeavys, 20)
    
    SetTeamName(GethPrimes, CIS)
	SetTeamIcon(GethPrimes, "cis_icon")
    AddUnitClass(GethPrimes, "gth_hero_prime_me2", 2)
    SetUnitCount(GethPrimes, 20)
    
    -- Team relationships
    
    SetTeamAsFriend(REP, SQD)
	SetTeamAsFriend(SQD, REP)
	
	SetTeamAsFriend(GethPawns, GethTacticals)
	SetTeamAsFriend(GethPawns, GethSpecials)
	SetTeamAsFriend(GethPawns, GethHeavys)
	SetTeamAsFriend(GethPawns, GethPrimes)
	SetTeamAsFriend(GethTacticals, GethPawns)
	SetTeamAsFriend(GethTacticals, GethSpecials)
	SetTeamAsFriend(GethTacticals, GethHeavys)
	SetTeamAsFriend(GethTacticals, GethPrimes)
	SetTeamAsFriend(GethSpecials, GethPawns)
	SetTeamAsFriend(GethSpecials, GethTacticals)
	SetTeamAsFriend(GethSpecials, GethHeavys)
	SetTeamAsFriend(GethSpecials, GethPrimes)
	SetTeamAsFriend(GethHeavys, GethPawns)
	SetTeamAsFriend(GethHeavys, GethTacticals)
	SetTeamAsFriend(GethHeavys, GethSpecials)
	SetTeamAsFriend(GethHeavys, GethPrimes)
	SetTeamAsFriend(GethPrimes, GethPawns)
	SetTeamAsFriend(GethPrimes, GethTacticals)
	SetTeamAsFriend(GethPrimes, GethSpecials)
	SetTeamAsFriend(GethPrimes, GethHeavys)
	
	SetTeamAsEnemy(REP, GethPawns)
	SetTeamAsEnemy(REP, GethTacticals)
	SetTeamAsEnemy(REP, GethSpecials)
	SetTeamAsEnemy(REP, GethHeavys)
	SetTeamAsEnemy(REP, GethPrimes)
	SetTeamAsEnemy(SQD, GethPawns)
	SetTeamAsEnemy(SQD, GethTacticals)
	SetTeamAsEnemy(SQD, GethSpecials)
	SetTeamAsEnemy(SQD, GethHeavys)
	SetTeamAsEnemy(SQD, GethPrimes)
	
	SetTeamAsEnemy(GethPawns, REP)
	SetTeamAsEnemy(GethPawns, SQD)
	SetTeamAsEnemy(GethTacticals, REP)
	SetTeamAsEnemy(GethTacticals, SQD)
	SetTeamAsEnemy(GethSpecials, REP)
	SetTeamAsEnemy(GethSpecials, SQD)
	SetTeamAsEnemy(GethHeavys, REP)
	SetTeamAsEnemy(GethHeavys, SQD)
	SetTeamAsEnemy(GethPrimes, REP)
	SetTeamAsEnemy(GethPrimes, SQD)
	
	--
	-- Sides setup end
	--
	
	--ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_EUR_Streaming.lvl")
	
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
	SetMemoryPoolSize("SoldierAnimation", 410)
    SetMemoryPoolSize("SoundSpaceRegion", 64)
    SetMemoryPoolSize("TreeGridStack", 1024)
	SetMemoryPoolSize("UnitAgent", 128)
	SetMemoryPoolSize("UnitController", 128)
	SetMemoryPoolSize("Weapon", weaponCnt)
    
    SetSpawnDelay(10.0, 0.25)
    ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ME5\\EUR.lvl", "EUR_campaign")
    SetDenseEnvironment("true")
    --AddDeathRegion("deathregion")
	
	
    -- Sound
    
	--Music04(4)
	
	MusicVariation = 4
	OpenMusicStreams()
	
	OpenAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_EUR_Streaming.lvl",  "EUR_ambiance")
	--OpenAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_EUR_Streaming.lvl",  "EUR_ambiance")

    SoundFX()


-- Opening Satellite Shots
	AddCameraShot(0.311518, -0.039204, -0.942001, -0.118549, -148.629410, 3.808583, 74.864357);
	
	PostLoadStuff()
end
