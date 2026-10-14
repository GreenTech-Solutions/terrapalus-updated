-- data-final-fixes.lua
-- Modifications to base/Space Age prototypes for Terra Palus compatibility

-- Helper function to clear surface conditions for an entity
local function allow_on_terrapalus(entity_type, entity_name)
    if data.raw[entity_type] and data.raw[entity_type][entity_name] then
        local entity = data.raw[entity_type][entity_name]
        -- Remove surface conditions to allow placement anywhere
        -- (Terra Palus as Gleba moon should support Gleba-style entities)
        if entity.surface_conditions then
            entity.surface_conditions = nil
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
