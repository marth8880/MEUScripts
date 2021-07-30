-----------------------------------------------------------------
-----------------------------------------------------------------
-- MASS EFFECT: UNIFICATION Template Script by Aaron Gilbert
-- Build 80219/07
-- Screen Names: Marth8880, GT-Marth8880, [GT] Marth8880
-- E-Mail: Marth8880@gmail.com
-- Copyright (c) 2021, Aaron Gilbert All rights reserved.
-- 
-- About: 
--  Scripted weapons.
-- 
-- 
-- Legal:
--  This script is licensed under the BSD 3-Clause License. A copy of this license (as LICENSE.md) should have been included
--  with this script. If it wasn't, it can also be found here: https://www.w3.org/Consortium/Legal/2008/03-bsd-license.html
--  
--  THIS SCRIPT IS NOT MADE, DISTRIBUTED, OR SUPPORTED BY LUCASARTS, A DIVISION OF LUCASFILM ENTERTAINMENT COMPANY LTD.
-----------------------------------------------------------------
-----------------------------------------------------------------

local __SCRIPT_NAME = "ME5_Weapons";
local debug = true;

local function PrintLog(...)
	if debug == true then
		print("["..__SCRIPT_NAME.."]", unpack(arg));
	end
end

PrintLog("Entered");

function Init_Weapon_Charge()
	PrintLog("Init_Weapon_Charge: Entered")
	
	local chargeShieldRegenDivisor = 3	-- Divisor for percentage of max shields to regen
	
	local enemyDamageHandler = OnObjectDamage(
		function(object, damager)
			-- Exit immediately if there are incorrect values
			if not object then return end
			if not damager then return end
			if not GetObjectLastHitWeaponClass(object) then return end
			
			local hitByCorrectWeapon = false
			local hitByBanshee = false
			
			if string.ends(GetObjectLastHitWeaponClass(object), "charge") then
				hitByCorrectWeapon = true
			end
			
			if string.ends(GetObjectLastHitWeaponClass(object), "banshee_charge") then
				hitByBanshee = true
			end
			
			if hitByCorrectWeapon == true then
				local charPtr = GetCharacterUnit(damager)
				local objectPtr = GetEntityPtr(object)
				if not charPtr then return end
				if not objectPtr then return end
				
				if GetObjectTeam(object) ~= GetObjectTeam(charPtr)
				and GetObjectTeam(object) ~= 0 then
					local teleEffect = CreateEffect("com_sfx_biotic_charge_tele")
					SetEffectMatrix(teleEffect, GetEntityMatrix(charPtr))
					
					-- get start and end coordinates
					local xStart, yStart, zStart = GetWorldPosition(charPtr)
					local xEnd, yEnd, zEnd = GetWorldPosition(objectPtr)
					
					-- position deltas - create the vector
					local dX = xEnd - xStart
					local dY = yEnd - yStart
					local dZ = zEnd - zStart
					
					local distance = math.sqrt(dX * dX + dY * dY + dZ * dZ)
					
					local objLocation = GetEntityMatrix(objectPtr)
					-- create temporary other turret so we can calculate its rotation
					tempturret = CreateEntity("com_bldg_chargedummy", CreateMatrix(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, objLocation), "temp_turret")
					local xTemp, yTemp, zTemp = GetWorldPosition(tempturret)
					DeleteEntity(tempturret)
					tempturret = nil
					
					--calculate angle (y-axis rotation)
					local adjacent = xTemp - xEnd
					local opposite = zTemp - zEnd
					local hypotenuse = math.sqrt(((xTemp - xEnd) * (xTemp - xEnd)) + ((zTemp - zEnd) * (zTemp - zEnd)))
					local phi = math.acos(adjacent / hypotenuse)
					
					--correct the angle
					-- this was a pain in the ass
					if opposite < 0 then
						phi = phi + (math.pi) / 2
					else
						phi = -(phi - (math.pi) / 2)
					end
					
					local newMatrix = CreateMatrix(phi - math.pi, 0.0, 1.0, 0.0, xStart + (dX), yStart + (dY - 0.5), zStart + (dZ + 0.5), nil)
					SetEntityMatrix(charPtr, newMatrix)
					
					-- PrintLog("newMatrix", newMatrix)
					
					-- Don't recharge the user's shields if it's a Banshee
					if hitByBanshee == false then
						local curShields, maxShields = GetObjectShield(charPtr)
						local newShields = curShields + (maxShields / chargeShieldRegenDivisor)
						
						-- Don't let the shields spill over
						if newShields > maxShields then
							newShields = maxShields
						end
						
						SetProperty(charPtr, "CurShield", newShields)
					end
					
					if IsCharacterHuman(damager) and not ScriptCB_InMultiplayer() then
						ScriptCB_SndPlaySound("biotic_charge_exp_2D")
						-- ShowMessageText("level.common.debug.damager_ssv")
					end
				else
					-- PrintLog("Object team doesn't match")
				end
			end
		end
	)
