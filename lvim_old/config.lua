--[[
lvim is the global options object

linters zouden moeten zijn
filled in as strings with either
a global executable or a path to
an executable
]]
-- THESE ARE EXAMPLE CONFIGS FEEL FREE TO CHANGE TO WHATEVER YOU WANT
-- general
vim.g.translator_target_lang = "fr"
vim.g.translator_source_lang = "en"
vim.g.neovide_cursor_animation_length = 0

vim.g.copilot_no_tab_map = true
vim.g.copilot_assume_mapped = true
vim.g.copilot_tab_fallback = ""

vim.opt.relativenumber = true
vim.filetype.add {
  extension = {
    mjml = "eruby",
    js = "typescriptreact"
  }
}
lvim.log.level = "warn"
lvim.format_on_save.enabled = true
vim.opt.termguicolors = false
-- vim.opt.background = "light"
-- lvim.colorscheme = "github_light"
-- lvim.builtin.theme.name = "catppuccin" -- temp fix to get the light bg
lvim.colorscheme = "catppuccin-mocha"

vim.opt.cmdheight = 1
-- vim.opt.guifont = "Fira Code:h16"
vim.opt.guifont = "Hack Nerd Font:h16"

lvim.builtin.alpha.dashboard.section.header.val = {
  "                  _________-----_____",
  "       _____------           __      ----_",
  "___----             ___------              \\",
  "   ----________        ----                 \\",
  "               -----__    |             _____)",
  "                    __-                /     \\",
  "        _______-----    ___--          \\    /)\\",
  "  ------_______      ---____            \\__/  /",
  "               -----__    \\ --    _          /\\",
  "                      --__--__     \\_____/   \\_/\\",
  "                              ----|   /          |",
  "                                  |  |___________|",
  "                                  |  | ((_(_)| )_)",
  "                                  |  \\_((_(_)|/(_)",
  "                                  \\             (",
  "                                   \\_____________)",
}

-- to disable icons and use a minimalist setup, uncomment the following
-- lvim.use_icons = false

-- keymappings [view all the defaults by pressing <leader>Lk]
lvim.leader = "space"
-- Remove default window focus keybinds
lvim.keys.normal_mode["<C-h>"] = false
lvim.keys.normal_mode["<C-j>"] = false
lvim.keys.normal_mode["<C-k>"] = false
lvim.keys.normal_mode["<C-l>"] = false
lvim.keys.normal_mode["<C-s>"] = ":w<cr>"
-- Navigation remaps
lvim.keys.normal_mode["<Tab>"] = ":BufferLineCycleNext<CR>"
lvim.keys.normal_mode["<S-Tab>"] = ":BufferLineCyclePrev<CR>"
-- Hop remaps
lvim.keys.normal_mode["f"] = "<cmd>lua require'hop'.hint_words()<cr>"
lvim.keys.normal_mode["F"] = "<cmd>lua require'hop'.hint_lines()<cr>"
lvim.keys.visual_mode["f"] = "<cmd>lua require'hop'.hint_words()<cr>"
lvim.keys.visual_mode["F"] = "<cmd>lua require'hop'.hint_lines()<cr>"
-- Search remaps
lvim.keys.normal_mode["<C-f>"] = "<cmd>lua require('spectre').open()<cr>"
lvim.keys.normal_mode["<CS-f>"] = "<cmd>lua require('spectre').close()<cr>"
-- lvim.keys.normal_mode["<CS-F>"] = "<Plug>CtrlSFPrompt"
-- lvim.keys.visual_mode["<leader>m"] = "<Esc><cmd>lua require('telescope').extensions.refactoring.refactors()<CR>"

-- unmap a default keymapping
-- vim.keymap.del("n", "<C-Up>")
-- override a default keymapping
-- lvim.keys.normal_mode["<C-q>"] = ":q<cr>" -- or vim.keymap.set("n", "<C-q>", ":q<cr>" )

-- Change Telescope navigation to use j and k for navigation and n and p for history in both input and normal mode.
-- we use protected-mode (pcall) just in case the plugin wasn't loaded yet.
local _, actions = pcall(require, "telescope.actions")
lvim.builtin.telescope.defaults.mappings = {
  -- for input mode
  i = {
    ["<C-t>"] = actions.move_selection_next,
    ["<C-s>"] = actions.move_selection_previous,
    ["<C-r>"] = actions.cycle_history_next,
    ["<C-c>"] = actions.cycle_history_prev,
    ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist
  },
  -- for normal mode
  n = {
    ["<C-r>"] = actions.move_selection_next,
    ["<C-c>"] = actions.move_selection_previous,
    ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist
  }
}

