-- customize mason plugins
return {
	-- use mason-lspconfig to configure LSP installations
	{
		"williamboman/mason-lspconfig.nvim",
		-- overrides `require("mason-lspconfig").setup(...)`
		opts = {
			ensure_installed = {
				"cssls",
				"emmet_ls",
				"eslint",
				"jsonls",
				"lua_ls",
				"ruby_ls",
				-- "solargraph",
				-- "rubocop",
				-- "sorbet",
				"tsserver",
			},
			automatic_installation = true,
		},
	},
	-- use mason-null-ls to configure Formatters/Linter installation for null-ls sources
	{
		"jay-babu/mason-null-ls.nvim",
		-- overrides `require("mason-null-ls").setup(...)`
		opts = {
			ensure_installed = { "prettier", "stylua" },
		},
	},
	{
		"jay-babu/mason-nvim-dap.nvim",
		-- overrides `require("mason-nvim-dap").setup(...)`
		opts = {
			-- ensure_installed = { "python" },
		},
	},
}
