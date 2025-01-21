local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
local git_installed = vim.fn.executable("git") == 1
if not git_installed then
	return
end

if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	{
		"stevearc/oil.nvim",
		tag = "stable",
	},
	"tpope/vim-surround",

	-- Git related plugins
	"tpope/vim-fugitive",

	"nvim-tree/nvim-web-devicons",
	-- Detect tabstop and shiftwidth automatically
	"tpope/vim-sleuth",
	{ "xiyaowong/transparent.nvim", commit = "fd35a46" },

	{
		"lervag/vimtex",
		lazy = false,
		tag = "v2.15",
		init = function()
			vim.g.vimtex_view_method = "zathura"
			vim.g.vimtex_compiler_method = "latexmk"
			vim.g.maplocalleader = ";"
		end,
	},

	{
		"danymat/neogen",
		config = function()
			require("neogen").setup({})
			vim.keymap.set("n", "<leader>ng", function()
				require("neogen").generate({})
			end)
		end,
		tag = "2.19.4",
	},
	{
		"neovim/nvim-lspconfig",
		tag = "v0.1.8",
		dependencies = {
			{
				"williamboman/mason.nvim",
				config = true,
				tag = "v1.10.0",
			},
			{
				"williamboman/mason-lspconfig.nvim",
				tag = "v1.29.0",
			},
			{
				"jay-babu/mason-null-ls.nvim",
				tag = "v2.6.0",
			},
			"jose-elias-alvarez/null-ls.nvim",
			{
				"ray-x/lsp_signature.nvim",
				tag = "v0.3.1",
			},
			{
				"j-hui/fidget.nvim",
				tag = "legacy",
			},
			"folke/neodev.nvim",
			{
				"folke/trouble.nvim",
				tag = "v3.6.0",
				cmd = "Trouble",
			},
		},
	},

	{
		"hrsh7th/nvim-cmp",
		commit = "a110e12",
		dependencies = {
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-path",
		},
	},

	{
		"lewis6991/gitsigns.nvim",
		tag = "release",
	},

	{
		"numToStr/Comment.nvim",
		tag = "v0.8.0",
	},

	{
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"ThePrimeagen/git-worktree.nvim",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
				cond = function()
					return vim.fn.executable("make") == 1
				end,
			},
		},
	},

	{
		-- Highlight, edit, and navigate code
		"nvim-treesitter/nvim-treesitter",
		tag = "v0.9.2",
		dependencies = {
			"nvim-treesitter/nvim-treesitter-context",
			-- { dir = "$HOME/src/nvim-treesitter-context" },
			"nvim-treesitter/playground",
		},
		build = ":TSUpdate",
	},

	{
		"windwp/nvim-ts-autotag",
		commit = "e239a56",
	},

	"ThePrimeagen/harpoon",
	{
		"mbbill/undotree",
		config = function()
			vim.keymap.set("n", "<leader>u", "<cmd>UndotreeToggle<CR>")
		end,
	},

	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		ft = { "markdown" },
		build = function(plugin)
			if vim.fn.executable("npx") then
				vim.cmd("!cd " .. plugin.dir .. " && cd app && npx --yes yarn install")
			else
				vim.cmd([[Lazy load markdown-preview.nvim]])
				vim.fn["mkdp#util#install"]()
			end
		end,
		init = function()
			if vim.fn.executable("npx") then
				vim.g.mkdp_filetypes = { "markdown" }
			end
		end,
	},
})
