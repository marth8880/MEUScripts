-- This is a local (only visible in this file) function used in the function "enableGrapplingHook"
-- moves a character to an object with a speed in meters per second.
-- odfName is the ODF name of the deployed autoturret
local moveUnitToObject = function(character, object, speed, odfName)

    local unit = GetCharacterUnit(character)

    --check if unit is alive (will be nil if dead)
    if unit then
        -- get start and end coordinates
        local xStart, yStart, zStart = GetWorldPosition(unit)
        local xEnd, yEnd, zEnd = GetWorldPosition(object)

        -- position deltas - create the vector
        local dX = xEnd - xStart
        local dY = yEnd - yStart
        local dZ = zEnd - zStart

        local distance = math.sqrt(dX * dX + dY * dY + dZ * dZ)

        local objLocation = GetEntityMatrix(object)
        -- create temporary other turret so we can calculate its rotation
        tempturret = CreateEntity(odfName, CreateMatrix(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, objLocation), "temp_turret")
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

        local count = 0
        --every time interval move this distance. These two variables control speed
        -- units in meters per second
        local incrementDistance = speed / 100
        local timeInterval = 0.01 -- one hundredth of a second
        moveUnitTimer = CreateTimer("moveUnitTimer")
        SetTimerValue(moveUnitTimer, timeInterval) -- in seconds

        moveUnitTimerTracker = OnTimerElapse(function(timer)
            count = count + incrementDistance -- move 1 meter per time interval unit we hit distance
            --print("timer count is " .. tostring(count))

            ---- Tried to do this, but it crashed. Maybe you can figure it out
            ----draw the cable. DrawBeamBetween is the C function used in galactic conquest
            --DrawBeamBetween(
            --        GetEntityMatrix(unit),
            --        objLocation,
            --        "troop_icon", 1.0, 255, 255, 255, 255, 0, 1
            --)

            local factor = count / distance

            --check if unit is alive
            if GetCharacterUnit(character) then

                -- move character once every timer interval
                -- stop a little above the destination to avoid impact damage
                -- by making the last argument "nil" you can use absolute position/rotation
                SetEntityMatrix(unit, CreateMatrix(phi, 0.0, 1.0, 0.0, xStart + ((dX) * factor), yStart + ((dY + 0.5) * factor), zStart + ((dZ) * factor), nil))
            else
                --print(" unit is dead. stopping ")
                count = 0
                DestroyTimer(timer)
                moveUnitTimer = nil

                ReleaseTimerElapse(moveUnitTimerTracker)
                moveUnitTimerTracker = nil
            end

            if count < distance then
                --print("continuing")
                --StopTimer(timer)
                SetTimerValue(timer, timeInterval)
                StartTimer(timer)
            else
                --print("stopping")
                count = 0
                DestroyTimer(timer)
                moveUnitTimer = nil

                ReleaseTimerElapse(moveUnitTimerTracker)
                moveUnitTimerTracker = nil
            end
        end
        , moveUnitTimer)

        StartTimer(moveUnitTimer)

    end

    --print("moving unit")

end

