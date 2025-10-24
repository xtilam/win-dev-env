local opts = {}
opts.font_size = 12
opts.opacity = 0.95
opts.hide_titlebar = true
opts.background = "20,20,20"

-------------------------------------
local COLORS = {
	black = "0,0,0",
	red = "255,85,85",
	green = "80,250,123",
	yellow = "241,250,140",
	blue = "189,147,249",
	magenta = "255,121,198",
	cyan = "139,233,253",
	white = "255,255,255",
	light_black = "68,71,90",
	light_red = "255,85,85",
	light_green = "80,250,123",
	light_yellow = "241,250,140",
	light_blue = "189,147,249",
	light_magenta = "255,121,198",
	light_cyan = "139,233,253",
}

opts.background = COLORS[opts.background] or opts.background
return opts
