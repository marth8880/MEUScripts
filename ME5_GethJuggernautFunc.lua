-----------------------------------------------------------------
-----------------------------------------------------------------
-- MASS EFFECT: UNIFICATION Geth Juggernaut Functionality Script by A. Gilbert
-- Build 31025/06
-- Screen Names: Marth8880, GT-Marth8880, [GT] Marth8880, [GT] Bran
-- E-Mail: Marth8880@gmail.com
-- Oct 25, 2016
-- Copyright (c) 2016 A. Gilbert.
-- 
-- About this script: This script contains various functions 
-- regarding the Heretic/Evolved Geth Juggernaut.
-- 
-- Usage: Simply call Init_JuggernautSquads_GTH() or 
-- Init_JuggernautSquads_EVG() anywhere in ScriptInit(), or 
-- Init_EvolvedJuggernautPowerDrain() anywhere in ScriptPostLoad().
-- 
-- 
-- Legal Stuff:
-- You are welcome to use this script in your custom-made mods and maps so long as they are not being rented or sold.
-- If you use this script, please credit me in the readme of the project you used it in.
-- Do not claim this script as your own. It may not be much, but I did spend some time writing it after all.
-- You may edit this script as you need in order to make it work with your own map or mod.
-- I am not responsible for any damages that might be incurred through the use of this script.
-- THIS SCRIPT IS NOT MADE, DISTRIBUTED, OR SUPPORTED BY LUCASARTS, A DIVISION OF LUCASFILM ENTERTAINMENT COMPANY LTD.
-----------------------------------------------------------------
-----------------------------------------------------------------

print("ME5_GethJuggernautFunc: Entered")

---
-- Sets up the event responses for Heretic Geth Juggernaut squads.
-- 
function Init_JuggernautSquads_GTH()
	print("ME5_GethJuggernautFunc.Init_JuggernautSquads_GTH(): Entered")
	
	local players = {}
	local goals = {}
	local count = 0
	local addgoal = OnCharacterSpawn(
		function(player)
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
		function(player,killer)
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
	print("ME5_GethJuggernautFunc.Init_JuggernautSquads_EVG(): Entered")
	
	local players = {}
	local goals = {}
	local count = 0
	local addgoal = OnCharacterSpawn(
		function(player)
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
		function(player,killer)
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
	print("ME5_GethJuggernautFunc.Init_EvolvedJuggernautPowerDrain(): Entered")
	
	local enemydamage = OnObjectDamage(
		function(object, damager)
			--local dmgrPtr = GetEntityPtr(GetCharacterUnit(damager))
			--print(object)
			--print(damager)
			--print(dmgrPtr)
			--if IsCharacterHuman(dmgrPtr) then
				if GetObjectLastHitWeaponClass(object) == "weap_tech_powerdrain" then
					local charPtr = GetCharacterUnit(damager)
					
					-- make it so shields can be extracted only from enemies
					if GetObjectTeam(object) ~= GetObjectTeam(charPtr) then
						print("ME5_GethJuggernautFunc.Init_EvolvedJuggernautPowerDrain(): Object team is CIS")
						
						-- Get the Juggernaut's current shields
						local curShields = GetObjectShield(charPtr)
						local addShields = 50	-- Amount of shields to add
						local maxShields = 1140	-- Juggernaut's MaxShield value in its ODF
						
						print("ME5_GethJuggernautFunc.Init_EvolvedJuggernautPowerDrain(): Unit's current shields: "..curShields)
						
						-- Only regenerate if the current shields are less than the max shields
						if curShields < maxShields then
							-- Calculate the Juggernaut's final total shields value
							local newShields = curShields + addShields
							
							-- Apply the shields change
							SetProperty( charPtr, "CurShield", newShields )
							print("ME5_GethJuggernautFunc.Init_EvolvedJuggernautPowerDrain(): Unit's new shields: "..newShields)
							
							-- Are the Juggernaut's current shields over the limit?
							if newShields > maxShields then
								print("ME5_GethJuggernautFunc.Init_EvolvedJuggernautPowerDrain(): Unit's shields are over the MaxShield limit at "..newShields.."... Resetting to "..maxShields)
								SetProperty( charPtr, "CurShield", maxShields )	-- reset the Juggernaut's shields to its maximum value
							end
						end
					else
						print("ME5_GethJuggernautFunc.Init_EvolvedJuggernautPowerDrain: Object team is not CIS")
					end
				end
			--end
		end
	)
end


print("ME5_GethJuggernautFunc: Exited")