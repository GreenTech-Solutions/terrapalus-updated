require ("circuit-connector-sprites")
local sounds = require("__base__/prototypes/entity/sounds")
local hit_effects = require ("__base__/prototypes/entity/hit-effects")
local util = require('util')


data:extend({
    {
      type = "beam",
      name = "uv-beam",
      flags = {"not-on-map"},
      hidden = true,
      width = 5,
      damage_interval = 5,
      random_target_offset = true,
      action_triggered_automatically = false,
      action = {
        type = "direct",
        -- To make an AoE turret:
        --  1 turret, 1 beam, hits one target, affects multiple targets
        -- type = "area",
        -- radius = 10,
        force = "enemy", -- if you don't do this, it also applies to the player.
        action_delivery = {
          type = "instant",
          target_effects = {
            {
              type = "damage",
              damage = { amount = 25, type = "laser"}
            },
            {
              type = "push-back",
              distance = 3.5
            },
            {
              type = "create-sticker",
              sticker = "tesla-turret-stun"
            },
            -- {
            --   type = "create-sticker",
            --   sticker = "tesla-turret-slow"
            -- },
            {
              type = "create-sticker",
              sticker = "uv-turret-burn-sticker"
            },
            
                        {
              type = "play-sound",
              sound =
              {
                category = "enemy",
                variations =
                {
                  {filename = "__base__/sound/creatures/projectile-acid-burn-1.ogg", volume = 0.65, modifiers = volume_multiplier("main-menu", 0.9)},
                  {filename = "__base__/sound/creatures/projectile-acid-burn-2.ogg", volume = 0.65, modifiers = volume_multiplier("main-menu", 0.9)},
                  {filename = "__base__/sound/creatures/projectile-acid-burn-long-1.ogg", volume = 0.65, modifiers = volume_multiplier("main-menu", 0.9)},
                  {filename = "__base__/sound/creatures/projectile-acid-burn-long-2.ogg", volume = 0.65, modifiers = volume_multiplier("main-menu", 0.9)},
                },
                aggregation = {max_count = 2, remove = true, count_already_playing = true}
              }
            },

          }
        }
      },
      working_sound = {
        sound = {
          filename = "__base__/sound/fight/laser-beam.ogg",
          volume = 0.8
        },
        max_sounds_per_type = 2
      },
      graphics_set = {
        beam = {
          head = {
            layers = {
              {
                filename = "__base__/graphics/entity/laser-turret/laser-body.png",
                flags = { "trilinear-filtering" },
                line_length = 8,
                width = 64,
                height = 12,
                frame_count = 8,
                scale = 1,
                animation_speed = 0.5,
                blend_mode = "additive",
                tint = {r=0.3, g=0.1, b=1, a=1}  -- Bright blue color
              },
              {
                filename = "__base__/graphics/entity/laser-turret/laser-body-light.png",
                draw_as_light = true,
                flags = {"light"},
                line_length = 8,
                width = 64,
                height = 12,
                frame_count = 8,
                scale = 1,
                animation_speed = 0.5,
                tint = {r=0.3, g=0.1, b=1, a=1}  -- Bright blue color
              }
            }
          },
          tail = {
            layers = {
              {
                filename = "__base__/graphics/entity/laser-turret/laser-end.png",
                flags = { "trilinear-filtering" },
                width = 110,
                height = 62,
                frame_count = 8,
                shift = {0.359375, 0.03125},
                scale = 1,
                animation_speed = 0.5,
                blend_mode = "additive",
                tint = {r=0.3, g=0.1, b=1, a=1}  -- Bright blue color
              },
              {
                filename = "__base__/graphics/entity/laser-turret/laser-end-light.png",
                draw_as_light = true,
                flags = {"light"},
                width = 110,
                height = 62,
                frame_count = 8,
                shift = {0.359375, 0.03125},
                scale = 1,
                animation_speed = 0.5,
                tint = {r=0.3, g=0.1, b=1, a=1}  -- Bright blue color
              }
            }
          },
          body = {
            {
              layers = {
                {
                  filename = "__base__/graphics/entity/laser-turret/laser-body.png",
                  flags = { "trilinear-filtering" },
                  line_length = 8,
                  width = 64,
                  height = 12,
                  frame_count = 8,
                  scale = 1,
                  animation_speed = 0.5,
                  blend_mode = "additive",
                  tint = {r=0.3, g=0.1, b=1, a=1}  -- Bright blue color
                },
                {
                  filename = "__base__/graphics/entity/laser-turret/laser-body-light.png",
                  draw_as_light = true,
                  flags = {"light"},
                  line_length = 8,
                  width = 64,
                  height = 12,
                  frame_count = 8,
                  scale = 1,
                  animation_speed = 0.5,
                  tint = {r=0.3, g=0.1, b=1, a=1}  -- Bright blue color
                }
              }
            }
          }
        },
        ground = {
          head = {
            filename = "__base__/graphics/entity/laser-turret/laser-ground-light-head.png",
            draw_as_light = true,
            flags = {"light"},
            line_length = 1,
            width = 256,
            height = 256,
            repeat_count = 8,
            scale = 1,
            shift = {-1, 0},
            animation_speed = 0.5,
            tint = {r=0.2, g=0.5, b=1, a=0.5}  -- Blue ground effect
          },
          tail = {
            filename = "__base__/graphics/entity/laser-turret/laser-ground-light-tail.png",
            draw_as_light = true,
            flags = {"light"},
            line_length = 1,
            width = 256,
            height = 256,
            repeat_count = 8,
            scale = 1,
            shift = {1, 0},
            animation_speed = 0.5,
            tint = {r=0.2, g=0.5, b=1, a=0.5}  -- Blue ground effect
          },
          body = {
            filename = "__base__/graphics/entity/laser-turret/laser-ground-light-body.png",
            draw_as_light = true,
            flags = {"light"},
            line_length = 1,
            width = 64,
            height = 256,
            repeat_count = 8,
            scale = 1,
            animation_speed = 0.5,
            tint = {r=0.2, g=0.5, b=1, a=0.5}  -- Blue ground effect
          }
        }
      }
    }
  })

