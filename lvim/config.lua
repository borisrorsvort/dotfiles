-- general
-- lvim.keys.normal_mode["<S-l>"] = ":BufferLineCycleNext<CR>"
-- lvim.keys.normal_mode["<S-h>"] = ":BufferLineCyclePrev<CR>"
-- unmap a default keymapping
-- vim.keymap.del("n", "<C-Up>")
-- override a default keymapping
-- lvim.keys.normal_mode["<C-q>"] = ":q<cr>" -- or vim.keymap.set("n", "<C-q>", ":q<cr>" )
-- Change Telescope navigation to use j and k for navigation and n and p for history in both input and normal mode.
-- we use protected-mode (pcall) just in case the plugin wasn't loaded yet.
-- local _, actions = pcall(require, "telescope.actions")
-- lvim.builtin.telescope.defaults.mappings = {
--   -- for input mode
--   i = {
--     ["<C-j>"] = actions.move_selection_next,
--     ["<C-k>"] = actions.move_selection_previous,
--     ["<C-n>"] = actions.cycle_history_next,
--     ["<C-p>"] = actions.cycle_history_prev,
--   },
--   -- for normal mode
--   n = {
--     ["<C-j>"] = actions.move_selection_next,
--     ["<C-k>"] = actions.move_selection_previous,
--   },
-- }
-- VIM general settings
vim.filetype.add {
  extension = {
    mjml = "eruby"
  }
}
vim.opt.mouse = "a" -- allow the mouse to be used in neovim
vim.opt.relativenumber = true
lvim.log.level = "warn"
lvim.format_on_save = true
lvim.colorscheme = "tokyonight-night"
lvim.leader = "space"
lvim.builtin.alpha.mode = "dashboard"
lvim.builtin.terminal.active = true

lvim.builtin.nvimtree.setup.view.side = "left"

lvim.builtin.nvimtree.setup.renderer.icons.show.git = true
lvim.builtin.nvimtree.setup.live_filter = {
  always_show_folders = false
}

lvim.builtin.treesitter.ensure_installed = {
  "bash", "c", "javascript", "json", "lua", "python", "typescript", "tsx", "ruby", "css", "rust", "yaml"
}

lvim.builtin.treesitter.ignore_install = { "haskell" }
lvim.builtin.treesitter.highlight.enable = true
lvim.builtin.telescope.pickers.live_grep = {
  layout_strategy = "horizontal",
  layout_config = {
    width = 0.9,
    height = 0.9,
    prompt_position = "bottom"
  }
}

lvim.builtin.telescope.pickers.grep_string = {
  layout_strategy = "horizontal",
  layout_config = {
    width = 0.9,
    height = 0.9,
    prompt_position = "bottom"
  }
}

-- generic LSP settings

-- -- make sure server will always be installed even if the server is in skipped_servers list
-- lvim.lsp.installer.setup.ensure_installed = {
--     "sumneko_lua",
--     "jsonls",
-- }
-- -- change UI setting of `LspInstallInfo`
-- -- see <https://github.com/williamboman/nvim-lsp-installer#default-configuration>
-- lvim.lsp.installer.setup.ui.check_outdated_servers_on_open = false
-- lvim.lsp.installer.setup.ui.border = "rounded"
-- lvim.lsp.installer.setup.ui.keymaps = {
--     uninstall_server = "d",
--     toggle_server_expand = "o",
-- }

-- ---@usage disable automatic installation of servers
-- lvim.lsp.installer.setup.automatic_installation = false

-- ---configure a server manually. !!Requires `:LvimCacheReset` to take effect!!
-- ---see the full default list `:lua print(vim.inspect(lvim.lsp.automatic_configuration.skipped_servers))`
-- vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "pyright" })
-- local opts = {} -- check the lspconfig documentation for a list of all possible options
-- require("lvim.lsp.manager").setup("pyright", opts)

-- ---remove a server from the skipped list, e.g. eslint, or emmet_ls. !!Requires `:LvimCacheReset` to take effect!!
-- ---`:LvimInfo` lists which server(s) are skipped for the current filetype
-- lvim.lsp.automatic_configuration.skipped_servers = vim.tbl_filter(function(server)
--   return server ~= "emmet_ls"
-- end, lvim.lsp.automatic_configuration.skipped_servers)

-- -- you can set a custom on_attach function that will be used for all the language servers
-- -- See <https://github.com/neovim/nvim-lspconfig#keybindings-and-completion>
-- lvim.lsp.on_attach_callback = function(client, bufnr)
--   local function buf_set_option(...)
--     vim.api.nvim_buf_set_option(bufnr, ...)
--   end
--   --Enable completion triggered by <c-x><c-o>
--   buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")
-- end

