# Terra Palus - Roadmap & Future Ideas

This document tracks planned features, improvements, and ideas for future development.

## High Priority

### UV Turret Improvements

- [DONE] **Turret Upgrade Research** - UV Turret MK2 (range 35, damage 35) and MK3 (range 42, damage 45)
- [DONE] **AoE Variants** - UV Turret AoE with 6 tile radius damage
- [DONE] **Chain Variant** - UV Turret Chain with primary target damage + nearby enemy chain damage
- [DONE] **Finalize Flee Behavior** - Enemies flee after hit from any UV turret variant

### Inhibitor Lamp Enhancements

- [DONE] **Range Upgrades** - Inhibitor Lamp MK2 (40% range) and MK3 (80% range)
- [DONE] **Spotlight Variants** - UV Spotlight turret that freezes enemies with sustained beam
- [DONE] **Damage Variants** - Inhibitor Lamp Damage with 50% slow + damage over time
- [ ] **Purple Map Icons** - Make lamp icons purple on minimap for visibility

### Ultravium Fluid Usage

- [DONE] **Ultravium Batteries** - Consumable items to charge power armor (10/50/200 MJ tiers)
- [DONE] **Armor Charging Stations** - Wireless charging for power armor (15/22/30 tile radius tiers)
- [ ] **UV Grenades** - Throwable stun grenades using Ultravium
- [ ] **UV Pucks** - Solid ammo form (like carbon) for grenade launchers
- [ ] **UV Liquid Turret** - Flamethrower-style turret spraying Ultravium
- [ ] **Fuel Usage** - Ultravium as high-energy fuel source

### Processing Chain

- [ ] **Ground Crusher Entity** - New machine to crush Palusium ore into powder
- [ ] **Complete Light Defense Tech Tree** - Full research chain for all UV weapons

## Medium Priority

### Equipment & Personal Defense

- [DONE] **UV Defense Turret** - Equipment grid turret that causes enemies to flee when hit
- [DONE] **UV Personal Shield** - Equipment that freezes nearby enemies within 10 tiles
- [DONE] **Strafer Projectile Interception** - UV Personal Shield also destroys incoming Strafer projectiles

### Strafer Projectile Defense (Technical Reference)

Strafer pentapods shoot guided projectile entities that spawn wrigglers on impact:
- `small-strafer-projectile`
- `medium-strafer-projectile`
- `big-strafer-projectile`

These are type `"projectile"` with:
- Low acceleration (0.001), slow turning (0.002), max speed 1
- Track targets with `turning_speed_increases_exponentially_with_projectile_speed`
- On impact: 90 damage (scaled), slowdown sticker, spawns wriggler entity

Defense approach: `on_tick` scans for projectile entities near players with UV shield and destroys them.

### Visual Effects

- [ ] **Ghost Animation** - Apply stasis/ghost effect to frozen enemies
- [ ] **Better Freeze Visual** - Ice crystals or energy field around frozen entities
- [ ] **UV Beam Colors** - More distinct visual for UV turret beam

### Audio

- [ ] **Fix Music Transitions** - Currently cuts in/out abruptly
- [ ] **Add Interlude Tracks** - Silence/ambient between main tracks
- [ ] **Theme-Appropriate Music** - Replace some tracks with better-fitting ambient
- [ ] **Additional Tracks to Add:**
  - Turf War (crime scene)
  - Mysterious Celesta
  - Mysterious Ambient Suspense
  - Sad Violin
  - Peaceful Eerie Piano

  ● Here's the current audio setup in prototypes/ambient-sounds.lua:

  Current State:
  - 5 main tracks (terrapalus-1 through terrapalus-5)
  - All have equal weight (10)
  - No interlude/silence tracks
  - No fade parameters configured

  Issues & Fixes:

  1. Fix Music Transitions - The ambient-sound prototype supports fade_in_ticks and fade_out_ticks parameters to
  smooth transitions
  2. Add Interlude Tracks - Can add track_type = "interlude" entries (see commented Gleba examples at lines 128-129)
  3. Additional Tracks - Would need to add .ogg files to sound/ambient/terrapalus/ and register them

  Would you like me to:
  - A) Add fade parameters to existing tracks to fix abrupt transitions?
  - B) Add interlude track entries (you'd need to provide the audio files)?
  - C) Review Factorio's ambient-sound API to see all available options?
  - D) Something else?

### Planet Improvements

- [DONE] **Fix Starmap Orbit** - Show orbiting Gleba, not sun
- [ ] **Planet Icon** - Finalize the starmap icon design
- [ ] **Cargo Pod Support** - Research based on latest FFF updates

## Low Priority / Ideas

### Balancing

- [ ] **Recipe Balancing** - Review all recipe costs and times
- [DONE] **Stack Sizes** - Add proper weight parameters to all items
- [ ] **Science Pack Costs** - Balance tech tree costs

### Quality of Life

- [ ] **Factoriopedia Fixes** - Palusium ore preview shows single ore, should show richer
- [ ] **Better Entity Descriptions** - More detailed locale strings
- [ ] **Settings Tooltips** - Improved setting descriptions

### Advanced Features

- [ ] **Surface Global Effects** - Use `LuaSurface.global_effect` for prod/speed modifiers
- [ ] **EffectReceiver Integration** - `uses_surface_effects` for entity bonuses
- [ ] **Biter/Pentapod Hybrid** - Custom enemy type unique to Terra Palus
- [ ] **Underground Resources** - Deep palusium deposits requiring special mining

### Compatibility

- [ ] **Mod Compatibility** - Test with popular mods
- [ ] **Settings Presets** - Easy/Normal/Hard difficulty presets

## Known Bugs to Fix

- [DONE] Starmap shows moon orbiting sun instead of Gleba
- [ ] Pentapod eggs auto-collect into inventory
- [ ] Frozen enemies stay frozen if lamp deleted during save/load
- [ ] Items stuck under placed containers (Factorio 2.0 issue?)
- [DONE] Rocket stacking weight parameters missing on some items

## Technical Debt

- [ ] **Code Cleanup** - Refactor control.lua for better organization
- [ ] **Performance Optimization** - Profile and optimize tick processing
- [ ] **Error Handling** - Better validation and error messages
- [ ] **Unit Tests** - Add test scenarios for core mechanics

## Research Links

Useful references for implementation:

- [Factorio Lua API - LuaSurface](https://lua-api.factorio.com/latest/classes/LuaSurface.html#global_effect)
- [EffectReceiver Type](https://lua-api.factorio.com/latest/types/EffectReceiver.html#uses_surface_effects)
- [2.0 Mod Porting Guide](https://github.com/tburrows13/factorio-2.0-mod-porting-guide/blob/master/utilising-2.0-features.md)

## Version History Goals

### v0.2.0 - Light Defense Complete
- Ground crusher entity
- Complete Light Defense tech tree
- UV grenades from Ultravium

### v0.3.0 - Turret Upgrades
- Range/damage research for UV turret
- Multi-target turret variant
- Personal UV laser equipment

### v0.4.0 - Polish
- Fix all known bugs
- Music improvements
- Visual effect polish

### v1.0.0 - Release
- Full balance pass
- Mod compatibility
- Complete documentation
