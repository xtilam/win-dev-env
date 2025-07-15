return function(o)
    o.servers.bacon_ls = { enabled = diagnostics == "bacon-ls" }
    o.servers.rust_analyzer = { enabled = false }
end
