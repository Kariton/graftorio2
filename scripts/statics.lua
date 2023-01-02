local translate = require("scripts/translation")
gauges.tick = prometheus.gauge("factorio_tick", "game tick")
gauges.connected_player_count = prometheus.gauge("factorio_connected_player_count", "connected players")
gauges.total_player_count = prometheus.gauge("factorio_total_player_count", "total registered players")
gauges.seed = prometheus.gauge("factorio_seed", "seed", {"surface"})
gauges.mods = prometheus.gauge("factorio_mods", "mods", {"name", "version"})

gauges.pollution_production_input = prometheus.gauge("factorio_pollution_production_input", "pollutions produced", {"name", "localised_name"})
gauges.pollution_production_output = prometheus.gauge("factorio_pollution_production_output", "pollutions consumed", {"name", "localised_name"})

local lib = {
  events = {
    [defines.events.on_tick] = function(event)
      if event.tick % 600 == 520 then
        local is_collected_once = {
          surfaces = false,
          mods = false,
        }

        local gauges = gauges
        local table_size = table_size

        gauges.tick:set(event.tick)
        gauges.connected_player_count:set(table_size(game.connected_players))
        gauges.total_player_count:set(table_size(game.players))

        if not is_collected_once.surfaces then
          for _, surface in pairs(game.surfaces) do
            gauges.seed:set(surface.map_gen_settings.seed, {surface.name})
          end
          is_collected_once.surfaces = true
        end

        if not is_collected_once.mods then
          for name, version in pairs(game.active_mods) do
            gauges.mods:set(1, {name, version})
          end
          is_collected_once.mods = true
        end

        local stats = {
          {game.pollution_statistics, gauges.pollution_production_input, gauges.pollution_production_output, "entity-name"}
        }

        for _, stat in pairs(stats) do
          for name, n in pairs(stat[1].input_counts) do
            translate.translate(
              {stat[4] .. "." .. name},
              function(translated)
                stat[2]:set(n, {name, translated})
              end
            )
          end

          for name, n in pairs(stat[1].output_counts) do
            translate.translate(
              {stat[4] .. "." .. name},
              function(translated)
                stat[3]:set(n, {name, translated})
              end
            )
          end
        end
      end
    end
  }
}
return lib
