gauges.yarm_site_amount = prometheus.gauge("factorio_yarm_site_amount", "YARM - site amount remaining", { "force", "name", "type" })
gauges.yarm_site_ore_per_minute = prometheus.gauge("factorio_yarm_site_ore_per_minute", "YARM - site ore per minute", { "force", "name", "type" })
gauges.yarm_site_remaining_permille = prometheus.gauge("factorio_yarm_site_remaining_permille", "YARM - site permille remaining", { "force", "name", "type" })

local function handleYARM(site)
      local gauges = gauges
      gauges.yarm_site_amount:set(site.amount, { site.force_name, site.site_name, site.ore_type })
      gauges.yarm_site_ore_per_minute:set(site.ore_per_minute, { site.force_name, site.site_name, site.ore_type })
      gauges.yarm_site_remaining_permille:set(site.remaining_permille, { site.force_name, site.site_name, site.ore_type })
end

local lib = {
  on_load = function()
    if global.yarm_on_site_update_event_id then
      if script.get_event_handler(global.yarm_on_site_update_event_id) then
        script.on_event(global.yarm_on_site_update_event_id, handleYARM)
      end
    end
  end,

  on_init = function()
    if game.active_mods["YARM"] then
      global.yarm_on_site_update_event_id = remote.call("YARM", "get_on_site_updated_event_id")
        script.on_event(global.yarm_on_site_update_event_id, handleYARM)
    end
  end,

  on_configuration_changed = function(event)
    if game.active_mods["YARM"] then
      global.yarm_on_site_update_event_id = remote.call("YARM", "get_on_site_updated_event_id")
        script.on_event(global.yarm_on_site_update_event_id, handleYARM)
    end
  end,
}

return lib
