-----------------------------------------------------------------
-----------------------------------------------------------------
-- MASS EFFECT: UNIFICATION Cinematic Container Script by Aaron Gilbert
-- Build 31110/06
-- Screen Names: Marth8880, GT-Marth8880, [GT] Marth8880, [GT] Bran
-- E-Mail: Marth8880@gmail.com
-- Nov 10, 2016
-- Copyright (c) 2016 Aaron Gilbert
-- 
-- About:
--  Largely based on MultiObjectiveContainer.lua
--  Manages a table of a chain of camera shots. Basically, there are one or more camera shots in a cinematic sequence. When a shot finishes, 
--  it moves onto the next shot. When all of the shots are completed, it exits the cinematic.
-- 
-- 
-- Usage:
--  1. Load the script using ScriptCB_DoFile() in your main mission script.
--  2. Initialize CinematicContainer:New{} into a variable. Example: 
--  
--  		testCinematicSequence = CinematicContainer:New{pathName = "playerspawn_start"}
--  
--  3. Call :AddShot() on your CinematicContainer variable for each CameraShot:New{} variable you assigned previous to CinematicContainer:New{}. Example: 
--  
--  		testCinematicSequence:AddShot(TestShot1)
--  		testCinematicSequence:AddShot(TestShot2)
--  		<...>
--  		testCinematicSequence:AddShot(TestShot6)
--  
--  4. After you've done step 3 for each shot, call :Start() on your CinematicContainer variable to start the cinematic. Example: 
--  
--  		testCinematicSequence:Start()
--  
--  5. CinematicContainer includes a Start() and Complete() function that you can override to add extra behavior when the cinematic starts or ends.
--   To do so, call .OnStart() or .OnComplete() somewhere in your mission script and assign a new function to it. Example: 
--  
--  		testCinematicSequence.OnStart() = function(self)
--  			-- do stuff
--  		end
--  		
--  		testCinematicSequence.OnComplete() = function(self)
--  			-- do stuff
--  		end
-- 		
-- 		NOTE: You can only override these functions BEFORE :Start() has been called!
-- 
-- 
-- Legal:
--  This script is licensed under the BSD 3-Clause License. A copy of this license (as LICENSE.md) should have been included
--  with this script. If it wasn't, it can also be found here: https://www.w3.org/Consortium/Legal/2008/03-bsd-license.html
--  
--  THIS SCRIPT IS NOT MADE, DISTRIBUTED, OR SUPPORTED BY LUCASARTS, A DIVISION OF LUCASFILM ENTERTAINMENT COMPANY LTD.
-----------------------------------------------------------------
-----------------------------------------------------------------
local __SCRIPT_NAME = "ME5_CinematicContainer";
local debug = true

local function PrintLog(...)
	if debug == true then
		print("["..__SCRIPT_NAME.."]", unpack(arg));
	end
end

PrintLog("Entered")

---
-- This is a constructor for a CinematicContainer object.
-- @param #string pathName		The name of the path to move the player to after the scene has ended.
-- @param #int pathNode			OPTIONAL: The node of the path 'pathName' to move the player to. Default value: 0
-- 
CinematicContainer = {
    -- Fields that need to be specified on creation
    pathName = nil, 				-- The name of the path to move the player to after the scene has ended.
    
    -- Optional fields
    pathNode = nil, 				-- The node of the path /pathName/ to move the player to.
}


----
-- Creates a new CinematicManager
--
function CinematicContainer:New(o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	return o
end

---
-- DESIGNERS: Override this function when you want to customize extra behavior when the cinematic starts
--  (ask a lua coder if you need help with this...it's really pretty easy)
--
function CinematicContainer:OnStart()

end

---
-- DESIGNERS: Override this function when you want to customize extra behavior when the cinematic completes
--  (ask a lua coder if you need help with this...it's really pretty easy)
--
function CinematicContainer:OnComplete()

end


---
-- Insert a new shotLayer and add the shot to it
--
function CinematicContainer:AddShot(...)
	self.shotSets = self.shotSets or {}
	
	for i, shot in ipairs(arg) do
		shot:SetContainer(self)
	end
	
	table.insert(self.shotSets, arg)
end

---
-- Activates the first shot
--
function CinematicContainer:Start()
	if self.pathName == nil then
		PrintLog("Start(): WARNING: pathName must be specified!")
		return
	end
	
	-- Initialize values for data fields (even if they don't exist)
	self.pathNode = self.pathNode or 0
	
	local numShots = table.getn(self.shotSets)
	if(numShots == 0) then
		PrintLog("Start(): WARNING: No shots were added to the CinematicContainer")
		return
	end

	-- Activate the first shot
	self:ActivateShotSet(1)
	
	-- Callback for overriding startup behavior
	self:OnStart()
end

---
-- Use this to tell the container when an active shot has finished
--
function CinematicContainer:NotifyShotComplete(shot)
	
	-- Check the active shot. If it's complete, then move 
	-- onto the next layer or trigger the scene end
	for i, shot in ipairs(self.shotSets[self.activeSet]) do
		if not shot.isComplete then
			return		--if there's an incomplete objective, then just keep playing the map
		end
	end
	
	-- If we've reached here, then all the shots are complete
	if self.activeSet >= table.getn(self.shotSets) then
		-- We have no more shot sets, so finish the scene
		self:Complete()
	else
		-- Move on to the next shot
		self:ActivateShotSet( self.activeSet + 1 )
	end
	
end

---
-- Updates the current shot set number, and activates all the shots within that set
--
function CinematicContainer:ActivateShotSet(whichSet)
	-- Don't advance to the next set if this is the last one
	--  (this handles the case when the last two objective sets
	--  are completed in a very short period of time, and the
	--  missionVictoryTime is relatively long)
	if whichSet > table.getn(self.shotSets) then
		-- Pretty sure we don't need anything here since we already 
		--  have ExitCamera() being called in CameraShot:Complete().
		return
	end
	
	self.activeSet = whichSet
	for i, shot in ipairs(self.shotSets[self.activeSet]) do
		shot:Start()
	end
end

---
-- Call this to complete the cinematic sequence
--
function CinematicContainer:Complete()
	-- Put the player back into a safe space once the scene ends
	SetEntityMatrix(GetCharacterUnit(0), GetPathPoint(self.pathName, self.pathNode))
	
	-- Callback for overriding completion behavior
	self:OnComplete()
end

PrintLog("Exited")