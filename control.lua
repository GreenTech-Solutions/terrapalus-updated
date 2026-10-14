
-- Factorio 2.0 uses 'storage' instead of 'global'

-- Ultravium battery energy values (in Joules)
local BATTERY_ENERGY = {
    ["ultravium-battery-use"] = 10000000,      -- 10 MJ
    ["ultravium-battery-pack-use"] = 50000000, -- 50 MJ
    ["ultravium-power-cell-use"] = 200000000   -- 200 MJ
}

-- Charging station configuration
local CHARGING_STATION_CONFIG = {
    ["armor-charging-station"] = {radius = 15, power_per_tick = 1000000},     -- 1 MW (60 MJ/s)
    ["armor-charging-station-mk2"] = {radius = 22, power_per_tick = 2000000}, -- 2 MW (120 MJ/s)
    ["armor-charging-station-mk3"] = {radius = 30, power_per_tick = 4000000}  -- 4 MW (240 MJ/s)
}

local CHARGING_STATION_UPDATE_INTERVAL = 10  -- Update every 10 ticks (6x per second)
local CHARGING_STATIONS_PER_TICK = 5  -- Process stations in batches

-- UV Personal Equipment configuration
local UV_SHIELD_RADIUS = 10  -- Freeze enemies within 10 tiles
local UV_SHIELD_FREEZE_DURATION = 600  -- 10 seconds (60 ticks/second)
local UV_SHIELD_ENERGY_PER_FREEZE = 20000  -- 20 kJ per freeze
local UV_SHIELD_ENERGY_PER_PROJECTILE = 5000  -- 5 kJ per projectile destroyed
local UV_EQUIPMENT_UPDATE_INTERVAL = 30  -- Check every 30 ticks (2x per second)
local UV_PROJECTILE_UPDATE_INTERVAL = 5  -- Check for projectiles more frequently (12x per second)

-- Strafer projectile names to intercept
local STRAFER_PROJECTILES = {
    ["small-strafer-projectile"] = true,
    ["medium-strafer-projectile"] = true,
    ["big-strafer-projectile"] = true
}

local INHIBITOR_RADIUS = settings.startup["inhibitor-radius"].value
local INHIBITOR_RADIUS_MK2 = INHIBITOR_RADIUS * 1.4  -- 40% increase
local INHIBITOR_RADIUS_MK3 = INHIBITOR_RADIUS * 1.8  -- 80% increase
local THAW_DURATION = settings.startup["inhibitor-thaw-duration"].value
local FREEZE_DURATION = settings.startup["inhibitor-freeze-duration"].value
local FREEZE_DAYTIME = settings.startup["freeze-daytime"].value
local DAYTIME_VALUE = settings.startup["daytime-value"].value
local LAMPS_PER_TICK = 10
local SPOTLIGHT_FREEZE_DURATION = 1800  -- 30 seconds
local FROZEN_ENTITIES_PER_TICK = 20  -- Process frozen entities in batches
local SPOTLIGHT_UPDATE_INTERVAL = 30  -- Update spotlights every 30 ticks (2x per second)
local SPOTLIGHTS_PER_TICK = 5  -- Process spotlights in batches

-- Pre-defined lookup tables (created once, not per-call)
local UV_TURRETS = {
    ["uv-turret"] = true,
    ["uv-turret-mk2"] = true,
    ["uv-turret-mk3"] = true,
    ["uv-turret-aoe"] = true,
    ["uv-turret-chain"] = true
}

local VALID_ENEMY_TYPES = {
    ["unit"] = true,
    ["spider-unit"] = true
}

-- Enemy Race Manager (ERM) compatibility
-- Cache for enemy forces list (refreshed periodically)
local cached_enemy_forces = nil
local enemy_forces_cache_tick = 0
local ENEMY_FORCES_CACHE_DURATION = 300  -- Refresh every 5 seconds

-- Check if a force is an enemy force (uses ERM API if available)
local function is_enemy_force(force)
    local force_name = type(force) == "string" and force or force.name
    if remote.interfaces["enemyracemanager"] and remote.interfaces["enemyracemanager"]["is_enemy_force"] then
        return remote.call("enemyracemanager", "is_enemy_force", force_name)
    end
    -- Fallback: check if force name starts with "enemy"
    return string.find(force_name, "^enemy") ~= nil
end

-- Get list of all enemy forces for find_entities_filtered
local function get_enemy_forces()
    -- Return cached value if still valid
    if cached_enemy_forces and game.tick - enemy_forces_cache_tick < ENEMY_FORCES_CACHE_DURATION then
        return cached_enemy_forces
    end

    local forces = {}
    if remote.interfaces["enemyracemanager"] and remote.interfaces["enemyracemanager"]["is_enemy_force"] then
        -- Use ERM API to get all enemy forces
        for _, force in pairs(game.forces) do
            if remote.call("enemyracemanager", "is_enemy_force", force.name) then
                table.insert(forces, force.name)
            end
        end
    else
        -- Fallback: collect all forces starting with "enemy"
        for _, force in pairs(game.forces) do
            if string.find(force.name, "^enemy") then
                table.insert(forces, force.name)
            end
        end
    end

    -- Cache the result
    cached_enemy_forces = forces
    enemy_forces_cache_tick = game.tick
    return forces
end

-- Get radius for a specific lamp type
local function get_lamp_radius(lamp)
    if lamp.name == "inhibitor-lamp-mk3" then
        return INHIBITOR_RADIUS_MK3
    elseif lamp.name == "inhibitor-lamp-mk2" then
        return INHIBITOR_RADIUS_MK2
    else
        return INHIBITOR_RADIUS
    end
