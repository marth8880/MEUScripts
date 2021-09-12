-----------------------------------------------------------------
-----------------------------------------------------------------
-- MASS EFFECT: UNIFICATION Combat Manager Script by Aaron Gilbert
-- Build 40218/06
-- Screen Names: Marth8880, GT-Marth8880, [GT] Marth8880, [GT] Bran
-- E-Mail: Marth8880@gmail.com
-- Feb 18, 2017
-- Copyright (c) 2017, Aaron Gilbert All rights reserved.
-- 
-- About:
--  Largely based on MultiObjectiveContainer.lua
--  Sets up a list of waves in a combat zone. Basically, there are one or more waves of enemies in a combat sequence. When 
--  a wave is completed, it moves onto the next wave. When all of the shots are completed, the combat zone is released. 
--  Also contains the functions for the SmartSpawn system, which controls where enemies and allies spawn based on where the 
--  player is physically located within the combat zone.
-- 
-- 
-- Usage:
--  1. Load the script using ScriptCB_DoFile() in your main mission script.
--  2. Initialize WaveSequence:New{} into a variable. Example: 
--  
--  		testWaveSequence = WaveSequence:New{pathName = "playerspawn_start"}
--  
--  3. Call :AddWave() on your WaveSequence variable for each CombatWave:New{} variable you assigned previous to WaveSequence:New{}. Example: 
--  
--  		testWaveSequence:AddWave(Wave1)
--  		testWaveSequence:AddWave(Wave2)
--  		<...>
--  		testWaveSequence:AddWave(Wave6)
--  
--  4. After you've done step 3 for each wave, call :Start() on your WaveSequence variable to start the combat zone. Example: 
--  
--  		testWaveSequence:Start()
--  
--  5. WaveSequence includes a Start() and Complete() function that you can override to add extra behavior when the combat zone starts or ends.
--   To do so, call .OnStart() or .OnComplete() somewhere in your mission script and assign a new function to it. Example: 
--  
--  		testWaveSequence.OnStart() = function(self)
--  			-- do stuff
--  		end
--  		
--  		testWaveSequence.OnComplete() = function(self)
--  			-- do stuff
--  		end
--  		
-- 		NOTE: You can only override these functions BEFORE :Start() has been called!
-- 	
-- 	====================
-- 	Attaching SmartSpawn
-- 	====================
-- 	
-- 	If you wish to attach SmartSpawn to the WaveSequence...
-- 	
-- 	1. Initialize SmartSpawn:New{} into a variable. Example: 
--  
--  		testSmartSpawner = SmartSpawn:New{ regionName = "cz_courtyard", allySpawnIn = "ps_courtyard_in", allySpawnOut = "ps_courtyard_out", 
--																		enemySpawnIn = "es_courtyard_in", enemySpawnOut = "es_courtyard_out" }
--																		
--	2. Call :AddSmartSpawn() on your WaveSequence variable for the SmartSpawn:New{} variable you assigned, *after* the :AddWave() calls but *before* 
--	 the :Start() call. Example: 
--  
--  		testWaveSequence:AddWave(Wave1)
--  		<...>
--  		testWaveSequence:AddWave(Wave6)
--  		testWaveSequence:AddSmartSpawn(testSmartSpawner)
--  		testWaveSequence:Start()
-- 
-- 
-- Legal:
--  This script is licensed under the BSD 3-Clause License. A copy of this license (as LICENSE.md) should have been included
--  with this script. If it wasn't, it can also be found here: https://www.w3.org/Consortium/Legal/2008/03-bsd-license.html
--  
--  THIS SCRIPT IS NOT MADE, DISTRIBUTED, OR SUPPORTED BY LUCASARTS, A DIVISION OF LUCASFILM ENTERTAINMENT COMPANY LTD.
-----------------------------------------------------------------
-----------------------------------------------------------------

local __SCRIPT_NAME = "ME5_CombatManager";
local debug = true

local function PrintLog(...)
	if debug == true then
		print("["..__SCRIPT_NAME.."]", unpack(arg));
	end
end

PrintLog("Entered")


--=================================
-- WaveSequence
--=================================

