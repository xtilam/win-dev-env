require("dinz-globals.globals")
require("dinz.apply-actions")
require("config.autocmds")

require(_G.__MODULE_INIT__ or "config.lazy")