end

-- Check if entity is an inhibitor lamp variant
local function is_inhibitor_lamp(name)
    return name == "inhibitor-lamp" or name == "inhibitor-lamp-mk2" or name == "inhibitor-lamp-mk3" or name == "inhibitor-lamp-damage"
end

-- Apply damage sticker to entity
local function apply_damage_sticker(entity)
    if entity and entity.valid then
        entity.surface.create_entity{
            name = "inhibitor-damage-sticker",
            target = entity,
            position = entity.position
        }
    end
end

-- Apply frozen sticker to entity
local function apply_frozen_sticker(entity)
    if entity and entity.valid then
        entity.surface.create_entity{
            name = "frozen-sticker",
            target = entity,
            position = entity.position
        }
    end
end

-- Apply thawing sticker to entity
local function apply_thawing_sticker(entity)
    if entity and entity.valid then
        entity.surface.create_entity{
            name = "thawing-sticker",
            target = entity,
            position = entity.position
        }
    end
end

-- Ensure global tables are initialized
local function initialize_storage()
    storage.frozen_entities = storage.frozen_entities or {}
    storage.thawing_entities = storage.thawing_entities or {}
    storage.inhibitor_lamps = storage.inhibitor_lamps or {}
    storage.lamp_index = storage.lamp_index or 1
    storage.spotlight_frozen = storage.spotlight_frozen or {}
    storage.frozen_entity_keys = storage.frozen_entity_keys or {}  -- Array of unit_numbers for batch processing
    storage.frozen_entity_index = storage.frozen_entity_index or 1
    storage.lamps_by_surface = storage.lamps_by_surface or {}  -- Spatial partitioning by surface
    storage.spotlights = storage.spotlights or {}  -- Cached spotlight list
    storage.spotlight_index = storage.spotlight_index or 1
    storage.charging_stations = storage.charging_stations or {}  -- Cached charging station list
    storage.charging_station_index = storage.charging_station_index or 1
end

-- Check if entity is a charging station
local function is_charging_station(name)
    return CHARGING_STATION_CONFIG[name] ~= nil
end

-- Charge an equipment grid with the specified amount of energy
-- Returns the amount of energy actually added
local function charge_equipment_grid(grid, energy_to_add)
    if not grid then return 0 end

    local energy_added = 0
    for _, equipment in pairs(grid.equipment) do
        if equipment.valid and equipment.max_energy > 0 then
            local space_available = equipment.max_energy - equipment.energy
            if space_available > 0 then
                local to_add = math.min(space_available, energy_to_add - energy_added)
                equipment.energy = equipment.energy + to_add
                energy_added = energy_added + to_add
                if energy_added >= energy_to_add then
                    break
                end
            end
        end
    end
    return energy_added
end

-- Get the equipment grid for a player's armor
local function get_player_armor_grid(player)
    if not player or not player.valid or not player.character then return nil end
    local armor_inventory = player.get_inventory(defines.inventory.character_armor)
    if armor_inventory and not armor_inventory.is_empty() then
        local armor = armor_inventory[1]
        if armor and armor.valid_for_read and armor.grid then
            return armor.grid
        end
    end
    return nil
end

-- Check if equipment grid needs charging (has any equipment not at max energy)
local function grid_needs_charging(grid)
    if not grid then return false end
    for _, equipment in pairs(grid.equipment) do
        if equipment.valid and equipment.max_energy > 0 then
            if equipment.energy < equipment.max_energy then
                return true
            end
        end
    end
    return false
end

-- Check if player has specific equipment in their armor grid
-- Returns the equipment if found and it has enough energy, nil otherwise
local function player_has_equipment(player, equipment_name, min_energy)
    local grid = get_player_armor_grid(player)
    if not grid then return nil end

    for _, equipment in pairs(grid.equipment) do
        if equipment.valid and equipment.name == equipment_name then
            if not min_energy or equipment.energy >= min_energy then
                return equipment
            end
        end
    end
    return nil
end

-- Drain energy from equipment
local function drain_equipment_energy(equipment, amount)
    if equipment and equipment.valid then
        equipment.energy = math.max(0, equipment.energy - amount)
    end
end

-- Rebuild frozen entity keys array from frozen_entities table
local function rebuild_frozen_entity_keys()
    storage.frozen_entity_keys = {}
    for unit_number, _ in pairs(storage.frozen_entities) do
        table.insert(storage.frozen_entity_keys, unit_number)
    end
    storage.frozen_entity_index = 1
end

-- Update lamps_by_surface cache when lamps change
local function update_lamp_surface_cache()
    storage.lamps_by_surface = {}
    for _, lamp in ipairs(storage.inhibitor_lamps) do
        if lamp and lamp.valid then
            local surface_name = lamp.surface.name
            if not storage.lamps_by_surface[surface_name] then
                storage.lamps_by_surface[surface_name] = {}
            end
            table.insert(storage.lamps_by_surface[surface_name], lamp)
        end
    end
end