end

---
-- Sets up the event responses for ordnance that applies damage over time (DOT).  Specifically, whenever an object is damaged by a weapon that's 
--  supposed to have DOT ammo or a power that's supposed to have DOT effects (like Incinerate), an invisible
--  auto-turret that fires an EmitterOrdnance is spawned at the object's matrix and then immediately self-destructs.
-- 
function Init_Weapon_DOT()
	PrintLog("Init_Weapon_DOT(): Entered")
	
	if not ScriptCB_InMultiplayer() then
		-- List of terms that incendiary weapons contain, these are used with string.sub(a,b,c) where a=[1], b=[2], c=[3]
		local dotWeapons = {
						{"incendiary", "com_bldg_incendiaryord_turret", -10, -1},
						{"incinerate", "com_bldg_incendiaryord_turret", -10, -1},
						{"incinerationblast", "com_bldg_incendiaryord_turret", -17, -1},
						{"scorch", "com_bldg_incendiaryord_turret", -6, -1},
						{"reave", "com_bldg_reaveord_turret", -5, -1},
		}
		
		-- Whenever an object is damaged
		local targetdamage = OnObjectDamage(
			function(object, damager)
				-- Exit immediately if any values are incorrect
				if not object then return end
				if not damager then return end
				
				local objectTeam = GetObjectTeam(object)
				local damagerTeam = GetCharacterTeam(damager)
				if (not objectTeam) or (objectTeam <= 0) then return end
				if (not damagerTeam) or (damagerTeam <= 0) then return end
				
				-- Are the object and damager on different teams?
				if objectTeam ~= damagerTeam then
					-- Figure out the damager's weapon (and exit if it's nil)
					local damagerWeapon = GetObjectLastHitWeaponClass(object)
					if not damagerWeapon then return end
					
					-- Is the weapon DOT?
					local bIsDot = false
					local weaponIdx
					
					for i in ipairs(dotWeapons) do
						if string.sub(damagerWeapon, dotWeapons[i][3], dotWeapons[i][4]) == dotWeapons[i][1] then
							bIsDot = true
							weaponIdx = i
							break
						end
					end
					
					-- Exit if the weapon isn't DOT, or continue if it is
					if bIsDot == false then
						return
					else
						-- Spawn the DOT ordnance turret
						gDotOrdTurretEntity = CreateEntity(dotWeapons[weaponIdx][2], GetEntityMatrix(object))
						
						--print("Weapon ("..damagerWeapon..") is DOT")
					end
				end
			end
		)
	end
end


function Init_Weapon_Cannibalize()
	PrintLog("Init_Weapon_Cannibalize(): Entered")
	
	gNumCorpsesAlive = 0	-- harr harr :P
	
	local function OnReaperDeath(object, killer)
		-- In order to prevent cases of corpses piling up out-of-bounds (for example), 
		-- only spawn a corpse if the unit was killed by another unit 
		if not killer then return end
		
		if gNumCorpsesAlive >= MAX_CANNIBALIZE_CORPSE_COUNT then
		else
			if ScriptCB_random() <= CANNIBALIZE_CORPSE_DROP_CHANCE then
				local corpsePos = GetEntityMatrix(object)
				CreateEntity("rpr_bldg_cannibalize_unbuilt", corpsePos, "cannibalize_sofuckingstupid")
				gNumCorpsesAlive = gNumCorpsesAlive + 1
			end
		end
	end
	
	local cannibalDeathHandler = OnObjectKillClass(OnReaperDeath, "rpr_inf_cannibal")
	local marauderDeathHandler = OnObjectKillClass(OnReaperDeath, rpr_inf_marauder)
	local ravagerDeathHandler = OnObjectKillClass(OnReaperDeath, "rpr_inf_ravager")
	local bruteDeathHandler = OnObjectKillClass(OnReaperDeath, "rpr_inf_brute")
	local bansheeDeathHandler = OnObjectKillClass(OnReaperDeath, rpr_inf_banshee)
	
	local onCannibalizeHandler = OnObjectKillClass(
		function(object, killer)
			-- There needs to be a killer
			if not killer then return end
			
			gNumCorpsesAlive = gNumCorpsesAlive - 1
			
			if GetObjectLastHitWeaponClass(object) == "rpr_weap_inf_cannibalize" then
				PrintLog("Cannibal consumed a corpse!")
				SetProperty(GetCharacterUnit(killer), "CurHealth", CANNIBALIZE_HEALTH_MAX)
				SetProperty(GetCharacterUnit(killer), "MaxHealth", CANNIBALIZE_HEALTH_MAX)
			end
		end,
		"rpr_bldg_cannibalize_unbuilt"
	)