--  example: "rep_bldg_inf_autoturret", 100
-- odfName, a string which is the name of the deployed autoturret ODF
-- speed, a number, the speed to travel the grappling hook in meters per second
enableGrapplingHook = function(odfName, speed)

    -- grappling hook code
    grappleLaunch = OnCharacterDispenseControllable(
            (function(player, controllable)
                --print("dispensed entity")

                if GetEntityClass(controllable) == FindEntityClass(odfName) then
                    --print("dispensed autoturret")


                    -- this timer will track the grapple's timer over time.
                    -- If it detects that the grapple is stopped, it will pull the unit towards it.
                    -- If the grapple dies or never stops, the timer stops and nothing happens.
                    local alive = true
                    local grappleCoordTable = {}
                    local loopCount = 0
                    local grappleTimeInterval = 0.25 -- check 4 times a second
                    moveGrappleTimer = CreateTimer("moveGrappleTimer")
                    SetTimerValue(moveGrappleTimer, grappleTimeInterval) -- in seconds
                    moveGrappleTimerTracker = OnTimerElapse(function(timer)
                        loopCount = loopCount + 1
                        --print("timer count is " .. tostring(loopCount))

                        if alive == true then


                            --print("hook still alive, continuing")
                            local xGrap, yGrap, zGrap = GetWorldPosition(controllable)
                            --print("grapple position is" .. xGrap .. " " .. yGrap .. " " .. zGrap)
                            table.insert(grappleCoordTable, { x = xGrap, y = yGrap, z = zGrap })

                            -- check if there is more than 1 entry in the table and if the last and second to last are equal
                            -- probably should clean out all but the last 2 of the table....
                            if table.getn(grappleCoordTable) > 1
                                    and grappleCoordTable[table.getn(grappleCoordTable)].x == grappleCoordTable[table.getn(grappleCoordTable) - 1].x
                                    and grappleCoordTable[table.getn(grappleCoordTable)].y == grappleCoordTable[table.getn(grappleCoordTable) - 1].y
                                    and grappleCoordTable[table.getn(grappleCoordTable)].z == grappleCoordTable[table.getn(grappleCoordTable) - 1].z
                            then
                                --print("grapple is stationary")

                                -- call the function that does the actual moving of our unit
                                moveUnitToObject(player, controllable, speed, odfName)

                                --exit the timer, clean up
                                loopCount = 0
                                grappleCoordTable = {}
                                alive = true
                                --StopTimer(timer) -- timer should already be stopped if we are in this function?
                                DestroyTimer(timer)
                                moveGrappleTimer = nil

                                ReleaseTimerElapse(moveGrappleTimerTracker)
                                moveGrappleTimerTracker = nil

                                --exit the callback function
                                return
                            end

                            --StopTimer(moveUnitTimer)
                            SetTimerValue(timer, grappleTimeInterval)
                            StartTimer(timer)
                        elseif alive == false then
                            --print("hook is dead, stopping")

                            -- clean up
                            loopCount = 0
                            grappleCoordTable = {}
                            alive = true
                            --StopTimer(timer)
                            DestroyTimer(timer)
                            moveGrappleTimer = nil

                            ReleaseTimerElapse(moveGrappleTimerTracker)
                            moveGrappleTimerTracker = nil
                        else
                            --print("Grapple code: something else happened!")
                        end
                    end
                    , moveGrappleTimer)

                    -- this event listener simply sets alive to false.
                    -- I tried to use IsObjectAlive but that crashed when it was dead. Lol
                    -- Could potentially run into some synchronization issues, but that hasn't happened during testing
                    -- If there are glitches with the weapon then consider using the "LifeTime" value in the autoturret odf ...
                    -- ... instead of this event. make the timer only go until a the LifeTime of the autoturret
                    hookDeath = OnObjectKill(function(object, killer)
                        --print("object died")
                        if object == controllable then
                            --print(" hook died")
                            alive = false
                            --print("alive is " .. tostring(alive))

                            ReleaseObjectKill(hookDeath)
                            hookDeath = nil
                        end
                    end)

                    -- kick off the timer to track the grapple's position over time
                    StartTimer(moveGrappleTimer)
                end
            end))

end





---------------
-- the below functions are similar to those above except the unit follows the trajectory the grappling hook was thrown
---------------





