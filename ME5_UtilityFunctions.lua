-----------------------------------------------------------------
-----------------------------------------------------------------
-- MASS EFFECT: UNIFICATION Master Script by A. Gilbert
-- Version 30206/06
-- Screen Names: Marth8880, GT-Marth8880, [GT] Marth8880, [GT] Bran
-- E-Mail: Marth8880@gmail.com
-- Feb 06, 2016
-- Copyright (c) 2016 A. Gilbert.

-- About this script: This script contains various utility functions 
-- that perform various tasks such as killing all members of a certain 
-- team, getting the number of units alive in an array of teams, etc.

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
	print("ME5_UtilityFunctions: Entered")

---
-- Returns the number of units alive in a table of teams 'teams'.
-- @param #table teams The table of teams to process.
function GetNumTeamMembersAliveInTable(teams)
	-- The number of members that are alive
	local numAlive = 0
	
	-- Go through the table of teams and count the number of members that are alive
	for i in pairs(teams) do
		numAlive = numAlive + GetNumTeamMembersAlive(teams[i])
	end
	
	-- Return the result
	return numAlive
end

---
-- Kills all units on team 'teamID'.
-- @param #int teamID The numeric ID of the team to perform the function on.
function KillAllTeamMembers(teamID)
		print("ME5_UtilityFunctions.KillAllTeamMembers(): Entered")
		
	local numDudes = GetTeamSize(teamID)
	
	for i=1,numDudes do
		-- Get each team member and murder them lmao
		KillObject(GetCharacterUnit(GetTeamMember(teamID, i)))
	end
end

	print("ME5_UtilityFunctions: Exited")