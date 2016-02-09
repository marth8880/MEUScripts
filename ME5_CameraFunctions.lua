-----------------------------------------------------------------
-----------------------------------------------------------------
-- MASS EFFECT: UNIFICATION Utility Functions Script by A. Gilbert
-- Version 30203/06
-- Screen Names: Marth8880, GT-Marth8880, [GT] Marth8880, [GT] Bran
-- E-Mail: Marth8880@gmail.com
-- Feb 03, 2016
-- Copyright (c) 2016 A. Gilbert.

-- About this script: This script contains various functions for 
-- MEU's cinematic camera system.

-- Usage:
-- Load the script using ScriptCB_DoFile() in your main mission script
-- Call whichever functions you need out of this script. Example:
-- 
-- LoadSSV()
-- LoadGTH()
-- Setup_SSVxGTH_sm()
-- 
-- The above example would load and then set up the Systems Alliance and Geth side


-- Legal Stuff:
-- You are welcome to use this script in your custom-made mods and maps so long as they are not being rented or sold.
-- If you use this script, please credit me in the readme of the project you used it in.
-- Do not claim this script as your own. It may not be much, but I did spend some time writing it after all.
-- You may edit this script as you need in order to make it work with your own map or mod.
-- I am not responsible for any damages that might be incurred through the use of this script.
-- THIS SCRIPT IS NOT MADE, DISTRIBUTED, OR SUPPORTED BY LUCASARTS, A DIVISION OF LUCASFILM ENTERTAINMENT COMPANY LTD.
-----------------------------------------------------------------
-----------------------------------------------------------------
	print("ME5_CameraFunctions: Entered")

---
-- Begins a cinematic sequence based on animation group 'animationName' and camera object 'cameraObj'.
-- @param #string animationName The name of the animation group to play.
-- @param #string cameraObj The name of the camera object associated with the cinematic.
function PlayCinematic(animationName, cameraObj)
	print("ME5_CameraFunctions.PlayCinematic(): Entered")
	
	-- Force the player into our camera vehicle
	EnterVehicle(0, cameraObj)
	
	-- Disable player and camera vehicle input
	SetProperty(0, "PhysicsActive", 0)
	SetProperty(cameraObj, "PhysicsActive", 0)
	
	--EntityFlyerTakeOff(cameraObj)
	
	PlayAnimation(animationName)
end

---
-- Zooms the camera object to angle 'FOV'.
-- @param #int FOV The new field of view angle to zoom to.
function ZoomCamera(FOV)
	print("ME5_CameraFunctions.ZoomCamera(): Entered")
	
	SetClassProperty("eur_prop_camera", "FirstPersonFOV", FOV)
	SetClassProperty("eur_prop_camera", "ThirdPersonFOV", FOV)
end

	print("ME5_CameraFunctions: Exited")