function laser_turret_extension(inputs)
    return
    {
      filename = "__terrapalus-updated__/graphics/entity/uv-turret/laser-uv-raising.png",
      priority = "medium",
      width = 130,
      height = 126,
      frame_count = inputs.frame_count or 15,
      line_length = inputs.line_length or 0,
      run_mode = inputs.run_mode or "forward",
      direction_count = 4,
      shift = util.by_pixel(0, -32.5),
      scale = 0.5
    }
  end
  
  function laser_turret_extension_shadow(inputs)
    return
    {
      filename = "__base__/graphics/entity/laser-turret/laser-turret-raising-shadow.png",
      width = 182,
      height = 96,
      frame_count = inputs.frame_count or 15,
      line_length = inputs.line_length or 0,
      run_mode = inputs.run_mode or "forward",
      direction_count = 4,
      draw_as_shadow = true,
      shift = util.by_pixel(47, 2.5),
      scale = 0.5,
      tint = {r=0.4, g=0.2, b=1, a=0.5}  -- Blue tint
    }
  end
  
  function laser_turret_extension_mask(inputs)
    return
    {
      filename = "__base__/graphics/entity/laser-turret/laser-turret-raising-mask.png",
      flags = {"mask"},
      width = 86,
      height = 80,
      frame_count = inputs.frame_count or 15,
      line_length = inputs.line_length or 0,
      run_mode = inputs.run_mode or "forward",
      apply_runtime_tint = true,
      direction_count = 4,
      shift = util.by_pixel(0, -43),
      scale = 0.5,
      tint = {r=0.4, g=0.2, b=1, a=0.5}  -- Blue tint
    }
  end
  
  function laser_turret_shooting()
    return
    {
      filename = "__terrapalus-updated__/graphics/entity/uv-turret/laser-uv-shooting.png",
      line_length = 8,
      width = 126,
      height = 120,
      direction_count = 64,
      shift = util.by_pixel(0, -35),
      scale = 0.5
    }
  end
  
  function laser_turret_shooting_glow()
    return
    {
      filename = "__base__/graphics/entity/laser-turret/laser-turret-shooting-light.png",
      line_length = 8,
      width = 122,
      height = 116,
      direction_count = 64,
      shift = util.by_pixel(-0.5, -35),
      blend_mode = "additive",
      scale = 1,
      tint = {r=0.4, g=0.2, b=1, a=1.0}  -- Blue tint
    }
  end
  
  function laser_turret_shooting_mask()
    return
    {
      filename = "__base__/graphics/entity/laser-turret/laser-turret-shooting-mask.png",
      flags = {"mask"},
      line_length = 8,
      width = 92,
      height = 80,
      apply_runtime_tint = true,
      direction_count = 64,
      shift = util.by_pixel(0, -43.5),
      scale = 0.5,
      tint = {r=0.4, g=0.2, b=1, a=0.5}  -- Blue tint
    }
  end
  
  function laser_turret_shooting_shadow()
    return
    {
      filename = "__base__/graphics/entity/laser-turret/laser-turret-shooting-shadow.png",
      line_length = 8,
      width = 170,
      height = 92,
      direction_count = 64,
      draw_as_shadow = true,
      shift = util.by_pixel(50.5, 2.5),
      scale = 0.5,
      tint = {r=0.4, g=0.2, b=1, a=0.5}  -- Blue tint
    }
  end
  
  data:extend({
    {
        type = "electric-turret",
        name = "uv-turret",
        icon = "__base__/graphics/icons/laser-turret.png",
        flags = {"placeable-player", "placeable-enemy", "player-creation"},
        minable = {mining_time = 0.5, result = "uv-turret"},
        -- fast_replaceable_group = "laser-turret",
        max_health = 1000,
        collision_box = {{-0.7, -0.7}, {0.7, 0.7}},
        selection_box = {{-1, -1}, {1, 1}},
        drawing_box_vertical_extension = 0.3,
        damaged_trigger_effect = hit_effects.entity(),
        circuit_connector = circuit_connector_definitions["laser-turret"],
        circuit_wire_max_distance = default_circuit_wire_max_distance,
        rotation_speed = 0.01,
        preparing_speed = 0.05,
        open_sound = {filename = "__base__/sound/open-close/turret-open.ogg", volume = 0.6},
        close_sound = {filename = "__base__/sound/open-close/turret-close.ogg", volume = 0.6},
        preparing_sound = sounds.laser_turret_activate,
        folding_sound = sounds.laser_turret_deactivate,
        corpse = "laser-turret-remnants",
        dying_explosion = "laser-turret-explosion",
        folding_speed = 0.05,
        energy_source =
        {
          type = "electric",
          buffer_capacity = "801kJ",
          input_flow_limit = "9600kW",
          drain = "24kW",
          usage_priority = "primary-input"
        },
        folded_animation =
        {
          layers =
          {
            laser_turret_extension{frame_count=1, line_length = 1},
            laser_turret_extension_shadow{frame_count=1, line_length=1},
            laser_turret_extension_mask{frame_count=1, line_length=1}
          }
        },
        preparing_animation =
        {
          layers =
          {
            laser_turret_extension{},
            laser_turret_extension_shadow{},
            laser_turret_extension_mask{}
          }
        },
        prepared_animation =
        {
          layers =
          {
            laser_turret_shooting(),
            laser_turret_shooting_shadow(),
            laser_turret_shooting_mask()
          }
        },
        --attacking_speed = 0.1,
        energy_glow_animation = laser_turret_shooting_glow(),
        glow_light_intensity = 1.5, -- defaults to 0
        folding_animation =
        {
          layers =
          {
            laser_turret_extension{run_mode = "backward"},
            laser_turret_extension_shadow{run_mode = "backward"},
            laser_turret_extension_mask{run_mode = "backward"}
          }
        },
        graphics_set =
        {
          base_visualisation =
          {
            animation =
            {
              layers =
              {
                {
                  filename = "__base__/graphics/entity/laser-turret/laser-turret-base.png",
                  priority = "high",
                  width = 138,
                  height = 104,
                  shift = util.by_pixel(-0.5, 2),
                  scale = 0.5
                },
                {
                  filename = "__base__/graphics/entity/laser-turret/laser-turret-base-shadow.png",
                  line_length = 1,
                  width = 132,
                  height = 82,
                  draw_as_shadow = true,
                  shift = util.by_pixel(6, 3),
                  scale = 0.5
                }
              }
            }
          }
        },
    
        attack_parameters =
        {
          type = "beam",
          cooldown = 20,
          range = 28,
          range_mode = "center-to-bounding-box",
          source_direction_count = 64,
          source_offset = {0, -3.423489 / 4},
          damage_modifier = 2,
          ammo_category = "laser",
          ammo_type =
          {
            energy_consumption = "800kJ",
            action =
            {
              type = "direct",
              -- AoE turret alternate 
              -- --  1 turret, multiple beams, hits multiple targets, affects multiple targets
              -- type = "area",
              -- radius = 10,
              -- force = "enemy",
              action_delivery =
              {
                type = "beam",
                beam = "uv-beam",
                max_length = 28,
                duration = 10,
                source_offset = {0, -1.31439 }
              }
            }
          }
        },
    
        call_for_help_radius = 40,
        water_reflection =
        {
          pictures =
          {
            filename = "__base__/graphics/entity/laser-turret/laser-turret-reflection.png",
            priority = "extra-high",
            width = 20,
            height = 32,
            shift = util.by_pixel(0, 40),
            variation_count = 1,
            scale = 5
          },
          rotate = false,
          orientation_to_variation = false
        }
      },
  })

