local MapGen = {}

-- Load all settings
local lowland_size = settings.startup["terrapalus-lowland-size"].value
local moisture_threshold = settings.startup["terrapalus-moisture-threshold"].value
local soil_frequency = settings.startup["terrapalus-fertile-soil-frequency"].value

-- Terrain scale settings
local elevation_scale = settings.startup["terrapalus-elevation-scale"].value
local biome_scale = settings.startup["terrapalus-biome-scale"].value
local mud_basin_scale = settings.startup["terrapalus-mud-basin-scale"].value

-- Temperature settings
local base_temperature = settings.startup["surface-temperature"].value
local temperature_variance = settings.startup["surface-temperature-variance"].value

-- Starting area settings
local starting_area_multiplier = settings.startup["terrapalus-starting-area-multiplier"].value
local starting_distance = settings.startup["terrapalus-starting-distance"].value
local starting_radius = settings.startup["terrapalus-starting-radius"].value
local starting_fertile_radius = settings.startup["terrapalus-starting-fertile-radius"].value

-- Resource distribution settings
local fertile_spot_radius = settings.startup["terrapalus-fertile-spot-radius"].value
local fertile_spot_spacing = settings.startup["terrapalus-fertile-spot-spacing"].value
local fertile_region_size = settings.startup["terrapalus-fertile-region-size"].value
local fertile_candidate_spots = settings.startup["terrapalus-fertile-candidate-spots"].value

-- Enemy spawning settings
local spawner_frequency = settings.startup["terrapalus-spawner-frequency"].value
local spawner_size = settings.startup["terrapalus-spawner-size"].value
local small_spawner_frequency = settings.startup["terrapalus-small-spawner-frequency"].value
local small_spawner_size = settings.startup["terrapalus-small-spawner-size"].value
-- The spawner settings scale the spawners' probability relative to their defaults, so the defaults generate as before
local spawner_factor = (spawner_frequency / 0.4) * (spawner_size / 0.7)
local small_spawner_factor = (small_spawner_frequency / 5.6) * (small_spawner_size / 1.8)
local enemy_safe_zone_radius = settings.startup["terrapalus-enemy-safe-zone-radius"].value


data:extend({
    -- First define constant noise expressions for the settings
    {
        type = "noise-expression",
        name = "terrapalus_lowland_size_setting",
        expression = tostring(lowland_size)
    },
    {
        type = "noise-expression",
        name = "terrapalus_moisture_threshold_setting",
        expression = tostring(moisture_threshold)
    },
    {
        type = "noise-expression",
        name = "terrapalus_soil_frequency_setting",
        expression = tostring(soil_frequency)
    },
    {
        type = "noise-expression",
        name = "terrapalus_elevation_scale_setting",
        expression = tostring(elevation_scale)
    },
    {
        type = "noise-expression",
        name = "terrapalus_biome_scale_setting",
        expression = tostring(biome_scale)
    },
    {
        type = "noise-expression",
        name = "terrapalus_mud_basin_scale_setting",
        expression = tostring(mud_basin_scale)
    },
    {
        type = "noise-expression",
        name = "terrapalus_base_temperature_setting",
        expression = tostring(base_temperature)
    },
    {
        type = "noise-expression",
        name = "terrapalus_temperature_variance_setting",
        expression = tostring(temperature_variance)
    },
    {
        type = "noise-expression",
        name = "terrapalus_starting_distance_setting",
        expression = tostring(starting_distance)
    },
    {
        type = "noise-expression",
        name = "terrapalus_starting_radius_setting",
        expression = tostring(starting_radius)
    },
    {
        type = "noise-expression",
        name = "terrapalus_starting_fertile_radius_setting",
        expression = tostring(starting_fertile_radius)
    },
    {
        type = "noise-expression",
        name = "terrapalus_fertile_spot_radius_setting",
        expression = tostring(fertile_spot_radius)
    },
    {
        type = "noise-expression",
        name = "terrapalus_fertile_spot_spacing_setting",
        expression = tostring(fertile_spot_spacing)
    },
    {
        type = "noise-expression",
        name = "terrapalus_fertile_region_size_setting",
        expression = tostring(fertile_region_size)
    },
    {
        type = "noise-expression",
        name = "terrapalus_fertile_candidate_spots_setting",
        expression = tostring(fertile_candidate_spots)
    },
    {
        type = "noise-expression",
        name = "terrapalus_enemy_safe_zone_radius_setting",
        expression = tostring(enemy_safe_zone_radius)
    }
})



