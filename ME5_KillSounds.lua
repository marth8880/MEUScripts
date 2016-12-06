-----------------------------------------------------------------
-----------------------------------------------------------------
-- MASS EFFECT: UNIFICATION Kill Sounds Script by Aaron Gilbert
-- Build 31205/06
-- Screen Names: Marth8880, GT-Marth8880, [GT] Marth8880, [GT] Bran
-- E-Mail: Marth8880@gmail.com
-- Dec 5, 2016
-- Copyright (c) 2016, Aaron Gilbert All rights reserved.
-- 
-- About: 
--  This script contains various functions regarding kill sounds.
-- 
-- 
-- Usage: 
--  Simply call Init_HealthFunc() anywhere in ScriptInit().
-- 
-- 
-- Legal:
--  This script is licensed under the BSD 3-Clause License. A copy of this license (as LICENSE.md) should have been included
--  with this script. If it wasn't, it can also be found here: https://www.w3.org/Consortium/Legal/2008/03-bsd-license.html
--  
--  THIS SCRIPT IS NOT MADE, DISTRIBUTED, OR SUPPORTED BY LUCASARTS, A DIVISION OF LUCASFILM ENTERTAINMENT COMPANY LTD.
-----------------------------------------------------------------
-----------------------------------------------------------------

print("ME5_KillSounds: Entered")

---
-- Sets up the event responses for kill sounds.
-- 
function Init_KillSounds()
	print("ME5_KillSounds.Init_KillSounds(): Entered")
	
	if not ScriptCB_InMultiplayer() then
		if ME5_KillSound == 0 then
			print("ME5_KillSounds.Init_KillSounds(): Initializing kill sound setting for DISABLED...")
		else
			print("ME5_KillSounds.Init_KillSounds(): Initializing kill sound setting for ENABLED...")
			
			local enemydeath = OnCharacterDeath(
				function(player, killer)
					-- Exit immediately if there are incorrect values
					if not player then return end
					if not killer then return end
					
					if killer and IsCharacterHuman(killer) then
						local playerTeam = GetCharacterTeam(player)
						local killerTeam = GetCharacterTeam(killer)
						
						-- Was the killed unit's team different from the killer's?
						if playerTeam ~= killerTeam then
							-- Is this not a campaign?
							if not IsCampaign() then
								ScriptCB_SndPlaySound("hud_player_kill")
							else
								local world = string.lower(GetWorldFilename())
								
								-- Are we on Europa?
								if world == "eur" then
									-- Is the victim team not the squad team?
									if playerTeam ~= 3 then
										ScriptCB_SndPlaySound("hud_player_kill")
									end
								end
							end
						end
					end
				end
			)
		end
	else
		print("ME5_KillSounds.Init_KillSounds(): Initializing kill sound setting for DISABLED...")
	end
end


print("ME5_KillSounds: Exited")