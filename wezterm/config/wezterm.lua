local wezterm = require("wezterm")
local config = wezterm.config_builder()
local color = wezterm.color
local os = require("os")
local act = wezterm.action
local opts = require("opts")

function printTable(t, indent)
	indent = indent or 0
	local prefix = string.rep("  ", indent)

	for k, v in pairs(t) do
		if type(v) == "table" then
			print(prefix .. tostring(k) .. " = {")
			printTable(v, indent + 1)
			print(prefix .. "}")
		else
			print(prefix .. tostring(k) .. " = " .. tostring(v))
		end
	end
end

local function applyConfig()
	local default_padding = { 0, 0 }
	config.default_prog = { os.getenv("SHELL") }
	config.font = wezterm.font({
		family = "Cascadia Code NF",
		weight = "DemiBold",
	})

	config.freetype_load_flags = "NO_HINTING"
	config.color_scheme = "Dracula"
	config.window_decorations = "RESIZE" .. (opts.hide_titlebar and "" or " | TITLE")
	config.enable_tab_bar = false
	config.scroll_to_bottom_on_input = false
	config.default_cursor_style = "BlinkingBlock"
	config.animation_fps = 1
	config.cursor_blink_ease_in = "Constant"
	config.cursor_blink_ease_out = "Constant"

	config.colors = {}
	config.colors.background = "rgba(" .. opts.background .. "," .. opts.opacity .. ")"
	config.window_background_opacity = opts.opacity
	config.font_size = opts.font_size
	config.color_scheme = "Dracula"
	config.cursor_blink_rate = 800
	config.window_padding = {
		left = default_padding[2],
		right = default_padding[2],
		top = default_padding[1],
		bottom = default_padding[1],
	}
	config.keys = {}
	local function addKey(key, mods, action)
		table.insert(config.keys, { key = key, mods = mods, action = action })
	end

	addKey("w", "ALT", act.CloseCurrentPane({ confirm = false }))
	addKey("Tab", "CTRL", act.ActivateLastTab)
	-- for i = 1, 8 do
	-- 	addKey(tostring(i), "ALT", act.ActivateTab(i - 1))
	-- end
end

local function setupDev()
	local is_dev = os.getenv("NODE_ENV") == "development"
	if not is_dev then
		return
	end
end

------------------------------------------------------------
setupDev()
applyConfig()
------------------------------------------------------------
return config