-- Rescan all lamps, spotlights, and charging stations on all surfaces
local function rescan_all_lamps()
    storage.inhibitor_lamps = {}
    storage.spotlights = {}
    storage.charging_stations = {}
    for _, surface in pairs(game.surfaces) do
        local lamps = surface.find_entities_filtered({name = {"inhibitor-lamp", "inhibitor-lamp-mk2", "inhibitor-lamp-mk3", "inhibitor-lamp-damage"}})
        for _, lamp in pairs(lamps) do
            table.insert(storage.inhibitor_lamps, lamp)
        end
        local spots = surface.find_entities_filtered({name = "uv-spotlight"})
        for _, spot in pairs(spots) do
            table.insert(storage.spotlights, spot)
        end
        local stations = surface.find_entities_filtered({name = {"armor-charging-station", "armor-charging-station-mk2", "armor-charging-station-mk3"}})
        for _, station in pairs(stations) do
            table.insert(storage.charging_stations, station)
        end
    end
    storage.lamp_index = 1
    storage.spotlight_index = 1
    storage.charging_station_index = 1
    update_lamp_surface_cache()
end

local function command_enemy_to_flee(enemy, turret)
    if not enemy.valid or not turret.valid then return end

    if enemy.valid and enemy.commandable then
        -- Access the LuaCommandable object
        local commandable = enemy.commandable

        if commandable then
            -- -- Calculate a random angle for movement direction
            -- local angle = math.random() * 3 * math.pi
            -- local distance = 100  -- Distance to move away

            -- -- Calculate the target position
            -- local target_position = {
            --     x = turret.position.x + math.cos(angle) * distance,
            --     y = turret.position.y + math.sin(angle) * distance
            -- }

            -- -- Create the movement command
            -- local move_command = {
            --     type = defines.command.go_to_location,
            --     destination = target_position,
            --     distraction = defines.distraction.none,
            --     radius = 1  -- Radius around the target position
            -- }

            -- Use the `flee` command to make the enemy move away from the turret
            local flee_command = {
                type = defines.command.flee,
                from = turret,
                distraction = defines.distraction.none
            }
            -- Assign the command using the dot operator
            commandable.set_command(flee_command)
        end
    end
end

local function on_entity_damaged(event)
    local source = event.cause

    -- Fast exit if no source
    if not source or not source.valid then return end

    local source_name = source.name

    -- Check for player character with UV defense turret
    local is_player_with_uv_turret = false
    if source.type == "character" and source.player then
        local uv_turret = player_has_equipment(source.player, "uv-defense-turret", 1000)  -- Need at least 1kJ
        if uv_turret then
            is_player_with_uv_turret = true
        end
    end

    -- Only process UV turrets, spotlights, or player UV defense turrets
    local is_uv_turret = UV_TURRETS[source_name]
    local is_spotlight = source_name == "uv-spotlight"
    if not is_uv_turret and not is_spotlight and not is_player_with_uv_turret then return end

    local enemy = event.entity
    if not enemy.valid then return end

    -- Check if valid enemy type using pre-defined table
    if not VALID_ENEMY_TYPES[enemy.type] then return end

    -- Check force (supports ERM and other mods with custom enemy forces)
    if not is_enemy_force(enemy.force) then return end

    if is_uv_turret then
        command_enemy_to_flee(enemy, source)
    end

    -- Handle player UV defense turret - causes enemies to flee
    if is_player_with_uv_turret then
        command_enemy_to_flee(enemy, source)
    end

    -- Handle spotlight freeze (30 seconds, entity.disabled_by_script = true)
    if is_spotlight then
        local unit_number = enemy.unit_number
        if not unit_number then return end

        initialize_storage()
        local spotlight_frozen = storage.spotlight_frozen

        if spotlight_frozen[unit_number] then
            -- Already frozen - heal the damage so spotlight can't kill frozen enemies
            local health = enemy.health
            local damage = event.final_damage_amount
            if health and damage then
                enemy.health = health + damage
            end
            -- Clear target to encourage retargeting
            source.shooting_target = nil
        else
            -- Freeze the enemy
            enemy.disabled_by_script = true
            spotlight_frozen[unit_number] = {
                entity = enemy,
                thaw_tick = game.tick + SPOTLIGHT_FREEZE_DURATION
            }
            -- Apply frozen sticker for visual
            apply_frozen_sticker(enemy)
            -- Remove from lamp frozen tracking if present
            storage.frozen_entities[unit_number] = nil
            storage.thawing_entities[unit_number] = nil
        end
    end
end
-- Register the event handler
script.on_event(defines.events.on_entity_damaged, on_entity_damaged)


-- Function to warn about night vision on Terra Palus (no longer forces removal)
local function handle_night_vision(player)
    if player.surface.name == "terrapalus" then
        local armor_inventory = player.get_inventory(defines.inventory.character_armor)
        if armor_inventory and not armor_inventory.is_empty() then
            local armor = armor_inventory[1]
            if armor and armor.valid_for_read then
                local grid = armor.grid
                if grid then
                    for _, equipment in pairs(grid.equipment) do
                        if equipment.name == "night-vision-equipment" then
                            player.print("[color=yellow]Warning:[/color] Night vision equipment has limited effectiveness on Terra Palus due to the dense atmosphere.")
                            return  -- Only warn once
                        end
                    end
                end
            end
        end
    end
end

-- Event handler for player changing surfaces
script.on_event(defines.events.on_player_changed_surface, function(event)
    local player = game.get_player(event.player_index)
    if player then
        handle_night_vision(player)
        -- Ensure daytime is set correctly when arriving on Terra Palus
        if player.surface.name == "terrapalus" then
            player.surface.daytime = DAYTIME_VALUE
            player.surface.freeze_daytime = FREEZE_DAYTIME
        end
    end
end)

-- Event handler for player joining the game
script.on_event(defines.events.on_player_joined_game, function(event)
    local player = game.get_player(event.player_index)
    if player then
        handle_night_vision(player)
    end
end)

