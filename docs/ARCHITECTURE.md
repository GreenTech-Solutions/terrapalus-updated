# Terra Palus - Technical Architecture

This document describes the technical structure and implementation details of the Terra Palus mod.

## File Structure

```
terrapalus_0.1.4/
├── info.json                    # Mod metadata (name, version, dependencies)
├── data.lua                     # Data stage entry point
├── control.lua                  # Runtime control script (game logic)
├── settings.lua                 # Mod startup settings
├── changelog.txt                # Version history
│
├── prototypes/                  # All game content definitions
│   ├── planet/
│   │   ├── planet.lua                              # Planet definition
│   │   ├── planet-terrapalus-map-gen.lua           # Map generation (noise expressions)
│   │   └── surface-render-parameter-effects.lua    # Visual effects (fog, clouds)
│   │
│   ├── entity/
│   │   ├── entities.lua         # Inhibitor lamp, stickers
│   │   ├── resources.lua        # Palusium ore resource
│   │   └── turrets.lua          # UV turret entity + beam
│   │
│   ├── item/
│   │   └── items.lua            # All items (ores, plates, equipment)
│   │
│   ├── recipe/
│   │   └── recipes.lua          # All crafting recipes
│   │
│   ├── technology.lua           # Tech tree structure
│   ├── fluid.lua                # Ultravium fluid
│   ├── stickers.lua             # Frozen/thawing stickers
│   ├── autoplace-controls.lua   # Resource generation controls
│   ├── ambient-sounds.lua       # Planet soundtrack
│   └── factoriopedia-simulations.lua
│
├── locale/en/
│   └── terrapalus.cfg           # English localization
│
├── graphics/                    # Visual assets
│   ├── entity/                  # Entity sprites
│   ├── icons/                   # Item/tech icons
│   ├── technology/              # Tech tree icons
│   └── *.png                    # Atmosphere textures
│
└── sound/ambient/terrapalus/    # 5 ambient music tracks
```

## Data Flow

### Loading Stages

1. **Settings Stage** (`settings.lua`)
   - Defines startup settings (freeze duration, radius, etc.)
   - Settings available via `settings.startup["setting-name"].value`

2. **Data Stage** (`data.lua`)
   - Loads all prototype definitions
   - Order: autoplace-controls → ambient-sounds → fluids → stickers → items → resources → entities → turrets → recipes → technology → planet

3. **Control Stage** (`control.lua`)
   - Runtime game logic
   - Event handlers for game interactions

## Core Systems

### 1. Planet System

**Definition:** `prototypes/planet/planet.lua`

Key properties:
- Orbits Gleba (not the sun)
- Daytime locked at 0.5 (midnight)
- Solar power: 20 (minimal)
- Spawns both biters and pentapods (gleba-spawner)

### 2. Inhibitor Lamp System

**Entity:** Electric lamp with 18-tile freeze radius

**Control Flow:**
```
on_tick → process_lamps() → find_enemies_in_radius()
                         → apply frozen-sticker
                         → after FREEZE_DURATION: entity.active = false
```

**State Tracking:**
```lua
global.inhibitor_lamps = {lamp1, lamp2, ...}
global.frozen_entities[unit_number] = {
  entity = reference,
  freeze_start_tick = game.tick,
  is_freezing = boolean
}
global.thawing_entities[unit_number] = {
  entity = reference,
  thaw_start_tick = game.tick
}
```

### 3. UV Turret System

**Entity:** Electric turret with beam attack

**Behavior:**
- Fires UV beam at enemies
- Applies stun sticker + push-back
- Triggers flee command via `on_entity_damaged` event

### 4. Sticker System

| Sticker | Duration | Effect |
|---------|----------|--------|
| `frozen-sticker` | 600 ticks | Movement: 1.0 → 0.0 |
| `thawing-sticker` | 240 ticks | Movement: 0.0 → 1.0 |
| `uv-turret-burn-sticker` | 480 ticks | Visual smoke effect |

### 5. Map Generation

**File:** `prototypes/planet/planet-terrapalus-map-gen.lua`

Uses noise expressions to blend:
- Nauvis terrain (elevation 80-120)
- Gleba terrain (muddy swamps)
- Custom moisture/temperature calculations

Key expressions:
- `terrapalus_elevation` - Base terrain height
- `terrapalus_lowland_basis` - Swamp placement
- `terrapalus_spawner` - Enemy base frequency

## Processing Pipeline

### Palusium Processing Chain

```
Palusium Ore (50)
    → [smelt] → Palusium Plate (1)
    → [crush] → Palusium Powder (1)
    → [refine + water] → Palusium Crystal (1)
    → [chemistry + oil] → Ultravium fluid (50)
```

### Technology Tree

```
planet-discovery-gleba
    └── planet-discovery-terrapalus (500 science)
        ├── palusium-processing (150)
        └── palusium-crushing (150)
            ├── palusium-liquefaction (150)
            └── palusium-refining (150)
                └── inhibitor-lamp (150)
                    └── uv-turret (150)
```

## Performance Considerations

### Tick-Based Processing

The control script processes lamps in batches to avoid lag:

```lua
local LAMPS_PER_TICK = 10
global.lamp_index cycles through all lamps
```

### Entity Tracking

Uses `unit_number` as dictionary key for O(1) lookups:
- Avoids iterating all entities each tick
- Tracks frozen/thawing state separately

### Event Filtering

Events filtered by entity name where possible:
- `on_entity_damaged` checks damage source
- `on_built_entity` filters for "inhibitor-lamp"

## Global State

```lua
global = {
  inhibitor_lamps = {},      -- Active lamp entities
  lamp_index = 1,            -- Current processing index
  frozen_entities = {},      -- {unit_number: data}
  thawing_entities = {}      -- {unit_number: data}
}
```

Initialized in `on_init` event handler.

## Dependencies

- **base** >= 2.0.15
- **space-age** (required for planetary mechanics)

## Configuration

All settings in `settings.lua`:

| Setting | Default | Range | Description |
|---------|---------|-------|-------------|
| `inhibitor-freeze-duration` | 120 | 0-10000 | Ticks before full freeze |
| `inhibitor-thaw-duration` | 120 | 0-10000 | Ticks to thaw |
| `inhibitor-radius` | 18 | 1-100 | Lamp effect radius |
| `surface-pressure` | 2000 | 1000-4000 | Atmospheric pressure (hPa) |
| `freeze-daytime` | true | - | Lock daytime value |
| `daytime-value` | 0.5 | 0-1 | Time of day (0.5 = midnight) |
| `terrapalus-lowland-size` | 15 | 5-30 | Swamp size modifier |
