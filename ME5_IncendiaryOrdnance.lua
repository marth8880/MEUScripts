-----------------------------------------------------------------
-----------------------------------------------------------------
-- MASS EFFECT: UNIFICATION Incendiary Ordnance Script by Aaron Gilbert
-- Build 31206/06
-- Screen Names: Marth8880, GT-Marth8880, [GT] Marth8880, [GT] Bran
-- E-Mail: Marth8880@gmail.com
-- Dec 6, 2016
-- Copyright (c) 2017, Aaron Gilbert All rights reserved.
-- 
-- About: 
--  This script contains functions regarding Lua weapons with incendiary ordnance.
-- 
-- 
-- Usage:
--  Simply call Init_IncendiaryOrd() somewhere in ScriptPostLoad().
-- 
-- 
-- Legal:
--  This script is licensed under the BSD 3-Clause License. A copy of this license (as LICENSE.md) should have been included
--  with this script. If it wasn't, it can also be found here: https://www.w3.org/Consortium/Legal/2008/03-bsd-license.html
--  
--  THIS SCRIPT IS NOT MADE, DISTRIBUTED, OR SUPPORTED BY LUCASARTS, A DIVISION OF LUCASFILM ENTERTAINMENT COMPANY LTD.
-----------------------------------------------------------------
-----------------------------------------------------------------

print("ME5_IncendiaryOrdnance: Entered")

---
-- Sets up the event responses for incendiary ordnance.  Specifically, whenever an object is damaged by a weapon that's 
--  supposed to have incendiary ammo or a power that's supposed to have incendiary effects (like Incinerate), an invisible
--  auto-turret that fires an EmitterOrdnance is spawned at the object's matrix and then immediately self-destructs.
-- 
function Init_IncendiaryOrd()
	print("ME5_IncendiaryOrdnance.Init_IncendiaryOrd(): Entered")
	
	if not ScriptCB_InMultiplayer() then
		-- Logic gate for processing incendiary ordnance
		gIncendiaryOrdGate_Open = true
		gIncendiaryOrdTurs = 0
		
		-- List of terms that incendiary weapons contain, these are used with string.sub(a,b,c) where a=[1], b=[2], c=[3]
		local incendiaryWeapons = {
						{"incendiary", -10, -1},
						{"incinerate", -10, -1},
						{"incinerationblast", -17, -1},
						{"scorch", -6, -1},
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
					
					-- Is the weapon incendiary?
					local bIsIncendiary = false
					
					for i in ipairs(incendiaryWeapons) do
						if string.sub(damagerWeapon, incendiaryWeapons[i][2], incendiaryWeapons[i][3]) == incendiaryWeapons[i][1] then
							bIsIncendiary = true
							break
						end
					end
					
					-- Exit if the weapon isn't incendiary, or continue if it is
					if bIsIncendiary == false then
						return
					else
						--if gIncendiaryOrdGate_Open == true then
							-- Close the gate
							--gIncendiaryOrdGate_Open = false
							--gIncendiaryOrdTurs = gIncendiaryOrdTurs + 1
							
							-- Spawn the incendiary ordnance turret
							gIncendiaryOrdTurretEntity = CreateEntity("com_bldg_incendiaryord_turret", GetEntityMatrix(object))
							
							-- Limit the spawn-rate of these turrets 
							--[[gIncendiaryOrdGateTimer = CreateTimer("gIncendiaryOrdGateTimer")
							SetTimerValue(gIncendiaryOrdGateTimer, 0.1)
							StartTimer(gIncendiaryOrdGateTimer)
							gIncendiaryOrdGateTimerElapse = OnTimerElapse(
								function(timer)
									-- Destroy the turret
									DeleteEntity(gIncendiaryOrdTurretEntity)
									gIncendiaryOrdTurretEntity = nil
									
									-- Reopen the logic gate
									gIncendiaryOrdGate_Open = true
									
									-- Garbage collection
									DestroyTimer(timer)
									gIncendiaryOrdGateTimer = nil
									ReleaseTimerElapse(gIncendiaryOrdGateTimerElapse)
								end,
							gIncendiaryOrdGateTimer
							)]]
							
							--print("Weapon ("..damagerWeapon..") is incendiary")
						--end
					end
				end
			end
		)
	end
end


print("ME5_IncendiaryOrdnance: Exited")