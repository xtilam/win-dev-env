return function(o)
    o.servers.tailwindcss = {
        settings = {
            tailwindCSS = {
                experimental = {
                    classRegex = {
                        { "twJoin\\(([^)]*)\\)", "[\"'`]([^\"'`]+)[\"'`]" },
                    },
                },
            },
        },
    }
end
