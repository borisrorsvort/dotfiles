local null_ls = require("null-ls")
local methods = require("null-ls.methods")
local c = require("null-ls.config")

return {
	cmd = { "solargraph", "stdio" },
	filetypes = { "ruby" },
	settings = {
		solargraph = {
			autoformat = true,
			completion = true,
			useBundler = true,
			diagnostic = true,
			logLevel = "debug",
			folding = true,
			references = true,
			formatting = true,
			rename = true,
			symbols = true,
		},
	},
	on_attach = function(client, bufnr)
		c.register({
			[methods.lsp.DID_OPEN] = { null_ls.builtins.diagnostics },
			[methods.lsp.DID_CHANGE] = { null_ls.builtins.diagnostics },
			[methods.lsp.DID_SAVE] = { null_ls.builtins.diagnostics },
		}, { bufnr = bufnr, client_id = client.id })
	end,
}
