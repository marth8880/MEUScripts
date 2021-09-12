-----------------------------------------------------------------
-----------------------------------------------------------------
-- MASS EFFECT: UNIFICATION Geth Juggernaut Functionality Script by Aaron Gilbert
-- Build 31025/06
-- Screen Names: Marth8880, GT-Marth8880, [GT] Marth8880, [GT] Bran
-- E-Mail: Marth8880@gmail.com
-- Oct 25, 2016
-- Copyright (c) 2017, Aaron Gilbert All rights reserved.
-- 
-- About: 
--  This script contains various functions regarding the Heretic/Evolved Geth Juggernaut.
-- 
-- 
-- Usage: 
--  Simply call Init_JuggernautSquads_GTH() or Init_JuggernautSquads_EVG() anywhere in ScriptInit(), or 
--  Init_EvolvedJuggernautPowerDrain() anywhere in ScriptPostLoad().
-- 
-- 
-- Legal:
--  This script is licensed under the BSD 3-Clause License. A copy of this license (as LICENSE.md) should have been included
--  with this script. If it wasn't, it can also be found here: https://www.w3.org/Consortium/Legal/2008/03-bsd-license.html
--  
--  THIS SCRIPT IS NOT MADE, DISTRIBUTED, OR SUPPORTED BY LUCASARTS, A DIVISION OF LUCASFILM ENTERTAINMENT COMPANY LTD.
-----------------------------------------------------------------
-----------------------------------------------------------------

local __SCRIPT_NAME = "ME5_GethJuggernautFunc";
local debug = true

local function PrintLog(...)
	if debug == true then
		print("["..__SCRIPT_NAME.."]", unpack(arg));
	end
end

PrintLog("Entered")

---
-- Sets up the event responses for Heretic Geth Juggernaut squads.
-- 
function Init_JuggernautSquads_GTH()
	PrintLog("Init_JuggernautSquads_GTH(): Entered")
	
	local players = {}
	local goals = {}
	local count = 0
	local addgoal = OnCharacterSpawn(
		function(player)
			-- Exit immediately if there are incorrect values
			if not player then return end
			
			if GetCharacterClass(player) == 7 and GetCharacterTeam(player) == CIS then -- replace 4 with the index of your commander, starting with 0
				local seen = false
				for i = 1,count do
					if players[i] == player then
						seen = true
						goals[i] = AddAIGoal(CIS, "Follow", 8, GetCharacterUnit(player)) -- or "Follow" if you want them to follow very closely, and change the weight too
					end
				end
				if not seen then
					count = count + 1
					players[count] = player
					goals[count] = AddAIGoal(CIS, "Follow", 8, GetCharacterUnit(player)) -- or "Follow" if you want them to follow very closely, and change the weight too
				end
			end
		end
	)
	
	local removegoal = OnCharacterDeath(
		function(player, killer)
			-- Exit immediately if there are incorrect values
			if not player then return end
			--if not killer then return end
			
			for j = 1,count do
				if players[i] == player and not goals[i] == nil then
					DeleteAIGoal(goals[i])
					goals[i] = nil
				end
			end
		end
	)
end


---
-- Sets up the event responses for Evolved Geth Juggernaut squads.
-- 
function Init_JuggernautSquads_EVG()
	PrintLog("Init_JuggernautSquads_EVG(): Entered")
	
	local players = {}
	local goals = {}
	local count = 0
	local addgoal = OnCharacterSpawn(
		function(player)
			-- Exit immediately if there are incorrect values
			if not player then return end
			
			if GetCharacterClass(player) == 6 and GetCharacterTeam(player) == REP then -- replace 4 with the index of your commander, starting with 0
				local seen = false
				for i = 1,count do
					if players[i] == player then
						seen = true
						goals[i] = AddAIGoal(REP, "Follow", 8, GetCharacterUnit(player)) -- or "Follow" if you want them to follow very closely, and change the weight too
					end
				end
				if not seen then
					count = count + 1
					players[count] = player
					goals[count] = AddAIGoal(REP, "Follow", 8, GetCharacterUnit(player)) -- or "Follow" if you want them to follow very closely, and change the weight
				end
			end
		end
	)
	
	local removegoal = OnCharacterDeath(
		function(player, killer)
			-- Exit immediately if there are incorrect values
			if not player then return end
			
			for j = 1,count do
				if players[i] == player and not goals[i] == nil then
					DeleteAIGoal(goals[i])
					goals[i] = nil
				end
			end
		end
	)
end


---
-- Sets up the event responses for the Evolved Juggernaut's Power Drain ability.
-- 
function Init_EvolvedJuggernautPowerDrain()
	PrintLog("Init_EvolvedJuggernautPowerDrain(): Entered")
	
	-- TODO: check to verify that this doesn't actually work in multiplayer
	if not ScriptCB_InMultiplayer() then
		local enemydamage = OnObjectDamage(
			function(object, damager)
				-- Exit immediately if there are incorrect values
				if not object then return end
				if not damager then return end
				
				--local dmgrPtr = GetEntityPtr(GetCharacterUnit(damager))
				--print(object)
				--print(damager)
				--print(dmgrPtr)
				--if IsCharacterHuman(dmgrPtr) then
					if GetObjectLastHitWeaponClass(object) == "weap_tech_powerdrain" then
						local charPtr = GetCharacterUnit(damager)
						
						-- make it so shields can be extracted only from enemies
						if GetObjectTeam(object) ~= GetObjectTeam(charPtr) then
							PrintLog("Init_EvolvedJuggernautPowerDrain(): Object team is CIS")
							
							-- Get the Juggernaut's current shields
							local curShields = GetObjectShield(charPtr)
							local addShields = 50	-- Amount of shields to add
							local maxShields = 1140	-- Juggernaut's MaxShield value in its ODF
							
							PrintLog("Init_EvolvedJuggernautPowerDrain(): Unit's current shields: "..curShields)
							
							-- Only regenerate if the current shields are less than the max shields
							if curShields < maxShields then
								-- Calculate the Juggernaut's final total shields value
								local newShields = curShields + addShields
								
								-- Apply the shields change
								SetProperty( charPtr, "CurShield", newShields )
								PrintLog("Init_EvolvedJuggernautPowerDrain(): Unit's new shields: "..newShields)
								
								-- Are the Juggernaut's current shields over the limit?
								if newShields > maxShields then
									PrintLog("Init_EvolvedJuggernautPowerDrain(): Unit's shields are over the MaxShield limit at "..newShields.."... Resetting to "..maxShields)
									SetProperty( charPtr, "CurShield", maxShields )	-- reset the Juggernaut's shields to its maximum value
								end
							end
						else
							PrintLog("Init_EvolvedJuggernautPowerDrain: Object team is not CIS")
						end
					end
				--end
			end
		)
	end
end


PrintLog("Exited")