-- UV Spotlight Beam (triggers 30-second freeze via control.lua, no damage)
data:extend({
  {
    type = "beam",
    name = "uv-spotlight-beam",
    flags = {"not-on-map"},
    hidden = true,
    width = 6,
    damage_interval = 10,
    random_target_offset = true,
    action_triggered_automatically = false,
    action = {
      type = "direct",
      force = "enemy",
      action_delivery = {
        type = "instant",
        target_effects = {
          {
            type = "damage",
            damage = { amount = 1, type = "laser"}
          },
          {
            type = "play-sound",
            sound = {
              category = "enemy",
              variations = {
                {filename = "__base__/sound/fight/laser-beam.ogg", volume = 0.3},
              },
              aggregation = {max_count = 1, remove = true, count_already_playing = true}
            }
          },
        }
      }
    },
    working_sound = {
      sound = {
        filename = "__base__/sound/fight/laser-beam.ogg",
        volume = 0.4
      },
      max_sounds_per_type = 2
    },
    graphics_set = {
      beam = {
        head = {
          layers = {
            {
              filename = "__base__/graphics/entity/laser-turret/laser-body.png",
              flags = { "trilinear-filtering" },
              line_length = 8,
              width = 64,
              height = 12,
              frame_count = 8,
              scale = 1.5,
              animation_speed = 0.5,
              blend_mode = "additive",
              tint = {r=0.7, g=0.2, b=1.0, a=0.8}
            }
          }
        },
        tail = {
          layers = {
            {
              filename = "__base__/graphics/entity/laser-turret/laser-end.png",
              flags = { "trilinear-filtering" },
              width = 110,
              height = 62,
              frame_count = 8,
              shift = {0.359375, 0.03125},
              scale = 1.5,
              animation_speed = 0.5,
              blend_mode = "additive",
              tint = {r=0.7, g=0.2, b=1.0, a=0.8}
            }
          }
        },
        body = {
          {
            layers = {
              {
                filename = "__base__/graphics/entity/laser-turret/laser-body.png",
                flags = { "trilinear-filtering" },
                line_length = 8,
                width = 64,
                height = 12,
                frame_count = 8,
                scale = 1.5,
                animation_speed = 0.5,
                blend_mode = "additive",
                tint = {r=0.7, g=0.2, b=1.0, a=0.8}
              }
            }
          }
        }
      },
      ground = {
        head = {
          filename = "__base__/graphics/entity/laser-turret/laser-ground-light-head.png",
          draw_as_light = true,
          flags = {"light"},
          line_length = 1,
          width = 256,
          height = 256,
          repeat_count = 8,
          scale = 1.5,
          shift = {-1, 0},
          animation_speed = 0.5,
          tint = {r=0.7, g=0.2, b=1.0, a=0.6}
        },
        tail = {
          filename = "__base__/graphics/entity/laser-turret/laser-ground-light-tail.png",
          draw_as_light = true,
          flags = {"light"},
          line_length = 1,
          width = 256,
          height = 256,
          repeat_count = 8,
          scale = 1.5,
          shift = {1, 0},
          animation_speed = 0.5,
          tint = {r=0.7, g=0.2, b=1.0, a=0.6}
        },
        body = {
          filename = "__base__/graphics/entity/laser-turret/laser-ground-light-body.png",
          draw_as_light = true,
          flags = {"light"},
          line_length = 1,
          width = 64,
          height = 256,
          repeat_count = 8,
          scale = 1.5,
          animation_speed = 0.5,
          tint = {r=0.7, g=0.2, b=1.0, a=0.6}
        }
      }
    }
  }
})

