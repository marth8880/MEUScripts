-----------------------------------------------------------------
-----------------------------------------------------------------
-- MASS EFFECT: UNIFICATION Camera Manager Script by Aaron Gilbert
-- Build 31110/06
-- Screen Names: Marth8880, GT-Marth8880, [GT] Marth8880, [GT] Bran
-- E-Mail: Marth8880@gmail.com
-- Nov 10, 2016
-- Copyright (c) 2016 Aaron Gilbert
-- 
-- About:
--  Lightly based on Objective.lua
--  Sets up individual camera shots. Designers can specify the camera, shot duration, the starting FOV, whether or not to zoom, the zoom FOV, 
--  when the zoom occurs, and, where the player is put (if the shot is being put into a container). Perhaps the most convenient aspect of this 
--  script is the fact that it can work in tandem with the CinematicContainer script, meaning chains/sequences of shots can be easily set up 
--  with full customization.
-- 
-- 
-- Usage:
--  1. Load the script using ScriptCB_DoFile() in your main mission script.
--  2. Initialize CameraShot:New{} into a variable. Do this for each shot you wish to add. Example: 
--  
--  		TestShot1 = CameraShot:New{cameraClassName = "eur_prop_camera", cameraObj = "camera_test_1", shotDuration = 3.0}
--  		TestShot2 = CameraShot:New{cameraClassName = "eur_prop_camera", cameraObj = "camera_test_2", shotDuration = 2.0}
--  		<...>
--  		TestShot6 = CameraShot:New{cameraClassName = "eur_prop_camera", cameraObj = "camera_test_6", shotDuration = 3.0}
--  		
--  	NOTE: You must set a CameraShot's pathName if you aren't putting the CameraShot into a CinematicContainer! Example: 
--  	
--  		TestShot = CameraShot:New{cameraClassName = "eur_prop_camera", cameraObj = "camera_test_1", shotDuration = 3.0, pathName = "playerspawn_camera_exit"}
--  
--  3. After you've done step 2 for each shot, either start setting up the CinematicContainer for your shots if you want to have a 
--   continous sequence of shots, or call :Start() on one of your CameraShot variable if you want to start each one manually and at a 
--   different time. Example: 
-- 
--  		testCinematicSequence = CinematicContainer:New{pathName = "playerspawn_start"}
--  		testCinematicSequence:AddShot(TestShot1)
--  		testCinematicSequence:AddShot(TestShot2)
--  		<...>
--  		testCinematicSequence:AddShot(TestShot6)
--  		testCinematicSequence:Start()
--  		
--  	OR:
--  		
--  		TestShot:Start()
--  		
--  NOTE: You must initialize a CameraShot variable before you can call :Start() (or anything) on it.
--  
--  4. CameraManager includes a Start() and Complete() function that you can override to add extra behavior when the shot starts or ends.
--   To do so, call .OnStart() or .OnComplete() somewhere in your mission script and assign a new function to it. Example: 
--  
--  		TestShot1.OnStart() = function(self)
--  			-- do stuff
--  		end
-- 	 	
--  		TestShot1.OnComplete() = function(self)
--  			-- do stuff
--  		end
--  		
--  	NOTE: You can only override these functions BEFORE :Start() has been called!
-- 
-- 
-- Legal:
--  This script is licensed under the BSD 3-Clause License. A copy of this license (as LICENSE.md) should have been included
--  with this script. If it wasn't, it can also be found here: https://www.w3.org/Consortium/Legal/2008/03-bsd-license.html
--  
--  THIS SCRIPT IS NOT MADE, DISTRIBUTED, OR SUPPORTED BY LUCASARTS, A DIVISION OF LUCASFILM ENTERTAINMENT COMPANY LTD.
-----------------------------------------------------------------
-----------------------------------------------------------------
local __SCRIPT_NAME = "ME5_CameraManager";
local debug = true

local function PrintLog(...)
	if debug == true then
		print("["..__SCRIPT_NAME.."]", unpack(arg));
	end
end

PrintLog("Entered")