-- This is a local (only visible in this file) function used in the function "enableGrapplingHook"
-- moves a character to an object with a speed in meters per second.
-- odfName is the ODF name of the deployed autoturret
local moveUnitToObjectAlongTrajectory = function(character, object, speed, odfName, trajectoryCoordTable)

    local unit = GetCharacterUnit(character)

    --check if unit is alive (will be nil if dead)
    if unit then
        --print("unit is alive, starting move")
        -- get start and end coordinates
        local xStart, yStart, zStart = GetWorldPosition(unit)
        --local xEnd, yEnd, zEnd = GetWorldPosition(object)
		
		-- variable to track the coordinate index
		local coordIndex = 1
		local xEnd = trajectoryCoordTable[coordIndex].x
		local yEnd = trajectoryCoordTable[coordIndex].y
		local zEnd = trajectoryCoordTable[coordIndex].z

        -- position deltas - create the vector
        local dX = xEnd - xStart
        local dY = yEnd - yStart
        local dZ = zEnd - zStart

        local distance = math.sqrt(dX * dX + dY * dY + dZ * dZ)

        local objLocation = GetEntityMatrix(object)
        -- create temporary other turret so we can calculate its rotation
        tempturret = CreateEntity(odfName, CreateMatrix(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, objLocation), "temp_turret")
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

        local count = 0
        --every time interval move this distance. These two variables control speed
        -- units in meters per second
        local incrementDistance = speed / 100
        local timeInterval = 1/100 -- one hundredth of a second or 100 fps. Change this to control how "smooth" the unit moves
        moveUnitTimer = CreateTimer("moveUnitTimer")
        SetTimerValue(moveUnitTimer, timeInterval) -- in seconds
		
		-- variable to track the coordinate index
		local coordIndex = 1

        moveUnitTimerTracker = OnTimerElapse(function(timer)
            count = count + incrementDistance -- move 1 meter per time interval unit we hit distance
            --print("timer count is " .. tostring(count))

            ---- Tried to do this, but it crashed. Maybe you can figure it out
            ----draw the cable. DrawBeamBetween is the C function used in galactic conquest
            --DrawBeamBetween(
            --        GetEntityMatrix(unit),
            --        objLocation,
            --        "troop_icon", 1.0, 255, 255, 255, 255, 0, 1
            --)

            local factor = count / distance

            --check if unit is alive
            if GetCharacterUnit(character) then
                --print("unit is alive, moving")

                -- move character once every timer interval
                -- stop a little above the destination to avoid impact damage
                -- by making the last argument "nil" you can use absolute position/rotation
                SetEntityMatrix(unit, CreateMatrix(phi, 0.0, 1.0, 0.0, xStart + ((dX) * factor), yStart + ((dY + 0.5) * factor), zStart + ((dZ) * factor), nil))
            else
                --print(" unit is dead. stopping ")
                count = 0
				coordIndex = 1
                DestroyTimer(timer)
                moveUnitTimer = nil

                ReleaseTimerElapse(moveUnitTimerTracker)
                moveUnitTimerTracker = nil
            end

            if count < distance then
                --print("continuing")
                --StopTimer(timer)
                SetTimerValue(timer, timeInterval)
                StartTimer(timer)
            else
			
				coordIndex = coordIndex + 1
				-- if there are more grapple coords
				if coordIndex < table.getn(trajectoryCoordTable) then
					--print("moving to next coord")
					
					count = 0
					
					xStart = trajectoryCoordTable[coordIndex-1].x
					yStart = trajectoryCoordTable[coordIndex-1].y
					zStart = trajectoryCoordTable[coordIndex-1].z
					
					-- recalculate the deltas
					dX = trajectoryCoordTable[coordIndex].x - xStart
					dY = trajectoryCoordTable[coordIndex].y - yStart
					dZ = trajectoryCoordTable[coordIndex].z - zStart

					distance = math.sqrt(dX * dX + dY * dY + dZ * dZ)
					
					--start timer again
					SetTimerValue(timer, timeInterval)
					StartTimer(timer)
			
				-- if we've reached the last grapple coord
				else
					--print("stopping")
					count = 0
					coordIndex = 1
					DestroyTimer(timer)
					moveUnitTimer = nil

					ReleaseTimerElapse(moveUnitTimerTracker)
					moveUnitTimerTracker = nil
				end
            end
        end
        , moveUnitTimer)

        --print("starting move timer")
        StartTimer(moveUnitTimer)

    else
        --print("unit is dead, not moving")
    end

    --print("moving unit")

end

