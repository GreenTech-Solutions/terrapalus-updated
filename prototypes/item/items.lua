local item_sounds = require("__base__.prototypes.item_sounds")

-- prototypes/item/items.lua
data:extend({
    {
        type = "item",
        name = "inhibitor-lamp",
        icon = "__terrapalus-updated__/graphics/icons/inhibitor-lamp.png",
        icon_size = 64,
        icon_mipmaps = 4,
        subgroup = "circuit-network",
        order = "a[light]-b[small-lamp]-a",
        inventory_move_sound = item_sounds.electric_small_inventory_move,
        pick_sound = item_sounds.electric_small_inventory_pickup,
        drop_sound = item_sounds.electric_small_inventory_move,
        place_result = "inhibitor-lamp",
        stack_size = 50,
        weight = 20*kg,
        is_military_target = true
    },
    {
        type = "item",
        name = "inhibitor-lamp-mk2",
        icon = "__terrapalus-updated__/graphics/icons/inhibitor-lamp.png",
        icon_size = 64,
        icon_mipmaps = 4,
        subgroup = "circuit-network",
        order = "a[light]-b[small-lamp]-b",
        inventory_move_sound = item_sounds.electric_small_inventory_move,
        pick_sound = item_sounds.electric_small_inventory_pickup,
        drop_sound = item_sounds.electric_small_inventory_move,
        place_result = "inhibitor-lamp-mk2",
        stack_size = 50,
        weight = 25*kg,
        is_military_target = true
    },
    {
        type = "item",
        name = "inhibitor-lamp-mk3",
        icon = "__terrapalus-updated__/graphics/icons/inhibitor-lamp.png",
        icon_size = 64,
        icon_mipmaps = 4,
        subgroup = "circuit-network",
        order = "a[light]-b[small-lamp]-c",
        inventory_move_sound = item_sounds.electric_small_inventory_move,
        pick_sound = item_sounds.electric_small_inventory_pickup,
        drop_sound = item_sounds.electric_small_inventory_move,
        place_result = "inhibitor-lamp-mk3",
        stack_size = 50,
        weight = 30*kg,
        is_military_target = true
    },
    {
        type = "item",
        name = "inhibitor-lamp-damage",
        icon = "__terrapalus-updated__/graphics/icons/inhibitor-lamp.png",
        icon_size = 64,
        icon_mipmaps = 4,
        subgroup = "circuit-network",
        order = "a[light]-b[small-lamp]-d",
        inventory_move_sound = item_sounds.electric_small_inventory_move,
        pick_sound = item_sounds.electric_small_inventory_pickup,
        drop_sound = item_sounds.electric_small_inventory_move,
        place_result = "inhibitor-lamp-damage",
        stack_size = 50,
        weight = 25*kg,
        is_military_target = true
    },
    {
        type = "item",
        name = "palusium-ore",
        icon = "__terrapalus-updated__/graphics/icons/palusium-ore.png", 
        icon_size = 64,
        subgroup = "raw-resource",
        order = "b[palusium-ore]",
        stack_size = 50,
        fuel_category = "chemical",
        fuel_value = "25kJ",
        inventory_move_sound = item_sounds.resource_inventory_move,
        pick_sound = item_sounds.resource_inventory_pickup,
        drop_sound = item_sounds.resource_inventory_move,
        weight = 1*kg
    },
    {
        type = "item",
        name = "palusium-plate",
        icon = "__terrapalus-updated__/graphics/icons/palusium-plate.png",  
        icon_size = 64,
        subgroup = "intermediate-product",
        order = "d[palusium-plate]",
        stack_size = 100,
        weight = 1*kg
    },
    {
        type = "item",
        name = "palusium-powder",
        icon = "__terrapalus-updated__/graphics/icons/palusium-powder.png", 
        icon_size = 64,
        subgroup = "intermediate-product",
        order = "d[palusium-powder]",
        stack_size = 25,
        weight = 0.5*kg
    },
    {
        type = "item",
        name = "palusium-crystal",
        icon = "__terrapalus-updated__/graphics/icons/palusium-crystal.png", 
        icon_size = 64,
        subgroup = "intermediate-product",
        order = "d[palusium-powder]",
        stack_size = 25,
        weight = 2*kg
    },
    {
        type = "item",
        name = "uv-turret",
        icon = "__base__/graphics/icons/laser-turret.png",
        subgroup = "turret",
        order = "b[turret]-b[laser-turret]-a",
        inventory_move_sound = item_sounds.turret_inventory_move,
        pick_sound = item_sounds.turret_inventory_pickup,
        drop_sound = item_sounds.turret_inventory_move,
        place_result = "uv-turret",
        stack_size = 50,
        weight = 40*kg
      },
    {
        type = "item",
        name = "uv-turret-mk2",
        icon = "__base__/graphics/icons/laser-turret.png",
        subgroup = "turret",
        order = "b[turret]-b[laser-turret]-b",
        inventory_move_sound = item_sounds.turret_inventory_move,
        pick_sound = item_sounds.turret_inventory_pickup,
        drop_sound = item_sounds.turret_inventory_move,
        place_result = "uv-turret-mk2",
        stack_size = 50,
        weight = 50*kg
      },
    {
        type = "item",
        name = "uv-turret-mk3",
        icon = "__base__/graphics/icons/laser-turret.png",
        subgroup = "turret",
        order = "b[turret]-b[laser-turret]-c",
        inventory_move_sound = item_sounds.turret_inventory_move,
        pick_sound = item_sounds.turret_inventory_pickup,
        drop_sound = item_sounds.turret_inventory_move,
        place_result = "uv-turret-mk3",
        stack_size = 50,
        weight = 60*kg
      },
    {
        type = "item",
        name = "uv-turret-aoe",
        icon = "__base__/graphics/icons/laser-turret.png",
        subgroup = "turret",
        order = "b[turret]-b[laser-turret]-d",
        inventory_move_sound = item_sounds.turret_inventory_move,
        pick_sound = item_sounds.turret_inventory_pickup,
        drop_sound = item_sounds.turret_inventory_move,
        place_result = "uv-turret-aoe",
        stack_size = 50,
        weight = 50*kg
      },
    {
        type = "item",
        name = "uv-turret-chain",
        icon = "__base__/graphics/icons/laser-turret.png",
        subgroup = "turret",
        order = "b[turret]-b[laser-turret]-e",
        inventory_move_sound = item_sounds.turret_inventory_move,
        pick_sound = item_sounds.turret_inventory_pickup,
        drop_sound = item_sounds.turret_inventory_move,
        place_result = "uv-turret-chain",
        stack_size = 50,
        weight = 50*kg
      },
    {
        type = "item",
        name = "uv-spotlight",
        icon = "__base__/graphics/icons/laser-turret.png",
        subgroup = "turret",
        order = "b[turret]-b[laser-turret]-f",
        inventory_move_sound = item_sounds.turret_inventory_move,
        pick_sound = item_sounds.turret_inventory_pickup,
        drop_sound = item_sounds.turret_inventory_move,
        place_result = "uv-spotlight",
        stack_size = 50,
        weight = 45*kg
      },

    -- {
    --     type = "item",
    --     name = "uv-stabilizer",
    --     icon = "__terrapalus-updated__/graphics/entity/uv-stabilizer/quantum-stabilizer-hr-animation-1.png", -- Set an image as the item icon
    --     icon_size = 64,
    --     subgroup = "production-machine",
    --     order = "b[uv-stabilizer]",
    --     place_result = "uv-stabilizer",
    --     stack_size = 10
    -- }

    -- Ultravium Batteries (consumable capsules for charging power armor)
    {
        type = "capsule",
        name = "ultravium-battery",
        icon = "__terrapalus-updated__/graphics/icons/uv-battery.png",
        icon_size = 64,
        subgroup = "capsule",
        order = "z[ultravium]-a[battery]",
        stack_size = 50,
        weight = 5*kg,
        capsule_action = {
            type = "use-on-self",
            attack_parameters = {
                type = "projectile",
                activation_type = "consume",
                ammo_category = "capsule",
                cooldown = 30,
                range = 0,
                ammo_type = {
                    target_type = "position",
                    action = {
                        type = "direct",
                        action_delivery = {
                            type = "instant",
                            target_effects = {
                                type = "script",
                                effect_id = "ultravium-battery-use"
                            }
                        }
                    }
                }
            }
        }
    },
    {
        type = "capsule",
        name = "ultravium-battery-pack",
        icon = "__terrapalus-updated__/graphics/icons/uv-battery.png",
        icon_size = 64,
        subgroup = "capsule",
        order = "z[ultravium]-b[battery-pack]",
        stack_size = 25,
        weight = 20*kg,
        capsule_action = {
            type = "use-on-self",
            attack_parameters = {
                type = "projectile",
                activation_type = "consume",
                ammo_category = "capsule",
                cooldown = 30,
                range = 0,
                ammo_type = {
                    target_type = "position",
                    action = {
                        type = "direct",
                        action_delivery = {
                            type = "instant",
                            target_effects = {
                                type = "script",
                                effect_id = "ultravium-battery-pack-use"
                            }
                        }
                    }
                }
            }
        }
    },
    {
        type = "capsule",
        name = "ultravium-power-cell",
        icon = "__terrapalus-updated__/graphics/icons/uv-battery.png",
        icon_size = 64,
        subgroup = "capsule",
        order = "z[ultravium]-c[power-cell]",
        stack_size = 10,
        weight = 50*kg,
        capsule_action = {
            type = "use-on-self",
            attack_parameters = {
                type = "projectile",
                activation_type = "consume",
                ammo_category = "capsule",
                cooldown = 30,
                range = 0,
                ammo_type = {
                    target_type = "position",
                    action = {
                        type = "direct",
                        action_delivery = {
                            type = "instant",
                            target_effects = {
                                type = "script",
                                effect_id = "ultravium-power-cell-use"
                            }
                        }
                    }
                }
            }
        }
    },

    -- Armor Charging Stations
    {
        type = "item",
        name = "armor-charging-station",
        icon = "__base__/graphics/icons/substation.png",
        icon_size = 64,
        subgroup = "energy",
        order = "z[armor-charging]-a[station]",
        inventory_move_sound = item_sounds.electric_large_inventory_move,
        pick_sound = item_sounds.electric_large_inventory_pickup,
        drop_sound = item_sounds.electric_large_inventory_move,
        place_result = "armor-charging-station",
        stack_size = 20,
        weight = 50*kg
    },
    {
        type = "item",
        name = "armor-charging-station-mk2",
        icon = "__base__/graphics/icons/substation.png",
        icon_size = 64,
        subgroup = "energy",
        order = "z[armor-charging]-b[station-mk2]",
        inventory_move_sound = item_sounds.electric_large_inventory_move,
        pick_sound = item_sounds.electric_large_inventory_pickup,
        drop_sound = item_sounds.electric_large_inventory_move,
        place_result = "armor-charging-station-mk2",
        stack_size = 20,
        weight = 60*kg
    },
    {
        type = "item",
        name = "armor-charging-station-mk3",
        icon = "__base__/graphics/icons/substation.png",
        icon_size = 64,
        subgroup = "energy",
        order = "z[armor-charging]-c[station-mk3]",
        inventory_move_sound = item_sounds.electric_large_inventory_move,
        pick_sound = item_sounds.electric_large_inventory_pickup,
        drop_sound = item_sounds.electric_large_inventory_move,
        place_result = "armor-charging-station-mk3",
        stack_size = 20,
        weight = 70*kg
    },

    -- UV Equipment for power armor
    {
        type = "item",
        name = "uv-defense-turret",
        icon = "__terrapalus-updated__/graphics/icons/personal-uv-defense.png",
        icon_size = 64,
        subgroup = "military-equipment",
        order = "d[active-defense]-b[uv-defense-turret]",
        inventory_move_sound = item_sounds.electric_small_inventory_move,
        pick_sound = item_sounds.electric_small_inventory_pickup,
        drop_sound = item_sounds.electric_small_inventory_move,
        place_as_equipment_result = "uv-defense-turret",
        stack_size = 20,
        weight = 20*kg
    },
    {
        type = "item",
        name = "uv-personal-shield",
        icon = "__base__/graphics/icons/energy-shield-equipment.png",
        icon_size = 64,
        subgroup = "military-equipment",
        order = "a[shield]-c[uv-personal-shield]",
        inventory_move_sound = item_sounds.electric_small_inventory_move,
        pick_sound = item_sounds.electric_small_inventory_pickup,
        drop_sound = item_sounds.electric_small_inventory_move,
        place_as_equipment_result = "uv-personal-shield",
        stack_size = 20,
        weight = 15*kg
    }
})