---
-- This is a constructor for a CameraShot object.
-- @param #string cameraClassName	The name of the camera's class (its ODF).
-- @param #string cameraObj			The camera object associated with the shot. This is the object's unique name that's set in the world file.
-- @param #float shotDuration		The duration of the shot in seconds. Default value: 1.0
-- @param #string pathName			The name of the path to move the player to after the scene has ended. This is only required if the shot isn't being put into a container.
-- @param #int pathNode				OPTIONAL: The node of the path 'pathName' to move the player to. Default value: 0
-- @param #float startFOV			OPTIONAL: The field of view (in degrees) to start the shot in. Default value: 60.0
-- @param #float zoomFOV			OPTIONAL: The field of view (in degrees) to zoom to sometime during the shot. Default value: 0
-- @param #float zoomTime			OPTIONAL: The number of seconds after the shot started to initiate the zoom. (This is NOT the duration of the zoom!) Default value: 0
-- @param #bool bDebugShowTimer		DEBUG: Whether or not to show the shotDurationTimer. Default value: false
-- 
CameraShot = 
{
    -- Fields that need to be specified on creation
    cameraClassName = nil, 			-- The name of the camera's class (its ODF).
    cameraObj = nil, 				-- The camera object associated with the shot. This is the object's unique name that's set in the world file.
    shotDuration = nil, 			-- The duration of the shot in seconds.
    pathName = nil, 				-- The name of the path to move the player to after the scene has ended. This is only required if the shot isn't being put into a container.
    
    -- Optional fields
    pathNode = nil, 				-- The node of the path 'pathName' to move the player to.
    startFOV = nil, 				-- The field of view (in degrees) to start the shot in.
    zoomFOV = nil, 					-- The field of view (in degrees) to zoom to sometime during the shot.
    zoomTime = nil, 				-- The number of seconds after the shot started to initiate the zoom. (This is NOT the duration of the zoom!)
    soundEffect = nil, 				-- The sound property to play when this camera is activated. NOTE: Can be used in conjunction with soundStream.
    soundEffectDelay = nil, 		-- The number of seconds to delay the soundEffect by.
    soundStream = nil, 				-- The sound stream property to play when this camera is activated. NOTE: Can be used in conjunction with soundEffect.
    soundStreamDelay = nil, 		-- The number of seconds to delay the soundStream by.
    
    -- Debug fields
    bDebugShowTimer = false, 		-- Whether or not to show the shotDurationTimer.
    
    -- Fields that are handled internally
    isComplete = false, 
}

