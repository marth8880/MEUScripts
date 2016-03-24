-----------------------------------------------------------------
-----------------------------------------------------------------
-- MASS EFFECT: UNIFICATION Combat Manager Script by A. Gilbert
-- Version 30318/06
-- Screen Names: Marth8880, GT-Marth8880, [GT] Marth8880, [GT] Bran
-- E-Mail: Marth8880@gmail.com
-- Mar 18, 2016
-- Copyright (c) 2016 A. Gilbert.
-- 
-- 
-- PURPOSE:
-- Largely based on MultiObjectiveContainer.lua
--  Manages a table of a chain of camera shots. Basically, there are 
--  one or more camera shots in a cinematic sequence. When a shot 
--	finishes, it moves onto the next shot. When all of the shots 
--	are completed, it exits the cinematic.
--
--
-- USAGE:
-- 1. Load the script using ScriptCB_DoFile() in your main mission script.
-- 2. Initialize WaveSequence:New{} into a variable. Example: 
-- 
-- 		testCinematicSequence = WaveSequence:New{pathName = "playerspawn_start"}
-- 
-- 3. Call :AddShot() on your WaveSequence variable for each CameraShot:New{} variable you assigned previous to WaveSequence:New{}. Example: 
-- 
-- 		testCinematicSequence:AddShot(TestShot1)
-- 		testCinematicSequence:AddShot(TestShot2)
-- 		<...>
-- 		testCinematicSequence:AddShot(TestShot6)
-- 
-- 4. After you've done step 3 for each shot, call :Start() on your WaveSequence variable to start the cinematic. Example: 
-- 
-- 		testCinematicSequence:Start()
-- 
-- 5. WaveSequence includes a Start() and Complete() function that you can override to add extra behavior when the cinematic starts or ends.
--  To do so, call .OnStart() or .OnComplete() somewhere in your mission script and assign a new function to it. Example: 
-- 
-- 		testCinematicSequence.OnStart() = function(self)
-- 			-- do stuff
-- 		end
-- 		
-- 		testCinematicSequence.OnComplete() = function(self)
-- 			-- do stuff
-- 		end
-- 		
-- 	NOTE: You can only override these functions BEFORE :Start() has been called!
-- 
-- 
-- LEGAL:
-- This script is free software: you can redistribute it and/or modify 
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
-- 
-- This script is distributed in the hope that it will be useful, 
-- but WITHOUT ANY WARRANTY; without even the implied warranty of 
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the 
-- GNU General Public License for more details.
-- 
-- You should have received a copy of the GNU General Public License 
-- along with this script.  If not, see <http://www.gnu.org/licenses/>.
-- 
-- 
-- THIS SCRIPT IS NOT MADE, DISTRIBUTED, OR SUPPORTED BY LUCASARTS, A DIVISION OF LUCASFILM ENTERTAINMENT COMPANY LTD.
-----------------------------------------------------------------
-----------------------------------------------------------------
	print("ME5_CombatManager: Entered")

---
-- This is a constructor for a WaveSequence object.
-- @param #string pathName		The name of the path to move the player to after the scene has ended.
-- @param #int pathNode			OPTIONAL: The node of the path 'pathName' to move the player to. Default value: 0
-- 
WaveSequence = {
    -- Fields that need to be specified on creation
    
    
    -- Requisitional fields
    waveToStopTiming = nil, 		-- The wave index to switch from timer-based spawning to killcount-based.mm
    
    -- Optional fields
    
    -- Fields that are handled internally
    bIsTimerSpawnActive = false, 	-- Whether or not the spawning is currently timer-based.
    currentWave = 1,				-- The current wave.
	enemiesRemaining = 0,			-- The number of enemies still alive.
	numKilled = 0,					-- The number of enemies killed in the wave.
	bIsFinalWave = false,			-- Whether or not we're on the final wave.
}


