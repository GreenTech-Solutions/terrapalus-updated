data:extend({
    -- ===========================================
    -- UV INHIBITOR SETTINGS
    -- ===========================================
    {
        type = "double-setting",
        name = "inhibitor-freeze-duration",
        setting_type = "startup",
        default_value = 120,
        minimum_value = 1,
        maximum_value = 10000,
        order = "a-a"
    },
    {
        type = "double-setting",
        name = "inhibitor-thaw-duration",
        setting_type = "startup",
        default_value = 120,
        minimum_value = 1,
        maximum_value = 10000,
        order = "a-b"
    },
    {
        type = "double-setting",
        name = "inhibitor-radius",
        setting_type = "startup",
        default_value = 18,
        minimum_value = 1,
        maximum_value = 100,
        order = "a-c"
    },
    {
        type = "double-setting",
        name = "inhibitor-lamp-power-multiplier",
        setting_type = "startup",
        default_value = 1.0,
        minimum_value = 0.1,
        maximum_value = 10.0,
        order = "a-d"
    },

    -- ===========================================
    -- SURFACE PROPERTIES
    -- ===========================================
    {
        type = "double-setting",
        name = "surface-temperature",
        setting_type = "startup",
        default_value = 14,
        minimum_value = -20,
        maximum_value = 50,
        order = "b-a"
    },
    {
        type = "double-setting",
        name = "surface-temperature-variance",
        setting_type = "startup",
        default_value = 6,
        minimum_value = 0,
        maximum_value = 30,
        order = "b-b"
    },
    {
        type = "double-setting",
        name = "surface-pressure",
        setting_type = "startup",
        default_value = 2000,
        minimum_value = 1000,
        maximum_value = 4000,
        order = "b-c"
    },
    {
        type = "double-setting",
        name = "surface-gravity",
        setting_type = "startup",
        default_value = 25,
        minimum_value = 1,
        maximum_value = 100,
        order = "b-d"
    },
    {
        type = "double-setting",
        name = "surface-solar-power",
        setting_type = "startup",
        default_value = 100,
        minimum_value = 10,
        maximum_value = 300,
        order = "b-e"
    },
    {
        type = "double-setting",
        name = "surface-magnetic-field",
        setting_type = "startup",
        default_value = 40,
        minimum_value = 0,
        maximum_value = 200,
        order = "b-f"
    },

    -- ===========================================
    -- DAY/NIGHT CYCLE SETTINGS
    -- ===========================================
    {
        type = "bool-setting",
        name = "freeze-daytime",
        setting_type = "startup",
        default_value = true,
        order = "c-a"
    },
    {
        type = "double-setting",
        name = "daytime-value",
        setting_type = "startup",
        default_value = 0.5,
        minimum_value = 0,
        maximum_value = 1,
        order = "c-b"
    },
    {
        type = "double-setting",
        name = "day-night-cycle-minutes",
        setting_type = "startup",
        default_value = 8,
        minimum_value = 1,
        maximum_value = 60,
        order = "c-c"
    },

    -- ===========================================
    -- TERRAIN SCALE SETTINGS
    -- ===========================================
    {
        type = "double-setting",
        name = "terrapalus-elevation-scale",
        setting_type = "startup",
        default_value = 60,
        minimum_value = 10,
        maximum_value = 200,
        order = "d-a"
    },
    {
        type = "double-setting",
        name = "terrapalus-biome-scale",
        setting_type = "startup",
        default_value = 150,
        minimum_value = 50,
        maximum_value = 500,
        order = "d-b"
    },
    {
        type = "double-setting",
        name = "terrapalus-mud-basin-scale",
        setting_type = "startup",
        default_value = 10,
        minimum_value = 5,
        maximum_value = 50,
        order = "d-c"
    },
    {
        type = "int-setting",
        name = "terrapalus-lowland-size",
        setting_type = "startup",
        default_value = 15,
        minimum_value = 5,
        maximum_value = 50,
        order = "d-d"
    },
    {
        type = "double-setting",
        name = "terrapalus-moisture-threshold",
        setting_type = "startup",
        default_value = 25,
        minimum_value = 0.3,
        maximum_value = 50,
        order = "d-e"
    },

    -- ===========================================
    -- STARTING AREA SETTINGS
    -- ===========================================
    {
        type = "double-setting",
        name = "terrapalus-starting-area-multiplier",
        setting_type = "startup",
        default_value = 0.7,
        minimum_value = 0.3,
        maximum_value = 2.0,
        order = "e-a"
    },
    {
        type = "double-setting",
        name = "terrapalus-starting-distance",
        setting_type = "startup",
        default_value = 300,
        minimum_value = 100,
        maximum_value = 1000,
        order = "e-b"
    },
    {
        type = "double-setting",
        name = "terrapalus-starting-radius",
        setting_type = "startup",
        default_value = 140,
        minimum_value = 50,
        maximum_value = 500,
        order = "e-c"
    },
    {
        type = "double-setting",
        name = "terrapalus-starting-fertile-radius",
        setting_type = "startup",
        default_value = 40,
        minimum_value = 10,
        maximum_value = 200,
        order = "e-d"
    },

    -- ===========================================
    -- RESOURCE DISTRIBUTION SETTINGS
    -- ===========================================
    {
        type = "double-setting",
        name = "terrapalus-fertile-soil-frequency",
        setting_type = "startup",
        default_value = 25.4,
        minimum_value = 0.5,
        maximum_value = 50.0,
        order = "f-a"
    },
    {
        type = "double-setting",
        name = "terrapalus-fertile-spot-radius",
        setting_type = "startup",
        default_value = 32,
        minimum_value = 10,
        maximum_value = 100,
        order = "f-b"
    },
    {
        type = "double-setting",
        name = "terrapalus-fertile-spot-spacing",
        setting_type = "startup",
        default_value = 128,
        minimum_value = 50,
        maximum_value = 500,
        order = "f-c"
    },
    {
        type = "double-setting",
        name = "terrapalus-fertile-region-size",
        setting_type = "startup",
        default_value = 1024,
        minimum_value = 200,
        maximum_value = 3000,
        order = "f-d"
    },
    {
        type = "int-setting",
        name = "terrapalus-fertile-candidate-spots",
        setting_type = "startup",
        default_value = 80,
        minimum_value = 20,
        maximum_value = 300,
        order = "f-e"
    },

    -- ===========================================
    -- ENEMY SPAWNING SETTINGS
    -- ===========================================
    {
        type = "double-setting",
        name = "terrapalus-spawner-frequency",
        setting_type = "startup",
        default_value = 0.4,
        minimum_value = 0.1,
        maximum_value = 5.0,
        order = "g-a"
    },
    {
        type = "double-setting",
        name = "terrapalus-spawner-size",
        setting_type = "startup",
        default_value = 0.7,
        minimum_value = 0.1,
        maximum_value = 5.0,
        order = "g-b"
    },
    {
        type = "double-setting",
        name = "terrapalus-small-spawner-frequency",
        setting_type = "startup",
        default_value = 5.6,
        minimum_value = 0.1,
        maximum_value = 20.0,
        order = "g-c"
    },
    {
        type = "double-setting",
        name = "terrapalus-small-spawner-size",
        setting_type = "startup",
        default_value = 1.8,
        minimum_value = 0.1,
        maximum_value = 10.0,
        order = "g-d"
    },
    {
        type = "double-setting",
        name = "terrapalus-enemy-safe-zone-radius",
        setting_type = "startup",
        default_value = 30,
        minimum_value = 10,
        maximum_value = 200,
        order = "g-e"
    },

    -- ===========================================
    -- VISUAL EFFECTS SETTINGS
    -- ===========================================
    {
        type = "double-setting",
        name = "terrapalus-fog-opacity",
        setting_type = "startup",
        default_value = 0.6,
        minimum_value = 0,
        maximum_value = 1.0,
        order = "h-a"
    },
    {
        type = "double-setting",
        name = "terrapalus-fog-color-r",
        setting_type = "startup",
        default_value = 0.5,
        minimum_value = 0,
        maximum_value = 1.0,
        order = "h-b"
    },
    {
        type = "double-setting",
        name = "terrapalus-fog-color-g",
        setting_type = "startup",
        default_value = 0.2,
        minimum_value = 0,
        maximum_value = 1.0,
        order = "h-c"
    },
    {
        type = "double-setting",
        name = "terrapalus-fog-color-b",
        setting_type = "startup",
        default_value = 1.0,
        minimum_value = 0,
        maximum_value = 1.0,
        order = "h-d"
    },
    {
        type = "double-setting",
        name = "terrapalus-cloud-opacity",
        setting_type = "startup",
        default_value = 0.7,
        minimum_value = 0,
        maximum_value = 1.0,
        order = "h-e"
    },
    {
        type = "double-setting",
        name = "terrapalus-cloud-color-r",
        setting_type = "startup",
        default_value = 1.0,
        minimum_value = 0,
        maximum_value = 1.0,
        order = "h-f"
    },
    {
        type = "double-setting",
        name = "terrapalus-cloud-color-g",
        setting_type = "startup",
        default_value = 0.2,
        minimum_value = 0,
        maximum_value = 1.0,
        order = "h-g"
    },
    {
        type = "double-setting",
        name = "terrapalus-cloud-color-b",
        setting_type = "startup",
        default_value = 0.0,
        minimum_value = 0,
        maximum_value = 1.0,
        order = "h-h"
    },
    {
        type = "bool-setting",
        name = "terrapalus-uranium-ore",
        setting_type = "startup",
        default_value = false,
        order = "i-a"
    },
    {
        type = "bool-setting",
        name = "terrapalus-stromatolites",
        setting_type = "startup",
        default_value = false,
        order = "i-b"
    }
})
