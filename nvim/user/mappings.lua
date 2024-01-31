--
-- Please use this mappings table to set keyboard mapping since this is the
-- lower level configuration and more robust one. (which-key will
return {
	-- first key is the mode
	n = {
		-- second key is the lefthand side of the map
		-- mappings seen under group name "Buffer"
		["<C-h>"] = false,
		["<C-j>"] = false,
		["<C-k>"] = false,
		["<C-l>"] = false,
		["k"] = false, -- cancel overwrite in https://github.com/AstroNvim/AstroNvim/blob/148a513072e6fc2a40fe8ad89534d4b6d00db5e7/lua/astronvim/mappings.lua#L23
		["j"] = false, -- cancel overwrite in https://github.com/AstroNvim/AstroNvim/blob/148a513072e6fc2a40fe8ad89534d4b6d00db5e7/lua/astronvim/mappings.lua#L24
		["<leader>bn"] = { "<cmd>tabnew<cr>", desc = "New tab" },
		["<leader>bD"] = {
			function()
				require("astronvim.utils.status").heirline.buffer_picker(function(bufnr)
					require("astronvim.utils.buffer").close(bufnr)
				end)
			end,
			desc = "Pick to close",
		},
		["<C-q>"] = { "<cmd>lua require'qf'.toggle('c', false)<CR>", noremap = { true }, desc = "Toggle quickfix" }, -- toggle("c", false) dont stay in current window
		["f"] = { "<cmd>lua require'hop'.hint_words()<cr>", desc = "Hop toggle" },
		["<C-s>"] = { ":w!<cr>", desc = "Save File" },
		["<leader>fs"] = { "<cmd>lua require('spectre').toggle()<cr>", desc = "Open Spectre" },
		["<leader>fS"] = {
			function()
				require("spectre").open_file_search()
			end,
			desc = "Spectre (current file)",
		},
		["<leader>fc"] = {
			function()
				require("spectre").open_visual({ select_word = true })
			end,
			desc = "Spectre (current word)",
		},
		-- ["<leader>fS"] = { "<cmd>lua require('spectre').close()<cr>", desc = "Close Spectre" },
		["<Tab>"] = {
			function()
				require("astronvim.utils.buffer").nav(vim.v.count > 0 and vim.v.count or 1)
			end,
			desc = "Next buffer",
		},
		["<S-Tab>"] = {
			function()
				require("astronvim.utils.buffer").nav(-(vim.v.count > 0 and vim.v.count or 1))
			end,
			desc = "Previous buffer",
		},
		["<leader>T"] = { name = "Test" },
		["<leader>Tn"] = {
			function()
				require("neotest").run.run()
			end,
			desc = "Run test under cursor",
		},
		["<leader>Tf"] = {
			function()
				require("neotest").run.run(vim.fn.expand("%"))
			end,
			desc = "Run test file",
		},
		["<leader>Ts"] = {
			function()
				require("neotest").summary.toggle()
			end,
			desc = "Open test summary",
		},
		["<leader>tc"] = { "<cmd>lua require('ror.commands').list_commands()<CR>", desc = "Open Rails menu" },
	},
	v = {
		["f"] = { "<cmd>lua require'hop'.hint_words()<cr>", desc = "Hop toggle" },
		["<leader>fs"] = { "<cmd>lua require('spectre').open_visual()<cr>", desc = "Open Spectre" },
		["<leader>rr"] = {
			"<Esc><cmd>lua require('telescope').extensions.refactoring.refactors()<CR>",
			desc = "Bring up the refacoring menu",
		},
	},
	t = {
		-- setting a mapping to false will disable it
		-- ["<esc>"] = false,
	},
}
-- automatically pick-up stored data by this setting.)
