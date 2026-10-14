-- prototypes/recipe/recipes.lua
data:extend({
    {
        type = "recipe",
        name = "inhibitor-lamp",
        enabled = false,
        ingredients = {
            {type = "item", name = "small-lamp", amount = 1},
            {type = "item", name = "electronic-circuit", amount = 2},
            {type = "item", name = "copper-cable", amount = 5},
            {type = "item", name = "palusium-crystal", amount = 100},
            {type = "item", name = "palusium-plate", amount = 50}
        },
        results = {
            {type = "item", name = "inhibitor-lamp", amount = 1}
        }
    },
    {
        type = "recipe",
        name = "inhibitor-lamp-mk2",
        enabled = false,
        energy_required = 10,
        ingredients = {
            {type = "item", name = "inhibitor-lamp", amount = 1},
            {type = "item", name = "advanced-circuit", amount = 5},
            {type = "item", name = "palusium-crystal", amount = 50},
            {type = "item", name = "palusium-plate", amount = 25}
        },
        results = {
            {type = "item", name = "inhibitor-lamp-mk2", amount = 1}
        }
    },
    {
        type = "recipe",
        name = "inhibitor-lamp-mk3",
        enabled = false,
        energy_required = 15,
        ingredients = {
            {type = "item", name = "inhibitor-lamp-mk2", amount = 1},
            {type = "item", name = "processing-unit", amount = 5},
            {type = "item", name = "palusium-crystal", amount = 75},
            {type = "item", name = "palusium-plate", amount = 50}
        },
        results = {
            {type = "item", name = "inhibitor-lamp-mk3", amount = 1}
        }
    },
    {
        type = "recipe",
        name = "inhibitor-lamp-damage",
        enabled = false,
        energy_required = 12,
        ingredients = {
            {type = "item", name = "inhibitor-lamp", amount = 1},
            {type = "item", name = "advanced-circuit", amount = 5},
            {type = "item", name = "palusium-crystal", amount = 75},
            {type = "item", name = "iron-plate", amount = 20}
        },
        results = {
            {type = "item", name = "inhibitor-lamp-damage", amount = 1}
        }
    },
    {
        type = "recipe",
        name = "palusium-processing",
        categories = {"smelting"},
        enabled = false,
        energy_required = 3.2,
        ingredients = {
            {type = "item", name = "palusium-ore", amount = 4}
        },
        results = {
            {type = "item", name = "palusium-plate", amount = 1}
        },
        allow_productivity = true
    },
    {
        type = "recipe",
        name = "palusium-crushing",
        categories = {"crafting"},
        enabled = false,
        energy_required = 2,
        ingredients = {
            {type = "item", name = "palusium-ore", amount = 5}
        },
        results = {
            {type = "item", name = "palusium-powder", amount = 1}
        },
        allow_productivity = true
    },
    {
        type = "recipe",
        name = "palusium-refining",
        categories = {"chemistry"},
        enabled = false,
        energy_required = 15,
        ingredients = {
            {type = "fluid", name = "water", amount = 500},
            {type = "item", name = "palusium-powder", amount = 10}
        },
        results = {
            {type = "item", name = "palusium-crystal", amount = 1}
        },
        allow_productivity = true
    },
    {
        type = "recipe",
        name = "palusium-liquefaction",
        categories = {"chemistry"},
        subgroup = "fluid-recipes",
        order = "c[oil-products]",
        energy_required = 25,
        enabled = false,
        ingredients =
        {
            {type = "fluid", name = "water", amount = 25},
            {type = "fluid", name = "heavy-oil", amount = 25},
            {type = "item", name = "palusium-powder", amount = 10},
          },
        results = {{type = "fluid", name = "ultravium", amount = 50}},
        allow_productivity = true
      },

--     {
--         type = "recipe",
--         name = "uv-stabilizer",
--         enabled = false,
--         ingredients = {
--             {type = "item", name = "iron-plate", amount = 10},
--             {type = "item", name = "electronic-circuit", amount = 5},
--             {type = "item", name = "palusium-plate", amount = 5}
--         },
--         results = {
--             {type = "item", name = "uv-stabilizer", amount = 1}
--     }
-- }

    -- Ultravium Batteries
    {
        type = "recipe",
        name = "ultravium-battery",
        categories = {"chemistry"},
        enabled = false,
        energy_required = 5,
        ingredients = {
            {type = "item", name = "battery", amount = 2},
            {type = "item", name = "iron-plate", amount = 5},
            {type = "fluid", name = "ultravium", amount = 25}
        },
        results = {
            {type = "item", name = "ultravium-battery", amount = 1}
        },
        allow_productivity = true
    },
    {
        type = "recipe",
        name = "ultravium-battery-pack",
        categories = {"crafting"},
        enabled = false,
        energy_required = 10,
        ingredients = {
            {type = "item", name = "ultravium-battery", amount = 5},
            {type = "item", name = "advanced-circuit", amount = 2},
            {type = "item", name = "steel-plate", amount = 5},
            {type = "item", name = "palusium-crystal", amount = 5}
        },
        results = {
            {type = "item", name = "ultravium-battery-pack", amount = 1}
        },
        allow_productivity = true
    },
    {
        type = "recipe",
        name = "ultravium-power-cell",
        categories = {"crafting"},
        enabled = false,
        energy_required = 15,
        ingredients = {
            {type = "item", name = "ultravium-battery-pack", amount = 2},
            {type = "item", name = "processing-unit", amount = 2},
            {type = "item", name = "palusium-crystal", amount = 10}
        },
        results = {
            {type = "item", name = "ultravium-power-cell", amount = 1}
        },
        allow_productivity = true
    },

    -- Armor Charging Stations
    {
        type = "recipe",
        name = "armor-charging-station",
        categories = {"crafting"},
        enabled = false,
        energy_required = 10,
        ingredients = {
            {type = "item", name = "substation", amount = 1},
            {type = "item", name = "electronic-circuit", amount = 10},
            {type = "item", name = "palusium-crystal", amount = 25},
            {type = "item", name = "copper-cable", amount = 20}
        },
        results = {
            {type = "item", name = "armor-charging-station", amount = 1}
        }
    },
    {
        type = "recipe",
        name = "armor-charging-station-mk2",
        categories = {"crafting"},
        enabled = false,
        energy_required = 15,
        ingredients = {
            {type = "item", name = "armor-charging-station", amount = 1},
            {type = "item", name = "advanced-circuit", amount = 10},
            {type = "item", name = "palusium-crystal", amount = 50},
            {type = "item", name = "steel-plate", amount = 20}
        },
        results = {
            {type = "item", name = "armor-charging-station-mk2", amount = 1}
        }
    },
    {
        type = "recipe",
        name = "armor-charging-station-mk3",
        categories = {"crafting"},
        enabled = false,
        energy_required = 20,
        ingredients = {
            {type = "item", name = "armor-charging-station-mk2", amount = 1},
            {type = "item", name = "processing-unit", amount = 10},
            {type = "item", name = "palusium-crystal", amount = 75},
            {type = "item", name = "low-density-structure", amount = 10}
        },
        results = {
            {type = "item", name = "armor-charging-station-mk3", amount = 1}
        }
    },

    -- UV Equipment recipes
    {
        type = "recipe",
        name = "uv-defense-turret",
        categories = {"crafting"},
        enabled = false,
        energy_required = 15,
        ingredients = {
            {type = "item", name = "personal-laser-defense-equipment", amount = 1},
            {type = "item", name = "palusium-crystal", amount = 50},
            {type = "item", name = "advanced-circuit", amount = 10},
            {type = "item", name = "steel-plate", amount = 10}
        },
        results = {
            {type = "item", name = "uv-defense-turret", amount = 1}
        }
    },
    {
        type = "recipe",
        name = "uv-personal-shield",
        categories = {"crafting"},
        enabled = false,
        energy_required = 15,
        ingredients = {
            {type = "item", name = "energy-shield-equipment", amount = 1},
            {type = "item", name = "palusium-crystal", amount = 50},
            {type = "item", name = "advanced-circuit", amount = 10},
            {type = "item", name = "palusium-plate", amount = 20}
        },
        results = {
            {type = "item", name = "uv-personal-shield", amount = 1}
        }
    }

})
