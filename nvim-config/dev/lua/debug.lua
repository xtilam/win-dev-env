_G.nvimDbg = {}
vim.notify("Debugging mode enabled", vim.log.levels.INFO, { title = "nvimDbg" })
function nvimDbg.forceClose()
	while true do
		vim.cmd("cquit! 1000")
	end
end

function nvimDbg.normalClose()
	vim.cmd("qa!")
end

vim.keymap.set("n", "<C-M-E>", nvimDbg.forceClose)
vim.api.nvim_create_user_command("CQ", nvimDbg.forceClose, {})