function CameraShot:New(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

---
-- DESIGNERS: Override this function when you want to customize extra behavior when a shot is activated
--  (ask a lua coder if you need help with this...it's really pretty easy)
--
function CameraShot:OnStart()

end

---
-- DESIGNERS: Override this function when you want to customize extra behavior when a shot is finished
--  (ask a lua coder if you need help with this...it's really pretty easy)
--
function CameraShot:OnComplete()

end

---
-- Call this to activate the shot after you have created an instance of the shot (using CameraShot:New)
--
function CameraShot:Start()
	-- Is the camera's class name set? If not, print an error message and exit the function
	if self.cameraClassName == nil then
		PrintLog("CameraShot:Start(): WARNING: cameraClassName must be specified! Exiting function")
		return
	end
	
	-- Is the camera's object name set? If not, print an error message and exit the function
	if self.cameraObj == nil then
		PrintLog("CameraShot:Start(): WARNING: cameraObj must be specified! Exiting function")
		return
	end
	
	-- Is this shot being put into a container?
	if not self.container then
		-- Is the path name set? If not, print an error message and exit the function
		if self.pathName == nil then
			PrintLog("CameraShot:Start(): WARNING: pathName must be specified if not using a container! Exiting function")
			return
		end
	end
	
    -- Initialize values for data fields (even if they don't exist)
    self.shotDuration = self.shotDuration or 1
    self.isComplete = false
    self.pathNode = self.pathNode or 0
    self.startFOV = self.startFOV or 60
    self.zoomFOV = self.zoomFOV or 0
    self.zoomTime = self.zoomTime or 0
    self.soundEffect = self.soundEffect or "none"
    self.soundEffectDelay = self.soundEffectDelay or 0
    self.soundStream = self.soundStream or "none"
    self.soundStreamDelay = self.soundStreamDelay or 0
    self.bDebugShowTimer = self.bDebugShowTimer or false
	
	
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
	
	-- Is the soundEffect set? If so, set up the soundEffectDelay
	if self.soundEffectDelay > 0 then
	    -- Create a new soundEffectDelayTimer 
        self.soundEffectDelayTimer = CreateTimer("soundEffectDelayTimer")
	    
	    SetTimerValue(self.soundEffectDelayTimer, self.soundEffectDelay)
	    StartTimer(self.soundEffectDelayTimer)
	end
	
	-- Is the soundStream set? If so, set up the soundStreamDelay
	if self.soundStreamDelay > 0 then
	    -- Create a new soundStreamDelayTimer 
        self.soundStreamDelayTimer = CreateTimer("soundStreamDelayTimer")
	    
	    SetTimerValue(self.soundStreamDelayTimer, self.soundStreamDelay)
	    StartTimer(self.soundStreamDelayTimer)
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
                if self.isComplete then return end
                
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
	
    -- If we have a soundStreamDelayTimer, play the sound stream when it runs out
    if self.soundStreamDelayTimer then
        local soundStreamDelayTimerElapse = OnTimerElapse(
            function(timer)
				BroadcastVoiceOver(self.soundStream)
				
				-- Garbage collection
				DestroyTimer(self.soundStreamDelayTimer)
				ReleaseTimerElapse(soundStreamDelayTimerElapse)
				soundStreamDelayTimerElapse = nil
            end,
            self.soundStreamDelayTimer
        )
    else
    	BroadcastVoiceOver(self.soundStream)
    end
	
    -- If we have a soundEffectDelayTimer, play the sound effect when it runs out
    if self.soundEffectDelayTimer then
        local soundEffectDelayTimerElapse = OnTimerElapse(
            function(timer)
				ScriptCB_SndPlaySound(self.soundEffect)
				
				-- Garbage collection
				DestroyTimer(self.soundEffectDelayTimer)
				ReleaseTimerElapse(soundEffectDelayTimerElapse)
				soundEffectDelayTimerElapse = nil
            end,
            self.soundEffectDelayTimer
        )
    else
    	ScriptCB_SndPlaySound(self.soundEffect)
    end
    
    -- Callback for overriding startup behavior
    self:OnStart()
end

---
-- If a container is set, then it takes over some of the logic that occurs when a shot is completed,
--  which allows for more complicated completion logic (like concurrent shots and chains of shots).
--
function CameraShot:SetContainer(container)
    self.container = container
end

---
-- Call this to activate a camera. The player is forced into the camera "vehicle" 
--  and their input is disabled. Call :ExitCamera() to deactivate the camera.
-- @param #string cameraIn	The unique name of the camera object to activate.
-- 
function CameraShot:EnterCamera(cameraIn)
	-- Force the player into our camera vehicle
	EnterVehicle(0, cameraIn)
	
	-- Disable player and camera vehicle input
	SetProperty(0, "PhysicsActive", 0)
	SetProperty(cameraIn, "PhysicsActive", 0)
end

---
-- Call this to deactivate any active camera. The player is forced out of the 
--  camera "vehicle" and their input is re-enabled.
--  
function CameraShot:ExitCamera()
	-- Force the player out of our camera vehicle
	ExitVehicle(0)
	
	-- Disable player and camera vehicle input
	SetProperty(0, "PhysicsActive", 1)
end

---
-- Zooms the camera object to angle /FOV/.
--  NOTE: This affects all objects of the camera's class.
-- @param #int FOV		The field of view angle to zoom to.
-- 
function CameraShot:ZoomCamera(FOV)
	SetClassProperty(self.cameraClassName, "FirstPersonFOV", FOV)
	SetClassProperty(self.cameraClassName, "ThirdPersonFOV", FOV)
end

---
-- Call this to finish the shot. First, it looks to see if it has a container, then lets the container 
--  handle the logic, otherwise will set the end scene on its own.
--
function CameraShot:Complete()
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
		self.container:NotifyShotComplete(self)
	else
		-- Put the player back into a safe space once the scene ends
		SetEntityMatrix(GetCharacterUnit(0), GetPathPoint(self.pathName, self.pathNode))
	end
	
	self:OnComplete()
end

PrintLog("Exited")