-----------------------------------------------------------------
-----------------------------------------------------------------
-- MASS EFFECT: UNIFICATION Team Globals Script by Aaron Gilbert
-- Screen Names: Marth8880, GT-Marth8880, [GT] Marth8880
-- E-Mail: Marth8880@gmail.com
-- Copyright (c) 2021, Aaron Gilbert All rights reserved.
-- 
-- About: 
--  Team globals.
-- 
-- 
-- Legal:
--  This script is licensed under the BSD 3-Clause License. A copy of this license (as LICENSE.md) should have been included
--  with this script. If it wasn't, it can also be found here: https://www.w3.org/Consortium/Legal/2008/03-bsd-license.html
--  
--  THIS SCRIPT IS NOT MADE, DISTRIBUTED, OR SUPPORTED BY LUCASARTS, A DIVISION OF LUCASFILM ENTERTAINMENT COMPANY LTD.
-----------------------------------------------------------------
-----------------------------------------------------------------

local __SCRIPT_NAME = "ME5_TeamGlobals";
local debug = true;

local function PrintLog(...)
	if debug == true then
		print("["..__SCRIPT_NAME.."]", unpack(arg));
	end
end

PrintLog("Entered")

TeamGlobals = {
	SSVxGTH = {
		xxs = {
			REP = {
				UnitCount = 7,
				Tickets = 150,
				Classes = {
					{ ssv_inf_soldier, 2, 3 },
					{ ssv_inf_infiltrator, 1, 3 },
					{ ssv_inf_engineer, 1, 3 },
					{ ssv_inf_adept, 1, 3 },
					{ ssv_inf_sentinel, 1, 3 },
					{ ssv_inf_vanguard, 1, 3 },
				},
			},
			CIS = {
				UnitCount = 6,
				Tickets = 150,
				Classes = {
					{ gth_inf_trooper, 1, 6 },
					{ gth_inf_rocketeer, 1, 4 },
					{ gth_inf_sniper, 1, 4 },
					{ gth_inf_machinist, 1, 4 },
					{ gth_inf_hunter, 1, 3 },
					{ gth_inf_shock, 1, 3 },
					{ gth_inf_destroyer, 1, 2 },
					{ gth_inf_juggernaut, 1, 2 },
				},
			},
			HuskTeam = {
				UnitCount = 1,
				Classes = {
					{ "indoc_inf_husk", 1, 1 },
				},
			},
		},
		
		xs = {
			REP = {
				UnitCount = 13,
				Tickets = 150,
				Classes = {
					{ ssv_inf_soldier, 2, 8 },
					{ ssv_inf_infiltrator, 2, 8 },
					{ ssv_inf_engineer, 2, 8 },
					{ ssv_inf_adept, 2, 8 },
					{ ssv_inf_sentinel, 2, 8 },
					{ ssv_inf_vanguard, 2, 8 },
				},
			},
			CIS = {
				UnitCount = 11,
				Tickets = 150,
				Classes = {
					{ gth_inf_trooper, 2, 20 },
					{ gth_inf_rocketeer, 2, 8 },
					{ gth_inf_sniper, 1, 8 },
					{ gth_inf_machinist, 1, 8 },
					{ gth_inf_hunter, 2, 6 },
					{ gth_inf_shock, 1, 6 },
					{ gth_inf_destroyer, 1, 4 },
					{ gth_inf_juggernaut, 1, 4 },
				},
			},
			HuskTeam = {
				UnitCount = 2,
				Classes = {
					{ "indoc_inf_husk", 2, 2 },
				},
			},
		},
		
		sm = {
			REP = {
				UnitCount = 15,
				Tickets = 150,
				Classes = {
					{ ssv_inf_soldier, 3, 8 },
					{ ssv_inf_infiltrator, 2, 8 },
					{ ssv_inf_engineer, 3, 8 },
					{ ssv_inf_adept, 2, 8 },
					{ ssv_inf_sentinel, 2, 8 },
					{ ssv_inf_vanguard, 2, 8 },
				},
			},
			CIS = {
				UnitCount = 15,
				Tickets = 150,
				Classes = {
					{ gth_inf_trooper, 2, 20 },
					{ gth_inf_rocketeer, 2, 8 },
					{ gth_inf_sniper, 1, 8 },
					{ gth_inf_machinist, 1, 8 },
					{ gth_inf_hunter, 2, 6 },
					{ gth_inf_shock, 1, 6 },
					{ gth_inf_destroyer, 1, 4 },
					{ gth_inf_juggernaut, 1, 4 },
				},
			},
			HuskTeam = {
				UnitCount = 3,
				Classes = {
					{ "indoc_inf_husk", 3, 3 },
				},
			},
		},
	},
}

PrintLog("Exited")