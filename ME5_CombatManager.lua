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
    
    -- Optional fields
    
    -- Fields that are handled internally
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
-- Insert a new waveLayer and add the wave to it.
--
function WaveSequence:AddWave(...)
	self.waveSets = self.waveSets or {}
	
	for i, shot in ipairs(arg) do
		shot:SetContainer(self)
	end
	
	table.insert(self.waveSets, arg)
end

---
-- Activates the first wave.
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