---
-- This is a constructor for a WaveSequence object.
-- @param #bool bDebug		OPTIONAL: Whether or not to print/display debug messages.
-- 
WaveSequence = {
    -- Fields that need to be specified on creation
    
    
    -- Optional fields
    bDebug = false,					-- Whether or not to print/display debug messages.
    
    
    -- Fields that are handled internally
    spawnPath = nil,				-- The name of the path to spawn the next wave at. This is handled by SmartSpawn.
    totalWaves = 0,					-- The total number of waves in this sequence.
	bIsFinalWave = false,			-- Whether or not we're on the final wave of the sequence.
	
	totalEnemies = 0,				-- The total number of enemies that spawn in this sequence.
	killCount = 0,					-- The number of enemies that have been killed.
}


----
-- Creates a new WaveSequence.
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
-- Inserts a new waveLayer and adds the wave to it.
--
function WaveSequence:AddWave(...)
	self.waveSets = self.waveSets or {}
	
	for i, wave in ipairs(arg) do
		-- Set the wave's container
		wave:SetContainer(self)
		
		-- Update totalEnemies with the number of enemies that are spawned in the wave
		self.totalEnemies = self.totalEnemies + wave.numDudes
		
		PrintLog("WaveSequence:AddWave(): totalEnemies:", self.totalEnemies)
	end
	
	table.insert(self.waveSets, arg)
end

---
-- Inserts a new SmartSpawn module.
--
function WaveSequence:AddSmartSpawn(smartSpawner)
	self.smartSpawnModule = smartSpawner
	
	-- Set the SmartSpawn's container
	smartSpawner:SetContainer(self)
end

