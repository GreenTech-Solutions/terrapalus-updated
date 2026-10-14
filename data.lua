-- Resource Spawner Overhaul places ores itself and clears the ores, plants and other entities of every planet it does
-- not know, which left Terra Palus bare: keep it off the moon and off palusium (its documented opt-out)
data.rso_ignore_planets = data.rso_ignore_planets or {}
data.rso_ignore_planets["terrapalus"] = true
data.rso_ignore_resource_entities = data.rso_ignore_resource_entities or {}
data.rso_ignore_resource_entities["palusium-ore"] = true

require("prototypes.planet.planet")
require("prototypes.planet.surface-render-parameter-effects")
require("prototypes.technology")
require("prototypes.entity.entities")
require("prototypes.item.items")
require("prototypes.recipe.recipes")
require("prototypes.entity.resources")
require("prototypes.entity.turrets")
require("prototypes.stickers")
require("prototypes.fluid")
require("prototypes.autoplace-controls")
require("prototypes.ambient-sounds")
require("prototypes.equipment")

-- Tenebris Prime copied these noise expressions of Terra Palus under the same terrapalus_* names, with its own formulas,
-- and the planet that loads last took the other's terrain. Terra Palus uses its own terra_palus_* names; the old names
-- stay for surfaces of older saves, which keep the names they were created with, unless another mod defines them.
-- Defined here in data.lua, before any data-final-fixes alias of the same names: in a save with both mods every
-- surface was generated with the Terra Palus formulas, and keeps them.
for _, suffix in pairs({
    "above_deep_water_mask", "aux", "biome_mask_green", "biome_mix",
    "elevation", "fertile_spots_coastal", "fertile_spots_coastal_raw", "moisture",
    "segmentation_multiplier", "spawner", "spawner_small", "starting_angle",
    "starting_area_multiplier", "starting_enemies", "starting_enemies_safe", "starting_fertile",
    "temperature", "wobble_large_x", "wobble_large_y", "wobble_x",
    "wobble_y",
}) do
    if not data.raw["noise-expression"]["terrapalus_" .. suffix] then
        data:extend({{type = "noise-expression", name = "terrapalus_" .. suffix, expression = "terra_palus_" .. suffix}})
    end
end
