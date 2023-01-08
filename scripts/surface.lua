gauges.surface = prometheus.gauge("factorio_surface", "surface stats", {"surface", "type"})

local lib = {
  events = {
    [defines.events.on_tick] = function(event)
      if event.tick % 600 == 530 then
        local gauges = gauges

        for _, surface in pairs(game.surfaces) do
          local stats = {
            {surface.map_gen_settings.seed, "seed"},
            {surface.daytime, "daytime"},
            {surface.darkness, "darkness"},
            {surface.wind_speed, "wind_speed"},
            {surface.wind_orientation, "wind_orientation"},
            {surface.dusk, "dusk"},
            {surface.dawn, "dawn"},
            {surface.evening, "evening"},
            {surface.morning, "morning"}
          }

          for _, stat in pairs(stats) do
            gauges.surface:set(stat[1] or -1, {surface.name, stat[2]})
            -- peaceful_mode returns bool
            gauges.surface:set(surface.peaceful_mode and 1 or 0, {surface.name, "peaceful_mode"})
          end
        end

      end
    end
  }
}

return lib