data:extend({
    {
        type = "noise-expression",
        name = "terrapalus_fertile_spots",
        expression = "spot_noise{\z
            x = x + wobble_noise_x * 15,\z
            y = y + wobble_noise_y * 15,\z
            seed0 = map_seed,\z
            seed1 = 1,\z
            candidate_spot_count = " .. fertile_candidate_spots .. ",\z
            suggested_minimum_candidate_point_spacing = " .. fertile_spot_spacing .. ",\z
            skip_span = 1,\z
            skip_offset = 0,\z
            region_size = " .. fertile_region_size .. ",\z
            density_expression = " .. fertile_candidate_spots .. ",\z
            spot_quantity_expression = 1000,\z
            spot_radius_expression = " .. fertile_spot_radius .. ",\z
            hard_region_target_quantity = 0,\z
            spot_favorability_expression = 60,\z
            basement_value = -0.5,\z
            maximum_spot_basement_radius = " .. (fertile_spot_spacing) .. "}",
        local_expressions = {
            wobble_noise_x = "multioctave_noise{x = x, y = y, persistence = 0.5, seed0 = map_seed, seed1 = 3000000, octaves = 2, input_scale = 1/20}",
            wobble_noise_y = "multioctave_noise{x = x, y = y, persistence = 0.5, seed0 = map_seed, seed1 = 4000000, octaves = 2, input_scale = 1/20}"
        }
    },
    {
        type = "noise-expression",
        name = "terrapalus_starting_direction",
        expression = "-1 + 2 * (map_seed_small & 1)"
    },
    {
        type = "noise-expression",
        name = "terrapalus_wobble_small_x",
        expression = "multioctave_noise{x = x, y = y, persistence = 0.7, seed0 = map_seed, seed1 = 2000, octaves = 2, input_scale = 1/6}"
    },
    {
        type = "noise-expression",
        name = "terrapalus_wobble_small_y",
        expression = "multioctave_noise{x = x, y = y, persistence = 0.7, seed0 = map_seed, seed1 = 3000, octaves = 2, input_scale = 1/6}"
    },
    {
        type = "noise-expression",
        name = "terra_palus_starting_angle",
        expression = "map_seed_normalized * 3600"
    },
    {
        type = "noise-expression",
        name = "terrapalus_fertile_random",
        expression = "max(\z
            spot_noise{\z
                x = x + wobble_noise_x * 15,\z
                y = y + wobble_noise_y * 15,\z
                seed0 = map_seed,\z
                seed1 = 1,\z
                candidate_spot_count = " .. math.floor(fertile_candidate_spots * 2.5) .. ",\z
                suggested_minimum_candidate_point_spacing = " .. math.floor(fertile_spot_spacing * 1.17) .. ",\z
                skip_span = 1,\z
                skip_offset = 0,\z
                region_size = " .. math.floor(fertile_region_size * 0.59) .. ",\z
                density_expression = " .. math.floor(fertile_candidate_spots * 2.5) .. ",\z
                spot_quantity_expression = 3000,\z
                spot_radius_expression = " .. math.floor(fertile_spot_radius * 1.56) .. ",\z
                hard_region_target_quantity = 0,\z
                spot_favorability_expression = 1,\z
                basement_value = -0.5,\z
                maximum_spot_basement_radius = " .. math.floor(fertile_spot_spacing * 1.17) .. "\z
            },\z
            spot_noise{\z
                x = x + wobble_noise_x * 20,\z
                y = y + wobble_noise_y * 20,\z
                seed0 = map_seed,\z
                seed1 = 2,\z
                candidate_spot_count = " .. math.floor(fertile_candidate_spots * 1.875) .. ",\z
                suggested_minimum_candidate_point_spacing = " .. math.floor(fertile_spot_spacing * 1.56) .. ",\z
                skip_span = 1,\z
                skip_offset = 0,\z
                region_size = " .. math.floor(fertile_region_size * 0.78) .. ",\z
                density_expression = " .. math.floor(fertile_candidate_spots * 1.875) .. ",\z
                spot_quantity_expression = 4000,\z
                spot_radius_expression = " .. math.floor(fertile_spot_radius * 2.5) .. ",\z
                hard_region_target_quantity = 0,\z
                spot_favorability_expression = 1,\z
                basement_value = -0.5,\z
                maximum_spot_basement_radius = " .. math.floor(fertile_spot_spacing * 1.56) .. "\z
            },\z
            spot_noise{\z
                x = x + wobble_noise_x * 10,\z
                y = y + wobble_noise_y * 10,\z
                seed0 = map_seed,\z
                seed1 = 3,\z
                candidate_spot_count = " .. math.floor(fertile_candidate_spots * 3.75) .. ",\z
                suggested_minimum_candidate_point_spacing = " .. math.floor(fertile_spot_spacing * 0.78) .. ",\z
                skip_span = 1,\z
                skip_offset = 0,\z
                region_size = " .. math.floor(fertile_region_size * 0.39) .. ",\z
                density_expression = " .. math.floor(fertile_candidate_spots * 3.125) .. ",\z
                spot_quantity_expression = 2000,\z
                spot_radius_expression = " .. math.floor(fertile_spot_radius * 0.94) .. ",\z
                hard_region_target_quantity = 0,\z
                spot_favorability_expression = 1,\z
                basement_value = -0.5,\z
                maximum_spot_basement_radius = " .. math.floor(fertile_spot_spacing * 0.78) .. "\z
            }\z
        )",
        local_expressions = {
            wobble_noise_x = "multioctave_noise{x = x, y = y, persistence = 0.5, seed0 = map_seed, seed1 = 3000000, octaves = 2, input_scale = 1/20}",
            wobble_noise_y = "multioctave_noise{x = x, y = y, persistence = 0.5, seed0 = map_seed, seed1 = 4000000, octaves = 2, input_scale = 1/20}"
        }
    },
    {
        type = "noise-expression",
        name = "terrapalus_fertile_soil",
        expression = "max(terrapalus_fertile_guaranteed, \z
                        terrapalus_fertile_random) * \z
                     gleba_select(terra_palus_elevation, 2, 40, 1, 0, 1) * \z
                     gleba_select(terra_palus_moisture, 0.4, 0.8, 0.1, 0, 1)"
    },
    {
        type = "noise-expression",
        name = "terrapalus_lowland",
        expression = "gleba_select(terra_palus_elevation, 2, terrapalus_lowland_size_setting, 0.5, 0, 1)"
    },
    {
        type = "noise-expression",
        name = "terrapalus_lowland_aux_1",
        expression = "terrapalus_lowland * terrapalus_select(terra_palus_aux, 0, 0.3, 0.005, 0, 1)"
    },
    {
        type = "noise-expression",
        name = "terrapalus_lowland_aux_2",
        expression = "terrapalus_lowland * terrapalus_select(terra_palus_aux, 0.3, 0.7, 0.005, 0, 1)"
    },
    {
        type = "noise-expression",
        name = "terrapalus_lowland_aux_3",
        expression = "terrapalus_lowland * terrapalus_select(terra_palus_aux, 0.7, 1, 0.005, 0, 1)"
    },
    -- Add the select function if you don't have it
    {
        type = "noise-function",
        name = "terrapalus_select",
        parameters = {"input", "from", "to", "slope", "min", "max"},
        expression = "clamp(min(input - (from - slope), to + slope - input) / slope, min, max)"
    },
    {
        type = "noise-expression",
        name = "terrapalus_yumako_spots",
        expression = "spot_noise{\z
            x = x + wobble_noise_x * 15,\z
            y = y + wobble_noise_y * 15,\z
            seed0 = map_seed,\z
            seed1 = 2,\z
            candidate_spot_count = " .. fertile_candidate_spots .. ",\z
            suggested_minimum_candidate_point_spacing = " .. fertile_spot_spacing .. ",\z
            skip_span = 1,\z
            skip_offset = 0,\z
            region_size = " .. fertile_region_size .. ",\z
            density_expression = " .. fertile_candidate_spots .. ",\z
            spot_quantity_expression = 1000,\z
            spot_radius_expression = " .. math.floor(fertile_spot_radius * 1.5) .. ",\z
            hard_region_target_quantity = 0,\z
            spot_favorability_expression = 60,\z
            basement_value = -0.5,\z
            maximum_spot_basement_radius = " .. fertile_spot_spacing .. "}",
        local_expressions = {
            wobble_noise_x = "multioctave_noise{x = x, y = y, persistence = 0.5, seed0 = map_seed, seed1 = 5000000, octaves = 2, input_scale = 1/20}",
            wobble_noise_y = "multioctave_noise{x = x, y = y, persistence = 0.5, seed0 = map_seed, seed1 = 6000000, octaves = 2, input_scale = 1/20}"
        }
    },
    {
        type = "noise-expression",
        name = "terrapalus_jellynut_spots",
        expression = "spot_noise{\z
            x = x + wobble_noise_x * 15,\z
            y = y + wobble_noise_y * 15,\z
            seed0 = map_seed,\z
            seed1 = 3,\z
            candidate_spot_count = " .. fertile_candidate_spots .. ",\z
            suggested_minimum_candidate_point_spacing = " .. fertile_spot_spacing .. ",\z
            skip_span = 1,\z
            skip_offset = 0,\z
            region_size = " .. fertile_region_size .. ",\z
            density_expression = " .. fertile_candidate_spots .. ",\z
            spot_quantity_expression = 1000,\z
            spot_radius_expression = " .. math.floor(fertile_spot_radius * 1.5) .. ",\z
            hard_region_target_quantity = 0,\z
            spot_favorability_expression = 60,\z
            basement_value = -0.5,\z
            maximum_spot_basement_radius = " .. fertile_spot_spacing .. "}",
        local_expressions = {
            wobble_noise_x = "multioctave_noise{x = x, y = y, persistence = 0.5, seed0 = map_seed, seed1 = 7000000, octaves = 2, input_scale = 1/20}",
            wobble_noise_y = "multioctave_noise{x = x, y = y, persistence = 0.5, seed0 = map_seed, seed1 = 8000000, octaves = 2, input_scale = 1/20}"
        }
    },
    {
        type = "noise-expression",
        name = "terra_palus_fertile_spots_coastal_raw",
        expression = "spot_noise{x = x + wobble_noise_x * 15,\z
                                y = y + wobble_noise_y * 15,\z
                                seed0 = map_seed,\z
                                seed1 = 1,\z
                                candidate_spot_count = " .. fertile_candidate_spots .. ",\z
                                suggested_minimum_candidate_point_spacing = " .. fertile_spot_spacing .. ",\z
                                skip_span = 1,\z
                                skip_offset = 0,\z
                                region_size = " .. fertile_region_size .. ",\z
                                density_expression = " .. fertile_candidate_spots .. ",\z
                                spot_quantity_expression = 1000,\z
                                spot_radius_expression = " .. fertile_spot_radius .. ",\z
                                hard_region_target_quantity = 0,\z
                                spot_favorability_expression = 60,\z
                                basement_value = -0.5,\z
                                maximum_spot_basement_radius = " .. fertile_spot_spacing .. "}",
        local_expressions = {
            wobble_noise_x = "multioctave_noise{x = x, y = y, persistence = 0.5, seed0 = map_seed, seed1 = 3000000, octaves = 2, input_scale = 1/20}",
            wobble_noise_y = "multioctave_noise{x = x, y = y, persistence = 0.5, seed0 = map_seed, seed1 = 4000000, octaves = 2, input_scale = 1/20}"
        }
    },
    {
        type = "noise-expression",
        name = "terrapalus_starting_lowlands",
        expression = "max(starting_lowland_yumako, starting_lowland_jellynut)",
        local_expressions = {
            starting_lowland_yumako = "spot_at_angle{angle = terra_palus_starting_angle + 235 * terrapalus_starting_direction,\z
                                               distance = " .. starting_distance .. " * terra_palus_starting_area_multiplier,\z
                                               radius = " .. starting_radius .. " * terra_palus_starting_area_multiplier,\z
                                               x_distortion = terra_palus_wobble_x * 15,\z
                                               y_distortion = terra_palus_wobble_x * 15}",
            starting_lowland_jellynut = "spot_at_angle{angle = terra_palus_starting_angle + 65 * terrapalus_starting_direction,\z
                                                 distance = " .. starting_distance .. " * terra_palus_starting_area_multiplier,\z
                                                 radius = " .. starting_radius .. " * terra_palus_starting_area_multiplier,\z
                                                 x_distortion = terra_palus_wobble_x * 15,\z
                                                 y_distortion = terra_palus_wobble_x * 15}"
        }
    },
    {
        type = "noise-expression",
        name = "terra_palus_starting_fertile",
        expression = "max(starting_lowland_yumako, starting_lowland_jellynut)",
        local_expressions = {
            starting_lowland_yumako = "spot_at_angle{angle = terra_palus_starting_angle + 235 * terrapalus_starting_direction,\z
                                               distance = " .. (starting_distance + 10) .. " * terra_palus_starting_area_multiplier,\z
                                               radius = " .. starting_fertile_radius .. " * terra_palus_starting_area_multiplier,\z
                                               x_distortion = terra_palus_wobble_x * 15,\z
                                               y_distortion = terra_palus_wobble_x * 15}",
            starting_lowland_jellynut = "spot_at_angle{angle = terra_palus_starting_angle + 65 * terrapalus_starting_direction,\z
                                                 distance = " .. (starting_distance + 10) .. " * terra_palus_starting_area_multiplier,\z
                                                 radius = " .. starting_fertile_radius .. " * terra_palus_starting_area_multiplier,\z
                                                 x_distortion = terra_palus_wobble_x * 15,\z
                                                 y_distortion = terra_palus_wobble_x * 15}"
        }
    },
       -- Autoplace controls for enemies spawners
    {
        type = "autoplace-control",
        name = "gleba-spawner",
        richness = true,
        order = "b[enemy]-c[gleba-spawner]",
        category = "enemy"
    },
    {
        type = "autoplace-control",
        name = "gleba-spawner-small",
        richness = true,
        order = "b[enemy]-d[gleba-spawner-small]",
        category = "enemy"
    },
    -- Basic control expressions
    {
        type = "noise-expression",
        name = "terra_palus_segmentation_multiplier",
        expression = 1
    },
    -- Basic terrain noise for mixing biomes
    {
        type = "noise-expression",
        name = "terra_palus_biome_mix",
        expression = "clamp(multioctave_noise{x = x, y = y, persistence = 0.7, seed0 = map_seed, seed1 = 1, octaves = 3, input_scale = 1/" .. biome_scale .. "}, 0, 1)"
    },
    -- Moisture based on Gleba's implementation
    {
        type = "noise-expression",
        name = "terra_palus_moisture",
        expression = "clamp(1.2 - min(0.2 + (terra_palus_elevation / 100), 0.4 + (terra_palus_elevation - 15) / 300), 0, 1)"
    },
    -- Elevation mixing Nauvis and Gleba patterns
    {
        type = "noise-expression",
        name = "terra_palus_elevation",
        expression = "lerp(nauvis_style, gleba_style, terra_palus_biome_mix)",
        local_expressions = {
            nauvis_style = "80 + 40 * basic_noise",
            gleba_style = "clamp(elevation_value * 0.4 + mud_noise, -1.0, 15.9) + 0.2 * mud_noise",
            basic_noise = "multioctave_noise{x = x, y = y, persistence = 0.7, seed0 = map_seed, seed1 = 1000000, octaves = 3, input_scale = 1/" .. elevation_scale .. "}",
            elevation_value = "100",
            mud_noise = "-6 + 12 * terrapalus_mud_basins"
        }
    },
    -- From Gleba's implementation, under an own name: the vanilla gleba_mud_basins shapes Gleba itself
    {
        type = "noise-expression",
        name = "terrapalus_mud_basins",
        expression = "1 - abs(multioctave_noise{x = x, y = y, persistence = 0.7, seed0 = map_seed, seed1 = 1000000, octaves = 3, input_scale = 1/" .. mud_basin_scale .. "})"
    },
    {
        type = "noise-expression",
        name = "terra_palus_aux",
        expression = "clamp(0.5 + basic_noise, 0, 1)",
        local_expressions = {
            basic_noise = "multioctave_noise{x = x, y = y, persistence = 0.7, seed0 = map_seed, seed1 = 1, octaves = 3, input_scale = 1/" .. elevation_scale .. "}"
        }
    },
    {
        type = "noise-expression",
        name = "terra_palus_temperature",
        expression = base_temperature .. " + " .. temperature_variance .. " * basic_noise",
        local_expressions = {
            basic_noise = "multioctave_noise{x = x, y = y, persistence = 0.7, seed0 = map_seed, seed1 = 2, octaves = 3, input_scale = 1/" .. elevation_scale .. "}"
        }
    },
        -- Add starting enemies safe zone expression
        {
            type = "noise-expression",
            name = "terra_palus_starting_enemies_safe",
            expression = "spot_at_angle{angle = terra_palus_starting_angle + 40,\z
                                      distance = " .. math.floor(starting_distance * 0.7) .. " * terra_palus_starting_area_multiplier,\z
                                      radius = " .. enemy_safe_zone_radius .. " * terra_palus_starting_area_multiplier,\z
                                      x_distortion = 0.1 * terra_palus_starting_area_multiplier * (terra_palus_wobble_x + terra_palus_wobble_large_x),\z
                                      y_distortion = 0.1 * terra_palus_starting_area_multiplier * (terra_palus_wobble_y + terra_palus_wobble_large_y)}"
        },
        {
            type = "noise-expression",
            name = "terra_palus_starting_angle",
            expression = "map_seed_normalized * 3600"
        },
        {
            type = "noise-expression",
            name = "terra_palus_wobble_x",
            expression = "multioctave_noise{x = x, y = y, persistence = 0.7, seed0 = map_seed, seed1 = 10, octaves = 2, input_scale = 1/8}"
        },
        {
            type = "noise-expression",
            name = "terra_palus_wobble_y",
            expression = "multioctave_noise{x = x, y = y, persistence = 0.7, seed0 = map_seed, seed1 = 1010, octaves = 2, input_scale = 1/8}"
        },
        {
            type = "noise-expression",
            name = "terra_palus_wobble_large_x",
            expression = "multioctave_noise{x = x, y = y, persistence = 0.7, seed0 = map_seed, seed1 = 20, octaves = 2, input_scale = 1/2}"
        },
        {
            type = "noise-expression",
            name = "terra_palus_wobble_large_y",
            expression = "multioctave_noise{x = x, y = y, persistence = 0.7, seed0 = map_seed, seed1 = 1020, octaves = 2, input_scale = 1/2}"
        },

    -- Enemy base control expressions
    {
        type = "noise-expression",
        name = "terra_palus_spawner",
        expression = "(max(0.01 * terra_palus_starting_enemies, max(min(0.02, enemy_autoplace_base(0, 8)), min(0.001, terra_palus_fertile_spots_coastal * 5000 - terra_palus_biome_mask_green * 25000)) * (distance > 500 * terra_palus_starting_area_multiplier)) * terra_palus_above_deep_water_mask) * var('control:gleba-spawner:frequency') * var('control:gleba-spawner:size') * " .. spawner_factor
    },
    {
        type = "noise-expression",
        name = "terra_palus_spawner_small",
        expression = "(max(0.02 * terra_palus_starting_enemies, 0.02 * terra_palus_starting_enemies_safe, min(0.02, enemy_autoplace_base(0, 8)), min(0.001, terra_palus_fertile_spots_coastal * 5000 - terra_palus_biome_mask_green * 25000)) * terra_palus_above_deep_water_mask * (1 - terra_palus_starting_enemies_safe)) * var('control:gleba-spawner-small:frequency') * var('control:gleba-spawner-small:size') * " .. small_spawner_factor
    },
    {
        type = "noise-expression",
        name = "terra_palus_starting_enemies",
        expression = "spot_noise{x = x + wobble_noise_x * 15,\z
                                y = y + wobble_noise_y * 15,\z
                                seed0 = map_seed,\z
                                seed1 = 1,\z
                                candidate_spot_count = " .. fertile_candidate_spots .. ",\z
                                suggested_minimum_candidate_point_spacing = " .. fertile_spot_spacing .. ",\z
                                skip_span = 1,\z
                                skip_offset = 0,\z
                                region_size = " .. fertile_region_size .. ",\z
                                density_expression = " .. fertile_candidate_spots .. ",\z
                                spot_quantity_expression = 1000,\z
                                spot_radius_expression = " .. fertile_spot_radius .. ",\z
                                hard_region_target_quantity = 0,\z
                                spot_favorability_expression = 60,\z
                                basement_value = -0.5,\z
                                maximum_spot_basement_radius = " .. fertile_spot_spacing .. "}",
        local_expressions = {
            wobble_noise_x = "multioctave_noise{x = x, y = y, persistence = 0.5, seed0 = map_seed, seed1 = 3000000, octaves = 2, input_scale = 1/20}",
            wobble_noise_y = "multioctave_noise{x = x, y = y, persistence = 0.5, seed0 = map_seed, seed1 = 4000000, octaves = 2, input_scale = 1/20}"
        }
    },
    {
        type = "noise-expression",
        name = "terra_palus_above_deep_water_mask",
        expression = "terra_palus_elevation > -10"
    },
    {
        type = "noise-expression",
        name = "terrapalus_plants_noise",
        expression = "multioctave_noise{x = x, y = y, persistence = 0.7, seed0 = map_seed, seed1 = 1000000, octaves = 3, input_scale = 1/" .. elevation_scale .. "}"
    },
    -- Other required expressions for enemy spawning
    {
        type = "noise-expression",
        name = "terra_palus_biome_mask_green",
        expression = "terra_palus_aux > 0.375"
    },
    {
        type = "noise-expression",
        name = "terrapalus_fertile_solid",
        expression = "2 * abs(multioctave_noise{x = x, y = y, persistence = 0.7, seed0 = map_seed, seed1 = 2000000, octaves = 2, input_scale = 1/16})\z
                     * terra_palus_fertile_spots_coastal"
    },
    {
        type = "noise-expression",
        name = "terrapalus_biome_mask_red",
        expression = "terra_palus_aux < 0.625"
    },
    {
        type = "noise-expression",
        name = "terra_palus_starting_area_multiplier",
        expression = tostring(starting_area_multiplier)
    },
    {
        type = "noise-expression",
        name = "terra_palus_fertile_spots_coastal",
        expression = "max(min(1, terra_palus_starting_fertile * 4),\z
                      min(exclude_middle, terra_palus_fertile_spots_coastal_raw) - max(0, -(elevation + 2) / 5) - max(0, (elevation - 10) / 5))",
        local_expressions = {
            exclude_middle = "(distance / terra_palus_starting_area_multiplier / 150) - 2.2"
        }
    },
    {
        type = "noise-function",
        name = "terrapalus_simple_spot",
        parameters = {"seed1", "radius", "spacing", "favorability"},
        expression = "spot_noise{\z
          x = x + terrapalus_wobble_small_x * 0.5 * radius,\z
          y = y + terrapalus_wobble_small_y * 0.5 * radius,\z
          seed0 = map_seed,\z
          seed1 = seed1,\z
          skip_span = 1,\z
          skip_offset = 1,\z
          region_size = spacing * 5,\z
          density_expression = favorability,\z
          spot_favorability_expression = favorability,\z
          candidate_spot_count = 22,\z
          suggested_minimum_candidate_point_spacing = spacing,\z
          spot_quantity_expression = radius * radius,\z
          spot_radius_expression = radius,\z
          hard_region_target_quantity = 0,\z
          basement_value = -1,\z
          maximum_spot_basement_radius = radius * 2\z
        }"
    },
})