lvim.builtin.telescope.defaults.path_display = { "absolute" }

lvim.builtin.which_key.mappings["T"] = {
  name = "Test",
  f = { "<cmd>TestFile<cr>", "File" },
  n = { "<cmd>TestNearest<cr>", "Nearest" },
  s = { "<cmd>TestSuite<cr>", "Suite" }
}

lvim.builtin.alpha.active = true
lvim.builtin.alpha.mode = "dashboard"
lvim.builtin.terminal.active = true
lvim.builtin.terminal.open_mapping = [[<CS-t>]]
lvim.builtin.terminal.direction = "horizontal"
lvim.builtin.nvimtree.setup.view.side = "left"
lvim.builtin.nvimtree.setup.renderer.icons.show.git = true
lvim.builtin.nvimtree.setup.renderer.icons.folder = {
  default = "",
  open = "",
  symlink = "",
}
local cmp = require "cmp"

lvim.builtin.cmp.mapping["<Tab>"] = function(fallback)
  local copilot_keys = vim.fn["copilot#Accept"]()
  if cmp.visible() then
    cmp.confirm({ select = true })
  elseif copilot_keys ~= "" and type(copilot_keys) == "string" then
    vim.api.nvim_feedkeys(copilot_keys, "n", true)
  else
    fallback()
  end
  -- -- if cmp.visible() then
  -- --   cmp.select_next_item()
  -- -- else
  -- local copilot_keys = vim.fn["copilot#Accept"]()
  -- if copilot_keys ~= "" then
  --   vim.api.nvim_feedkeys(copilot_keys, "i", true)
  -- else
  --   fallback()
  -- end
  -- -- end
end

lvim.builtin.nvimtree.setup.live_filter = {
  always_show_folders = false
}
lvim.builtin.nvimtree.setup.view.mappings.list = {
  { key = "s", action = "" }, -- remove default mapping to allow the remapped move key s to work
}

lvim.builtin.treesitter.ignore_install = { "haskell" }
lvim.builtin.treesitter.highlight.enable = true
lvim.builtin.treesitter.matchup.enable = true
lvim.builtin.dap.on_config_done = function(dap)
  dap.configurations.rb = {
    type = 'ruby',
    request = 'launch',
    name = 'Rails',
    program = 'foreman',
    programArgs = { 'start', '-f', 'Procfile.dev' },
    useBundler = true,
  }
  dap.adapters.ruby = {
    type = 'executable',
    command = 'bundle',
    args = { 'exec', 'readapt', 'stdio' },
  }
  dap.configurations.ruby = dap.configurations.rb
end


-- ---@usage disable automatic installation of servers
lvim.lsp.installer.setup.automatic_installation = true

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
  }
}
require("lspconfig")["solargraph"].setup(vim.tbl_extend("force", opts, common_opts))

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

