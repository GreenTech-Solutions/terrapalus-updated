-- prototypes/equipment.lua
-- UV Equipment for power armor

data:extend({
    -- UV Defense Turret - causes enemies to flee
    {
        type = "active-defense-equipment",
        name = "uv-defense-turret",
        sprite = {
            filename = "__terrapalus-updated__/graphics/equipment/personal-uv-defense-equipment.png",
            width = 128,
            height = 128,
            priority = "medium",
            scale = 0.5
        },
        shape = {
            width = 2,
            height = 2,
            type = "full"
        },
        energy_source = {
            type = "electric",
            usage_priority = "secondary-input",
            buffer_capacity = "500kJ"
        },
        attack_parameters = {
            type = "beam",
            cooldown = 30,
            damage_modifier = 1,
            range = 18,
            ammo_category = "laser",
            ammo_type = {
                energy_consumption = "50kJ",
                action = {
                    type = "direct",
                    action_delivery = {
                        type = "beam",
                        beam = "laser-beam",
                        max_length = 18,
                        duration = 20,
                        source_offset = {0, -1.31439}
                    }
                }
            }
        },
        automatic = true,
        categories = {"armor"}
    },

    -- UV Personal Shield - creates a freeze aura around the player
    {
        type = "energy-shield-equipment",
        name = "uv-personal-shield",
        sprite = {
            filename = "__base__/graphics/equipment/energy-shield-equipment.png",
            width = 128,
            height = 128,
            priority = "medium",
            scale = 0.5,
            tint = {r = 0.7, g = 0.2, b = 1.0, a = 1.0}  -- Purple tint
        },
        shape = {
            width = 2,
            height = 2,
            type = "full"
        },
        energy_source = {
            type = "electric",
            usage_priority = "secondary-input",
            buffer_capacity = "300kJ",
            input_flow_limit = "480kW"
        },
        max_shield_value = 100,
        energy_per_shield = "30kJ",
        categories = {"armor"}
    }
})
