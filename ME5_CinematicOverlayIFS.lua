-----------------------------------------------------------------
-----------------------------------------------------------------
-- MASS EFFECT: UNIFICATION Cinematic Overlay Interface Screen Script by A. Gilbert
-- Version 30307/06
-- Screen Names: Marth8880, GT-Marth8880, [GT] Marth8880, [GT] Bran
-- E-Mail: Marth8880@gmail.com
-- Mar 7, 2016
-- Copyright (c) 2016 Aaron Gilbert
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
-- 
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


function ifs_cinematic_overlay_fnBuildScreen( this, mode )
	
	local BackButtonW = 300 -- made 130 to fix 6198 on PC - NM 8/18/04
	local BackButtonH = 25
	local OffsetY = -15
	
	-- skip cutscene button
	this.skip_cutscene = NewPCIFButton {
		ScreenRelativeX = 0.0, -- left
		ScreenRelativeY = 1.0, -- bottom
		y = OffsetY, -- just above bottom
		x = 120,

		btnw = BackButtonW, 
		btnh = BackButtonH,
		font = "meu_myriadpro_medium", 
		bg_tail = 20,
		--nocreatebackground = 1,
		tag = "_back",
	} -- end of Helptext_Back
	
	RoundIFButtonLabel_fnSetString(this.skip_cutscene,"ifs.cinematic.skip_cutscene")
end

ifs_cinematic_overlay = NewIFShellScreen 
{
	nologo = 1,
	bNohelptext_back = 1,		-- Remove the default "back" button
	bNohelptext_backPC = 1,		-- To be safe, use PC variable as well
	bNohelptext_accept = 1,		-- Remove the default "accept" button
	Container = nil,			-- The cinematic container object associated with this overlay
	
	-- Call this to remove the screen
	PullScreen = function(this)
		ScriptCB_PopScreen()
	end,
	
	Enter = function(this)
		if(this.skip_cutscene) then
			gIFShellScreenTemplate_fnEnter(this, bFwd) -- call base class
			
			IFButton_fnSelect(this.skip_cutscene, false, false) -- Deactivate button
			Container:Complete()
		end
	end,
	
	Update = function(this, fDt)
		gIFShellScreenTemplate_fnUpdate(this, fDt) -- Load defaults
	end,
	
	Input_Back = function(this)
	end,
	Input_Accept = function(this)
	end,
	Input_GeneralLeft = function(this)
	end,
	Input_GeneralRight = function(this)
	end,
	Input_GeneralUp = function(this)
	end,
	Input_GeneralDown = function(this)
	end,
}

ifs_cinematic_overlay_fnBuildScreen(ifs_cinematic_overlay, 0)
AddIFScreen(ifs_cinematic_overlay,"ifs_cinematic_overlay")
ifs_cinematic_overlay_fnBuildScreen = nil