-- Additional Plugins
lvim.plugins = {
  { "michamos/vim-bepo" },
  { 'metakirby5/codi.vim' },
  { 'sheerun/vim-polyglot' },
  { 'liuchengxu/space-vim-theme' },
  { "gennaro-tedesco/nvim-jqx",  ft = { "json", "yaml" }, },
  {
    'norcalli/nvim-colorizer.lua',
    config = function()
      require 'colorizer'.setup()
    end
  },
  {
    "catppuccin/nvim",
    as = "catppuccin",
  },
  { 'kristijanhusak/vim-carbon-now-sh' },
  { "github/copilot.vim" },
  {
    'weizheheng/ror.nvim',
    config = function()
      -- The default settings
      require("ror").setup({
        test = {
          message = {
            -- These are the default title for nvim-notify
            file = "Running test file...",
            line = "Running single test..."
          },
          coverage = {
            -- To customize replace with the hex color you want for the highlight
            -- guibg=#354a39
            up = "DiffAdd",
            -- guibg=#4a3536
            down = "DiffDelete",
          },
          notification = {
            -- Using timeout false will replace the progress notification window
            -- Otherwise, the progress and the result will be a different notification window
            timeout = false
          },
          pass_icon = "✅",
          fail_icon = "❌"
        }
      })
    end
  },
  {
    "andythigpen/nvim-coverage",
    requires = "nvim-lua/plenary.nvim",
    config = function()
      require("coverage").setup({
        load_coverage_cb = function(ftype)
          vim.notify("Loaded " .. ftype .. " coverage")
        end,
        -- lang = { ruby = {coverage_file = "./coverage/.resultset.json"}}
      })
    end,
  },
  {
    "klen/nvim-test",
    config = function()
      require('nvim-test').setup {
        termOpts = {
          direction = "vertical", -- terminal's direction ("horizontal"|"vertical"|"float")
          width = 70,             -- terminal's width (for vertical|float)
          height = 14,            -- terminal's height (for horizontal|float)
          go_back = false,        -- return focus to original window after executing
          stopinsert = "auto",    -- exit from insert mode (true|false|"auto")
          keep_one = true         -- keep only one terminal for testing
        }
      }
    end
  },
  {
    "tpope/vim-rails",
    ft = { 'ruby', 'eruby' },
    cmd = { "Eview", "Econtroller", "Emodel", "Smodel", "Sview", "Scontroller", "Vmodel", "Vview", "Vcontroller",
      "Tmodel", "Tview", "Tcontroller", "Rails", "Generate", "Runner", "Extract" }
  },
  { 'alvan/vim-closetag' },
  { 'ecomba/vim-ruby-refactoring' },
  { 'vim-ruby/vim-ruby' },
  { "tpope/vim-bundler",                          cmd = { "Bundler", "Bopen", "Bsplit", "Btabedit" } },
  { 'tpope/vim-unimpaired' },
  { 'nvim-treesitter/nvim-treesitter-textobjects' },
  {
    "tpope/vim-surround",
    -- make sure to change the value of `timeoutlen` if it's not triggering correctly, see https://github.com/tpope/vim-surround/issues/117
    setup = function()
      vim.o.timeoutlen = 500
    end
  },
  {
    'phaazon/hop.nvim',
    config = function()
      require('hop').setup()
    end
  },
  {
    "ray-x/lsp_signature.nvim",
    event = "BufRead",
    config = function()
      require "lsp_signature".on_attach()
    end
  },
  {
    'windwp/nvim-spectre',
    event = "BufRead",
    config = function()
      require("spectre").setup({
        live_update = true,
        is_insert_mode = true
      })
    end
  },
  {
    "folke/todo-comments.nvim",
    event = "BufRead",
    config = function()
      require("todo-comments").setup()
    end
  },
  {
    "ThePrimeagen/refactoring.nvim",
    requires = {
      { "nvim-lua/plenary.nvim" },
      { "nvim-treesitter/nvim-treesitter" }
    },
    config = function()
      require('refactoring').setup()
    end
  },
  {
    'voldikss/vim-translator'
  },
  {
    'andymass/vim-matchup',
    setup = function()
      -- may set any options here
      vim.g.matchup_matchparen_offscreen = { method = "popup" }
    end
  },
  {
    'nacro90/numb.nvim',
    config = function()
      require('numb').setup()
    end
  }
}



-- With luasnip installed, you will need to add this line to your config
require("luasnip.loaders.from_vscode").lazy_load()
require("telescope").load_extension("refactoring")
require('nvim-treesitter.configs').setup {
  -- Add languages to be installed here that you want installed for treesitter
  ensure_installed = { 'lua', 'javascript', 'help', 'json', 'vim', 'ruby', 'html', 'css', 'tsx' },

  highlight = { enable = true },
  indent = { enable = true, disable = { 'python' } },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<c-space>',
      node_incremental = '<c-space>',
      scope_incremental = '<c-s>',
      -- scope_decremental = '<c-t>', -- waiting for https://github.com/nvim-treesitter/nvim-treesitter/issues/4494
      node_decremental = '<c-backspace>',
    },
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ['aa'] = '@parameter.outer',
        ['ia'] = '@parameter.inner',
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        [']m'] = '@function.outer',
        [']]'] = '@class.outer',
      },
      goto_next_end = {
        [']M'] = '@function.outer',
        [']['] = '@class.outer',
      },
      goto_previous_start = {
        ['[m'] = '@function.outer',
        ['[['] = '@class.outer',
      },
      goto_previous_end = {
        ['[M'] = '@function.outer',
        ['[]'] = '@class.outer',
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ['<leader>a'] = '@parameter.inner',
      },
      swap_previous = {
        ['<leader>A'] = '@parameter.inner',
      },
    },
  },
}