-- Event handler for when equipment is placed in the armor grid
script.on_event(defines.events.on_player_placed_equipment, function(event)
    if event.equipment.name == "night-vision-equipment" then
        local player = game.get_player(event.player_index)
        if player then
            handle_night_vision(player)
        end
    end
end)

-- Event handler for when a new surface is created
script.on_event(defines.events.on_surface_created, function(event)
    local surface = game.surfaces[event.surface_index]
    if surface.name == "terrapalus" then
        surface.daytime = DAYTIME_VALUE  -- Set to midnight
        surface.freeze_daytime = FREEZE_DAYTIME  -- Freeze the time at midnight
    end
end)

-- Add lamp/spotlight/charging station to global list when built
---@param event EventData.on_built_entity|EventData.on_robot_built_entity|EventData.script_raised_built|EventData.script_raised_revive
script.on_event({defines.events.on_built_entity, defines.events.on_robot_built_entity, defines.events.script_raised_built, defines.events.script_raised_revive}, function(event)
    local entity = event.entity
    if is_inhibitor_lamp(entity.name) then
        initialize_storage()
        table.insert(storage.inhibitor_lamps, entity)
        -- Update surface cache
        local surface_name = entity.surface.name
        if not storage.lamps_by_surface[surface_name] then
            storage.lamps_by_surface[surface_name] = {}
        end
        table.insert(storage.lamps_by_surface[surface_name], entity)
    elseif entity.name == "uv-spotlight" then
        initialize_storage()
        table.insert(storage.spotlights, entity)
    elseif is_charging_station(entity.name) then
        initialize_storage()
        table.insert(storage.charging_stations, entity)
    end
end)

-- Remove lamp/spotlight/charging station from global list when destroyed
---@param event EventData.on_entity_died|EventData.on_player_mined_entity|EventData.on_robot_mined_entity|EventData.script_raised_destroy
script.on_event({defines.events.on_entity_died, defines.events.on_player_mined_entity, defines.events.on_robot_mined_entity, defines.events.script_raised_destroy}, function(event)
    local entity = event.entity
    if is_inhibitor_lamp(entity.name) then
        initialize_storage()
        -- Remove from main list using swap-and-pop for O(1) removal
        for i, lamp in ipairs(storage.inhibitor_lamps) do
            if lamp == entity then
                local last = #storage.inhibitor_lamps
                storage.inhibitor_lamps[i] = storage.inhibitor_lamps[last]
                storage.inhibitor_lamps[last] = nil
                break
            end
        end
        -- Remove from surface cache
        local surface_name = entity.surface.name
        if storage.lamps_by_surface[surface_name] then
            for i, lamp in ipairs(storage.lamps_by_surface[surface_name]) do
                if lamp == entity then
                    local last = #storage.lamps_by_surface[surface_name]
                    storage.lamps_by_surface[surface_name][i] = storage.lamps_by_surface[surface_name][last]
                    storage.lamps_by_surface[surface_name][last] = nil
                    break
                end
            end
        end
    elseif entity.name == "uv-spotlight" then
        initialize_storage()
        -- Remove from spotlight list using swap-and-pop
        for i, spot in ipairs(storage.spotlights) do
            if spot == entity then
                local last = #storage.spotlights
                storage.spotlights[i] = storage.spotlights[last]
                storage.spotlights[last] = nil
                break
            end
        end
    elseif is_charging_station(entity.name) then
        initialize_storage()
        -- Remove from charging station list using swap-and-pop
        for i, station in ipairs(storage.charging_stations) do
            if station == entity then
                local last = #storage.charging_stations
                storage.charging_stations[i] = storage.charging_stations[last]
                storage.charging_stations[last] = nil
                break
            end
        end
    end
end)

-- Initialization event to handle existing lamps and surfaces on startup
script.on_init(function()
    initialize_storage()
    -- Initialize surfaces
    for _, surface in pairs(game.surfaces) do
        if surface.name == "terrapalus" then
            surface.daytime = DAYTIME_VALUE  -- Set to midnight
            surface.freeze_daytime = FREEZE_DAYTIME  -- Freeze the time at midnight
        end
    end

    -- Populate the global lamp list with existing lamps
    rescan_all_lamps()

    -- A save switching from the original Terra Palus keeps the enemies it froze disabled, but not its lists of them,
    -- so nothing would ever thaw them: track them as frozen, those out of a lamp's range then thaw as usual
    for _, surface in pairs(game.surfaces) do
        for _, enemy in pairs(surface.find_entities_filtered({force = get_enemy_forces(), type = {"unit", "spider-unit"}})) do
            if enemy.disabled_by_script and not storage.frozen_entities[enemy.unit_number] then
                storage.frozen_entities[enemy.unit_number] = {
                    entity = enemy,
                    freeze_start_tick = game.tick,
                    is_freezing = false
                }
                table.insert(storage.frozen_entity_keys, enemy.unit_number)
            end
        end
    end
end)

-- Handle loading the script
script.on_load(function()
    -- Event handlers are automatically re-registered, no action needed
    -- Note: Cannot modify storage here, sticker refresh is triggered by on_player_joined_game
end)

-- Trigger sticker refresh when any player joins (including on game load)
-- This is multiplayer-safe because on_player_joined_game is a synchronized game event
script.on_event(defines.events.on_player_joined_game, function(event)
    storage.pending_sticker_refresh = true
end)