-- UV Spotlight Turret
data:extend({
  {
      type = "electric-turret",
      name = "uv-spotlight",
      icon = "__base__/graphics/icons/laser-turret.png",
      flags = {"placeable-player", "placeable-enemy", "player-creation"},
      minable = {mining_time = 0.5, result = "uv-spotlight"},
      max_health = 800,
      collision_box = {{-0.7, -0.7}, {0.7, 0.7}},
      selection_box = {{-1, -1}, {1, 1}},
      drawing_box_vertical_extension = 0.3,
      damaged_trigger_effect = hit_effects.entity(),
      circuit_connector = circuit_connector_definitions["laser-turret"],
      circuit_wire_max_distance = default_circuit_wire_max_distance,
      rotation_speed = 0.02,
      preparing_speed = 0.08,
      open_sound = {filename = "__base__/sound/open-close/turret-open.ogg", volume = 0.6},
      close_sound = {filename = "__base__/sound/open-close/turret-close.ogg", volume = 0.6},
      preparing_sound = sounds.laser_turret_activate,
      folding_sound = sounds.laser_turret_deactivate,
      corpse = "laser-turret-remnants",
      dying_explosion = "laser-turret-explosion",
      folding_speed = 0.08,
      energy_source = {
        type = "electric",
        buffer_capacity = "400kJ",
        input_flow_limit = "4800kW",
        drain = "20kW",
        usage_priority = "primary-input"
      },
      folded_animation = {
        layers = {
          laser_turret_extension{frame_count=1, line_length = 1},
          laser_turret_extension_shadow{frame_count=1, line_length=1},
          laser_turret_extension_mask{frame_count=1, line_length=1}
        }
      },
      preparing_animation = {
        layers = {
          laser_turret_extension{},
          laser_turret_extension_shadow{},
          laser_turret_extension_mask{}
        }
      },
      prepared_animation = {
        layers = {
          laser_turret_shooting(),
          laser_turret_shooting_shadow(),
          laser_turret_shooting_mask()
        }
      },
      energy_glow_animation = laser_turret_shooting_glow(),
      glow_light_intensity = 2.0,
      folding_animation = {
        layers = {
          laser_turret_extension{run_mode = "backward"},
          laser_turret_extension_shadow{run_mode = "backward"},
          laser_turret_extension_mask{run_mode = "backward"}
        }
      },
      graphics_set = {
        base_visualisation = {
          animation = {
            layers = {
              {
                filename = "__base__/graphics/entity/laser-turret/laser-turret-base.png",
                priority = "high",
                width = 138,
                height = 104,
                shift = util.by_pixel(-0.5, 2),
                scale = 0.5
              },
              {
                filename = "__base__/graphics/entity/laser-turret/laser-turret-base-shadow.png",
                line_length = 1,
                width = 132,
                height = 82,
                draw_as_shadow = true,
                shift = util.by_pixel(6, 3),
                scale = 0.5
              }
            }
          }
        }
      },
      attack_parameters = {
        type = "beam",
        cooldown = 20,
        range = 24,
        range_mode = "center-to-bounding-box",
        source_direction_count = 64,
        source_offset = {0, -3.423489 / 4},
        damage_modifier = 1,
        ammo_category = "laser",
        ammo_type = {
          energy_consumption = "100kJ",
          action = {
            type = "direct",
            action_delivery = {
              type = "beam",
              beam = "uv-spotlight-beam",
              max_length = 24,
              duration = 15,
              source_offset = {0, -1.31439}
            }
          }
        }
      },
      call_for_help_radius = 40,
      water_reflection = {
        pictures = {
          filename = "__base__/graphics/entity/laser-turret/laser-turret-reflection.png",
          priority = "extra-high",
          width = 20,
          height = 32,
          shift = util.by_pixel(0, 40),
          variation_count = 1,
          scale = 5
        },
        rotate = false,
        orientation_to_variation = false
      }
    },
})

-- UV Beam MK2 (increased damage)
data:extend({
  {
    type = "beam",
    name = "uv-beam-mk2",
    flags = {"not-on-map"},
    hidden = true,
    width = 5,
    damage_interval = 5,
    random_target_offset = true,
    action_triggered_automatically = false,
    action = {
      type = "direct",
      force = "enemy",
      action_delivery = {
        type = "instant",
        target_effects = {
          {
            type = "damage",
            damage = { amount = 35, type = "laser"}
          },
          {
            type = "push-back",
            distance = 3.5
          },
          {
            type = "create-sticker",
            sticker = "tesla-turret-stun"
          },
          {
            type = "create-sticker",
            sticker = "uv-turret-burn-sticker"
          },
          {
            type = "play-sound",
            sound = {
              category = "enemy",
              variations = {
                {filename = "__base__/sound/creatures/projectile-acid-burn-1.ogg", volume = 0.65},
                {filename = "__base__/sound/creatures/projectile-acid-burn-2.ogg", volume = 0.65},
              },
              aggregation = {max_count = 2, remove = true, count_already_playing = true}
            }
          },
        }
      }
    },
    working_sound = {
      sound = {
        filename = "__base__/sound/fight/laser-beam.ogg",
        volume = 0.8
      },
      max_sounds_per_type = 2
    },
    graphics_set = data.raw["beam"]["uv-beam"].graphics_set
  }
})

