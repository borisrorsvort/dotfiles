return {
	{
		"michamos/vim-bepo",
		lazy = false,
	},
	{ "metakirby5/codi.vim" },
	{ "sheerun/vim-polyglot" },
	{ "liuchengxu/space-vim-theme" },
	{
		"projekt0n/github-nvim-theme",
		branch = "main",
		config = function()
			require("github-theme").setup()
		end,
	},
	{ "gennaro-tedesco/nvim-jqx",         ft = { "json", "yaml" } },
	{
		"catppuccin/nvim",
		as = "catppuccin",
		config = function()
			require("catppuccin").setup({
				flavour = "mocha",
			})
		end,
	},
	{ "kristijanhusak/vim-carbon-now-sh", event = "BufRead" },
	{
		"ten3roberts/qf.nvim",

		config = function()
			require("qf").setup({})
		end,
	},
	{
		"nvim-neotest/neotest",
		config = function()
			-- get neotest namespace (api call creates or returns namespace)
			local neotest_ns = vim.api.nvim_create_namespace("neotest")
			vim.diagnostic.config({
				virtual_text = {
					format = function(diagnostic)
						local message =
								diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
						return message
					end,
				},
			}, neotest_ns)
			require("neotest").setup({
				-- your neotest config here
				icons = {
					child_indent = "│",
					child_prefix = "├",
					collapsed = "─",
					expanded = "╮",
					failed = "",
					final_child_indent = " ",
					final_child_prefix = "╰",
					non_collapsible = "─",
					passed = "",
					running = "",
					running_animated = { "/", "|", "\\", "-", "/", "|", "\\", "-" },
					skipped = "",
					unknown = "",
				},
				quickfix = {
					enabled = false,
					open = false,
				},
				output_panel = {
					open = "rightbelow vsplit | resize 30",
				},
				status = {
					virtual_text = false,
					signs = true,
				},
				adapters = {
					require("neotest-rspec"),
					require("neotest-jest")({
						jestCommand = "npm test --",
						jestConfigFile = "jest.config.js",
						env = { CI = true },
					}),
				},
			})
		end,
		ft = { "ruby", "javascript" },
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			"antoinemadec/FixCursorHold.nvim",
			"olimorris/neotest-rspec",
			"haydenmeade/neotest-jest",
		},
	},
	{
		"weizheheng/ror.nvim",
		event = "BufRead",
	},
	{
		"tpope/vim-rails",
		lazy = false,
		ft = { "ruby", "eruby" },
		cmd = {
			"Eview",
			"Econtroller",
			"Emodel",
			"Smodel",
			"Sview",
			"Scontroller",
			"Vmodel",
			"Vview",
			"Vcontroller",
			"Tmodel",
			"Tview",
			"Tcontroller",
			"Rails",
			"Generate",
			"Runner",
			"Extract",
		},
	},
	{ "vim-ruby/vim-ruby",                           event = "BufRead" },
	{ "tpope/vim-bundler",                           cmd = { "Bundle", "Bundler", "Bopen", "Bsplit", "Btabedit" } },
	{ "nvim-treesitter/nvim-treesitter-textobjects", event = "BufRead" },
	{
		"kylechui/nvim-surround",
		version = "*", -- Use for stability; omit to use `main` branch for the latest features
		event = "VeryLazy",
	},
	{
		"phaazon/hop.nvim",
		config = function()
			require("hop").setup()
		end,
	},
	{
		"ray-x/lsp_signature.nvim",
		event = "BufRead",
		config = function()
			require("lsp_signature").on_attach()
		end,
	},
	{
		"windwp/nvim-spectre",
		event = "BufRead",
		config = function()
			require("spectre").setup({
				live_update = true,
				is_insert_mode = true,
			})
		end,
	},
	{
		"folke/todo-comments.nvim",
		event = "BufRead",
		config = function()
			require("todo-comments").setup()
		end,
	},
	{
		"ThePrimeagen/refactoring.nvim",
		event = "BufRead",
		requires = {
			{ "nvim-lua/plenary.nvim" },
			{ "nvim-treesitter/nvim-treesitter" },
		},
		config = function()
			require("refactoring").setup()
		end,
	},
	{
		"voldikss/vim-translator",
		lazy = false,
	},
	{
		"andymass/vim-matchup", -- better % navigation
		event = "BufRead",
		config = function()
			-- may set any options here
			vim.g.matchup_matchparen_offscreen = { method = "popup" }
		end,
	},
	{
		"nacro90/numb.nvim", -- line preview when using :[num]
		event = "BufRead",
		config = function()
			require("numb").setup()
		end,
	},
}