-- Process a subset of lamps each tick
local function process_lamps()
    initialize_storage()
    local lamps = storage.inhibitor_lamps
    local lamp_count = #lamps

    if lamp_count == 0 then return end

    -- Ensure storage.lamp_index is within valid range
    if storage.lamp_index > lamp_count then
        storage.lamp_index = 1
    end

    local end_index = math.min(storage.lamp_index + LAMPS_PER_TICK - 1, lamp_count)
    for i = storage.lamp_index, end_index do
        local lamp = lamps[i]
        if lamp and lamp.valid and lamp.energy > 0 and lamp.status ~= defines.entity_status.disabled_by_control_behavior then
            -- Process the lamp as before
            local lamp_radius = get_lamp_radius(lamp)
            local enemies_in_range = lamp.surface.find_entities_filtered({
                position = lamp.position,
                radius = lamp_radius,
                force = get_enemy_forces(),
                type = {"unit", "spider-unit"}
            })
            -- [Continue with the existing logic for freezing entities]
            for _, enemy in ipairs(enemies_in_range) do
                if enemy and enemy.valid and enemy.health > 0 then
                    -- Damage lamp applies damage sticker in addition to freeze
                    if lamp.name == "inhibitor-lamp-damage" then
                        apply_damage_sticker(enemy)
                    end

                    -- All lamps freeze enemies
                    if not storage.frozen_entities[enemy.unit_number] then
                        storage.frozen_entities[enemy.unit_number] = {
                            entity = enemy,
                            freeze_start_tick = game.tick,
                            is_freezing = true
                        }
                        -- Add to keys array for batch processing
                        table.insert(storage.frozen_entity_keys, enemy.unit_number)
                        apply_frozen_sticker(enemy)
                    else
                        local freeze_data = storage.frozen_entities[enemy.unit_number]
                        local elapsed_ticks = game.tick - freeze_data.freeze_start_tick
                        if freeze_data.is_freezing and elapsed_ticks >= FREEZE_DURATION then
                            enemy.disabled_by_script = true
                            freeze_data.is_freezing = false
                        end
                    end
                    storage.thawing_entities[enemy.unit_number] = nil
                end
            end
        elseif not lamp or not lamp.valid then
            -- Only remove invalid lamps (destroyed/mined), not unpowered ones
            lamps[i] = nil
        end
        -- Skip lamps with no energy but keep them in the list
    end

    -- Clean up nil/invalid entries using swap-and-pop (more efficient)
    local write_index = 1
    for read_index = 1, lamp_count do
        local lamp = lamps[read_index]
        if lamp and lamp.valid then
            if write_index ~= read_index then
                lamps[write_index] = lamp
            end
            write_index = write_index + 1
        end
    end
    -- Clear remaining entries
    for i = write_index, lamp_count do
        lamps[i] = nil
    end

    -- Update storage.lamp_index for the next iteration
    local new_count = write_index - 1
    storage.lamp_index = end_index + 1
    if storage.lamp_index > new_count then
        storage.lamp_index = 1
    end
end

-- Update thawing entities
local function update_thawing_entities()
    initialize_storage()
    for unit_number, thaw_data in pairs(storage.thawing_entities) do
        local entity = thaw_data.entity
        if entity and entity.valid then
            local elapsed_ticks = game.tick - thaw_data.thaw_start_tick
            if elapsed_ticks > THAW_DURATION then
                -- Fully thawed; restore entity to normal
                entity.disabled_by_script = false
                storage.thawing_entities[unit_number] = nil
            elseif elapsed_ticks == 0 then
                -- Apply thawing sticker once when thawing starts
                apply_thawing_sticker(entity)
            end
        else
            -- Clean up invalid entities
            storage.thawing_entities[unit_number] = nil
        end
    end
end

-- Update spotlight-frozen entities (30 second freeze)
local function update_spotlight_frozen()
    initialize_storage()
    local current_tick = game.tick
    for unit_number, freeze_data in pairs(storage.spotlight_frozen) do
        local entity = freeze_data.entity
        if entity and entity.valid then
            if current_tick >= freeze_data.thaw_tick then
                -- Thaw the entity
                entity.disabled_by_script = false
                storage.spotlight_frozen[unit_number] = nil
            end
        else
            -- Clean up invalid entities
            storage.spotlight_frozen[unit_number] = nil
        end
    end
end

