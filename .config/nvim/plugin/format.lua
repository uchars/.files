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

vim.keymap.set("n", "<leader>fm", function()
	fmt.format()
end)
