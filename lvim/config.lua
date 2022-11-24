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
  {
    "tpope/vim-rails",
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
      "Extract"
    }
  },
  {
    "tpope/vim-bundler",
    cmd = { "Bundler", "Bopen", "Bsplit", "Btabedit" }
  },
  { 'tpope/vim-unimpaired' },
  { 'machakann/vim-sandwich' },
  { 'phaazon/hop.nvim' },
  {
    "ray-x/lsp_signature.nvim",
    event = "BufRead",
    config = function() require "lsp_signature".on_attach() end,
  },
  { 'nvim-lua/plenary.nvim' },
  { 'windwp/nvim-spectre',
    event = "BufRead",
    config = function()
      require("spectre").setup({
        live_update = true,
        is_insert_mode = true
      })
    end
  },
  {
    "karb94/neoscroll.nvim",
    event = "WinScrolled",
    config = function()
      require('neoscroll').setup({
        -- All these keys will be mapped to their corresponding default scrolling animation
        mappings = { '<C-u>', '<C-d>', '<C-b>', '<C-f>',
          '<C-y>', '<C-e>', 'zt', 'zz', 'zb' },
        hide_cursor = true, -- Hide cursor while scrolling
        stop_eof = true, -- Stop at <EOF> when scrolling downwards
        use_local_scrolloff = false, -- Use the local scope of scrolloff instead of the global scope
        respect_scrolloff = false, -- Stop scrolling when the cursor reaches the scrolloff margin of the file
        cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
        easing_function = nil, -- Default easing function
        pre_hook = nil, -- Function to run before the scrolling animation starts
        post_hook = nil, -- Function to run after the scrolling animation ends
      })
    end
  },
  {
    "folke/todo-comments.nvim",
    event = "BufRead",
    config = function()
      require("todo-comments").setup()
    end,
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

map("n", "<C-r>", "<cmd>:bnext<cr>")
map("n", "<C-c>", "<cmd>:bprevious<cr>")
map("n", "f", "<cmd>lua require'hop'.hint_words()<cr>")
map("n", "F", "<cmd>lua require'hop'.hint_lines()<cr>")
map("v", "f", "<cmd>lua require'hop'.hint_words()<cr>")
map("v", "F", "<cmd>lua require'hop'.hint_lines()<cr>")
map("n", "S", "<cmd>lua require('spectre').open_visual()<cr>")


-- function _G.set_terminal_keymaps()
--   local term_option = { buffer = 0 }
--   vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], term_option)
--   vim.keymap.set('t', 'ts', [[<C-\><C-n>]], term_option)
--   vim.keymap.set('t', '<C-c>', [[<Cmd>wincmd h<CR>]], term_option)
--   vim.keymap.set('t', '<C-t>', [[<Cmd>wincmd j<CR>]], term_option)
--   vim.keymap.set('t', '<C-s>', [[<Cmd>wincmd k<CR>]], term_option)
--   vim.keymap.set('t', '<C-r>', [[<Cmd>wincmd l<CR>]], term_option)
-- end

-- -- if you only want these mappings for toggle term use term://*toggleterm#* instead
-- vim.cmd('autocmd! TermOpen term://toggleterm#* lua set_terminal_keymaps()')