-- Manage spotlight targeting - force retarget if current target is frozen
-- Uses cached spotlights and batch processing to reduce frame spikes
local function manage_spotlight_targeting()
    initialize_storage()

    local spotlights = storage.spotlights
    local spotlight_count = #spotlights
    if spotlight_count == 0 then return end

    -- Ensure index is valid
    if storage.spotlight_index > spotlight_count then
        storage.spotlight_index = 1
    end

    local end_index = math.min(storage.spotlight_index + SPOTLIGHTS_PER_TICK - 1, spotlight_count)

    for i = storage.spotlight_index, end_index do
        local spotlight = spotlights[i]
        if spotlight and spotlight.valid then
            local surface = spotlight.surface
            -- Check for enemies in range
            local enemies = surface.find_entities_filtered({
                position = spotlight.position,
                radius = 24,
                force = get_enemy_forces(),
                type = {"unit", "spider-unit", "unit-spawner", "turret"}
            })

            -- Find unfrozen enemies and closest in single pass
            local closest_enemy = nil
            local closest_dist_sq = math.huge
            local has_frozen = false
            local spotlight_pos = spotlight.position

            for _, enemy in ipairs(enemies) do
                if enemy.valid and enemy.unit_number then
                    if storage.spotlight_frozen[enemy.unit_number] then
                        has_frozen = true
                    else
                        -- Calculate distance for unfrozen enemies
                        local dx = enemy.position.x - spotlight_pos.x
                        local dy = enemy.position.y - spotlight_pos.y
                        local dist_sq = dx * dx + dy * dy
                        if dist_sq < closest_dist_sq then
                            closest_dist_sq = dist_sq
                            closest_enemy = enemy
                        end
                    end
                end
            end

            if closest_enemy then
                -- There are unfrozen enemies - enable turret
                spotlight.disabled_by_script = false

                -- Set target if: no target, invalid target, or current target is frozen
                local current_target = spotlight.shooting_target
                local needs_retarget = not current_target
                    or not current_target.valid
                    or (current_target.unit_number and storage.spotlight_frozen[current_target.unit_number])

                if needs_retarget then
                    spotlight.shooting_target = closest_enemy
                end
            elseif has_frozen then
                -- All enemies are frozen - disable turret completely
                spotlight.disabled_by_script = true
                spotlight.shooting_target = nil
            else
                -- No enemies - keep turret active and ready
                spotlight.disabled_by_script = false
            end
        elseif spotlight and not spotlight.valid then
            -- Mark invalid for cleanup
            spotlights[i] = nil
        end
    end

    -- Clean up invalid spotlights periodically (when we wrap around)
    if end_index >= spotlight_count then
        local write_index = 1
        for read_index = 1, spotlight_count do
            local spot = spotlights[read_index]
            if spot and spot.valid then
                if write_index ~= read_index then
                    spotlights[write_index] = spot
                end
                write_index = write_index + 1
            end
        end
        for j = write_index, spotlight_count do
            spotlights[j] = nil
        end
        storage.spotlight_index = 1
    else
        storage.spotlight_index = end_index + 1
    end
end

-- Handle entities moving out of range and start thawing (batch processed)
local function process_frozen_entities()
    initialize_storage()

    local keys = storage.frozen_entity_keys
    local key_count = #keys
    if key_count == 0 then return end

    -- Ensure index is valid
    if storage.frozen_entity_index > key_count then
        storage.frozen_entity_index = 1
    end

    local end_index = math.min(storage.frozen_entity_index + FROZEN_ENTITIES_PER_TICK - 1, key_count)
    local keys_to_remove = {}

    for i = storage.frozen_entity_index, end_index do
        local unit_number = keys[i]
        local freeze_data = storage.frozen_entities[unit_number]

        if not freeze_data then
            table.insert(keys_to_remove, i)
        else
            local entity = freeze_data.entity
            if entity and entity.valid then
                local in_range = false
                -- Only check lamps on the same surface (spatial partitioning)
                local surface_lamps = storage.lamps_by_surface[entity.surface.name]
                if surface_lamps then
                    for _, lamp in ipairs(surface_lamps) do
                        if lamp and lamp.valid and lamp.energy > 0 and lamp.status ~= defines.entity_status.disabled_by_control_behavior then
                            local lamp_radius = get_lamp_radius(lamp)
                            local dx = lamp.position.x - entity.position.x
                            local dy = lamp.position.y - entity.position.y
                            local distance_squared = dx * dx + dy * dy
                            if distance_squared <= lamp_radius * lamp_radius then
                                in_range = true
                                break
                            end
                        end
                    end
                end
                if not in_range then
                    -- Start thawing
                    storage.thawing_entities[unit_number] = {
                        entity = entity,
                        thaw_start_tick = game.tick
                    }
                    storage.frozen_entities[unit_number] = nil
                    entity.disabled_by_script = false  -- Reactivate for gradual thaw
                    apply_thawing_sticker(entity)
                    table.insert(keys_to_remove, i)
                end
            else
                -- Clean up invalid entities
                storage.frozen_entities[unit_number] = nil
                table.insert(keys_to_remove, i)
            end
        end
    end

    -- Remove processed/invalid keys using swap-and-pop (reverse order to maintain indices)
    table.sort(keys_to_remove, function(a, b) return a > b end)
    for _, idx in ipairs(keys_to_remove) do
        local last = #keys
        keys[idx] = keys[last]
        keys[last] = nil
    end

    -- Update index for next iteration
    storage.frozen_entity_index = end_index + 1
    if storage.frozen_entity_index > #keys then
        storage.frozen_entity_index = 1
    end
end

