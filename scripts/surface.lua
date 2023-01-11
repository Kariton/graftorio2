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
            {surface.wind_orientation_change, "wind_orientation_change"},
            {surface.dusk, "dusk"},
            {surface.dawn, "dawn"},
            {surface.evening, "evening"},
            {surface.morning, "morning"}
          }

          for _, stat in pairs(stats) do
            gauges.surface:set(stat[1] or -1, {surface.name, stat[2]})
          end

          -- returns bool
          local bool_stats = {
            {surface.peaceful_mode, "peaceful_mode"},
            {surface.always_day, "always_day"},
            {surface.freeze_daytime, "freeze_daytime"},
            {surface.show_clouds, "show_clouds"}
          }

          for _, stat in pairs(bool_stats) do
            gauges.surface:set(stat[1] and 1 or 0, {surface.name, stat[2]})
          end

        end
      end
    end
  }
}

return lib

