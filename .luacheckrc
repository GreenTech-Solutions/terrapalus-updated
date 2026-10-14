-- Runs on top of the base config of factorio-mod-tools (lua/luacheckrc.lua), which sets std, the Factorio globals and
-- allow_defined_top: add to its tables here.
-- data-stage globals of __core__ and __base__ (circuit-connector-sprites, sound-util, factoriopedia-util) and PlanetsLib
for _, name in ipairs({
  "circuit_connector_definitions", "default_circuit_wire_max_distance", "sound_variations", "volume_multiplier",
  "make_resource", "PlanetsLib",
}) do
  read_globals[#read_globals + 1] = name
end
-- Style of the upstream code, kept as it is so that the diff with upstream stays readable: whitespace (611-614), unused
-- variables and arguments (211-213), shadowing (412, 421, 422), a field set twice in a table constructor (314; the later
-- value is the one the game sees, as before)
for _, code in ipairs({ "611", "612", "613", "614", "211", "212", "213", "314", "412", "421", "422" }) do
  ignore[#ignore + 1] = code
end
-- LuaSurface.daytime and freeze_daytime are writable; luacheck's std marks game.surfaces read-only
files["control.lua"] = { ignore = { "122" } }