-- Process charging stations - charge nearby players and vehicles
local function process_charging_stations()
    initialize_storage()

    local stations = storage.charging_stations
    local station_count = #stations
    if station_count == 0 then return end

    -- Ensure index is valid
    if storage.charging_station_index > station_count then
        storage.charging_station_index = 1
    end

    local end_index = math.min(storage.charging_station_index + CHARGING_STATIONS_PER_TICK - 1, station_count)

    for i = storage.charging_station_index, end_index do
        local station = stations[i]
        if station and station.valid then
            local config = CHARGING_STATION_CONFIG[station.name]
            if config then
                local radius = config.radius
                local power_per_tick = config.power_per_tick
                local surface = station.surface
                local position = station.position

                -- Check if station has enough energy
                local available_energy = station.energy
                if available_energy > 0 then
                    local total_energy_needed = 0
                    local targets_to_charge = {}

                    -- Find players in range
                    for _, player in pairs(game.players) do
                        if player.valid and player.connected and player.surface == surface then
                            local player_pos = player.position
                            local dx = player_pos.x - position.x
                            local dy = player_pos.y - position.y
                            local distance_squared = dx * dx + dy * dy
                            if distance_squared <= radius * radius then
                                local grid = get_player_armor_grid(player)
                                if grid and grid_needs_charging(grid) then
                                    table.insert(targets_to_charge, {type = "player", grid = grid, player = player})
                                end
                            end
                        end
                    end

                    -- Find vehicles in range with equipment grids
                    local vehicles = surface.find_entities_filtered({
                        position = position,
                        radius = radius,
                        type = {"car", "spider-vehicle", "locomotive", "cargo-wagon", "fluid-wagon", "artillery-wagon"}
                    })
                    for _, vehicle in pairs(vehicles) do
                        if vehicle.valid and vehicle.grid then
                            if grid_needs_charging(vehicle.grid) then
                                table.insert(targets_to_charge, {type = "vehicle", grid = vehicle.grid, entity = vehicle})
                            end
                        end
                    end

                    -- Charge all targets, distributing energy
                    if #targets_to_charge > 0 then
                        local energy_per_target = math.min(power_per_tick, available_energy) / #targets_to_charge
                        local total_energy_used = 0

                        for _, target in pairs(targets_to_charge) do
                            local energy_added = charge_equipment_grid(target.grid, energy_per_target)
                            total_energy_used = total_energy_used + energy_added
                        end

                        -- Drain energy from station
                        if total_energy_used > 0 then
                            station.energy = station.energy - total_energy_used
                        end
                    end
                end
            end
        elseif station and not station.valid then
            -- Mark invalid for cleanup
            stations[i] = nil
        end
    end

    -- Clean up invalid stations periodically (when we wrap around)
    if end_index >= station_count then
        local write_index = 1
        for read_index = 1, station_count do
            local s = stations[read_index]
            if s and s.valid then
                if write_index ~= read_index then
                    stations[write_index] = s
                end
                write_index = write_index + 1
            end
        end
        for j = write_index, station_count do
            stations[j] = nil
        end
        storage.charging_station_index = 1
    else
        storage.charging_station_index = end_index + 1
    end
end

-- Process UV personal shields - freeze enemies near players with shield equipped
local function process_uv_personal_shields()
    initialize_storage()

    -- Initialize shield frozen tracking if needed
    storage.shield_frozen = storage.shield_frozen or {}

    for _, player in pairs(game.players) do
        if player.valid and player.connected and player.character then
            local shield = player_has_equipment(player, "uv-personal-shield", UV_SHIELD_ENERGY_PER_FREEZE)
            if shield then
                local surface = player.surface
                local position = player.position

                -- Find enemies in range
                local enemies = surface.find_entities_filtered({
                    position = position,
                    radius = UV_SHIELD_RADIUS,
                    force = get_enemy_forces()
                })

                for _, enemy in pairs(enemies) do
                    if enemy.valid and VALID_ENEMY_TYPES[enemy.type] then
                        local unit_number = enemy.unit_number
                        if unit_number then
                            -- Check if already frozen by shield
                            local shield_data = storage.shield_frozen[unit_number]
                            if not shield_data then
                                -- Not frozen - freeze the enemy
                                enemy.disabled_by_script = true
                                apply_frozen_sticker(enemy)

                                -- Track the freeze
                                storage.shield_frozen[unit_number] = {
                                    entity = enemy,
                                    freeze_until = game.tick + UV_SHIELD_FREEZE_DURATION
                                }

                                -- Drain energy from shield
                                drain_equipment_energy(shield, UV_SHIELD_ENERGY_PER_FREEZE)

                                -- Check if we still have energy for more freezes
                                if shield.energy < UV_SHIELD_ENERGY_PER_FREEZE then
                                    break  -- Stop freezing, not enough energy
                                end
                            else
                                -- Already frozen - extend the freeze duration if player is still nearby
                                shield_data.freeze_until = game.tick + UV_SHIELD_FREEZE_DURATION
                            end
                        end
                    end
                end
            end
        end
    end
end

-- Update shield frozen entities - unfreeze when timer expires
local function update_shield_frozen()
    initialize_storage()
    storage.shield_frozen = storage.shield_frozen or {}

    local current_tick = game.tick
    local to_remove = {}

    for unit_number, data in pairs(storage.shield_frozen) do
        local entity = data.entity
        if not entity or not entity.valid then
            table.insert(to_remove, unit_number)
        elseif current_tick >= data.freeze_until then
            -- Freeze expired - unfreeze
            entity.disabled_by_script = false
            table.insert(to_remove, unit_number)
        end
    end

    -- Clean up
    for _, unit_number in ipairs(to_remove) do
        storage.shield_frozen[unit_number] = nil
    end
end

-- Intercept Strafer projectiles near players with UV personal shield
local function intercept_strafer_projectiles()
    for _, player in pairs(game.players) do
        if player.valid and player.connected and player.character then
            local shield = player_has_equipment(player, "uv-personal-shield", UV_SHIELD_ENERGY_PER_PROJECTILE)
            if shield then
                local surface = player.surface
                local position = player.position

                -- Find all strafer projectiles in range
                for projectile_name, _ in pairs(STRAFER_PROJECTILES) do
                    local projectiles = surface.find_entities_filtered({
                        name = projectile_name,
                        position = position,
                        radius = UV_SHIELD_RADIUS
                    })

                    for _, projectile in pairs(projectiles) do
                        if projectile.valid then
                            -- Check if we have enough energy
                            if shield.energy >= UV_SHIELD_ENERGY_PER_PROJECTILE then
                                -- Create a visual effect at projectile location
                                surface.create_entity({
                                    name = "laser-beam",
                                    position = projectile.position,
                                    target_position = position,
                                    source_position = projectile.position,
                                    duration = 10
                                })

                                -- Destroy the projectile
                                projectile.destroy()

                                -- Drain energy from shield
                                drain_equipment_energy(shield, UV_SHIELD_ENERGY_PER_PROJECTILE)
                            else
                                -- Not enough energy, stop intercepting
                                break
                            end
                        end
                    end
                end
            end
        end
    end
