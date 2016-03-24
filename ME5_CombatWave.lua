-----------------------------------------------------------------
-----------------------------------------------------------------
-- MASS EFFECT: UNIFICATION Camera Wave Script by A. Gilbert
-- Version 30318/06
-- Screen Names: Marth8880, GT-Marth8880, [GT] Marth8880, [GT] Bran
-- E-Mail: Marth8880@gmail.com
-- Mar 18, 2016
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
-- @param #string team			The name of the camera's class (its ODF).
-- @param #int numDudes			Must be greater than 0. Number of enemies to spawn from team.
-- @param #int spawnValue		Must be greater than 0. If bIsTimerSpawnActive, this is the timer value to input to the timer that spawns the 
-- 								next wave. If not bIsTimerSpawnActive, this is the required number of dead enemies to trigger the next wave.
-- @param #string spawnPath		The name of the path to spawn the wave at.
-- 
CombatWave = 
{
    -- Fields that need to be specified on creation
    team = nil, 					-- The team to spawn enemies from.
    numDudes = nil, 				-- Must be greater than 0. Number of enemies to spawn from team.
    spawnValue = nil, 				-- Must be greater than 0. If bIsTimerSpawnActive, this is the timer value to input to the timer that spawns the 
    								--  next wave. If not bIsTimerSpawnActive, this is the required number of dead enemies to trigger the next wave.
    spawnPath = nil, 				-- The name of the path to spawn the wave at.
    
    -- Optional fields
    
    -- Debug fields
    
    -- Fields that are handled internally
    isComplete = false, 
    totalEnemies = 0,				-- The total number of enemies in this wave.
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
-- Call this to activate the shot after you have created an instance of the shot (using CombatWave:New)
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
	
	
    -- Get or create a new shotDurationTimer (this ensures there's only one "shotDurationTimer" in the game at one time)
    self.shotDurationTimer = FindTimer("shotDurationTimer")
    if not self.shotDurationTimer then
        self.shotDurationTimer = CreateTimer("shotDurationTimer")
    end
    
    -- Start ticking down the time
    SetTimerValue(self.shotDurationTimer, self.shotDuration)
    StartTimer(self.shotDurationTimer)
    
    -- Are we supposed to show the shot duration timer?
    if bDebugShowTimer == true then
    	ShowTimer(self.shotDurationTimer)
    end
	
	-- Is the zoom FOV set? If so, set up the zoomTimer
	if self.zoomFOV > 0 then
	    -- Create a new zoomTimer 
        self.zoomTimer = CreateTimer("zoomTimer")
	    
	    -- Start ticking down the time
	    SetTimerValue(self.zoomTimer, self.zoomTime)
	    StartTimer(self.zoomTimer)
	end
	
	-- Set the initial field of view
	self:ZoomCamera(self.startFOV)
    
    -- Switch to the shot's camera
    self:EnterCamera(self.cameraObj)
    
    --=================================
    -- Event Responses
    --=================================
	
    -- If we have a shotDurationTimer, end the current shot when it runs out
    if self.shotDurationTimer then
        OnTimerElapse(
            function(timer)
                if self.isComplete then
                    return
                end
                
				self:Complete()
            end,
            self.shotDurationTimer
        )
    end
	
    -- If we have a zoomTimer, set the camera's field of view when it runs out
    if self.zoomTimer then
        local zoomTimerElapse = OnTimerElapse(
            function(timer)
				self:ZoomCamera(self.zoomFOV)
				
				-- Garbage collection
				DestroyTimer(self.zoomTimer)
				ReleaseTimerElapse(zoomTimerElapse)
				zoomTimerElapse = nil
            end,
            self.zoomTimer
        )
    end
    
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
function CombatWave:Complete()
    if self.isComplete then return end
    
    self.isComplete = true
    
    if self.shotDurationTimer then
		ShowTimer(nil)
		DestroyTimer(self.shotDurationTimer)
		self.shotDurationTimer = nil
    end
    
    -- Exit from the camera (not actually necessary during mid-chain shots if the shot's in a container, but required for end)
    self:ExitCamera()
			
	if self.container then
		self.container:NotifyWaveComplete(self)
	else
		-- Put the player back into a safe space once the scene ends
		SetEntityMatrix(GetCharacterUnit(0), GetPathPoint(self.pathName, self.pathNode))
	end
	
	self:OnComplete()
end

	print("ME5_CombatWave: Exited")