-- data-updates.lua
-- Optional PlanetsLib integration for proper orbit visualization

-- Only apply orbit fixes if PlanetsLib is available
if mods["PlanetsLib"] then
    local orbit_config = {
        distance = 1.89,
        orientation = 0.125,
        sprite_file = "__terrapalus-updated__/graphics/terrapalus-orbit.png",
        sprite_size = 500
    }

    PlanetsLib:update({
        {
            type = "planet",
            name = "terrapalus",
            subgroup = "satellites",
            is_satellite = true,
            draw_orbit = false,
            orbit = {
                parent = {
                    type = "planet",
                    name = "gleba"
                },
                distance = orbit_config.distance,
                orientation = orbit_config.orientation,
                sprite = {
                    type = "sprite",
                    filename = orbit_config.sprite_file,
                    size = orbit_config.sprite_size,
                    scale = 0.32
                }
            }
        }
    })
end