end

-- Handle ultravium battery use (script trigger effect from capsule)
script.on_event(defines.events.on_script_trigger_effect, function(event)
    local effect_id = event.effect_id
    local energy_amount = BATTERY_ENERGY[effect_id]

    if not energy_amount then return end

    -- Get the player who used the battery
    local source_entity = event.source_entity
    if not source_entity or not source_entity.valid then return end

    -- Source entity should be the player character
    if source_entity.type ~= "character" then return end

    local player = source_entity.player
    if not player or not player.valid then return end

    -- Get the player's armor grid
    local grid = get_player_armor_grid(player)
    if not grid then
        player.print("[color=yellow]No power armor equipped to charge.[/color]")
        return
    end

    -- Charge the equipment grid
    local energy_added = charge_equipment_grid(grid, energy_amount)

    if energy_added > 0 then
        local mj_added = energy_added / 1000000
        player.print("[color=green]Charged armor with " .. string.format("%.1f", mj_added) .. " MJ[/color]")
    else
        player.print("[color=yellow]Armor equipment is already fully charged.[/color]")
    end
end)

-- Main update function called every tick
script.on_event(defines.events.on_tick, function(event)
    initialize_storage()

    -- Reapply stickers after load (flag set by on_player_joined_game)
    -- This is multiplayer-safe because the flag is in synchronized storage
    if storage.pending_sticker_refresh then
        for unit_number, freeze_data in pairs(storage.frozen_entities) do
            if freeze_data.entity and freeze_data.entity.valid then
                apply_frozen_sticker(freeze_data.entity)
            end
        end
        for unit_number, freeze_data in pairs(storage.spotlight_frozen or {}) do
            if freeze_data.entity and freeze_data.entity.valid then
                apply_frozen_sticker(freeze_data.entity)
            end
        end
        for unit_number, thaw_data in pairs(storage.thawing_entities) do
            if thaw_data.entity and thaw_data.entity.valid then
                apply_thawing_sticker(thaw_data.entity)
            end
        end
        storage.pending_sticker_refresh = false
    end

    local tick = event.tick

    -- Process lamps every tick (already batched with LAMPS_PER_TICK)
    process_lamps()

    -- Process frozen entities every tick (now batched with FROZEN_ENTITIES_PER_TICK)
    process_frozen_entities()

    -- Update thawing entities every tick (lightweight - just timer checks)
    update_thawing_entities()

    -- Update spotlight frozen every tick (lightweight - just timer checks)
    update_spotlight_frozen()

    -- Manage spotlight targeting less frequently (expensive operation)
    if tick % SPOTLIGHT_UPDATE_INTERVAL == 0 then
        manage_spotlight_targeting()
    end

    -- Process charging stations periodically
    if tick % CHARGING_STATION_UPDATE_INTERVAL == 0 then
        process_charging_stations()
    end

    -- Process UV personal shields periodically
    if tick % UV_EQUIPMENT_UPDATE_INTERVAL == 0 then
        process_uv_personal_shields()
    end

    -- Intercept Strafer projectiles more frequently (they move fast)
    if tick % UV_PROJECTILE_UPDATE_INTERVAL == 0 then
        intercept_strafer_projectiles()
    end

    -- Update shield frozen entities every tick (lightweight timer check)
    update_shield_frozen()
end)


-- Ensure configuration changes are handled properly
script.on_configuration_changed(function(data)
    initialize_storage()

    -- Ensure Terra Palus daytime is set correctly on mod update
    for _, surface in pairs(game.surfaces) do
        if surface.name == "terrapalus" then
            surface.daytime = DAYTIME_VALUE
            surface.freeze_daytime = FREEZE_DAYTIME
        end
    end

    -- Clean up invalid references
    for unit_number, data in pairs(storage.frozen_entities) do
        if not data.entity or not data.entity.valid then
            storage.frozen_entities[unit_number] = nil
        end
    end
    for unit_number, data in pairs(storage.thawing_entities) do
        if not data.entity or not data.entity.valid then
            storage.thawing_entities[unit_number] = nil
        end
    end
    if storage.spotlight_frozen then
        for unit_number, data in pairs(storage.spotlight_frozen) do
            if not data.entity or not data.entity.valid then
                storage.spotlight_frozen[unit_number] = nil
            end
        end
    end

    -- Rescan all lamps to ensure new lamp types are included
    rescan_all_lamps()

    -- Rebuild frozen entity keys for batch processing
    rebuild_frozen_entity_keys()

    -- Reapply stickers to already-frozen entities after configuration change
    for unit_number, freeze_data in pairs(storage.frozen_entities) do
        if freeze_data.entity and freeze_data.entity.valid then
            apply_frozen_sticker(freeze_data.entity)
        end
    end
    for unit_number, freeze_data in pairs(storage.spotlight_frozen) do
        if freeze_data.entity and freeze_data.entity.valid then
            apply_frozen_sticker(freeze_data.entity)
        end
    end
    for unit_number, thaw_data in pairs(storage.thawing_entities) do
        if thaw_data.entity and thaw_data.entity.valid then
            apply_thawing_sticker(thaw_data.entity)
        end
    end
end)
