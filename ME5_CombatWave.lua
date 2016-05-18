-----------------------------------------------------------------
-----------------------------------------------------------------
-- MASS EFFECT: UNIFICATION Combat Wave Script by A. Gilbert
-- Version 30502/06
-- Screen Names: Marth8880, GT-Marth8880, [GT] Marth8880, [GT] Bran
-- E-Mail: Marth8880@gmail.com
-- May 2, 2016
-- Copyright (c) 2016 A. Gilbert.
-- 
-- 
-- PURPOSE:
-- Lightly based on Objective.lua
--  Sets up individual camera shots. Designers can specify 
--  the camera, shot duration, the starting FOV, whether or 
--  not to zoom, the zoom FOV, when the zoom occurs, and, 
--  where the player is put (if the shot is being put into 
--  a container). Perhaps the most convenient aspect of this 
--  script is the fact that it can work in tandem with the 
--  CinematicContainer script, meaning chains/sequences of 
--  shots can be easily set up with full customization.
-- 
-- 
-- USAGE:
-- 1. Load the script using ScriptCB_DoFile() in your main mission script.
-- 2. Initialize CombatWave:New{} into a variable. Do this for each shot you wish to add. Example: 
-- 
-- 		TestShot1 = CombatWave:New{cameraClassName = "eur_prop_camera", cameraObj = "camera_test_1", shotDuration = 3.0}
-- 		TestShot2 = CombatWave:New{cameraClassName = "eur_prop_camera", cameraObj = "camera_test_2", shotDuration = 2.0}
-- 		<...>
-- 		TestShot6 = CombatWave:New{cameraClassName = "eur_prop_camera", cameraObj = "camera_test_6", shotDuration = 3.0}
-- 		
-- 	NOTE: You must set a CombatWave's pathName if you aren't putting the CombatWave into a CinematicContainer! Example: 
-- 	
-- 		TestShot = CombatWave:New{cameraClassName = "eur_prop_camera", cameraObj = "camera_test_1", shotDuration = 3.0, pathName = "playerspawn_camera_exit"}
-- 
-- 3. After you've done step 2 for each shot, either start setting up the CinematicContainer for your shots if you want to have a 
--  continous sequence of shots, or call :Start() on one of your CombatWave variable if you want to start each one manually and at a 
--  different time. Example: 
-- 
-- 		testCinematicSequence = CinematicContainer:New{pathName = "playerspawn_start"}
-- 		testCinematicSequence:AddShot(TestShot1)
-- 		testCinematicSequence:AddShot(TestShot2)
-- 		<...>
-- 		testCinematicSequence:AddShot(TestShot6)
-- 		testCinematicSequence:Start()
-- 		
-- 	OR:
-- 		
-- 		TestShot:Start()
-- 		
-- 	NOTE: You must initialize a CombatWave variable before you can call :Start() (or anything) on it.
-- 
-- 4. CameraManager includes a Start() and Complete() function that you can override to add extra behavior when the shot starts or ends.
--  To do so, call .OnStart() or .OnComplete() somewhere in your mission script and assign a new function to it. Example: 
-- 
-- 		TestShot1.OnStart() = function(self)
-- 			-- do stuff
-- 		end
-- 		
-- 		TestShot1.OnComplete() = function(self)
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
	print("ME5_CombatWave: Entered")

---
-- This is a constructor for a CombatWave object.
-- @param #int team				The team to spawn enemies from.
-- @param #int numDudes			Must be greater than 0. Number of enemies to spawn from team.
-- @param #int spawnValue		Must be greater than 0. The required number of dead enemies to trigger the next wave.
-- @param #string spawnPath		The name of the path to spawn the wave at.
-- @param #bool bDebugWaves		OPTIONAL: Whether or not to print/display debug messages.
-- 
CombatWave = 
{
    -- Fields that need to be specified on creation
    team = nil, 					-- The team to spawn enemies from.
    numDudes = nil, 				-- Must be greater than 0. Number of enemies to spawn from team.
    spawnValue = nil, 				-- Must be greater than 0. The required number of dead enemies to trigger the next wave.
    spawnPath = nil, 				-- The name of the path to spawn the wave at.
    
    -- Optional fields
    
    -- Debug fields
    bDebugWaves = false,			-- Whether or not to print/display debug messages.
    
    -- Fields that are handled internally
    isComplete = false,				-- Whether or not the wave is complete.
    enemiesRemaining = 0,			-- The number of enemies remaining until moving on.
}

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
-- Call this to activate the wave after you have created an instance of the wave (using CombatWave:New)
--
function CombatWave:Start()
	-- Is the team set? If not, print an error message and exit the function
	if self.team == nil then
		print("CombatWave:Start(): WARNING: team must be specified! Exiting function")
		return
	end
	
	-- Is the spawnPath set? If not, print an error message and exit the function
	if self.spawnPath == nil then
		print("CombatWave:Start(): WARNING: spawnPath must be specified! Exiting function")
		return
	end
	
	
    -- Initialize values for data fields (even if they don't exist)
	self.numDudes = self.numDudes or 3
	self.spawnValue = self.spawnValue or 3
	
	-- Update the enemies remaining to the number required to complete the wave
	self.enemiesRemaining = self.spawnValue
	
    
    -- Spawn the enemies
    print()
    print("CombatWave:Start(): Spawning "..self.numDudes.." enemies from team "..self.team.." at "..self.spawnPath)
    Ambush(self.spawnPath, self.numDudes, self.team)
    
    print("CombatWave:Start(): Total enemiesRemaining:", self.enemiesRemaining)
    
    
    
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
		    	if killer and ((charTeam == GethPawns) or (charTeam == GethTacticals) or (charTeam == GethHeavys) or (charTeam == GethSpecials) or (charTeam == GethPrimes)) then
					
					-- Decrement enemies remaining
					self.enemiesRemaining = self.enemiesRemaining - 1
		    		print("CombatWave:Start(): enemiesRemaining:", self.enemiesRemaining)
					
					
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
    if self.isComplete then return end
    
    self.isComplete = true
	
	if self.container then
		self.container:NotifyWaveComplete(self)
	end
	
	self:OnComplete()
end

	print("ME5_CombatWave: Exited")