----
-- Creates a new WaveSequence
--
function WaveSequence:New(o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	return o
end

---
-- DESIGNERS: Override this function when you want to customize extra behavior when the wave sequence starts
--  (ask a lua coder if you need help with this...it's really pretty easy)
--
function WaveSequence:OnStart()

end

---
-- DESIGNERS: Override this function when you want to customize extra behavior when the wave sequence completes
--  (ask a lua coder if you need help with this...it's really pretty easy)
--
function WaveSequence:OnComplete()

end


---
-- Insert a new waveLayer and add the wave to it
--
function WaveSequence:AddWave(...)
	self.waveSets = self.waveSets or {}
	
	for i, shot in ipairs(arg) do
		shot:SetContainer(self)
	end
	
	table.insert(self.waveSets, arg)
end

---
-- Activates the first wave
--
function WaveSequence:Start(combatZoneID, musicID)
	print("EURn_c.StartCombatZone(): Starting combat zone "..zoneID)
	--print("EURn_c.StartCombatZone(): enemySpawnPathName:", spawnPathName)
	
	-- Initialize values for data fields (even if they don't exist)
	self.pathNode = self.pathNode or 0
	
	local numWaves = table.getn(self.waveSets)
	if(numWaves == 0) then
		print("WaveSequence:Start(): WARNING: No shots were added to the WaveSequence")
		return
	end
	
	
		print("EURn_c.StartCombatZone(\""..combatZoneID.."\", \""..combatMusicID.."\"): Entered")
		
	local zoneID = combatZoneID
	--local spawnPathName = enemySpawnPathName
	local musicID = combatMusicID
	
	-- debug text
	ShowMessageText("level.EUR.debug.comzone_entered", REP)
	ShowMessageText("level.EUR.debug.comzone_spawning", REP)
	
	bIsTimerSpawnActive = false
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
	--AddAIGoal(GethPawns, "Destroy", 100, 0)
	
	AddAIGoal(GethTacticals, "Deathmatch", 20)
	AddAIGoal(GethTacticals, "Destroy", 100, 0)
	
	AddAIGoal(GethSpecials, "Deathmatch", 20)
	--AddAIGoal(GethSpecials, "Destroy", 100, 0)
	
	AddAIGoal(GethHeavys, "Deathmatch", 20)
	--AddAIGoal(GethHeavys, "Destroy", 100, 0)
	
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
			-- Are there any enemies remaining?
			if enemiesRemaining > 0 then
				if currentWave < (totalWaves + 1) then
					--print("EURn_c.StartCombatZone(): Running SpawnNextWave("..spawnClasses[currentWave]['spawnPath']..")")
					-- Spawn the next wave of enemies
					SpawnNextWave()
					
					-- Is the spawn timer active?
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
		
		-- Was the killed object an enemy unit?
    	if killer and ((GetObjectTeam(object) == GethPawns) or (GetObjectTeam(object) == GethTacticals) or (GetObjectTeam(object) == GethHeavys) or (GetObjectTeam(object) == GethSpecials) or (GetObjectTeam(object) == GethPrimes)) then
    		ShowMessageText("level.EUR.debug.comzone_kill", REP)
    		
    		enemiesRemaining = enemiesRemaining - 1
    		numKilled = numKilled + 1
    		killCount = killCount + 1
    		print("EURn_c.StartCombatZone(): enemiesRemaining:", enemiesRemaining)
    		print("EURn_c.StartCombatZone(): numKilled:", numKilled)
    		print("EURn_c.StartCombatZone(): killCount:", killCount)
    		
    		-- Killcount
    		if bIsTimerSpawnActive == false then
    			
    			-- Are there any enemies remaining?
    			if enemiesRemaining > 0 then
					-- Are we still within the range of waves?
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
    			-- Are there any enemies remaining?
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

	-- Activate the first shot
	self:ActivateWaveSet(1)
	
	-- Callback for overriding startup behavior
	self:OnStart()
end

---
-- Use this to tell the container when an active wave has finished
--
function WaveSequence:NotifyWaveComplete(wave)
	
	-- Check the active wave. If it's complete, then move 
	-- onto the next layer or trigger the combat zone end
	for i, wave in ipairs(self.waveSets[self.activeSet]) do
		if not wave.isComplete then
			return		--if there's an incomplete objective, then just keep playing the map
		end
	end
	
	-- If we've reached here, then all the shots are complete
	if self.activeSet >= table.getn(self.waveSets) then
		-- We have no more shot sets, so finish the scene
		self:Complete()
	else
		-- Move on to the next shot
		self:ActivateWaveSet( self.activeSet + 1 )
	end
	
end

---
-- Updates the current wave set number, and activates all the waves within that set
--
function WaveSequence:ActivateWaveSet(whichSet)
	-- Don't advance to the next set if this is the last one
	--  (this handles the case when the last two objective sets
	--  are completed in a very short period of time, and the
	--  missionVictoryTime is relatively long)
	if whichSet > table.getn(self.waveSets) then
		-- Pretty sure we don't need anything here since we already 
		--  have ExitCamera() being called in CameraShot:Complete().
		return
	end
	
	self.activeSet = whichSet
	for i, shot in ipairs(self.waveSets[self.activeSet]) do
		shot:Start()
	end
end

---
-- Call this to complete the cinematic sequence
--
function WaveSequence:Complete()
	
	
	-- Callback for overriding completion behavior
	self:OnComplete()
end

	print("ME5_CombatManager: Exited")