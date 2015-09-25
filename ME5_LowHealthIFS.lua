-----------------------------------------------------------------
-----------------------------------------------------------------
-- MASS EFFECT: UNIFICATION Low Health IFS Script by Nedarb7
-- Version 20404/06
-- Screen Names: Nedarb7
-- E-Mail: Marth8880@gmail.com
-- Apr 04, 2015
-- Copyright (c) 2015 Nedarb7.

-- About this script: The purpose of script is to work with MEU's 
-- low health function and display a red vignette when the player 
-- has low health.


-- Legal Stuff:
-- Usage of this script is unauthorized without mine and Nedarb7's prior consent. Contact us if you wish to use it.
-- Do not claim this script as your own. It may not be much, but we did spend some time writing it after all.
-- We are not responsible for any damages that might be incurred through the use of this script.
-- THIS SCRIPT IS NOT MADE, DISTRIBUTED, OR SUPPORTED BY LUCASARTS, A DIVISION OF LUCASFILM ENTERTAINMENT COMPANY LTD.
-----------------------------------------------------------------
-----------------------------------------------------------------

ifs_lowhealth_vignette = NewIFShellScreen {
	Timer = nil,             -- This is our timer variable. It is useless unless used by the update function.
	TimerMngr = nil,         -- Manages the amount of frames displayed and prepares the timer for rewinding
	TimerType = nil,         -- This will only be used for reversing the vision effects
	bNohelptext_back = 1,    -- Remove the default "back" button
	bNohelptext_backPC = 1,  -- To be safe, use PC variable as well
	bNohelptext_accept = 1,  -- Remove the default "accept" button
	bg_texture = nil,        -- Background texture, leave it at nil since the update function manages that
	movieBackground = nil,   -- We don't have a movie background
	movieIntro      = nil,   -- We don't have a movie intro
	
	Enter = function(this, bFwd) -- Function runs on entering the screen
		gIFShellScreenTemplate_fnEnter(this, bFwd) -- call base class
		
		-- Make sure these variables are only set on entering forward to the screen, not backing in
		if(bFwd) and this.TimerType ~= false then -- Further, prevent spawn screen bugs
			this.Timer = 10			-- By setting the timer to 10, we have initiated the fake timer
			this.TimerMngr = 0		-- We will also keep track of frames
			this.TimerType = nil	-- Reset the reversal if on entering screen to prevent bugs
		end
		
		-- Disable mouse
		ScriptCB_EnableCursor(nil)
	end,
	
	Update = function(this, fDt)
		gIFShellScreenTemplate_fnUpdate(this, fDt) -- Load defaults
		
		-- Keep the mouse invisible (bug fix)
		ScriptCB_EnableCursor(nil)
		
		-- Exit this function as soon as possible if the timer is nil
		if this.Timer == nil then return end
		
		-- Safety reasons, we don't want to jump frames
		if fDt < 0.5 then
			-- Subtract the function delay time from our timer variable
			this.Timer = this.Timer - ( fDt * 100 )
			
			-- Timer time
			if this.Timer <= 0 then
				-- Make sure we haven't passed ten frames
				if this.TimerMngr < 10 and this.TimerType == nil then
					-- Count the frame
					this.TimerMngr = this.TimerMngr + 1
					
					-- Change the texture using TimerMngr as our frame number
					IFImage_fnSetTexture(ifs_lowhealth_vignette["lowhealth_vignette_textures"], "meu_lowhealth_threshold_" .. this.TimerMngr)
					
					Timer = nil -- End the timer
					
				elseif this.TimerType == true then -- If it is a reversed process, undo the effects
					-- Count the frame
					this.TimerMngr = this.TimerMngr - 1
					
					-- Change the texture using TimerMngr as our frame number
					IFImage_fnSetTexture(ifs_lowhealth_vignette["lowhealth_vignette_textures"], "meu_lowhealth_threshold_" .. this.TimerMngr)
					
					if this.TimerMngr <= 0 then -- Exit the screen when no frames are left
						ScriptCB_PopScreen()
					end
				end
			end
		end
	end,
	
	Exit = function(this, bFwd)
	end,
	
	Input_Accept = function(this)
	end,
	Input_Back = function(this)
	end,
	Input_GeneralUp = function(this)
	end,
	Input_GeneralRight = function(this)
	end,
	Input_GeneralDown = function(this)
	end,
	Input_GeneralLeft = function(this)
	end,
	Input_GeneralUp2 = function(this)
	end,
	Input_GeneralRight2 = function(this)
	end,
	Input_GeneralDown2 = function(this)
	end,
	Input_GeneralLeft2 = function(this)
	end,
	
}

-- This function will create our texture table
function ifs_LowHealth_TextureTable(this)  
	local w,h = ScriptCB_GetScreenInfo()
	
	ifs_lowhealth_vignette["lowhealth_vignette_textures"] = NewIFImage {
		ZPos = 255, -- or ZOrder
		ScreenRelativeX = 0.5,
		ScreenRelativeY = 0.5,
		texture = "single_player_campaign",
		localpos_l = -w / 2,  -- localpos_(x) is how far the image stretches in a direction from the position
		localpos_t = -h / 2,
		localpos_r = w / 2,
		localpos_b = h / 2,
	}
	
	-- Make the texture invisible
	IFImage_fnSetTexture(ifs_lowhealth_vignette["lowhealth_vignette_textures"], nil)
end

-- Call our texture making function
ifs_LowHealth_TextureTable(ifs_lowhealth_vignette)
ifs_LowHealth_TextureTable = nil

-- Make the screen
AddIFScreen(ifs_lowhealth_vignette,"ifs_lowhealth_vignette")