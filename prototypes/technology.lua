data:extend(
{
  {
      type = "technology",
      name = "planet-discovery-terrapalus",
      icons = util.technology_icon_constant_planet("__terrapalus-updated__/graphics/technology/terrapalus.png"),
      icon_size = 256,
      essential = true,
      effects =
      {
        {
          type = "unlock-space-location",
          space_location = "terrapalus",
          use_icon_overlay_constant = true
        }
      },
      prerequisites = {"planet-discovery-gleba"},
      unit =
      {
        count = 500,
        ingredients =
        {
          {"automation-science-pack", 1},
          {"logistic-science-pack", 1},
          {"chemical-science-pack", 1},
          {"space-science-pack", 1}
        },
        time = 60
      }
    },
    {
      type = "technology",
      name = "palusium-processing",
      icon = "__terrapalus-updated__/graphics/technology/palusium-processing.png",
      icon_size = 256,
      prerequisites = {"planet-discovery-terrapalus"},
      effects = {
          {
              type = "unlock-recipe",
              recipe = "palusium-processing"
          }
      },
      unit = {
          count = 150,
          ingredients = {
              {"automation-science-pack", 1},
              {"space-science-pack", 1},
              {"chemical-science-pack", 1},
              {"military-science-pack", 1}
          },
          time = 30
      },
      order = "e-p-b-c"
  },
  {
    type = "technology",
    name = "palusium-crushing",
    icon = "__terrapalus-updated__/graphics/technology/palusium-crushing.png",
    icon_size = 256,
    prerequisites = {"planet-discovery-terrapalus"},
    effects = {
        {
            type = "unlock-recipe",
            recipe = "palusium-crushing"
        }
    },
    unit = {
        count = 150,
        ingredients = {
            {"automation-science-pack", 1},
            {"space-science-pack", 1},
            {"chemical-science-pack", 1},
            {"military-science-pack", 1}
        },
        time = 30
    },
    order = "e-p-b-c"
},
{
  type = "technology",
  name = "palusium-liquefaction",
  icon = "__terrapalus-updated__/graphics/technology/palusium-liquefaction.png",  -- Placeholder icon
  icon_size = 256,
  prerequisites = {"palusium-crushing"},
  effects = {
      {
          type = "unlock-recipe",
          recipe = "palusium-liquefaction"
      }
  },
  unit = {
      count = 150,
      ingredients = {
          {"automation-science-pack", 1},
          {"space-science-pack", 1},
          {"chemical-science-pack", 1},
          {"military-science-pack", 1}
      },
      time = 30
  },
  order = "e-p-b-c"
},
{
  type = "technology",
  name = "palusium-refining",
  icon = "__terrapalus-updated__/graphics/technology/palusium-refining.png",  -- Placeholder icon
  icon_size = 256,
  prerequisites = {"palusium-crushing"},
  effects = {
      {
          type = "unlock-recipe",
          recipe = "palusium-refining"
      }
  },
  unit = {
      count = 150,
      ingredients = {
          {"automation-science-pack", 1},
          {"space-science-pack", 1},
          {"chemical-science-pack", 1},
          {"military-science-pack", 1}
      },
      time = 30
  },
  order = "e-p-b-c"
},
{
  type = "technology",
  name = "inhibitor-lamp",
  icon = "__terrapalus-updated__/graphics/technology/inhibitor-lamp.png",
  icon_size = 256,
  prerequisites = {"palusium-refining","palusium-processing"},
  effects = {
      {
          type = "unlock-recipe",
          recipe = "inhibitor-lamp"
      }
  },
  unit = {
      count = 150,
      ingredients = {
          {"automation-science-pack", 1},
          {"space-science-pack", 1},
          {"chemical-science-pack", 1},
          {"military-science-pack", 1}
      },
      time = 30
  },
  order = "e-p-b-c"
},
{
  type = "technology",
  name = "inhibitor-lamp-mk2",
  icon = "__terrapalus-updated__/graphics/technology/inhibitor-lamp.png",
  icon_size = 256,
  prerequisites = {"inhibitor-lamp", "production-science-pack"},
  effects = {
      {
          type = "unlock-recipe",
          recipe = "inhibitor-lamp-mk2"
      }
  },
  unit = {
      count = 200,
      ingredients = {
          {"automation-science-pack", 1},
          {"logistic-science-pack", 1},
          {"chemical-science-pack", 1},
          {"military-science-pack", 1},
          {"production-science-pack", 1}
      },
      time = 45
  },
  order = "e-p-b-d"
},
{
  type = "technology",
  name = "inhibitor-lamp-mk3",
  icon = "__terrapalus-updated__/graphics/technology/inhibitor-lamp.png",
  icon_size = 256,
  prerequisites = {"inhibitor-lamp-mk2", "utility-science-pack"},
  effects = {
      {
          type = "unlock-recipe",
          recipe = "inhibitor-lamp-mk3"
      }
  },
  unit = {
      count = 300,
      ingredients = {
          {"automation-science-pack", 1},
          {"logistic-science-pack", 1},
          {"chemical-science-pack", 1},
          {"military-science-pack", 1},
          {"production-science-pack", 1},
          {"utility-science-pack", 1}
      },
      time = 60
  },
  order = "e-p-b-e"
},
{
  type = "technology",
  name = "inhibitor-lamp-damage",
  icon = "__terrapalus-updated__/graphics/technology/inhibitor-lamp.png",
  icon_size = 256,
  prerequisites = {"inhibitor-lamp", "production-science-pack"},
  effects = {
      {
          type = "unlock-recipe",
          recipe = "inhibitor-lamp-damage"
      }
  },
  unit = {
      count = 200,
      ingredients = {
          {"automation-science-pack", 1},
          {"logistic-science-pack", 1},
          {"chemical-science-pack", 1},
          {"military-science-pack", 1},
          {"production-science-pack", 1}
      },
      time = 45
  },
  order = "e-p-b-f"
},
{
    type = "technology",
    name = "uv-turret",
    icon_size = 256,
    icon_mipmaps = 4,
    icon = "__base__/graphics/technology/laser-turret.png", -- need to create a custom icon
    effects = {
      {
        type = "unlock-recipe",
        recipe = "uv-turret"
      }
    },
    prerequisites = {
      "laser-turret",
      "inhibitor-lamp",
      "chemical-science-pack",

    },
    unit = {
      count = 150,
      ingredients = {
        {"automation-science-pack", 1},
        {"logistic-science-pack", 1},
        {"military-science-pack", 1},
        {"chemical-science-pack", 1}
      },
      time = 30
    },
    order = "a-j-b"
  },
{
    type = "technology",
    name = "uv-turret-mk2",
    icon_size = 256,
    icon_mipmaps = 4,
    icon = "__base__/graphics/technology/laser-turret.png",
    effects = {
      {
        type = "unlock-recipe",
        recipe = "uv-turret-mk2"
      }
    },
    prerequisites = {
      "uv-turret",
      "production-science-pack"
    },
    unit = {
      count = 200,
      ingredients = {
        {"automation-science-pack", 1},
        {"logistic-science-pack", 1},
        {"military-science-pack", 1},
        {"chemical-science-pack", 1},
        {"production-science-pack", 1}
      },
      time = 45
    },
    order = "a-j-c"
  },
{
    type = "technology",
    name = "uv-turret-mk3",
    icon_size = 256,
    icon_mipmaps = 4,
    icon = "__base__/graphics/technology/laser-turret.png",
    effects = {
      {
        type = "unlock-recipe",
        recipe = "uv-turret-mk3"
      }
    },
    prerequisites = {
      "uv-turret-mk2",
      "utility-science-pack"
    },
    unit = {
      count = 300,
      ingredients = {
        {"automation-science-pack", 1},
        {"logistic-science-pack", 1},
        {"military-science-pack", 1},
        {"chemical-science-pack", 1},
        {"production-science-pack", 1},
        {"utility-science-pack", 1}
      },
      time = 60
    },
    order = "a-j-d"
  },
{
    type = "technology",
    name = "uv-turret-aoe",
    icon_size = 256,
    icon_mipmaps = 4,
    icon = "__base__/graphics/technology/laser-turret.png",
    effects = {
      {
        type = "unlock-recipe",
        recipe = "uv-turret-aoe"
      }
    },
    prerequisites = {
      "uv-turret",
      "production-science-pack"
    },
    unit = {
      count = 250,
      ingredients = {
        {"automation-science-pack", 1},
        {"logistic-science-pack", 1},
        {"military-science-pack", 1},
        {"chemical-science-pack", 1},
        {"production-science-pack", 1}
      },
      time = 45
    },
    order = "a-j-e"
  },
{
    type = "technology",
    name = "uv-turret-chain",
    icon_size = 256,
    icon_mipmaps = 4,
    icon = "__base__/graphics/technology/laser-turret.png",
    effects = {
      {
        type = "unlock-recipe",
        recipe = "uv-turret-chain"
      }
    },
    prerequisites = {
      "uv-turret",
      "production-science-pack"
    },
    unit = {
      count = 250,
      ingredients = {
        {"automation-science-pack", 1},
        {"logistic-science-pack", 1},
        {"military-science-pack", 1},
        {"chemical-science-pack", 1},
        {"production-science-pack", 1}
      },
      time = 45
    },
    order = "a-j-f"
  },
{
    type = "technology",
    name = "uv-spotlight",
    icon_size = 256,
    icon_mipmaps = 4,
    icon = "__base__/graphics/technology/laser-turret.png",
    effects = {
      {
        type = "unlock-recipe",
        recipe = "uv-spotlight"
      }
    },
    prerequisites = {
      "inhibitor-lamp",
      "laser-turret"
    },
    unit = {
      count = 200,
      ingredients = {
        {"automation-science-pack", 1},
        {"logistic-science-pack", 1},
        {"military-science-pack", 1},
        {"chemical-science-pack", 1}
      },
      time = 30
    },
    order = "a-j-g"
  },
-- {
--   type = "technology",
--   name = "uv-stabilizer",
--   icon = "__base__/graphics/technology/nuclear-power.png",  -- Placeholder icon
--   icon_size = 256,
--   prerequisites = {"palusium-processing"},
--   effects = {
--       {
--           type = "unlock-recipe",
--           recipe = "uv-stabilizer"
--       }
--   },
--   unit = {
--       count = 150,
--       ingredients = {
--           {"automation-science-pack", 1},
--           {"space-science-pack", 1},
--           {"chemical-science-pack", 1},
--           {"military-science-pack", 1}
--       },
--       time = 30
--   },
--   order = "e-p-b-c"
-- }

-- Ultravium Power Systems (Tier 1)
{
  type = "technology",
  name = "ultravium-power-systems",
  icon = "__terrapalus-updated__/graphics/technology/uv-battery.png",
  icon_size = 256,
  prerequisites = {"palusium-liquefaction"},
  effects = {
      {
          type = "unlock-recipe",
          recipe = "ultravium-battery"
      },
      {
          type = "unlock-recipe",
          recipe = "armor-charging-station"
      }
  },
  unit = {
      count = 150,
      ingredients = {
          {"automation-science-pack", 1},
          {"logistic-science-pack", 1},
          {"chemical-science-pack", 1},
          {"space-science-pack", 1}
      },
      time = 30
  },
  order = "e-p-c-a"
},

-- Ultravium Power Systems 2 (Tier 2)
{
  type = "technology",
  name = "ultravium-power-systems-2",
  icon = "__terrapalus-updated__/graphics/technology/uv-battery.png",
  icon_size = 256,
  prerequisites = {"ultravium-power-systems", "production-science-pack"},
  effects = {
      {
          type = "unlock-recipe",
          recipe = "ultravium-battery-pack"
      },
      {
          type = "unlock-recipe",
          recipe = "armor-charging-station-mk2"
      }
  },
  unit = {
      count = 200,
      ingredients = {
          {"automation-science-pack", 1},
          {"logistic-science-pack", 1},
          {"chemical-science-pack", 1},
          {"space-science-pack", 1},
          {"production-science-pack", 1}
      },
      time = 45
  },
  order = "e-p-c-b"
},

-- Ultravium Power Systems 3 (Tier 3)
{
  type = "technology",
  name = "ultravium-power-systems-3",
  icon = "__terrapalus-updated__/graphics/technology/uv-battery.png",
  icon_size = 256,
  prerequisites = {"ultravium-power-systems-2", "utility-science-pack"},
  effects = {
      {
          type = "unlock-recipe",
          recipe = "ultravium-power-cell"
      },
      {
          type = "unlock-recipe",
          recipe = "armor-charging-station-mk3"
      }
  },
  unit = {
      count = 300,
      ingredients = {
          {"automation-science-pack", 1},
          {"logistic-science-pack", 1},
          {"chemical-science-pack", 1},
          {"space-science-pack", 1},
          {"production-science-pack", 1},
          {"utility-science-pack", 1}
      },
      time = 60
  },
  order = "e-p-c-c"
},

-- UV Personal Equipment
{
  type = "technology",
  name = "uv-personal-equipment",
  icon = "__terrapalus-updated__/graphics/technology/personal-uv-defense.png",
  icon_size = 256,
  prerequisites = {"inhibitor-lamp", "personal-laser-defense-equipment", "energy-shield-equipment"},
  effects = {
      {
          type = "unlock-recipe",
          recipe = "uv-defense-turret"
      },
      {
          type = "unlock-recipe",
          recipe = "uv-personal-shield"
      }
  },
  unit = {
      count = 200,
      ingredients = {
          {"automation-science-pack", 1},
          {"logistic-science-pack", 1},
          {"chemical-science-pack", 1},
          {"military-science-pack", 1},
          {"space-science-pack", 1}
      },
      time = 45
  },
  order = "e-p-d-a"
}

})