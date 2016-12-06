-----------------------------------------------------------------
-----------------------------------------------------------------
-- MASS EFFECT: UNIFICATION Incendiary Ordnance Script by Aaron Gilbert
-- Build 31206/06
-- Screen Names: Marth8880, GT-Marth8880, [GT] Marth8880, [GT] Bran
-- E-Mail: Marth8880@gmail.com
-- Dec 6, 2016
-- Copyright (c) 2016, Aaron Gilbert All rights reserved.
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
		
		-- Whenever an object is damaged
		local targetdamage = OnObjectDamage(
			function(object, damager)
				-- Exit immediately if any values are incorrect
				if not object then return end
				
				-- Figure out the damager's weapon (and exit if it's nil)
				local damagerWeapon = GetObjectLastHitWeaponClass(object)
				if not damagerWeapon then return end
				
				-- Is the damager weapon incendiary?
				if string.sub(damagerWeapon,-10,-1) == "incendiary" or string.sub(damagerWeapon,-10,-1) == "incinerate" or string.sub(damagerWeapon,-17,-1) == "incinerationblast" or string.sub(damagerWeapon,-6,-1) == "scorch" then
					if gIncendiaryOrdGate_Open == true then
						gIncendiaryOrdGate_Open = false
						gIncendiaryOrdTurs = gIncendiaryOrdTurs + 1
						
						-- Spawn the incendiary ordnance turret
						CreateEntity("com_bldg_incendiaryord_turret", GetEntityMatrix(object), "incendiaryTurs"..gIncendiaryOrdTurs)
						
						-- Limit the spawn-rate of these turrets 
						gIncendiaryOrdGateTimer = CreateTimer("gIncendiaryOrdGateTimer")
						SetTimerValue(gIncendiaryOrdGateTimer, 0.1)
						StartTimer(gIncendiaryOrdGateTimer)
						gIncendiaryOrdGateTimerElapse = OnTimerElapse(
							function(timer)
								-- Reopen the logic gate
								gIncendiaryOrdGate_Open = true
								
								-- Garbage collection
								DestroyTimer(timer)
								gIncendiaryOrdGateTimer = nil
								ReleaseTimerElapse(gIncendiaryOrdGateTimerElapse)
							end,
						gIncendiaryOrdGateTimer
						)
						
						--print("Weapon ("..damagerWeapon..") is incendiary")
					end
				else
					return
				end
			end
		)
	end
end

print("ME5_IncendiaryOrdnance: Exited")