function MapGen.terrapalus()
    local map_gen_settings = {
        property_expression_names = {
            elevation = "terra_palus_elevation",
            temperature = "terra_palus_temperature",
            moisture = "terra_palus_moisture",
            aux = "terra_palus_aux",
            cliffiness = "cliffiness_basic",
            cliff_elevation = "cliff_elevation_from_elevation",
            ["entity:gleba-spawner:probability"] = "terra_palus_spawner",
            ["entity:gleba-spawner-small:probability"] = "terra_palus_spawner_small",
        },
        autoplace_controls = {
            ["iron-ore"] = {},
            ["copper-ore"] = {},
            ["stone"] = {},
            ["coal"] = {},
            ["crude-oil"] = {},
            ["trees"] = {},
            ["palusium-ore"] = {},
            ["gleba_plants"] = {
                frequency = soil_frequency,
                size = lowland_size / 10
            },
            ["enemy-base"] = {},
            -- the pentapod spawners' own control, as on Gleba: listing the spawners in autoplace_settings instead made
            -- the planet fail to load when another mod removed their autoplace
            ["gleba_enemy_base"] = {},
            ["gleba-spawner"] = {},
            ["gleba-spawner-small"] = {}
        },
        autoplace_settings = {
            ["tile"] = {
                settings = {
                    -- Nauvis tiles (lower frequency in swampy areas)
                    ["grass-1"] = {
                        frequency = 0.6,
                        size = 0.8
                    },
                    ["grass-2"] = {
                        frequency = 0.5,
                        size = 0.7
                    },
                    ["dirt-1"] = {
                        frequency = 0.4,
                        size = 0.6
                    },
                    ["water"] = {},
                    ["deepwater"] = {},

                    -- Actual Gleba tiles
                    ["natural-yumako-soil"] = {
                        frequency = soil_frequency,
                        size = lowland_size * 5.5
                    },
                    ["natural-jellynut-soil"] = {
                        frequency = soil_frequency,
                        size = lowland_size * 5.5
                    },
                    ["wetland-yumako"] = {
                        frequency = 3.4,
                        size = 1.6
                    },
                    ["wetland-jellynut"] = {
                        frequency = 3.4,
                        size = 1.6
                    },
                    ["wetland-blue-slime"] = {},
                    ["wetland-light-green-slime"] = {},
                    ["wetland-green-slime"] = {},
                    ["wetland-light-dead-skin"] = {},
                    ["wetland-dead-skin"] = {},
                    ["gleba-deep-lake"] = {
                        frequency = 1.4,
                        size = 1.6
                    },
                    ["lowland-brown-blubber"] = {},
                    ["lowland-olive-blubber"] = {},
                    ["lowland-pale-green"] = {},
                    ["lowland-cream-cauliflower"] = {}
                }
            },
            ["decorative"] = {
                settings = {
                }
            },
            ["entity"] = {
                settings = {
                    ["iron-ore"] = {},
                    ["copper-ore"] = {},
                    ["stone"] = {},
                    ["coal"] = {},
                    ["palusium-ore"] = {
                        frequency = 1.0,
                        size = 1.0,
                        richness = 1.0
                    },
                    ["crude-oil"] = {
                        frequency = 0.8,
                        size = 1.0
                    },
                    ["ashland-lichen-tree"] = {
                        frequency = 0.8,
                        size = 1.0
                    },
                    ["ashland-lichen-tree-flaming"] = {
                        frequency = 0.4,
                        size = 0.8
                    },
                }
            }
        },
        cliff_settings = {
            name = "cliff",
            cliff_elevation_0 = 40,
            cliff_elevation_interval = 40
        }
    }
    -- Optional extras, off by default (startup settings)
    if settings.startup["terrapalus-uranium-ore"].value then
        map_gen_settings.autoplace_controls["uranium-ore"] = {}
        map_gen_settings.autoplace_settings["entity"].settings["uranium-ore"] = {}
    end
    if settings.startup["terrapalus-stromatolites"].value then
        map_gen_settings.autoplace_settings["entity"].settings["iron-stromatolite"] = {}
        map_gen_settings.autoplace_settings["entity"].settings["copper-stromatolite"] = {}
    end
    return map_gen_settings
end

return MapGen