-- UV Beam MK3 (highest damage)
data:extend({
  {
    type = "beam",
    name = "uv-beam-mk3",
    flags = {"not-on-map"},
    hidden = true,
    width = 5,
    damage_interval = 5,
    random_target_offset = true,
    action_triggered_automatically = false,
    action = {
      type = "direct",
      force = "enemy",
      action_delivery = {
        type = "instant",
        target_effects = {
          {
            type = "damage",
            damage = { amount = 45, type = "laser"}
          },
          {
            type = "push-back",
            distance = 4.0
          },
          {
            type = "create-sticker",
            sticker = "tesla-turret-stun"
          },
          {
            type = "create-sticker",
            sticker = "uv-turret-burn-sticker"
          },
          {
            type = "play-sound",
            sound = {
              category = "enemy",
              variations = {
                {filename = "__base__/sound/creatures/projectile-acid-burn-1.ogg", volume = 0.65},
                {filename = "__base__/sound/creatures/projectile-acid-burn-2.ogg", volume = 0.65},
              },
              aggregation = {max_count = 2, remove = true, count_already_playing = true}
            }
          },
        }
      }
    },
    working_sound = {
      sound = {
        filename = "__base__/sound/fight/laser-beam.ogg",
        volume = 0.8
      },
      max_sounds_per_type = 2
    },
    graphics_set = data.raw["beam"]["uv-beam"].graphics_set
  }
})

-- UV Turret MK2
data:extend({
  {
      type = "electric-turret",
      name = "uv-turret-mk2",
      icon = "__base__/graphics/icons/laser-turret.png",
      flags = {"placeable-player", "placeable-enemy", "player-creation"},
      minable = {mining_time = 0.5, result = "uv-turret-mk2"},
      max_health = 1200,
      collision_box = {{-0.7, -0.7}, {0.7, 0.7}},
      selection_box = {{-1, -1}, {1, 1}},
      drawing_box_vertical_extension = 0.3,
      damaged_trigger_effect = hit_effects.entity(),
      circuit_connector = circuit_connector_definitions["laser-turret"],
      circuit_wire_max_distance = default_circuit_wire_max_distance,
      rotation_speed = 0.01,
      preparing_speed = 0.05,
      open_sound = {filename = "__base__/sound/open-close/turret-open.ogg", volume = 0.6},
      close_sound = {filename = "__base__/sound/open-close/turret-close.ogg", volume = 0.6},
      preparing_sound = sounds.laser_turret_activate,
      folding_sound = sounds.laser_turret_deactivate,
      corpse = "laser-turret-remnants",
      dying_explosion = "laser-turret-explosion",
      folding_speed = 0.05,
      energy_source = {
        type = "electric",
        buffer_capacity = "1001kJ",
        input_flow_limit = "12000kW",
        drain = "30kW",
        usage_priority = "primary-input"
      },
      folded_animation = {
        layers = {
          laser_turret_extension{frame_count=1, line_length = 1},
          laser_turret_extension_shadow{frame_count=1, line_length=1},
          laser_turret_extension_mask{frame_count=1, line_length=1}
        }
      },
      preparing_animation = {
        layers = {
          laser_turret_extension{},
          laser_turret_extension_shadow{},
          laser_turret_extension_mask{}
        }
      },
      prepared_animation = {
        layers = {
          laser_turret_shooting(),
          laser_turret_shooting_shadow(),
          laser_turret_shooting_mask()
        }
      },
      energy_glow_animation = laser_turret_shooting_glow(),
      glow_light_intensity = 1.5,
      folding_animation = {
        layers = {
          laser_turret_extension{run_mode = "backward"},
          laser_turret_extension_shadow{run_mode = "backward"},
          laser_turret_extension_mask{run_mode = "backward"}
        }
      },
      graphics_set = {
        base_visualisation = {
          animation = {
            layers = {
              {
                filename = "__base__/graphics/entity/laser-turret/laser-turret-base.png",
                priority = "high",
                width = 138,
                height = 104,
                shift = util.by_pixel(-0.5, 2),
                scale = 0.5
              },
              {
                filename = "__base__/graphics/entity/laser-turret/laser-turret-base-shadow.png",
                line_length = 1,
                width = 132,
                height = 82,
                draw_as_shadow = true,
                shift = util.by_pixel(6, 3),
                scale = 0.5
              }
            }
          }
        }
      },
      attack_parameters = {
        type = "beam",
        cooldown = 20,
        range = 35,
        range_mode = "center-to-bounding-box",
        source_direction_count = 64,
        source_offset = {0, -3.423489 / 4},
        damage_modifier = 2.5,
        ammo_category = "laser",
        ammo_type = {
          energy_consumption = "1000kJ",
          action = {
            type = "direct",
            action_delivery = {
              type = "beam",
              beam = "uv-beam-mk2",
              max_length = 35,
              duration = 10,
              source_offset = {0, -1.31439}
            }
          }
        }
      },
      call_for_help_radius = 40,
      water_reflection = {
        pictures = {
          filename = "__base__/graphics/entity/laser-turret/laser-turret-reflection.png",
          priority = "extra-high",
          width = 20,
          height = 32,
          shift = util.by_pixel(0, 40),
          variation_count = 1,
          scale = 5
        },
        rotate = false,
        orientation_to_variation = false
      }
    },
})