-- -- set a formatter, this will override the language server formatting capabilities (if it exists)
-- local formatters = require "lvim.lsp.null-ls.formatters"
-- formatters.setup {
--   { command = "black", filetypes = { "python" } },
--   { command = "isort", filetypes = { "python" } },
--   {
--     -- each formatter accepts a list of options identical to https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md#Configuration
--     command = "prettier",
--     ---@usage arguments to pass to the formatter
--     -- these cannot contain whitespaces, options such as `--line-width 80` become either `{'--line-width', '80'}` or `{'--line-width=80'}`
--     extra_args = { "--print-with", "100" },
--     ---@usage specify which filetypes to enable. By default a providers will attach to all the filetypes it supports.
--     filetypes = { "typescript", "typescriptreact" },
--   },
-- }

-- -- set additional linters
-- local linters = require "lvim.lsp.null-ls.linters"
-- linters.setup {
--   { command = "flake8", filetypes = { "python" } },
--   {
--     -- each linter accepts a list of options identical to https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md#Configuration
--     command = "shellcheck",
--     ---@usage arguments to pass to the formatter
--     -- these cannot contain whitespaces, options such as `--line-width 80` become either `{'--line-width', '80'}` or `{'--line-width=80'}`
--     extra_args = { "--severity", "warning" },
--   },
--   {
--     command = "codespell",
--     ---@usage specify which filetypes to enable. By default a providers will attach to all the filetypes it supports.
--     filetypes = { "javascript", "python" },
--   },
-- }

-- local nvim_lsp = require("lspconfig")
require("lspconfig").ruby_ls.setup {
  init_options = {
    enabledFeatures = {
      "codeActions", "diagnostics", "documentHighlights", "documentSymbols", "formatting", "inlayHint", "hover"
    }
  }
}
-- require("lspconfig").solargraph.setup {
--   filetypes = { "ruby", "rakefile" },
--   settings = {
--     solargraph = {
--       autoformat = true,
--       completion = true,
--       diagnostic = true,
--       logLevel = "debug",
--       folding = true,
--       references = true,
--       formatting = true,
--       rename = true,
--       symbols = true
--     }
--   }
-- }

lvim.builtin.terminal.active = true
lvim.builtin.which_key.mappings["T"] = {
  name = "Test",
  f = { "<cmd>TestFile<cr>", "File" },
  n = { "<cmd>TestNearest<cr>", "Nearest" },
  s = { "<cmd>TestSuite<cr>", "Suite" }
}

lvim.builtin.which_key.mappings["s"] = {
  name = "Search",

  b = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
  c = { "<cmd>Telescope colorscheme<cr>", "Colorscheme" },
  f = { "<cmd>Telescope find_files<cr>", "Find File" },
  h = { "<cmd>Telescope help_tags<cr>", "Find Help" },
  H = { "<cmd>Telescope highlights<cr>", "Find highlight groups" },
  M = { "<cmd>Telescope man_pages<cr>", "Man Pages" },
  r = { "<cmd>Telescope oldfiles<cr>", "Open Recent File" },
  R = { "<cmd>Telescope resume<cr>", "Resume search" },
  t = { "<cmd>Telescope live_grep<cr>", "Text" },
  k = { "<cmd>Telescope keymaps<cr>", "Keymaps" },
  C = { "<cmd>Telescope commands<cr>", "Commands" },
  p = { "<cmd>lua require('telescope.builtin').colorscheme({enable_preview = true})<cr>", "Colorscheme with Preview" }
}

-- Additional Plugins
lvim.plugins = {
  { "michamos/vim-bepo" }, -- { 'Ergodis/vim-bepo' },
  { "vim-test/vim-test" },
  { 'tpope/vim-rails' },
  { 'tpope/vim-unimpaired' },
  { 'machakann/vim-sandwich' },
  { 'phaazon/hop.nvim' }
}

local function map(mode, lhs, rhs, opts)
  local options = {
    noremap = true
  }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

map("n", "<C-b>", "<cmd>BufferLineCyclePrev<cr>")
map("n", "<C-é>", "<cmd>BufferLineCycleNext<cr>")
require('hop').setup();
map("n", "f", "<cmd>lua require'hop'.hint_words()<cr>")
map("n", "F", "<cmd>lua require'hop'.hint_lines()<cr>")
map("v", "f", "<cmd>lua require'hop'.hint_words()<cr>")
map("v", "F", "<cmd>lua require'hop'.hint_lines()<cr>")
