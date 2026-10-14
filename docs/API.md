# Terra Palus - Control Script API

This document describes the runtime mechanics and event handlers in `control.lua`.

## Configuration Constants

```lua
local FREEZE_DURATION = settings.startup["inhibitor-freeze-duration"].value
local THAW_DURATION = settings.startup["inhibitor-thaw-duration"].value
local INHIBITOR_RADIUS = settings.startup["inhibitor-radius"].value
local LAMPS_PER_TICK = 10
```

## Global State Structure

```lua
global.inhibitor_lamps = {}      -- List of lamp entity references
global.lamp_index = 1            -- Circular index for processing
global.frozen_entities = {}      -- Dictionary keyed by unit_number
global.thawing_entities = {}     -- Dictionary keyed by unit_number
```

### Frozen Entity Data

```lua
global.frozen_entities[unit_number] = {
  entity = LuaEntity,           -- The frozen enemy
  freeze_start_tick = number,   -- When freeze started
  is_freezing = boolean         -- Whether actively freezing
}
```

### Thawing Entity Data

```lua
global.thawing_entities[unit_number] = {
  entity = LuaEntity,           -- The thawing enemy
  thaw_start_tick = number      -- When thaw started
}
```

## Event Handlers

### Initialization

#### `on_init`
Called when mod is first loaded into a save.

```lua
script.on_init(function()
  global.inhibitor_lamps = {}
  global.lamp_index = 1
  global.frozen_entities = {}
  global.thawing_entities = {}
end)
```

#### `on_configuration_changed`
Called when mod version changes or configuration updates.

### Entity Events

#### `on_built_entity` / `on_robot_built_entity`
Tracks new inhibitor lamps.

```lua
-- Filter: {filter = "name", name = "inhibitor-lamp"}
if entity.name == "inhibitor-lamp" then
  table.insert(global.inhibitor_lamps, entity)
end
```

#### `on_entity_died` / `on_player_mined_entity`
Removes lamps from tracking when destroyed or mined.

#### `on_entity_damaged`
Handles UV turret hits to trigger enemy flee behavior.

```lua
if cause and cause.name == "uv-turret" then
  command_enemy_to_flee(entity, cause)
end
```

### Player Events

#### `on_player_changed_surface`
Removes night vision equipment when entering Terra Palus.

```lua
if surface.name == "terrapalus" then
  -- Remove night-vision-equipment from armor
  -- Move to player inventory with warning message
end
```

#### `on_player_placed_equipment`
Prevents equipping night vision on Terra Palus.

#### `on_player_joined_game`
Checks for night vision on game load.

### Surface Events

#### `on_surface_created`
Sets daytime to frozen value when surface is created.

```lua
if surface.name == "terrapalus" then
  surface.daytime = settings.startup["daytime-value"].value
  surface.freeze_daytime = settings.startup["freeze-daytime"].value
end
```

### Tick Processing

#### `on_tick`
Main game loop, runs every tick (60/second).

```lua
script.on_event(defines.events.on_tick, function(event)
  process_lamps()
  process_frozen_entities()
  update_thawing_entities()
end)
```

## Core Functions

### `process_lamps()`

Processes a batch of lamps each tick.

**Logic:**
1. Process up to `LAMPS_PER_TICK` lamps
2. For each lamp:
   - Skip if invalid or unpowered
   - Find enemies within `INHIBITOR_RADIUS`
   - Apply freeze effect to new enemies
3. Cycle `global.lamp_index`

**Enemy Detection:**
```lua
local enemies = lamp.surface.find_entities_filtered{
  position = lamp.position,
  radius = INHIBITOR_RADIUS,
  force = "enemy",
  type = {"unit", "unit-spawner", "turret"}
}
```

### `freeze_enemy(entity)`

Applies freeze effect to an entity.

**Steps:**
1. Apply `frozen-sticker` immediately
2. Track in `global.frozen_entities`
3. After `FREEZE_DURATION` ticks: set `entity.active = false`

```lua
entity.surface.create_entity{
  name = "frozen-sticker",
  position = entity.position,
  target = entity
}
```

### `process_frozen_entities()`

Checks if frozen entities are still in lamp range.

**Logic:**
1. For each frozen entity:
   - Check if any lamp covers it
   - If not: start thawing process
2. Remove invalid entities

### `update_thawing_entities()`

Handles the thawing process.

**Logic:**
1. Apply `thawing-sticker` when thaw starts
2. Reactivate entity: `entity.active = true`
3. After `THAW_DURATION`: remove from tracking
4. Cleanup invalid entities

### `command_enemy_to_flee(entity, cause)`

Issues flee command to enemies hit by UV turret.

```lua
if entity.commandable then
  entity.commandable.set_command{
    type = defines.command.flee,
    from = cause,
    distraction = defines.distraction.none
  }
end
```

### `is_in_lamp_range(entity)`

Checks if entity is within range of any active lamp.

```lua
for _, lamp in ipairs(global.inhibitor_lamps) do
  if lamp.valid and lamp.is_connected_to_electric_network() then
    local distance = -- calculate distance
    if distance <= INHIBITOR_RADIUS then
      return true
    end
  end
end
return false
```

## Entity Types Affected

### Freezable Entities
- `unit` (biters, spitters, pentapods)
- `unit-spawner` (nests)
- `turret` (worms)

### Excluded
- Player entities
- Friendly forces
- Vehicles

## Sticker Effects

### frozen-sticker
```lua
{
  type = "sticker",
  duration_in_ticks = 600,
  target_movement_modifier = 0,
  vehicle_speed_modifier = 0
}
```

### thawing-sticker
```lua
{
  type = "sticker",
  duration_in_ticks = 240,
  target_movement_modifier_from = 0,
  target_movement_modifier_to = 1
}
```

## Debug Commands

Useful console commands for testing:

```lua
-- Force chunk generation
/c game.player.force.chart(game.player.surface, {{-1024, -1024}, {1024, 1024}})

-- Set daytime
/c game.player.surface.daytime = 0.5

-- List frozen entities
/c for k, v in pairs(global.frozen_entities) do game.print(k) end

-- Count active lamps
/c game.print(#global.inhibitor_lamps)
```

## Performance Notes

- Lamps processed in batches of 10 per tick
- Entity lookups use unit_number dictionary keys
- Invalid entities cleaned up during normal processing
- Event filters reduce unnecessary handler calls