end


function Init_Weapon_AcidDrop()
	PrintLog("Init_Weapon_AcidDrop(): Entered")
	
	gNumAcidTurretsAlive = 0
	
	local ravagerDeathHandler = OnObjectKillClass(
		function(object, killer)
			-- In order to prevent cases of corpses piling up out-of-bounds (for example), 
			-- only spawn a corpse if the unit was killed by another unit 
			if not killer then return end
			
			if gNumAcidTurretsAlive < MAX_RAVAGER_ACID_COUNT then
				if ScriptCB_random() <= RAVAGER_ACID_DROP_CHANCE then
					local turretPos = GetEntityMatrix(object)
					local newTurret = CreateEntity("rpr_weap_inf_ravager_acid_bldg", turretPos, "acidturret_sofuckingstupid")
					gNumAcidTurretsAlive = gNumAcidTurretsAlive + 1
					SetObjectTeam(newTurret, CIS)
					local newAvoidanceTurret = CreateEntity("rpr_weap_inf_ravager_acid_avoidance_bldg", turretPos, "avoidanceturret_sofuckingstupid")
				end
			end
		end, 
		"rpr_inf_ravager"
	)
	
	local acidTurretDeathHandler = OnObjectKillClass(
		function(object, killer)
			gNumAcidTurretsAlive = gNumAcidTurretsAlive - 1
		end,
		"rpr_weap_inf_ravager_acid_bldg"
	)
end


function Init_Weapon_DispenseSeekers()
	PrintLog("Init_Weapon_DispenseSeekers(): Entered")
	
	if ME5_SideVar ~= 2 and ME5_SideVar ~= 4 then return end
	
	gColCaptainsSpawned = {}
	
	local onColCaptainSpawn = OnCharacterSpawnTeam(
		function(player)
			if GetCharacterClass(player) == 2 then
				-- This Captain is new, so it hasn't spawned any Seekers yet
				gColCaptainsSpawned[GetCharacterUnit(player)] = false
			end
		end,
		CIS
	)
	
	local onColCaptainDie = OnObjectKill(
		function(object, killer)
			if not object then return end
			
			if GetEntityClass(GetEntityPtr(object)) == FindEntityClass("col_inf_captain") or
			GetEntityClass(GetEntityPtr(object)) == FindEntityClass("col_inf_captain_shield") then
				-- Remove the Captain from the registry
				if gColCaptainsSpawned[object] ~= nil then
					gColCaptainsSpawned[object] = nil
				end
			end
		end
	)
	
	local onDispenseSeekersHandler = OnCharacterDispenseControllableTeam(
		function(character, controlled)
			if GetEntityClass(controlled) == GetEntityClassPtr("col_weap_inf_captain_seekers_ord") then
				-- Has this Captain spawned Seekers yet? Can only do so once per lifetime
				if gColCaptainsSpawned[GetCharacterUnit(character)] == false then
					gColCaptainsSpawned[GetCharacterUnit(character)] = true
					local numSpawned = 0
					local teamSize = GetTeamSize(SeekerTeam)
					for i = 0, teamSize - 1 do
						local characterIndex = GetTeamMember(SeekerTeam, i)
						local charUnit = GetCharacterUnit(characterIndex)
						
						if not charUnit then
							local destination = GetEntityMatrix(GetCharacterUnit(character))
							SpawnCharacter(characterIndex, destination)
							
							numSpawned = numSpawned + 1
							if numSpawned >= NUM_SEEKERS_PER_CAPTAIN then
								break
							end
						end
					end
				else
					-- PrintLog("This Captain has already spawned Seekers!")
				end
			end
		end,
		CIS
	)
	
	local onSeekerDie = OnObjectKill(
		function(object, killer)
			if not object then return end
			
			-- Guarantee an "explosion" every time a Seeker dies
			if GetEntityClass(GetEntityPtr(object)) == FindEntityClass("col_inf_seekers") then
				local seekerExpPfx = CreateEffect("com_sfx_seekers_exp")
				SetEffectMatrix(seekerExpPfx, GetEntityMatrix(object))
				SetEntityMatrix(object, CreateMatrix(0, 0, 0, 0, 0, -1000, 0, GetEntityMatrix(object)))
			end
		end
	)
end