---
-- Call this to activate the first wave and initialize event logic.
--
function WaveSequence:Start(combatZoneID, musicID)
	PrintLog("WaveSequence:Start(): Starting combat zone")
	
	-- Initialize values for data fields (even if they don't exist)
	--self.pathNode = self.pathNode or 0
	
	
	-- Store the number of waves in this sequence
	self.totalWaves = table.getn(self.waveSets)
	if(self.totalWaves == 0) then
		PrintLog("WaveSequence:Start(): WARNING: No waves were added to the WaveSequence")
		return
	end
	
	
	-- Set the AI goals
	ClearAIGoals(GethPawns)
	ClearAIGoals(GethTacticals)
	ClearAIGoals(GethSpecials)
	ClearAIGoals(GethHeavys)
	ClearAIGoals(GethPrimes)
	
	AddAIGoal(GethPawns, "Deathmatch", 100)
	AddAIGoal(GethPawns, "Destroy", 30, 0)
	
	AddAIGoal(GethTacticals, "Deathmatch", 100)
	AddAIGoal(GethTacticals, "Destroy", 45, 0)
	
	AddAIGoal(GethSpecials, "Deathmatch", 100)
	AddAIGoal(GethSpecials, "Destroy", 60, 0)
	
	AddAIGoal(GethHeavys, "Deathmatch", 100)
	AddAIGoal(GethHeavys, "Destroy", 75, 0)
	
	AddAIGoal(GethPrimes, "Destroy", 100, 0)
	
	
	-- Is debug messages enabled?
	if self.bDebug == true then
		ShowMessageText("level.EUR.debug.comzone_entered", REP)
		ShowMessageText("level.EUR.debug.comzone_spawning", REP)
	end
	
	-- Initialize the SmartSpawn
	self.smartSpawnModule:Start()

	-- Activate the first wave
	self:ActivateWaveSet(1)
	
	
    --=================================
    -- Event Responses
    --=================================
	
	-- When an enemy is killed
	self.EnemyKillEvent = OnCharacterDeath(
		function(player, killer)
			-- Is the killed object a unit and not an enemy building?
			--if IsObjectUnit(player) == true then
				local charTeam = GetCharacterTeam(player)
				
				-- Was the killed object an enemy unit?
		    	if ((charTeam == GethPawns) or (charTeam == GethTacticals) or (charTeam == GethHeavys) or (charTeam == GethSpecials) or (charTeam == GethPrimes)) then
		    		
					-- Is debug messages enabled?
					if self.bDebug == true then
						ShowMessageText("level.EUR.debug.comzone_kill", REP)
					end
					
		    		-- Increment the kill count
					self.killCount = self.killCount + 1
		    		PrintLog("WaveSequence:Start(): killCount:", self.killCount)
					
					
					-- Have all the enemies been killed?
					if self.killCount >= self.totalEnemies then
						-- Garbage collection
						ReleaseCharacterDeath(self.EnemyKillEvent)
						self.EnemyKillEvent = nil
						
						-- Complete the sequence
						self:Complete()
					end
		    		
		    	end
			--end
		end
	)
	
	
	-- Callback for overriding startup behavior
	self:OnStart()
end

---
-- Used by container's objects (CombatWave objects) to tell the container when an active wave has finished.
--
function WaveSequence:NotifyWaveComplete(wave)
	
	-- Check the active wave. If it's complete, then move 
	-- onto the next layer or trigger the sequence end
	for i, wave in ipairs(self.waveSets[self.activeSet]) do
		if not wave.isComplete then
			return		--if there's an incomplete wave, then just keep playing the map
		end
	end
	
	-- If we've reached here, then all the waves are complete
	if self.activeSet >= table.getn(self.waveSets) then
		
	else
		-- Move on to the next wave
		self:ActivateWaveSet( self.activeSet + 1 )
	end
	
end

---
-- Updates the current wave set number, and activates all the waves within that set.
--
function WaveSequence:ActivateWaveSet(whichSet)
	PrintLog("WaveSequence:ActivateWaveSet(): Spawning wave "..whichSet)
	
	-- Is debug messages enabled?
	if self.bDebug == true then
		ShowMessageText("level.EUR.debug.comzone_spawning", REP)
	end
	
	if whichSet == table.getn(self.waveSets) then
		PrintLog("EURn_c.SpawnNextWave(): NOTICE: Final wave")
		
		-- Is debug messages enabled?
		if self.bDebug == true then
			-- Let the player know they're on the final wave
			ShowMessageText("level.EUR.debug.comzone_finalwave", REP)
		end
		
		-- We have no more wave sets, so set finalwave
		self.bIsFinalWave = true
	end
	
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
	for i, wave in ipairs(self.waveSets[self.activeSet]) do
		wave:Start()
	end
end

---
-- Call this to complete the wave sequence.
--
function WaveSequence:Complete()
	PrintLog("WaveSequence:Complete(): Combat zone cleared")
	
	-- Is debug messages enabled?
	if bDebug == true then
		ShowMessageText("level.EUR.debug.comzone_done", REP)
	end
	
	-- Tell SmartSpawn to run completion logic 
	self.smartSpawnModule:Complete()
	
	-- Callback for overriding completion behavior
	self:OnComplete()
end


--=================================
-- SmartSpawn
--=================================

---
-- Initializes logic for SmartSpawn system.
-- 
-- @param #string regionName	The name of the region to associate with the SmartSpawning.
-- @param #string allySpawnIn	The name of the path the player and allies spawn at when inside regionName.
-- @param #string allySpawnOut	The name of the path the player and allies spawn at when outside regionName.
-- @param #string enemySpawnIn	The name of the path enemies spawn at when the player is inside regionName.
-- @param #string enemySpawnOut	The name of the path enemies spawn at when the player is outside regionName.
-- 
SmartSpawn = 
{
    -- Fields that need to be specified on creation
    regionName = nil,			-- The name of the region to associate with the SmartSpawning.
    allySpawnIn = nil,			-- The name of the path the player and allies spawn at when inside regionName.
    allySpawnOut = nil,			-- The name of the path the player and allies spawn at when outside regionName.
    enemySpawnIn = nil,			-- The name of the path enemies spawn at when the player is inside regionName.
    enemySpawnOut = nil,		-- The name of the path enemies spawn at when the player is outside regionName.
    
    -- Optional fields
    
    -- Debug fields
    bDebug = false,				-- Whether or not debug messages are enabled.
    
    -- Fields that are handled internally
    playerIs = "in",			-- Player is "in" the region, or player is "out" of the region.
    curAllySpawn = nil,			-- The current path the player and allies spawn at.
    curEnemySpawn = nil,		-- The current path enemies spawn at.
}

---
-- Call this to construct a new SmartSpawn object.
-- @param #table o SmartSpawn object table with its fields filled out.
-- @return The SmartSpawn object.
-- 
function SmartSpawn:New(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end


---
-- Initializes logic for SmartSpawn system.
-- 
function SmartSpawn:Start()

	-- Initialize data fields
	if self.regionName == nil then
		PrintLog("SmartSpawn:Start(): WARNING: regionName must be specified! Exiting function")
		return
	end
	if self.allySpawnIn == nil then
		PrintLog("SmartSpawn:Start(): WARNING: allySpawnIn must be specified! Exiting function")
		return
	end
	if self.allySpawnOut == nil then
		PrintLog("SmartSpawn:Start(): WARNING: allySpawnOut must be specified! Exiting function")
		return
	end
	if self.enemySpawnIn == nil then
		PrintLog("SmartSpawn:Start(): WARNING: enemySpawnIn must be specified! Exiting function")
		return
	end
	if self.enemySpawnOut == nil then
		PrintLog("SmartSpawn:Start(): WARNING: enemySpawnOut must be specified! Exiting function")
		return
	end
	
	-- Set current spawns to SpawnIn paths since the WaveSequence always starts with the player in the region
	self.curAllySpawn = self.allySpawnIn
	self.curEnemySpawn = self.enemySpawnIn
	
	
	-- Activate the SmartSpawn region so we can use it
	ActivateRegion(self.regionName)
	
	
	--=======================
	-- LOCAL FUNCTIONS
	--=======================
	
	local function UpdateState()
		-- Update the spawn path vars
		if self.playerIs == "in" then
			self.curAllySpawn = self.allySpawnIn
			self.curEnemySpawn = self.enemySpawnIn
			
		elseif self.playerIs == "out" then
			self.curAllySpawn = self.allySpawnOut
			self.curEnemySpawn = self.enemySpawnOut
			
		end
		
		-- Update the player's spawn path
		SetRespawnPoint(self.curAllySpawn)
		
		-- Update the enemy's spawn path
		self.container.spawnPath = self.curEnemySpawn
	end
	
	-- Do an initial update on the state
	UpdateState()
	
	--=======================
	-- EVENT RESPONSES
	--=======================
	
	self.SmartSpawn_RegionEnter = OnEnterRegion(
		function(region, character)
			if IsCharacterHuman(character) then
				self.playerIs = "in"
				
				if self.bDebug == true then
					PrintLog("SmartSpawn:Start(): Player entered region")
					ShowMessageText("level.common.debug.smartspawn_entered")
				end
				
				UpdateState()
			end
		end,
	self.regionName
	)
	
	self.SmartSpawn_RegionExit = OnLeaveRegion(
		function(region, character)
			if IsCharacterHuman(character) then
				self.playerIs = "out"
				
				if self.bDebug == true then
					PrintLog("SmartSpawn:Start(): Player exited region")
					ShowMessageText("level.common.debug.smartspawn_exited")
				end
				
				UpdateState()
			end
		end,
	self.regionName
	)
	
end

---
-- This is called when the WaveSequence has completed.
--
function SmartSpawn:Complete()
	-- Deactivate the SmartSpawn region
	DeactivateRegion(self.regionName)
	
	-- Release the region event responses
	ReleaseEnterRegion(self.SmartSpawn_RegionEnter)
	ReleaseLeaveRegion(self.SmartSpawn_RegionExit)
end

---
-- This is called when the SmartSpawn object is added to the WaveSequence.
--
function SmartSpawn:SetContainer(container)
    self.container = container
end


--=================================
-- CombatWave
--=================================

---
-- This is a constructor for a CombatWave.
-- @param #int team				The team to spawn enemies from.
-- @param #int numDudes			Must be greater than 0. Number of enemies to spawn from team.
-- @param #int spawnValue		Must be greater than 0. The required number of dead enemies to trigger the next wave.
-- @param #string spawnPath		The name of the path to spawn the wave at.
-- @param #bool bDebug		OPTIONAL: Whether or not to print/display debug messages.
-- 
CombatWave = 
{
    -- Fields that need to be specified on creation
    team = nil, 					-- The team to spawn enemies from.
    numDudes = nil, 				-- Must be greater than 0. Number of enemies to spawn from team.
    spawnValue = nil, 				-- Must be greater than 0. The required number of dead enemies to trigger the next wave.
    --spawnPath = nil, 				-- The name of the path to spawn the wave at.
    
    -- Optional fields
    
    -- Debug fields
    bDebug = false,			-- Whether or not to print/display debug messages.
    
    -- Fields that are handled internally
    isComplete = false,				-- Whether or not the wave is complete.
    enemiesRemaining = 0,			-- The number of enemies remaining until moving on.
}

---
-- Call this to construct a new CombatWave object.
-- @param #table o CombatWave object table with its fields filled out.
-- @return The CombatWave object.
-- 
function CombatWave:New(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

---
-- DESIGNERS: Override this function when you want to customize extra behavior when a wave is activated
--  (ask a lua coder if you need help with this...it's really pretty easy)
--
function CombatWave:OnStart()

end

---
-- DESIGNERS: Override this function when you want to customize extra behavior when a wave is finished
--  (ask a lua coder if you need help with this...it's really pretty easy)
--
function CombatWave:OnComplete()

end

---
-- Call this to activate the wave after you have created an instance of the wave (using CombatWave:New).
--
function CombatWave:Start()
	-- Is the team set? If not, print an error message and exit the function
	if self.team == nil then
		PrintLog("CombatWave:Start(): WARNING: team must be specified! Exiting function")
		return
	end
	
	-- Is the spawnPath set? If not, print an error message and exit the function
	--[[if self.spawnPath == nil then
		PrintLog("CombatWave:Start(): WARNING: spawnPath must be specified! Exiting function")
		return
	end]]
	
	
    -- Initialize values for data fields (even if they don't exist)
	self.numDudes = self.numDudes or 3
	self.spawnValue = self.spawnValue or 3
	
	-- Update the enemies remaining to the number required to complete the wave
	self.enemiesRemaining = self.spawnValue
	
    
    -- Spawn the enemies
    print()
    PrintLog("CombatWave:Start(): Spawning "..self.numDudes.." enemies from team "..self.team.." at "..self.container.spawnPath)
    Ambush(self.container.spawnPath, self.numDudes, self.team)
    
    PrintLog("CombatWave:Start(): Total enemiesRemaining:", self.enemiesRemaining)
    
    
    
    --=================================
    -- Event Responses
    --=================================
	
	-- When an enemy is killed
	self.EnemyKillEvent = OnCharacterDeath(
		function(player, killer)
			-- Is the killed object a unit and not an enemy building?
			--if IsObjectUnit(player) == true then
				local charTeam = GetCharacterTeam(player)
				
				-- Was the killed object an enemy unit?
		    	if ((charTeam == GethPawns) or (charTeam == GethTacticals) or (charTeam == GethHeavys) or (charTeam == GethSpecials) or (charTeam == GethPrimes)) then
					
					-- Decrement enemies remaining
					self.enemiesRemaining = self.enemiesRemaining - 1
		    		PrintLog("CombatWave:Start(): enemiesRemaining:", self.enemiesRemaining)
					
					
					-- Has spawnValue been met?
					if self.enemiesRemaining <= 0 then
						-- Garbage collection
						ReleaseCharacterDeath(self.EnemyKillEvent)
						self.EnemyKillEvent = nil
						
						-- Complete the wave
						self:Complete()
					end
		    	end
			--end
		end
	)
    
    
    -- Callback for overriding startup behavior
    self:OnStart()
end

---
-- If a container is set, then it takes over some of the logic that occurs when a shot is completed,
--  which allows for more complicated completion logic (like concurrent shots and chains of shots).
--
function CombatWave:SetContainer(container)
    self.container = container
end

---
-- Call this to finish the wave. First, it looks to see if it has a container, then lets the container 
--  handle the logic, otherwise will set the end sequence on its own.
--  
--  NOTE: The definition of a "finished wave" is when the spawnValue is met, i.e., the next wave is triggered.
--
function CombatWave:Complete()
	PrintLog("CombatWave.Complete(): Exited")
	
    if self.isComplete then return end
    
    self.isComplete = true
	
	if self.container then
		self.container:NotifyWaveComplete(self)
	end
	
	self:OnComplete()
end

PrintLog("Exited")