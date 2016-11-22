-----------------------------------------------------------------
-----------------------------------------------------------------
-- MASS EFFECT: UNIFICATION Cinematic Overlay Interface Screen Script by Aaron Gilbert
-- Build 30307/06
-- Screen Names: Marth8880, GT-Marth8880, [GT] Marth8880, [GT] Bran
-- E-Mail: Marth8880@gmail.com
-- Mar 7, 2016
-- Copyright (c) 2016 Aaron Gilbert
-- 
-- About:
-- 
-- 
-- 
-- Usage:
-- 
-- 
-- 
-- Legal:
--  This script is licensed under the BSD 3-Clause License. A copy of this license (as LICENSE.md) should have been included
--  with this script. If it wasn't, it can also be found here: https://www.w3.org/Consortium/Legal/2008/03-bsd-license.html
--  
--  THIS SCRIPT IS NOT MADE, DISTRIBUTED, OR SUPPORTED BY LUCASARTS, A DIVISION OF LUCASFILM ENTERTAINMENT COMPANY LTD.
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
