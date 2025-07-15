local wezterm = require("wezterm")
local tabs_module = {}

function tabs_module.apply_to_config(config)
	-- The filled in variant of the < symbol

	local SOLID_LEFT_ARROW = wezterm.nerdfonts.pl_right_hard_divider

	-- The filled in variant of the > symbol
	local SOLID_RIGHT_ARROW = wezterm.nerdfonts.pl_left_hard_divider

	config.tab_bar_style = {
		active_tab_left = wezterm.format({
			{ Background = { Color = "#0b0022" } },
			{ Foreground = { Color = "#2b2042" } },
			{ Text = SOLID_LEFT_ARROW },
		}),
		active_tab_right = wezterm.format({
			{ Background = { Color = "#0b0022" } },
			{ Foreground = { Color = "#2b2042" } },
			{ Text = SOLID_RIGHT_ARROW },
		}),
		inactive_tab_left = wezterm.format({
			{ Background = { Color = "#0b0022" } },
			{ Foreground = { Color = "#1b1032" } },
			{ Text = SOLID_LEFT_ARROW },
		}),
		inactive_tab_right = wezterm.format({
			{ Background = { Color = "#0b0022" } },
			{ Foreground = { Color = "#1b1032" } },
			{ Text = SOLID_RIGHT_ARROW },
		}),
	}
end

return tabs_module
