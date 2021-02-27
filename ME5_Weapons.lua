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
	
	local enemyDamageHandler = OnObjectDamage(
		function(object, damager)
			-- Exit immediately if there are incorrect values
			if not object then return end
			if not damager then return end
			
			local hitByCorrectWeapon = false
			local hitByBanshee = false
			
			if GetObjectLastHitWeaponClass(object) == "weap_bio_charge" then
				hitByCorrectWeapon = true
			end
				
			if GetObjectLastHitWeaponClass(object) == "weap_bio_banshee_charge" then
				hitByCorrectWeapon = true
				hitByBanshee = true
			end
			
			if hitByCorrectWeapon == true then
				local charPtr = GetCharacterUnit(damager)
				local objectPtr = GetEntityPtr(object)
				
				if GetObjectTeam(object) ~= GetObjectTeam(charPtr) then
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
						local newShields = curShields + (maxShields / 2)
						
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

PrintLog("Exited");