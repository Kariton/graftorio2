local translate = require("scripts/translation")

gauges.yarm_resource_monitor = prometheus.gauge("factorio_yarm_resource_monitor", "YARM - Resource Monitor stats", { "force", "site", "site_name", "name", "localised_name", "type" })

local function alphanumeric(str)
  return str:gsub('%W','_')
end

local function handleYARM(site)
      local gauges = gauges
      local item_prototypes = game.item_prototypes
      local fluid_prototypes = game.fluid_prototypes

      local stats = {
		{site.amount, gauges.yarm_resource_monitor, "amount"},
		{site.ore_per_minute, gauges.yarm_resource_monitor, "ore_per_minute"},
		{site.remaining_permille, gauges.yarm_resource_monitor, "remaining_permille"},
                {site.etd_minutes, gauges.yarm_resource_monitor, "etd_minutes"}
	  }

      for _, stat in pairs(stats) do
	      local site_name = string.lower(alphanumeric(site.site_name))
		  local name = site.ore_type

          if item_prototypes[name] then
            translate.translate(
              item_prototypes[name].localised_name,
              function(translated)
                stat[2]:set(stat[1], {site.force_name, site_name, site.site_name, name, translated, stat[3]})
              end
            )
          elseif fluid_prototypes[name] then
            translate.translate(
              fluid_prototypes[name].localised_name,
              function(translated)
                stat[2]:set(stat[1], {site.force_name, site_name, site.site_name, name, translated, stat[3]})
              end
            )
		  else
              stat[2]:set(stat[1], {site.force_name, site_name, site.site_name, name, translated, stat[3]})
          end
	  end

end

local lib = {
  on_load = function()
    if remote.interfaces["YARM"] then
      script.on_event(remote.call("YARM", "get_on_site_updated_event_id"), handleYARM)
    end
  end,

  on_init = function()
    if remote.interfaces["YARM"] then
      script.on_event(remote.call("YARM", "get_on_site_updated_event_id"), handleYARM)
    end
  end,

  on_configuration_changed = function(event)
    if remote.interfaces["YARM"] then
      script.on_event(remote.call("YARM", "get_on_site_updated_event_id"), handleYARM)
    end
  end,
}

return lib