function Init_Weapon_SeekerSuicide()
	PrintLog("Init_Weapon_SeekerSuicide(): Entered")
	
	if ME5_SideVar ~= 2 and ME5_SideVar ~= 4 then return end
	
	-- Whenever an object is damaged
	local onSeekerSuicideHit = OnObjectDamage(
		function(object, damager)
			-- Exit immediately if any values are incorrect
			if not object then return end
			if not damager then return end
			if GetCharacterUnit(damager) == nil then return end
			
			local objectTeam = GetObjectTeam(object)
			local damagerTeam = GetCharacterTeam(damager)
			if (not objectTeam) or (objectTeam <= 0) then return end
			if (not damagerTeam) or (damagerTeam <= 0) then return end
			
			-- Are the object and damager on different teams?
			if objectTeam ~= damagerTeam then
				-- Figure out the damager's weapon (and exit if it's nil)
				local damagerWeapon = GetObjectLastHitWeaponClass(object)
				if not damagerWeapon then return end
				
				if damagerWeapon == "col_weap_inf_seekers_suicide" then
					PrintLog("Init_Weapon_SeekerSuicide: Trying to kill user")
					KillObject(GetCharacterUnit(damager))
				end
			end
		end
	)
end


function Init_Weapon_DispenseSwarmers()
	PrintLog("Init_Weapon_DispenseSwarmers(): Entered")
	
	if ME5_SideVar ~= 5 then return end
	
	gRavagersSpawned = {}
	
	local onRavagerSpawn = OnCharacterSpawnTeam(
		function(player)
			if GetCharacterClass(player) == 2 then
				-- This Ravager is new, so it hasn't spawned any Swarmers yet
				gRavagersSpawned[GetCharacterUnit(player)] = false
			end
		end,
		CIS
	)
	
	local onRavagerDie = OnObjectKill(
		function(object, killer)
			if not object then return end
			
			if GetEntityClass(GetEntityPtr(object)) == FindEntityClass("rpr_inf_ravager") then
				-- Remove the Ravager from the registry
				if gRavagersSpawned[object] ~= nil then
					gRavagersSpawned[object] = nil
				end
			end
		end
	)
	
	local onDispenseSwarmersHandler = OnCharacterDispenseControllableTeam(
		function(character, controlled)
			if GetEntityClass(controlled) == GetEntityClassPtr("rpr_weap_inf_ravager_swarmers_ord") then
				-- Has this Ravager spawned Swarmers yet? Can only do so once per lifetime
				if gRavagersSpawned[GetCharacterUnit(character)] == false then
					gRavagersSpawned[GetCharacterUnit(character)] = true
					local numSpawned = 0
					local teamSize = GetTeamSize(SwarmerTeam)
					for i = 0, teamSize - 1 do
						local characterIndex = GetTeamMember(SwarmerTeam, i)
						local charUnit = GetCharacterUnit(characterIndex)
						
						if not charUnit then
							local destination = GetEntityMatrix(GetCharacterUnit(character))
							SpawnCharacter(characterIndex, destination)
							
							numSpawned = numSpawned + 1
							if numSpawned >= NUM_SWARMERS_PER_RAVAGER then
								break
							end
						end
					end
				else
					-- PrintLog("This Ravager has already spawned Swarmers!")
				end
			end
		end,
		CIS
	)
	
	local onSwarmerDie = OnObjectKill(
		function(object, killer)
			if not object then return end
			
			-- Guarantee an "explosion" every time a Swarmer dies
			if GetEntityClass(GetEntityPtr(object)) == FindEntityClass("rpr_inf_swarmer") then
				local seekerExpPfx = CreateEffect("com_sfx_swarmer_exp")
				SetEffectMatrix(seekerExpPfx, GetEntityMatrix(object))
				SetEntityMatrix(object, CreateMatrix(0, 0, 0, 0, 0, -1000, 0, GetEntityMatrix(object)))
			end
		end
	)
end


function Init_Weapon_SwarmerSuicide()
	PrintLog("Init_Weapon_SwarmerSuicide(): Entered")
	
	if ME5_SideVar ~= 5 then return end
	
	-- Whenever an object is damaged
	local onSwarmerSuicideHit = OnObjectDamage(
		function(object, damager)
			-- Exit immediately if any values are incorrect
			if not object then return end
			if not damager then return end
			
			local objectTeam = GetObjectTeam(object)
			local damagerTeam = GetCharacterTeam(damager)
			if (not objectTeam) or (objectTeam <= 0) then return end
			if (not damagerTeam) or (damagerTeam <= 0) then return end
			
			-- Are the object and damager on different teams?
			if objectTeam ~= damagerTeam then
				-- Figure out the damager's weapon (and exit if it's nil)
				local damagerWeapon = GetObjectLastHitWeaponClass(object)
				if not damagerWeapon then return end
				
				if damagerWeapon == "rpr_weap_inf_swarmer_suicide" then
					KillObject(GetCharacterUnit(damager))
				end
			end
		end
	)
end

PrintLog("Exited");