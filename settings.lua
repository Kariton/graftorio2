data:extend({
	{
		type = "string-setting",
		name = "graftorio2-train-histogram-buckets",
		setting_type = "startup",
		default_value = "10,30,60,90,120,180,240,300,600",
		allow_blank = false,
	},
	{
		type = "bool-setting",
		name = "graftorio2-server-save",
		setting_type = "runtime-global",
		default_value = false,
		allow_blank = false,
	},
	{
		type = "bool-setting",
		name = "graftorio2-disable-detailed-train-stats",
		setting_type = "runtime-global",
		default_value = false,
		allow_blank = false,
	},
})
