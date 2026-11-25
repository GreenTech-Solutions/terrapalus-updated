-- data-final-fixes.lua
-- Modifications to base/Space Age prototypes for Terra Palus compatibility

-- The surface conditions are widened just enough to include Terra Palus instead of cleared, which let these entities
-- onto every planet and onto space platforms: what Terra Palus does not meet becomes the bound, the rest stays.
local terrapalus = data.raw.planet and data.raw.planet["terrapalus"]

local function terrapalus_value(property)
    local own = terrapalus and terrapalus.surface_properties and terrapalus.surface_properties[property]
    if own ~= nil then return own end
    local prototype = data.raw["surface-property"] and data.raw["surface-property"][property]
    return prototype and prototype.default_value or 0
end

local function allow_on_terrapalus(entity_type, entity_name)
    if data.raw[entity_type] and data.raw[entity_type][entity_name] then
        local entity = data.raw[entity_type][entity_name]
        ---@diagnostic disable-next-line: undefined-field
        for _, condition in pairs(entity.surface_conditions or {}) do
            local value = terrapalus_value(condition.property)
            if condition.min and value < condition.min then condition.min = value end
            if condition.max and value > condition.max then condition.max = value end
        end
    end
end

-- Allow biolab on Terra Palus (enables agricultural science production)
allow_on_terrapalus("lab", "biolab")

-- Allow agricultural tower on Terra Palus
allow_on_terrapalus("agricultural-tower", "agricultural-tower")

-- Allow yumako/jellynut plants (enables farming on Terra Palus)
allow_on_terrapalus("plant", "yumako-tree")
allow_on_terrapalus("plant", "jellystem")

-- In 2.x the captive biter spawner is an assembling-machine, so the old unit-spawner lookup found nothing. Widening its
-- pressure range would also allow it on every planet between 1000 and 2000 hPa; a separate property keeps the earlier scope.
-- Rampant, fixed adds a captive spawner for each of its factions, a copy of the vanilla one named
-- "<faction>-captive-biter-spawner-rampant" (RampantFixed prototypes/SwarmUtils.lua), and those get the same treatment.
local captive_spawners = {}
for name, machine in pairs(data.raw["assembling-machine"] or {}) do
    if (name == "captive-biter-spawner" or name:match("%-captive%-biter%-spawner%-rampant$"))
        and type(machine.surface_conditions) == "table" then
        captive_spawners[#captive_spawners + 1] = machine
    end
end

if #captive_spawners > 0 then
    local function surface_value(planet, property)
        local own = planet.surface_properties and planet.surface_properties[property]
        if own ~= nil then return own end
        local prototype = data.raw["surface-property"] and data.raw["surface-property"][property]
        return prototype and prototype.default_value or 0
    end

    local function can_place(spawner, planet)
        for _, condition in pairs(spawner.surface_conditions) do
            local value = surface_value(planet, condition.property)
            if condition.min and value < condition.min then return false end
            if condition.max and value > condition.max then return false end
        end
        return true
    end

    for _, planet in pairs(data.raw.planet or {}) do
        for _, spawner in pairs(captive_spawners) do
            if can_place(spawner, planet) then
                planet.surface_properties = planet.surface_properties or {}
                planet.surface_properties["terrapalus-captive-nest"] = 1
                break
            end
        end
    end

    if terrapalus then
        terrapalus.surface_properties = terrapalus.surface_properties or {}
        terrapalus.surface_properties["terrapalus-captive-nest"] = 1
    end

    for _, spawner in pairs(captive_spawners) do
        allow_on_terrapalus("assembling-machine", spawner.name)
        spawner.surface_conditions[#spawner.surface_conditions + 1] = {
            property = "terrapalus-captive-nest",
            min = 1,
        }
    end
end

-- Allow fish breeding (requested by SeymourWilliamsJr)
allow_on_terrapalus("fish", "fish")
