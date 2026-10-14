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