-- UV Beam AoE (area effect)
data:extend({
  {
    type = "beam",
    name = "uv-beam-aoe",
    flags = {"not-on-map"},
    hidden = true,
    width = 8,
    damage_interval = 5,
    random_target_offset = true,
    action_triggered_automatically = false,
    action = {
      type = "area",
      radius = 6,
      force = "enemy",
      action_delivery = {
        type = "instant",
        target_effects = {
          {
            type = "damage",
            damage = { amount = 15, type = "laser"}
          },
          {
            type = "push-back",
            distance = 2.0
          },
          {
            type = "create-sticker",
            sticker = "uv-turret-burn-sticker"
          },
          {
            type = "play-sound",
            sound = {
              category = "enemy",
              variations = {
                {filename = "__base__/sound/creatures/projectile-acid-burn-1.ogg", volume = 0.65},
                {filename = "__base__/sound/creatures/projectile-acid-burn-2.ogg", volume = 0.65},
              },
              aggregation = {max_count = 2, remove = true, count_already_playing = true}
            }
          },
        }
      }
    },
    working_sound = {
      sound = {
        filename = "__base__/sound/fight/laser-beam.ogg",
        volume = 0.8
      },
      max_sounds_per_type = 2
    },
    graphics_set = data.raw["beam"]["uv-beam"].graphics_set
  }
})

-- UV Beam Chain (multi-target)
data:extend({
  {
    type = "beam",
    name = "uv-beam-chain",
    flags = {"not-on-map"},
    hidden = true,
    width = 5,
    damage_interval = 5,
    random_target_offset = true,
    action_triggered_automatically = false,
    action = {
      type = "direct",
      force = "enemy",
      action_delivery = {
        type = "instant",
        target_effects = {
          {
            type = "damage",
            damage = { amount = 20, type = "laser"}
          },
          {
            type = "push-back",
            distance = 2.5
          },
          {
            type = "create-sticker",
            sticker = "uv-turret-burn-sticker"
          },
          {
            type = "nested-result",
            action = {
              type = "area",
              radius = 8,
              force = "enemy",
              action_delivery = {
                type = "instant",
                target_effects = {
                  {
                    type = "damage",
                    damage = { amount = 12, type = "laser"}
                  },
                  {
                    type = "create-sticker",
                    sticker = "uv-turret-burn-sticker"
                  }
                }
              }
            }
          },
          {
            type = "play-sound",
            sound = {
              category = "enemy",
              variations = {
                {filename = "__base__/sound/creatures/projectile-acid-burn-1.ogg", volume = 0.65},
                {filename = "__base__/sound/creatures/projectile-acid-burn-2.ogg", volume = 0.65},
              },
              aggregation = {max_count = 2, remove = true, count_already_playing = true}
            }
          },
        }
      }
    },
    working_sound = {
      sound = {
        filename = "__base__/sound/fight/laser-beam.ogg",
        volume = 0.8
      },
      max_sounds_per_type = 2
    },
    graphics_set = data.raw["beam"]["uv-beam"].graphics_set
  }
})

-- UV Turret Chain (multi-target)
data:extend({
  {
      type = "electric-turret",
      name = "uv-turret-chain",
      icon = "__base__/graphics/icons/laser-turret.png",
      flags = {"placeable-player", "placeable-enemy", "player-creation"},
      minable = {mining_time = 0.5, result = "uv-turret-chain"},
      max_health = 1000,
      collision_box = {{-0.7, -0.7}, {0.7, 0.7}},
      selection_box = {{-1, -1}, {1, 1}},
      drawing_box_vertical_extension = 0.3,
      damaged_trigger_effect = hit_effects.entity(),
      circuit_connector = circuit_connector_definitions["laser-turret"],
      circuit_wire_max_distance = default_circuit_wire_max_distance,
      rotation_speed = 0.01,
      preparing_speed = 0.05,
      open_sound = {filename = "__base__/sound/open-close/turret-open.ogg", volume = 0.6},
      close_sound = {filename = "__base__/sound/open-close/turret-close.ogg", volume = 0.6},
      preparing_sound = sounds.laser_turret_activate,
      folding_sound = sounds.laser_turret_deactivate,
      corpse = "laser-turret-remnants",
      dying_explosion = "laser-turret-explosion",
      folding_speed = 0.05,
      energy_source = {
        type = "electric",
        buffer_capacity = "1001kJ",
        input_flow_limit = "12000kW",
        drain = "30kW",
        usage_priority = "primary-input"
      },
      folded_animation = {
        layers = {
          laser_turret_extension{frame_count=1, line_length = 1},
          laser_turret_extension_shadow{frame_count=1, line_length=1},
          laser_turret_extension_mask{frame_count=1, line_length=1}
        }
      },
      preparing_animation = {
        layers = {
          laser_turret_extension{},
          laser_turret_extension_shadow{},
          laser_turret_extension_mask{}
        }
      },
      prepared_animation = {
        layers = {
          laser_turret_shooting(),
          laser_turret_shooting_shadow(),
          laser_turret_shooting_mask()
        }
      },
      energy_glow_animation = laser_turret_shooting_glow(),
      glow_light_intensity = 1.5,
      folding_animation = {
        layers = {
          laser_turret_extension{run_mode = "backward"},
          laser_turret_extension_shadow{run_mode = "backward"},
          laser_turret_extension_mask{run_mode = "backward"}
        }
      },
      graphics_set = {
        base_visualisation = {
          animation = {
            layers = {
              {
                filename = "__base__/graphics/entity/laser-turret/laser-turret-base.png",
                priority = "high",
                width = 138,
                height = 104,
                shift = util.by_pixel(-0.5, 2),
                scale = 0.5
              },
              {
                filename = "__base__/graphics/entity/laser-turret/laser-turret-base-shadow.png",
                line_length = 1,
                width = 132,
                height = 82,
                draw_as_shadow = true,
                shift = util.by_pixel(6, 3),
                scale = 0.5
              }
            }
          }
        }
      },
      attack_parameters = {
        type = "beam",
        cooldown = 30,
        range = 26,
        range_mode = "center-to-bounding-box",
        source_direction_count = 64,
        source_offset = {0, -3.423489 / 4},
        damage_modifier = 2,
        ammo_category = "laser",
        ammo_type = {
          energy_consumption = "1000kJ",
          action = {
            type = "direct",
            action_delivery = {
              type = "beam",
              beam = "uv-beam-chain",
              max_length = 26,
              duration = 12,
              source_offset = {0, -1.31439}
            }
          }
        }
      },
      call_for_help_radius = 40,
      water_reflection = {
        pictures = {
          filename = "__base__/graphics/entity/laser-turret/laser-turret-reflection.png",
          priority = "extra-high",
          width = 20,
          height = 32,
          shift = util.by_pixel(0, 40),
          variation_count = 1,
          scale = 5
        },
        rotate = false,
        orientation_to_variation = false
      }
    },
})

