local ok, fmt = pcall(require, "conform")
if not ok then
	return
end

fmt.setup({
	formatters_by_ft = {
		lua = { "stylua" },
		c = { "clang-format" },
		cpp = { "clang-format" },
		rust = { "rustfmt" },
		go = { "gofmt" },
	},
})

vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*",
	callback = function(args)
		fmt.format({ bufnr = args.buf })
	end,
})

vim.api.nvim_create_user_command("DisableLspFormatting", function()
	vim.api.nvim_clear_autocmds({ buffer = 0 })
end, { nargs = 0 })
