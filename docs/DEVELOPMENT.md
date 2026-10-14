# Terra Palus - Development Guide

This guide covers how to develop, test, and contribute to the Terra Palus mod.

## Setup

### Prerequisites

- Factorio 2.0.15 or higher
- Space Age DLC
- Text editor with Lua support (VS Code recommended)

### Installation for Development

1. Locate your Factorio mods folder:
   - Windows: `%APPDATA%\Factorio\mods\`
   - Linux: `~/.factorio/mods/`
   - macOS: `~/Library/Application Support/factorio/mods/`

2. Create a symlink or copy the mod folder:
   ```bash
   ln -s /path/to/terrapalus/terrapalus_0.1.4 ~/.factorio/mods/terrapalus_0.1.4
   ```

3. Enable the mod in Factorio's mod menu

### Useful Tools

- **Factorio Mod Portal**: https://mods.factorio.com
- **Lua API Documentation**: https://lua-api.factorio.com/latest/
- **Prototype Explorer**: In-game tool (F5)

## Project Structure

### Data Stage Files

Files loaded during game startup to define prototypes:

| File | Purpose |
|------|---------|
| `data.lua` | Entry point, requires all prototype files |
| `settings.lua` | Mod settings definitions |
| `prototypes/*.lua` | Entity, item, recipe definitions |

### Control Stage Files

Files loaded at runtime for game logic:

| File | Purpose |
|------|---------|
| `control.lua` | Event handlers, game mechanics |

### Resources

| Folder | Contents |
|--------|----------|
| `graphics/` | PNG sprites and icons |
| `sound/` | OGG audio files |
| `locale/` | Localization CFG files |

## Development Workflow

### Making Changes

1. **Prototype Changes** (items, entities, recipes):
   - Edit files in `prototypes/`
   - Restart Factorio to reload

2. **Runtime Changes** (control.lua):
   - Edit `control.lua`
   - Use `/c` console commands to reload or test
   - Full restart recommended for major changes

3. **Localization**:
   - Edit `locale/en/terrapalus.cfg`
   - Restart to see changes

### Testing

#### Quick Testing Commands

```lua
-- Teleport to Terra Palus
/c game.player.teleport({0, 0}, "terrapalus")

-- Give yourself items
/c game.player.insert{name="inhibitor-lamp", count=10}
/c game.player.insert{name="uv-turret", count=10}

-- Spawn enemies for testing
/c game.player.surface.create_entity{
  name="small-biter",
  position=game.player.position,
  force="enemy"
}

-- Chart area (reveal map)
/c game.player.force.chart(game.player.surface, {{-512, -512}, {512, 512}})

-- Debug frozen entities
/c for k, v in pairs(global.frozen_entities) do
  game.print(k .. ": " .. tostring(v.entity.valid))
end

-- Reset global state (careful!)
/c global.frozen_entities = {}
/c global.thawing_entities = {}
```

#### Debug Mode

Enable debug visualizations:
```lua
-- Show lamp radius
-- Already implemented via drawing.draw_circle in entities.lua
```

### Common Tasks

#### Adding a New Item

1. Define item in `prototypes/item/items.lua`:
   ```lua
   {
     type = "item",
     name = "my-new-item",
     icon = "__terrapalus-updated__/graphics/icons/my-item.png",
     icon_size = 64,
     subgroup = "intermediate-product",
     order = "a[my-item]",
     stack_size = 100
   }
   ```

2. Add recipe in `prototypes/recipe/recipes.lua`

3. Add technology unlock in `prototypes/technology.lua`

4. Add localization in `locale/en/terrapalus.cfg`:
   ```ini
   [item-name]
   my-new-item=My New Item

   [item-description]
   my-new-item=Description of what it does.
   ```

#### Adding a New Entity

1. Define entity prototype
2. Create sprites in `graphics/entity/`
3. Add item to place it
4. Add recipe to craft it
5. Add technology to unlock
6. Add localization

#### Modifying Map Generation

Edit `prototypes/planet/planet-terrapalus-map-gen.lua`:

```lua
-- Noise expressions control terrain generation
data:extend{{
  type = "noise-expression",
  name = "terrapalus_my_feature",
  expression = -- noise function
}}
```

## Code Style

### Lua Conventions

- Use `local` for all variables
- 2-space indentation
- Descriptive variable names
- Comment complex logic

### Prototype Naming

- Items: `palusium-*`
- Entities: descriptive (e.g., `inhibitor-lamp`)
- Technologies: match what they unlock
- Recipes: match output item

### File Organization

- One prototype type per file where possible
- Group related prototypes together
- Keep files under 500 lines

## Debugging

### Log Output

```lua
-- Print to console
game.print("Debug: " .. tostring(value))

-- Log to factorio-current.log
log("Debug: " .. serpent.block(table))
```

### Common Issues

**"Prototype not found"**
- Check spelling in requires
- Verify file is loaded in data.lua
- Check for syntax errors

**"Entity has no sprite"**
- Verify icon_size matches actual PNG
- Check file path is correct
- Ensure __modname__ syntax is correct

**Control script not running**
- Check for Lua syntax errors
- Verify event registration
- Check global table initialization

### Performance Profiling

```lua
-- Measure execution time
local start = game.tick
-- ... code ...
game.print("Took " .. (game.tick - start) .. " ticks")
```

## Building for Release

### Version Bump

1. Update `info.json`:
   ```json
   "version": "0.1.5"
   ```

2. Rename folder to match:
   ```
   terrapalus_0.1.5
   ```

3. Update `changelog.txt`

### Creating Release Package

```bash
cd /path/to/mod
zip -r terrapalus_0.1.5.zip terrapalus_0.1.5/
```

### Checklist Before Release

- [ ] All features tested
- [ ] No console errors
- [ ] Localization complete
- [ ] Changelog updated
- [ ] Version numbers match
- [ ] README updated
- [ ] Graphics optimized (PNG compression)

## Resources

### Documentation

- [Factorio Lua API](https://lua-api.factorio.com/latest/)
- [Prototype Definitions](https://wiki.factorio.com/Prototype_definitions)
- [Mod Portal Guidelines](https://wiki.factorio.com/Mod_portal)

### Community

- [Factorio Forums - Modding](https://forums.factorio.com/viewforum.php?f=82)
- [r/factorio](https://reddit.com/r/factorio)
- [Factorio Discord](https://discord.gg/factorio)

### Example Mods

- Space Exploration (complex planets)
- Krastorio 2 (tech trees)
- Bob's/Angel's (processing chains)
