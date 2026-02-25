vim.loader.enable()

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("settings")

require("plugins")

-- Big-file guard: disable Snacks indent for very large files to avoid lag
vim.api.nvim_create_autocmd("BufReadPre", {
	group = vim.api.nvim_create_augroup("BigFileGuard", { clear = true }),
	callback = function(args)
		local ok, stat = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(args.buf))
		if ok and stat and stat.size > 1024 * 1024 then
			vim.b[args.buf].snacks_indent = false
		end
	end,
})
