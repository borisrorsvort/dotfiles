vim.opt.mouse = "a" -- allow the mouse to be used in neovim
vim.opt.relativenumber = true
vim.filetype.add {
  extension = {
    mjml = "eruby"
  }
}


lvim.log.level = "warn"
lvim.format_on_save = true
lvim.colorscheme = "tokyonight-night"
lvim.leader = "space"
lvim.builtin.alpha.mode = "dashboard"
lvim.builtin.terminal.active = true
lvim.builtin.terminal.open_mapping = [[<c-t>]]
lvim.builtin.terminal.direction = "horizontal"
lvim.builtin.nvimtree.setup.view.side = "left"
lvim.builtin.nvimtree.setup.renderer.icons.show.git = true
lvim.builtin.nvimtree.setup.live_filter = { always_show_folders = false }
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

lvim.builtin.which_key.mappings["T"] = {
  name = "Test",
  f = { "<cmd>TestFile<cr>", "File" },
  n = { "<cmd>TestNearest<cr>", "Nearest" },
  s = { "<cmd>TestSuite<cr>", "Suite" }
}

lvim.builtin.which_key.mappings["s"] = {
  name = "Search",
  b = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
  f = { "<cmd>Telescope find_files<cr>", "Find File" },
  h = { "<cmd>Telescope help_tags<cr>", "Find Help" },
  H = { "<cmd>Telescope highlights<cr>", "Find highlight groups" },
  M = { "<cmd>Telescope man_pages<cr>", "Man Pages" },
  r = { "<cmd>Telescope oldfiles<cr>", "Open Recent File" },
  R = { "<cmd>Telescope resume<cr>", "Resume search" },
  t = { "<cmd>Telescope live_grep<cr>", "Live search" },
  T = { "<cmd>Telescope grep_string<cr>", "Search word" },
  k = { "<cmd>Telescope keymaps<cr>", "Keymaps" },
  c = { "<cmd>Telescope commands<cr>", "Commands" },
  p = { "<cmd>lua require('telescope.builtin').colorscheme({enable_preview = true})<cr>", "Colorscheme with Preview" }
}

lvim.lsp.installer.setup.automatic_installation = false

-- Additional Plugins
lvim.plugins = {
  { "michamos/vim-bepo" },
  { "vim-test/vim-test" },
  { 'tpope/vim-rails' },
  { 'tpope/vim-unimpaired' },
  { 'machakann/vim-sandwich' },
  { 'phaazon/hop.nvim' },
  {
    "ray-x/lsp_signature.nvim",
    event = "BufRead",
    config = function() require "lsp_signature".on_attach() end,
  }
}

local common_opts = require("lvim/lsp").get_common_opts()
vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "solargraph" })
local util = require("lspconfig/util")
local opts = {
  cmd = { "solargraph", "stdio" },
  filetypes = { "ruby" },
  root_dir = util.root_pattern("Gemfile", ".git"),
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
      symbols = true
    }
  },
}
require("lspconfig")["solargraph"].setup(vim.tbl_extend("force", opts, common_opts))
-- require "lsp_signature".setup();
require('hop').setup();




local function map(mode, lhs, rhs, opts)
  local options = {
    noremap = true
  }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

map("n", "<C-n>", "<cmd>:bnext<cr>")
map("n", "<C-c>", "<cmd>:bprevious<cr>")
map("n", "f", "<cmd>lua require'hop'.hint_words()<cr>")
map("n", "F", "<cmd>lua require'hop'.hint_lines()<cr>")
map("v", "f", "<cmd>lua require'hop'.hint_words()<cr>")
map("v", "F", "<cmd>lua require'hop'.hint_lines()<cr>")