-- UV Turret AoE
data:extend({
  {
      type = "electric-turret",
      name = "uv-turret-aoe",
      icon = "__base__/graphics/icons/laser-turret.png",
      flags = {"placeable-player", "placeable-enemy", "player-creation"},
      minable = {mining_time = 0.5, result = "uv-turret-aoe"},
      max_health = 1000,
      collision_box = {{-0.7, -0.7}, {0.7, 0.7}},
      selection_box = {{-1, -1}, {1, 1}},
      drawing_box_vertical_extension = 0.3,
      damaged_trigger_effect = hit_effects.entity(),
      circuit_connector = circuit_connector_definitions["laser-turret"],
      circuit_wire_max_distance = default_circuit_wire_max_distance,
      rotation_speed = 0.01,
      preparing_speed = 0.05,
      open_sound = {filename = "__base__/sound/open-close/turret-open.ogg", volume = 0.6},
      close_sound = {filename = "__base__/sound/open-close/turret-close.ogg", volume = 0.6},
      preparing_sound = sounds.laser_turret_activate,
      folding_sound = sounds.laser_turret_deactivate,
      corpse = "laser-turret-remnants",
      dying_explosion = "laser-turret-explosion",
      folding_speed = 0.05,
      energy_source = {
        type = "electric",
        buffer_capacity = "1201kJ",
        input_flow_limit = "14400kW",
        drain = "36kW",
        usage_priority = "primary-input"
      },
      folded_animation = {
        layers = {
          laser_turret_extension{frame_count=1, line_length = 1},
          laser_turret_extension_shadow{frame_count=1, line_length=1},
          laser_turret_extension_mask{frame_count=1, line_length=1}
        }
      },
      preparing_animation = {
        layers = {
          laser_turret_extension{},
          laser_turret_extension_shadow{},
          laser_turret_extension_mask{}
        }
      },
      prepared_animation = {
        layers = {
          laser_turret_shooting(),
          laser_turret_shooting_shadow(),
          laser_turret_shooting_mask()
        }
      },
      energy_glow_animation = laser_turret_shooting_glow(),
      glow_light_intensity = 1.5,
      folding_animation = {
        layers = {
          laser_turret_extension{run_mode = "backward"},
          laser_turret_extension_shadow{run_mode = "backward"},
          laser_turret_extension_mask{run_mode = "backward"}
        }
      },
      graphics_set = {
        base_visualisation = {
          animation = {
            layers = {
              {
                filename = "__base__/graphics/entity/laser-turret/laser-turret-base.png",
                priority = "high",
                width = 138,
                height = 104,
                shift = util.by_pixel(-0.5, 2),
                scale = 0.5
              },
              {
                filename = "__base__/graphics/entity/laser-turret/laser-turret-base-shadow.png",
                line_length = 1,
                width = 132,
                height = 82,
                draw_as_shadow = true,
                shift = util.by_pixel(6, 3),
                scale = 0.5
              }
            }
          }
        }
      },
      attack_parameters = {
        type = "beam",
        cooldown = 40,
        range = 24,
        range_mode = "center-to-bounding-box",
        source_direction_count = 64,
        source_offset = {0, -3.423489 / 4},
        damage_modifier = 1.5,
        ammo_category = "laser",
        ammo_type = {
          energy_consumption = "1200kJ",
          action = {
            type = "direct",
            action_delivery = {
              type = "beam",
              beam = "uv-beam-aoe",
              max_length = 24,
              duration = 15,
              source_offset = {0, -1.31439}
            }
          }
        }
      },
      call_for_help_radius = 40,
      water_reflection = {
        pictures = {
          filename = "__base__/graphics/entity/laser-turret/laser-turret-reflection.png",
          priority = "extra-high",
          width = 20,
          height = 32,
          shift = util.by_pixel(0, 40),
          variation_count = 1,
          scale = 5
        },
        rotate = false,
        orientation_to_variation = false
      }
    },
})

