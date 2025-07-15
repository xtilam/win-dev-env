return function(o)
    o.servers.jsonls = {
        on_new_config = function(new_config)
            local schemastore_schemas = require("schemastore").json.schemas()
            new_config.settings = new_config.settings or {}
            new_config.settings.json = new_config.settings.json or {}
            new_config.settings.json.schemas =
                vim.tbl_deep_extend("force", new_config.settings.json.schemas or {}, schemastore_schemas)
        end,
        settings = {
            json = {
                validate = { enable = true },
                schemas = {
                    {
                        fileMatch = { "tsconfig.json", "tsconfig.*.json" },
                        url = "https://json.schemastore.org/tsconfig.json",
                    },
                },
            },
        },
    }
end
