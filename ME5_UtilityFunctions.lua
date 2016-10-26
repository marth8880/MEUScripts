-----------------------------------------------------------------
-----------------------------------------------------------------
-- MASS EFFECT: UNIFICATION Utility Functions Script by A. Gilbert
-- Version 31025/06
-- Screen Names: Marth8880, GT-Marth8880, [GT] Marth8880, [GT] Bran
-- E-Mail: Marth8880@gmail.com
-- Oct 25, 2016
-- Copyright (c) 2016 A. Gilbert.
-- 
-- About this script: This script contains various utility functions 
-- that perform various tasks such as killing all members of a certain 
-- team, getting the number of units alive in an array of teams, etc.
-- 
-- Usage:
-- Load the script using ScriptCB_DoFile() in your main mission script
-- Call whichever functions you need out of this script. Example:
-- 
-- LoadSSV()
-- LoadGTH()
-- Setup_SSVxGTH_sm()
-- 
-- The above example would load and then set up the Systems Alliance and Geth side
-- 
-- 
-- Legal Stuff:
-- Usage of this script is unauthorized without my prior consent. Contact me if you wish to use it. 
-- Do not claim this script as your own. I did spend time writing it after all. I cannot be held  
-- accountable for any damages that might be incurred through the use of this script.
-- THIS SCRIPT IS NOT MADE, DISTRIBUTED, OR SUPPORTED BY LUCASARTS, A DIVISION OF LUCASFILM ENTERTAINMENT COMPANY LTD.
-----------------------------------------------------------------
-----------------------------------------------------------------

print("ME5_UtilityFunctions: Entered")

---
-- Returns the number of units alive in a table of teams /teams/.
-- @param #table teams	The table of teams to process.
-- @return #int			The number of units alive.
-- 
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
-- Kills all units on team /teamID/.
-- @param #int teamID	The numeric ID of the team to perform the function on.
-- 
function KillAllTeamMembers(teamID)
		print("ME5_UtilityFunctions.KillAllTeamMembers(): Entered")
		
	local numDudes = GetTeamSize(teamID)
	
	print("ME5_UtilityFunctions.KillAllTeamMembers(): numDudes = "..numDudes)
	
	for i=0,numDudes do
		-- Round up each team member and murder them lmao
		KillObject(GetCharacterUnit(GetTeamMember(teamID, i)))
	end
end


---
-- Applies the given function to all the units of the given teams.
-- @param #function cont		The continuation function to call.  Should take 3 parameters: unit, property, value
-- @param #data property		Value to be passed on to the given cont function.
-- @param #data value			Value to be passed on to the given cont function.
-- @param #table teams			Table of numbers which represent team numbers.
-- @param #string aiOrHuman		"ai" to only process AI bots, "human" to only process human players, nil to process both bots and humans.
--
function ApplyFunctionOnTeamUnits( cont, property, value, teams, aiOrHuman )
	if cont == nil then return end   --if have nothing to do, then do nothing
	
	--the teams whos units will have the given function applied to them
	local teams = teams or {1, 2}
	
	--for each team,
	local team
	for team = 1, table.getn(teams) do
		
		--get the team's size
		local size = GetTeamSize( teams[team] )
		
		--for each team member,
		local m
		for m = 0, size-1 do
			
			--get a team member's unit
			local player = GetTeamMember(teams[team], m)
			local type = IsCharacterHuman(player)
			
			if (type and (aiOrHuman == "ai")) or ((not type) and (aiOrHuman == "human")) then
				--player is not the correct type
			else
				local unit = GetCharacterUnit(player)
				print( "ApplyFunctionOnTeamUnits(): Team, Unit:", team, m ) 
				cont(player, unit, property, value)
			end
		
		end
	end
end


---
-- Kills the units on the given /teams/.
-- @param #table teams	Table of teams whose units should be killed.
-- @param #bool ai		True to kill only AI units, false to kill only human units.
-- 
function KillUnits( teams, ai )
	--check input
	if teams == nil then return end
	if ai == nil then return end
	
	local miniFun = function( player, unit, property, ai, teams )
		if (player == nil) or (unit == nil) or (ai == nil) then return end   --check input
		
		--determine the player type (ai or human)
		--local isAi = true
		--if IsCharacterHuman(player) then
		--   isAi = false
		--end
		local isAi = not IsCharacterHuman(player)
		
		--if is the correct type, kill it
		if (isAi == ai) then
			KillObject( unit )
		end
	end
	
	ApplyFunctionOnTeamUnits( miniFun, nil, ai, teams )
end


---
-- Moves entity /entIn/ to path node /nodeIn/ of path /pathIn/.
-- @param #entity entIn		The entity to move.
-- @param #string pathIn	The name of the path to get the node from.
-- @param #int nodeIn		The numeric path node to move the entity to.
-- 
function MoveEntityToNode(entIn, pathIn, nodeIn)
	print("MoveEntityToNode(): Entered")

	if not entIn then
		print("MoveEntityToNode(): Warning! Entity not specified for move")
		return false
	elseif not pathIn then
		print("MoveEntityToNode(): Warning! Path not specified for entity "..entIn.." move")
		return false
	end
	
	local node
	if nodeIn then
		node = nodeIn
	else
		node = 0
	end
	
	local locDest = GetPathPoint(pathIn,node)
	local charUnit = GetCharacterUnit(entIn)
	local charVeh = GetCharacterVehicle(entIn)
	
	if charVeh then
		SetEntityMatrix(charVeh,locDest)
	elseif charUnit then
		SetEntityMatrix(charUnit,locDest)
		return true
	end
		return false
end


---
-- Moves all units in team /teamID/ to path /pathName/.
-- @param #int teamID		The numeric ID of the team to reset.
-- @param #string pathName	The name of the path to move the units to.
-- 
function ResetTeamMemberLocations(team, pathName)
	print("ResetTeamMemberLocations(): Entered")
	
	--get the team's size
	local size = GetTeamSize( team )
	
	--for each team member,
	local m
	for m = 0, size-1 do
		
		--get a team member's unit
		local player = GetTeamMember(team, m)
		
		local unit = GetCharacterUnit(player)
		print("ResetTeamMemberLocations(): Team, Unit:", team, m)
		
		local pathPtr = GetPathPoint(pathName, 0)
		
		--MoveEntityToNode(player, pathName, 0)
		
		--SetEntityMatrix(unit, pathPtr)	-- TODO: fix this!
		
		KillUnits({team}, true)
	end
end


---
-- Shuffles the order of the cells in table /t/.
-- @param #table t	The table to shuffle.
-- 
function ShuffleTable( t )
	local rand = math.random 
	assert( t, "ShuffleTable() expected a table, got nil" )
	local iterations = table.getn(t)
	local j
	
	for i = iterations, 2, -1 do
		j = rand(i)
		t[i], t[j] = t[j], t[i]
	end
end


print("ME5_UtilityFunctions: Exited")