-- UV Turret MK3
data:extend({
  {
      type = "electric-turret",
      name = "uv-turret-mk3",
      icon = "__base__/graphics/icons/laser-turret.png",
      flags = {"placeable-player", "placeable-enemy", "player-creation"},
      minable = {mining_time = 0.5, result = "uv-turret-mk3"},
      max_health = 1500,
      collision_box = {{-0.7, -0.7}, {0.7, 0.7}},
      selection_box = {{-1, -1}, {1, 1}},
      drawing_box_vertical_extension = 0.3,
      damaged_trigger_effect = hit_effects.entity(),
      circuit_connector = circuit_connector_definitions["laser-turret"],
      circuit_wire_max_distance = default_circuit_wire_max_distance,
      rotation_speed = 0.01,
      preparing_speed = 0.05,
      open_sound = {filename = "__base__/sound/open-close/turret-open.ogg", volume = 0.6},
      close_sound = {filename = "__base__/sound/open-close/turret-close.ogg", volume = 0.6},
      preparing_sound = sounds.laser_turret_activate,
      folding_sound = sounds.laser_turret_deactivate,
      corpse = "laser-turret-remnants",
      dying_explosion = "laser-turret-explosion",
      folding_speed = 0.05,
      energy_source = {
        type = "electric",
        buffer_capacity = "1201kJ",
        input_flow_limit = "14400kW",
        drain = "36kW",
        usage_priority = "primary-input"
      },
      folded_animation = {
        layers = {
          laser_turret_extension{frame_count=1, line_length = 1},
          laser_turret_extension_shadow{frame_count=1, line_length=1},
          laser_turret_extension_mask{frame_count=1, line_length=1}
        }
      },
      preparing_animation = {
        layers = {
          laser_turret_extension{},
          laser_turret_extension_shadow{},
          laser_turret_extension_mask{}
        }
      },
      prepared_animation = {
        layers = {
          laser_turret_shooting(),
          laser_turret_shooting_shadow(),
          laser_turret_shooting_mask()
        }
      },
      energy_glow_animation = laser_turret_shooting_glow(),
      glow_light_intensity = 1.5,
      folding_animation = {
        layers = {
          laser_turret_extension{run_mode = "backward"},
          laser_turret_extension_shadow{run_mode = "backward"},
          laser_turret_extension_mask{run_mode = "backward"}
        }
      },
      graphics_set = {
        base_visualisation = {
          animation = {
            layers = {
              {
                filename = "__base__/graphics/entity/laser-turret/laser-turret-base.png",
                priority = "high",
                width = 138,
                height = 104,
                shift = util.by_pixel(-0.5, 2),
                scale = 0.5
              },
              {
                filename = "__base__/graphics/entity/laser-turret/laser-turret-base-shadow.png",
                line_length = 1,
                width = 132,
                height = 82,
                draw_as_shadow = true,
                shift = util.by_pixel(6, 3),
                scale = 0.5
              }
            }
          }
        }
      },
      attack_parameters = {
        type = "beam",
        cooldown = 18,
        range = 42,
        range_mode = "center-to-bounding-box",
        source_direction_count = 64,
        source_offset = {0, -3.423489 / 4},
        damage_modifier = 3,
        ammo_category = "laser",
        ammo_type = {
          energy_consumption = "1200kJ",
          action = {
            type = "direct",
            action_delivery = {
              type = "beam",
              beam = "uv-beam-mk3",
              max_length = 42,
              duration = 10,
              source_offset = {0, -1.31439}
            }
          }
        }
      },
      call_for_help_radius = 40,
      water_reflection = {
        pictures = {
          filename = "__base__/graphics/entity/laser-turret/laser-turret-reflection.png",
          priority = "extra-high",
          width = 20,
          height = 32,
          shift = util.by_pixel(0, 40),
          variation_count = 1,
          scale = 5
        },
        rotate = false,
        orientation_to_variation = false
      }
    },
})

  data:extend({
    {
      type = "recipe",
      name = "uv-turret",
      enabled = false,
      energy_required = 20,
      ingredients = {
          {type = "item", name = "palusium-plate", amount = 15},
          {type = "item", name = "palusium-crystal", amount = 10},
          {type = "item", name = "laser-turret", amount = 1}

      },
      results = {
          {type = "item", name = "uv-turret", amount = 1}
      }
    },
    {
      type = "recipe",
      name = "uv-turret-mk2",
      enabled = false,
      energy_required = 25,
      ingredients = {
          {type = "item", name = "uv-turret", amount = 1},
          {type = "item", name = "palusium-plate", amount = 20},
          {type = "item", name = "palusium-crystal", amount = 15},
          {type = "item", name = "processing-unit", amount = 5}
      },
      results = {
          {type = "item", name = "uv-turret-mk2", amount = 1}
      }
    },
    {
      type = "recipe",
      name = "uv-turret-mk3",
      enabled = false,
      energy_required = 30,
      ingredients = {
          {type = "item", name = "uv-turret-mk2", amount = 1},
          {type = "item", name = "palusium-plate", amount = 25},
          {type = "item", name = "palusium-crystal", amount = 20},
          {type = "item", name = "processing-unit", amount = 10}
      },
      results = {
          {type = "item", name = "uv-turret-mk3", amount = 1}
      }
    },
    {
      type = "recipe",
      name = "uv-turret-aoe",
      enabled = false,
      energy_required = 25,
      ingredients = {
          {type = "item", name = "uv-turret", amount = 1},
          {type = "item", name = "palusium-plate", amount = 20},
          {type = "item", name = "palusium-crystal", amount = 20},
          {type = "item", name = "processing-unit", amount = 5}
      },
      results = {
          {type = "item", name = "uv-turret-aoe", amount = 1}
      }
    },
    {
      type = "recipe",
      name = "uv-turret-chain",
      enabled = false,
      energy_required = 25,
      ingredients = {
          {type = "item", name = "uv-turret", amount = 1},
          {type = "item", name = "palusium-plate", amount = 20},
          {type = "item", name = "palusium-crystal", amount = 15},
          {type = "item", name = "processing-unit", amount = 5}
      },
      results = {
          {type = "item", name = "uv-turret-chain", amount = 1}
      }
    },
    {
      type = "recipe",
      name = "uv-spotlight",
      enabled = false,
      energy_required = 20,
      ingredients = {
          {type = "item", name = "inhibitor-lamp", amount = 1},
          {type = "item", name = "laser-turret", amount = 1},
          {type = "item", name = "palusium-crystal", amount = 50},
          {type = "item", name = "advanced-circuit", amount = 10}
      },
      results = {
          {type = "item", name = "uv-spotlight", amount = 1}
      }
    },

  })