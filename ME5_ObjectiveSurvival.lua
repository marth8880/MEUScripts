--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

ScriptCB_DoFile("ME5_Objective")

if bStockFontLoaded == nil then
	-- Has the stock font been loaded?
	bStockFontLoaded = false
end

MEU_GameMode = "meu_surv"

ObjectiveSurvivalHasRan = 1
	print("ObjectiveSurvival: Entered")

--=============================
-- CommandPost
--	Class representing a specific CP, allowing some measure of customization
--	of what happens at each post when it is captured
--=============================
CommandPost =
{
	-- fields that need to be specified when calling New()
	name = "noname",			--name of the CP
	
	-- Overridable functions
	OnCapture = function()
		--override me to customize behavior when the command post is captured
	end,
}

function CommandPost:New(o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	return o
end

--=============================
-- ObjectiveSurvival
--	Handles the logic for a survival game (a.k.a. drain the other team's tickets)
--=============================
ObjectiveSurvival = Objective:New
{
	-- external values
	icon = "hud_objective_icon_circle",
	
	-- internal values
	defaultBleedRate = 0.0,	-- 0.3333333333		--how many units will be lost per second
	defeatTimerSeconds = 110,		--how long the defeat timer lasts after capping the all the CPs
}

function ObjectiveSurvival:GetOpposingTeam(team)
	if team == self.teamATT then
		return self.teamDEF
	else
		return self.teamATT
	end
end


function ObjectiveSurvival:AddCommandPost(cp)
	--make sure we have a table to add the cp to
	self.commandPosts = self.commandPosts or {}
	
	--do all the error checking we can on the cp
	assert(cp.name, "WARNING: no name supplied for the command post")
	cp.name = string.lower(cp.name)
			
	self.commandPosts[cp.name] = cp
	
	--keep a running tally of the bleedValue relative to each team
	--[[if not self.totalBleedValue then
		self.totalBleedValue = {}
		self.totalBleedValue[self.teamATT] = 0
		self.totalBleedValue[self.teamDEF] = 0
	end
	self.totalBleedValue[self.teamATT] = self.totalBleedValue[self.teamATT] + GetCommandPostBleedValue(cp.name, self.teamATT)
	self.totalBleedValue[self.teamDEF] = self.totalBleedValue[self.teamDEF] + GetCommandPostBleedValue(cp.name, self.teamDEF)]]
end


--Add a threshold value for bleeding. Basically
--[[function ObjectiveSurvival:AddBleedThreshold(team, threshold, rate)
	--assert(team == self.teamATT or team == self.teamDEF, "invalid team!")
	
	if not self.bleedRates then
		--initialize the bleedRates two-dimensional array
		self.bleedRates = {}
		self.bleedRates[self.teamATT] = {}
		self.bleedRates[self.teamDEF] = {}
	end
	
	self.bleedRates[team][threshold] = rate
end]]

-- Get game time limit as set in game options menu, if any.  0 if none.
--[[function ObjectiveSurvival:GetGameTimeLimit()
	return ScriptCB_GetCONMaxTimeLimit()
end

function ObjectiveSurvival:GameOptionsTimeLimitUp()
	local team1pts = GetReinforcementCount(1)
	local team2pts = GetReinforcementCount(2)
	if ( team1pts > team2pts ) then
		MissionVictory(1)
	elseif ( team1pts < team2pts ) then
		MissionVictory(2)
	else
		--tied, so victory for both
		MissionVictory({1,2})
	end
end]]

function ObjectiveSurvival:Start()
	--===============================
	-- Local functions
	--===============================
	
	
	--[[local UpdateBleedRate = function(team)
		--count up the total bleedPoints (bleedPoints only count if they're on a CP owned by a different team)
		local bleedPoints = 0
		for i, cp in pairs(self.commandPosts) do
			local cpTeam = GetObjectTeam(cp.name)
			if cpTeam == self:GetOpposingTeam(team) then
				--print("cp.name:", cp.name, "bleedPoints:", GetCommandPostBleedValue(cp.name, cpTeam))			--uncomment me for test output!
				bleedPoints = bleedPoints + GetCommandPostBleedValue(cp.name, cpTeam)
			end
		end		
		
		
		--set the bleed rate based on the total accumulated bleedPoints
		local bleedRate = 0.0		
		if self.bleedRates and self.bleedRates[team] then
			--look through the unsorted list for the highest threshold that bleedPoints is higher than
			local highestThresholdSoFar = 0
			for threshold, rate in pairs(self.bleedRates[team]) do
				if bleedPoints >= threshold and threshold > highestThresholdSoFar then
					bleedRate = rate
					highestThresholdSoFar = threshold
				end
			end
		else
			--default bleeding rule is to start bleeding when the team's bleed points are greater
			--than half the total points
			if bleedPoints > (self.totalBleedValue[team] / 2.0) then
				bleedRate = self.defaultBleedRate
			end
		end
		
		--print("totalbleedpts:", self.totalBleedValue[team])													--uncomment me for test output!
		--print("team:", team, "bleedPoints:", bleedPoints, "bleedRate:", bleedRate)							--uncomment me for test output!
	
		--setup the bleedrate display (i.e. how fast the score flashes in the HUD)
		SetBleedRate(team, bleedRate)
		
		if bleedRate > 0.0 then
			--start bleeding reinforcements
			StopTimer(self.bleedTimer[team])
			SetTimerValue(self.bleedTimer[team], 1.0)
			SetTimerRate(self.bleedTimer[team], bleedRate)
			StartTimer(self.bleedTimer[team])
		else
			--stop bleeding reinforcements
			StopTimer(self.bleedTimer[team])
		end
	end]]
	
	
	--turns off the timers and resets the winningTeam number
	local DisableWinnerDoodads = function()
		self.winningTeam = 0
		StopTimer(self.defeatTimer)

		--hide the timers (HACK: this way of displaying the lose timer should be updated to use new HUD code)
		SetDefeatTimer(nil, self.teamATT)
		SetVictoryTimer(nil, self.teamATT)
		SetDefeatTimer(nil, self.teamDEF)
		SetVictoryTimer(nil, self.teamDEF)
	end
	
	
	--[[local UpdateState = function()
		if self.multiplayerRules then
			UpdateBleedRate(self.teamDEF)
			UpdateBleedRate(self.teamATT)
		end	
	
		--check to see if one team (the winningTeam) has all the CPs
		self.winningTeam = 0
		for i, cp in pairs(self.commandPosts) do
			--NOTE: destroyed CP's aren't supposed to count against the win/loss accounting
			if IsObjectAlive(cp.name) then
				local cpTeam = GetObjectTeam(cp.name)
				
				if cpTeam == 0 then
					--can't have a winner if one of the CPs is still neutral
					DisableWinnerDoodads()
					return
				elseif self.winningTeam == 0 then
					--start tracking this team that might be winning
					self.winningTeam = cpTeam
				elseif self.winningTeam ~= cpTeam then
					--there is no winner, since we just found two CP's that don't match
					DisableWinnerDoodads()
					return
				end
			end
		end
				
		if self.winningTeam ~= 0 then
			if self.disallowDefensiveVictory and self.winningTeam ~= self.teamATT then
				return
			end
			
			if self.multiplayerRules then
				--start the defeat timer to end the game in a few seconds
				SetTimerValue(self.defeatTimer, self.defeatTimerSeconds)
				StartTimer(self.defeatTimer)
				
				--tell the C++ code about the defeat/victory timer (which will display it on the HUD)
				SetDefeatTimer(self.defeatTimer, self:GetOpposingTeam(self.winningTeam))
				SetVictoryTimer(self.defeatTimer, self.winningTeam)
			else
				--end the objective immediately
				self:Complete(self.winningTeam)
			end
		end
	end]]
	
	
	--[[local InitBleedTimer = function(team)
		self.bleedTimer[team] = CreateTimer("bleed" .. team)
		
		OnTimerElapse(
			function (timer)				
				if GetReinforcementCount(team) > GetNumTeamMembersAlive(team) then
					--tick off a reinforcement when the timer elapses, and start it up again
					if GetReinforcementCount(team) > 0 then
						AddReinforcements(team, -1)
					end
					SetTimerValue(timer, GetTimerValue(timer) + 1.0)
					StartTimer(timer)					
				else
					--disallow bleeding when a team gets really low on reinforcements (so the team
					--doesn't run entirely out of units due to bleedrate, as per designer request)
					SetBleedRate(team, 0.0)
					StopTimer(timer)
				end
			end,
			self.bleedTimer[team]
			)
	end]]
	
	
	local InitDefeatTimer = function()
		self.defeatTimer = CreateTimer("defeat")
		SetTimerRate(self.defeatTimer, 1.0)
		
		OnTimerElapse(
			function (timer)
				StopTimer(timer)
				SetReinforcementCount(self:GetOpposingTeam(self.winningTeam), 0)
				self:Complete(self.winningTeam)
			end,
			self.defeatTimer
			)
	end
	
	
	local UpdatePostMapMarker = function(postPtr)
		if not self.multiplayerRules then
			--check the team that capped the CP, and change the map marker accordingly
			if GetObjectTeam(postPtr) == self.teamATT then
				MapRemoveEntityMarker(postPtr, self.teamATT)
			else
				MapAddEntityMarker(postPtr, self.icon, 4.0, self.teamATT, "YELLOW", true)
			end
		end
	end
		
	--==========
	-- Set the number of guys in the level to number in game options
	--==========
	--ScriptCB_SetNumBots(ScriptCB_GetCONNumBots())
	
	local ClassInitTimer = function()
		SetClassProperty("gth_inf_trooper", "PointsToUnlock", 99999)
		SetClassProperty("gth_inf_rocketeer", "PointsToUnlock", 99999)
		SetClassProperty("gth_inf_sniper", "PointsToUnlock", 99999)
		SetClassProperty("gth_inf_machinist", "PointsToUnlock", 99999)
		SetClassProperty("gth_inf_hunter", "PointsToUnlock", 99999)
		SetClassProperty("gth_inf_shock", "PointsToUnlock", 99999)
		SetClassProperty("gth_inf_destroyer", "PointsToUnlock", 99999)
		SetClassProperty("gth_inf_juggernaut", "PointsToUnlock", 99999)
		--SetClassProperty("gth_inf_prime", "PointsToUnlock", 99999)
		
		SetClassProperty("gth_inf_default", "AddShield", 0.0)
		SetClassProperty("gth_inf_trooper", "AddShield", 0.0)
		
		CreateTimer("survGameTimer")
		SetTimerValue("survGameTimer", 1200)
		
		CreateTimer("team1ticketbonustimer")
		SetTimerValue("team1ticketbonustimer", 900)
		StartTimer("team1ticketbonustimer")
		
		CreateTimer("gthMachinistTimer")
		SetTimerValue("gthMachinistTimer", 240)
		
		CreateTimer("gthHunterTimer")
		SetTimerValue("gthHunterTimer", 120)
		
		CreateTimer("gthShockTrooperTimer")
		SetTimerValue("gthShockTrooperTimer", 120)
		
		CreateTimer("gthDestroyerTimer")
		SetTimerValue("gthDestroyerTimer", 180)
		
		CreateTimer("gthJuggernautTimer")
		SetTimerValue("gthJuggernautTimer", 180)
		
		CreateTimer("gthPrimeTimer")
		SetTimerValue("gthPrimeTimer", 180)
		
		ShowTimer("survGameTimer")
		StartTimer("survGameTimer")
		OnTimerElapse(
			function(timer)
				local team1pts = GetReinforcementCount(1)
				if team1pts > 0 then
					ScriptCB_SndBusFade("music", 0.0, 1.0)
					MissionVictory(1)
				else
					ScriptCB_SndBusFade("music", 0.0, 1.0)
					MissionVictory(2)
				end
				
				DestroyTimer(Timer)
			end,
		"survGameTimer"
		)
			StartTimer("gthMachinistTimer")
			OnTimerElapse(
				function(timer)
						print("ObjectiveSurvival: Spawning Geth Machinists...")
					AddUnitClass(2, "gth_inf_machinist",9, 9)
					ShowMessageText("level.common.events.surv.classes.gthMachinist")
					StartTimer("gthHunterTimer")
					DestroyTimer(timer)
				end,
			"gthMachinistTimer"
			)
				OnTimerElapse(
					function(timer)
							print("ObjectiveSurvival: Spawning Geth Hunters...")
						AddUnitClass(2, "gth_inf_hunter",6, 6)
						ShowMessageText("level.common.events.surv.classes.gthHunter")
						StartTimer("gthShockTrooperTimer")
						DestroyTimer(timer)
					end,
				"gthHunterTimer"
				)
					OnTimerElapse(
						function(timer)
								print("ObjectiveSurvival: Spawning Geth Shock Troopers...")
							AddUnitClass(2, "gth_inf_shock",6, 6)
							ShowMessageText("level.common.events.surv.classes.gthShock")
							StartTimer("gthDestroyerTimer")
							DestroyTimer(timer)
						end,
					"gthShockTrooperTimer"
					)
						OnTimerElapse(
							function(timer)
									print("ObjectiveSurvival: Spawning Geth Destroyers...")
								AddUnitClass(2, "gth_inf_destroyer",5, 5)
								ShowMessageText("level.common.events.surv.classes.gthDestroyer")
								StartTimer("gthJuggernautTimer")
								DestroyTimer(timer)
							end,
						"gthDestroyerTimer"
						)
							OnTimerElapse(
								function(timer)
										print("ObjectiveSurvival: Spawning Geth Juggernauts...")
									AddUnitClass(2, "gth_inf_juggernaut",3, 3)
									ShowMessageText("level.common.events.surv.classes.gthJuggernaut")
									StartTimer("gthPrimeTimer")
									DestroyTimer(timer)
								end,
							"gthJuggernautTimer"
							)
								OnTimerElapse(
									function(timer)
											print("ObjectiveSurvival: Spawning Geth Primes...")
										--AddUnitClass(2, "gth_inf_prime",2, 2)
										ShowMessageText("level.common.events.surv.classes.gthPrime")
										DestroyTimer(timer)
									end,
								"gthPrimeTimer"
								)
	
	end

	--===============================
	-- Initialization logic
	--===============================	
	--initialize the base objective data first
	Objective.Start(self)
	
	--initialize internal values
	self.commandPosts = self.commandPosts or {}
	
	--[[self.bleedTimer = {}
	InitBleedTimer(self.teamATT)
	InitBleedTimer(self.teamDEF)]]
	
	InitDefeatTimer()
	
	--initialize team 2 class timer stuff
	ClassInitTimer()
	
	if self.multiplayerRules then
		self.disallowDefensiveVictory = false
	else
		self.disallowDefensiveVictory = true		--in single player/co-op, the defense can't win by capping all the CPs
	end
	
	numCPs = 0
	for i, cp in pairs(self.commandPosts) do
		if not self.multiplayerRules then
			MapAddEntityMarker(cp.name, self.icon, 4.0, self.teamATT, "YELLOW", true)
		end
		numCPs = numCPs + 1
	end
	if(numCPs == 0) then
		print ("ERROR: no valid CommandPosts were added to the ObjectiveSurvival")
		return
	end	
	
	--set AI goals
	self.AIGoals = {}
	if self.AIGoalWeight > 0.0 then
		table.insert(self.AIGoals, AddAIGoal(self.teamATT, "Conquest", 100*self.AIGoalWeight))
		table.insert(self.AIGoals, AddAIGoal(self.teamATT, "Deathmatch", 100*self.AIGoalWeight))
		table.insert(self.AIGoals, AddAIGoal(self.teamDEF, "Conquest", 100*self.AIGoalWeight))
		table.insert(self.AIGoals, AddAIGoal(self.teamDEF, "Deathmatch", 100*self.AIGoalWeight))
	end
	
	--do an initial update on the state
	--UpdateState()
	
	--=======================================
	-- Event responses
	--=======================================
	-- command post captures
	OnFinishCapture(
		function (postPtr)
			if self.isComplete then	return end
			if not self.commandPosts[GetEntityName(postPtr)] then return end
						
			UpdatePostMapMarker(postPtr)
			--UpdateState()
		end
		)
		
	-- command post neutralize
	OnFinishNeutralize(
		function (postPtr)				
			if self.isComplete then	return end
			if not self.commandPosts[GetEntityName(postPtr)] then return end
			
			UpdatePostMapMarker(postPtr)
			--UpdateState()
		end
		)
		
	-- command post spawn
	OnCommandPostRespawn(
		function (postPtr)				
			if self.isComplete then	return end
			if not self.commandPosts[GetEntityName(postPtr)] then return end
			
			UpdatePostMapMarker(postPtr)			
			--UpdateState()
		end
		)
	
	-- command post kill
	OnCommandPostKill(
		function (postPtr)
			if self.isComplete then	return end
			if not self.commandPosts[GetEntityName(postPtr)] then return end
			
			if not self.multiplayerRules then
				MapRemoveEntityMarker(postPtr, self.teamATT)
			end
			
			--UpdateState()
		end
		)	
	
	--[[CreateTimer("team1ticket_timer")
		SetTimerValue("team1ticket_timer", 20)
			team1ticket_flagged = 0
		ShowTimer("team1ticket_timer")
		OnTimerElapse(
			function(timer)
				team1ticket_flagged = 0
			end,
			"team1ticket_timer"
		)
	
	CreateTimer("team2ticket_timer")
		SetTimerValue("team2ticket_timer", 20)
			team2ticket_flagged = 0
		ShowTimer("team2ticket_timer")
		OnTimerElapse(
			function(timer)
				team2ticket_flagged = 0
			end,
			"team2ticket_timer"
		)]]
	
	-- These add reinforcements for CP captures
	OnFinishCaptureTeam(
		function(post)
			team1cpcount = 0
			-- Count the number of CPs team 1 possesses
				print("ObjectiveSurvival: Counting the number of CPs owned by team 1...")
			for i, cp in pairs(self.commandPosts) do
				-- NOTE: destroyed CP's aren't supposed to count against the win/loss accounting
				if IsObjectAlive(cp.name) then
					team1cpTeam = GetObjectTeam(cp.name)
					if team1cpTeam == 1 then
						team1cpcount = team1cpcount + 1
							print("ObjectiveSurvival: team 1 CP count = " .. team1cpcount)
					end
				end
			end
			
				--[[print("ObjectiveSurvival: Team 1 currently owns " .. team1cpcount .. " CPs")
			team1ticketbonus = 30 / team1cpcount
				print("ObjectiveSurvival: team 1 bonus = " .. team1ticketbonus)
			AddReinforcements(1, team1ticketbonus)
			ShowMessageText(team1ticketstring)]]
		end,
	1 -- Team number for the ticket bonus
	)
	
	OnTimerElapse(
		function(timer)
			if team1cpcount >= 2 then
				AddReinforcements(1, 50)
			else
			end
		end,
	"team1ticketbonustimer"
	)
	
	-- spawn block for Husks -- 
	OnTicketCountChange(
		function (team, count)
			if team == CIS and count == 20 then				
				AllowAISpawn(3, false)
			end
		end
		)
	
	--[[CaptureRegionsTable = {1}

	for i, cp in pairs(self.commandPosts) do
		CaptureRegionsTable[i] = GetCommandPostCaptureRegion(cp.name)
	end

	-- These add reinforcements for CP captures
	OnFinishCaptureTeam(
		function(post)
			team1cpcount = 0
			-- Count the number of CPs team 1 possesses
				print("ObjectiveSurvival: Counting the number of CPs owned by team 1...")
			for i, cp in pairs(self.commandPosts) do
				-- NOTE: destroyed CP's aren't supposed to count against the win/loss accounting
				if IsObjectAlive(cp.name) then
					team1cpTeam = GetObjectTeam(cp.name)
					if team1cpTeam == 1 then
						team1cpcount = team1cpcount + 1
							print("ObjectiveSurvival: team 1 CP count = " .. team1cpcount)
					end
				end
			end
			if team1cpcount == 1 then			
				for i, cp in pairs(self.commandPosts) do
					team1cpTeam = GetObjectTeam(cp.name)
					if team1cpTeam == 1 then
						--SetProperty(cp.name, "CaptureRegion", "")
							print("ObjectiveSurvival: Removing capture region for " .. cp.name)
					end
				end
			elseif team1cpcount > 1 then
				for i, cp in pairs(self.commandPosts) do
					--SetProperty(cp.name, "CaptureRegion", CaptureRegionsTable[i])
						print("ObjectiveSurvival: Replacing capture region for " .. cp.name)
				end
			end
				print("ObjectiveSurvival: Team 1 currently owns " .. team1cpcount .. " CPs")
			team1ticketbonus = 30 / team1cpcount
				print("ObjectiveSurvival: team 1 bonus = " .. team1ticketbonus)
			AddReinforcements(1, team1ticketbonus)
			ShowMessageText(team1ticketstring)
		end,
	1 -- Team number for the ticket bonus
	)]]
	
	--[[Upon team 1 capturing command post
		Team 1 ticket count is increased by ticketboostvariable
		ticketboostvariable is product of team 1 total CP count and X (currently undefined)
	End(er's Game)]]
	
	-- These add reinforcements for CP captures
	--[[OnFinishCaptureTeam(
		function(post)
			team2cpcount = 0
			-- Count the number of CPs team 2 possesses
				print("ObjectiveSurvival: Counting the number of CPs owned by team 2...")
			for i, cp in pairs(self.commandPosts) do
				-- NOTE: destroyed CP's aren't supposed to count against the win/loss accounting
				if IsObjectAlive(cp.name) then
					team2cpTeam = GetObjectTeam(cp.name)
					if team2cpTeam == 2 then
						team2cpcount = team2cpcount + 1
							print("ObjectiveSurvival: team 2 CP count = " .. team2cpcount)
					end
				end
			end
				print("ObjectiveSurvival: Team 2 currently owns " .. team2cpcount .. " CPs")
			team2ticketbonus = 30 / team2cpcount
				print("ObjectiveSurvival: team 2 bonus = " .. team2ticketbonus)
			AddReinforcements(2, team2ticketbonus)
			ShowMessageText(team2ticketstring)
		end,
	2 -- Team number for the ticket bonus
	)]]
	
end

function ObjectiveSurvival:Complete(winningTeam)
	if not self.multiplayerRules then
		--remove all the cp markers
		for i, cp in pairs(self.commandPosts) do
			MapRemoveEntityMarker(cp.name)
		end
		
		--[[if ME5_CustomHUD == 1 then
			if bStockFontLoaded == false then
				bStockFontLoaded = true
					print("ME5_ObjectiveSurvival: Loading hud_font_stock.lvl...")
				-- hotfix that reloads the stock fonts in the stats screen
				ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\hud_font_stock.lvl")
			end
		end]]
	end
	
	--then call the default objective complete method
	Objective.Complete(self, winningTeam)
end

	print("ObjectiveSurvival: Exited")
