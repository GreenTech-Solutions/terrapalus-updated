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

-- Allow captive biter spawner placement (Aquilo tech) - requested by SeymourWilliamsJr
allow_on_terrapalus("unit-spawner", "captive-biter-spawner")

-- Allow fish breeding (requested by SeymourWilliamsJr)
allow_on_terrapalus("fish", "fish")