--  example: "rep_bldg_inf_autoturret", 100
-- odfName, a string which is the name of the deployed autoturret ODF
-- speed, a number, the speed to travel the grappling hook in meters per second
enableGrapplingHookFollowTrajectory = function(odfName, speed)

    -- grappling hook code
    grappleLaunch = OnCharacterDispenseControllable(
            (function(player, controllable)
                --print("dispensed entity")

                if GetEntityClass(controllable) == FindEntityClass(odfName) then
                    --print("dispensed autoturret")


                    -- this timer will track the grapple's position over time.
                    -- If it detects that the grapple is stopped, it will pull the unit towards it.
                    -- If the grapple dies or never stops, the timer stops and nothing happens.
                    local alive = true
                    local grappleCoordTable = {}
                    local loopCount = 0
                    local grappleTimeInterval = 1/60 --record the path of the grappling hook at 60 fps so it looks nice! Can lower if desired
                    moveGrappleTimer = CreateTimer("moveGrappleTimer")
                    SetTimerValue(moveGrappleTimer, grappleTimeInterval) -- in seconds
                    moveGrappleTimerTracker = OnTimerElapse(function(timer)
                        loopCount = loopCount + 1
                        --print("timer count is " .. tostring(loopCount))

                        if alive == true then


                            --print("hook still alive, continuing")
                            local xGrap, yGrap, zGrap = GetWorldPosition(controllable)
                            table.insert(grappleCoordTable, { x = xGrap, y = yGrap, z = zGrap })

                            -- check if there is more than 1 entry in the table and if the last and second to last are equal
                            -- probably should clean out all but the last 2 of the table....
                            if table.getn(grappleCoordTable) > 1
                                    and grappleCoordTable[table.getn(grappleCoordTable)].x == grappleCoordTable[table.getn(grappleCoordTable) - 1].x
                                    and grappleCoordTable[table.getn(grappleCoordTable)].y == grappleCoordTable[table.getn(grappleCoordTable) - 1].y
                                    and grappleCoordTable[table.getn(grappleCoordTable)].z == grappleCoordTable[table.getn(grappleCoordTable) - 1].z
                            then
                                --print("grapple is stationary")

                                -- call the function that does the actual moving of our unit
                                moveUnitToObjectAlongTrajectory(player, controllable, speed, odfName, grappleCoordTable)

                                --exit the timer, clean up
                                loopCount = 0
                                grappleCoordTable = {}
                                alive = true
                                --StopTimer(timer) -- timer should already be stopped if we are in this function?
                                DestroyTimer(timer)
                                moveGrappleTimer = nil

                                ReleaseTimerElapse(moveGrappleTimerTracker)
                                moveGrappleTimerTracker = nil

                                --print("exiting")
                                --exit the callback function
                                return
                            end

                            --StopTimer(moveUnitTimer)
                            SetTimerValue(timer, grappleTimeInterval)
                            StartTimer(timer)
                        elseif alive == false then
                            --print("hook is dead, stopping")

                            -- clean up
                            loopCount = 0
                            grappleCoordTable = {}
                            alive = true
                            --StopTimer(timer)
                            DestroyTimer(timer)
                            moveGrappleTimer = nil

                            ReleaseTimerElapse(moveGrappleTimerTracker)
                            moveGrappleTimerTracker = nil
                        else
                            --print("Grapple code: something else happened!")
                        end
                    end
                    , moveGrappleTimer)

                    -- this event listener simply sets alive to false.
                    -- I tried to use IsObjectAlive but that crashed when it was dead. Lol
                    -- Could potentially run into some synchronization issues, but that hasn't happened during testing
                    -- If there are glitches with the weapon then consider using the "LifeTime" value in the autoturret odf ...
                    -- ... instead of this event. make the timer only go until a the LifeTime of the autoturret
                    hookDeath = OnObjectKill(function(object, killer)
                        --print("object died")
                        if object == controllable then
                            --print(" hook died")
                            alive = false
                            --print("alive is " .. tostring(alive))

                            ReleaseObjectKill(hookDeath)
                            hookDeath = nil
                        end
                    end)

                    --print("starting grapple timer")
                    -- kick off the timer to track the grapple's position over time
                    StartTimer(moveGrappleTimer)
                end
            end
			))

end

