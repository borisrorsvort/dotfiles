-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- You can also add or configure plugins by creating files in this `plugins/` folder
-- Here are some examples:

---@type LazySpec
return {

  -- == Examples of Adding Plugins ==

  "andweeb/presence.nvim",
  {
    "ray-x/lsp_signature.nvim",
    event = "BufRead",
    config = function() require("lsp_signature").setup() end,
  },

  -- == Examples of Overriding Plugins ==

  -- customize alpha options
  {
    "goolord/alpha-nvim",
    opts = function(_, opts)
      -- customize the dashboard header
      opts.section.header.val = {
        "        888                     888    ",
        "        888                     888    ",
        "        888                     888    ",
        " .d88b. 88888b.  .d88b. .d8888b 888888 ",
        'd88P"88b888 "88bd88""88b88K     888    ',
        '888  888888  888888  888"Y8888b.888    ',
        "Y88b 888888  888Y88..88P     X88Y88b.  ",
        '"Y88888888  888 "Y88P"  88888P\' "Y888 ',
        "     888                               ",
        "Y8b d88P                               ",
        '"Y88P"       ',
      }
      return opts
    end,
  },

  -- You can disable default plugins as follows:
  { "max397574/better-escape.nvim", enabled = false },

  -- You can also easily customize additional setup of plugins that is outside of the plugin's setup call
  {
    "L3MON4D3/LuaSnip",
    config = function(plugin, opts)
      require "astronvim.plugins.configs.luasnip"(plugin, opts) -- include the default astronvim config that calls the setup call
      -- add more custom luasnip configuration such as filetype extend or custom snippets
      local luasnip = require "luasnip"
      luasnip.filetype_extend("javascript", { "javascriptreact" })
    end,
  },

  {
    "windwp/nvim-autopairs",
    config = function(plugin, opts)
      require "astronvim.plugins.configs.nvim-autopairs"(plugin, opts) -- include the default astronvim config that calls the setup call
      -- add more custom autopairs configuration such as custom rules
      local npairs = require "nvim-autopairs"
      local Rule = require "nvim-autopairs.rule"
      local cond = require "nvim-autopairs.conds"
      npairs.add_rules(
        {
          Rule("$", "$", { "tex", "latex" })
            -- don't add a pair if the next character is %
            :with_pair(cond.not_after_regex "%%")
            -- don't add a pair if  the previous character is xxx
            :with_pair(
              cond.not_before_regex("xxx", 3)
            )
            -- don't move right when repeat character
            :with_move(cond.none())
            -- don't delete if the next character is xx
            :with_del(cond.not_after_regex "xx")
            -- disable adding a newline when you press <cr>
            :with_cr(cond.none()),
        },
        -- disable for .vim files, but it work for another filetypes
        Rule("a", "a", "-vim")
      )
    end,
  },
  {
    "michamos/vim-bepo",
    lazy = false,
  },
  { "metakirby5/codi.vim" },
  { "sheerun/vim-polyglot" },
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
  },
  { "gennaro-tedesco/nvim-jqx", ft = { "json", "yaml" } },
  {
    "AstroNvim/astrotheme",
    config = function()
      require("astrotheme").setup {
        background = { -- :h background, palettes to use when using the core vim background colors
          light = "astrolight",
          dark = "astrodark",
        },
        palettes = {
          global = {},
          astrodark = {},
          astrolight = {
            ui = {
              -- base = "#FFFFFF",
            },
          },
        },
      }
    end,
  },
  { "kristijanhusak/vim-carbon-now-sh", event = "BufRead" },
  {
    "nvim-neotest/neotest",
    config = function()
      -- get neotest namespace (api call creates or returns namespace)
      local neotest_ns = vim.api.nvim_create_namespace "neotest"
      vim.diagnostic.config({
        virtual_text = {
          format = function(diagnostic)
            local message = diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
            return message
          end,
        },
      }, neotest_ns)
      require("neotest").setup {
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
          require "neotest-rspec",
          require "neotest-jest" {
            jestCommand = "npm test --",
            jestConfigFile = "jest.config.js",
            env = { CI = true },
          },
        },
      }
    end,
    ft = { "ruby", "javascript" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "antoinemadec/FixCursorHold.nvim",
      "olimorris/neotest-rspec",
      "haydenmeade/neotest-jest",
      {
        "folke/neodev.nvim",
        opts = function(_, opts)
          opts.library = opts.library or {}
          -- TODO: fix later
          -- if opts.library.plugins ~= true then
          --   opts.library.plugins = require("astronvim.utils").list_insert_unique(opts.library.plugins, "neotest")
          -- end
          opts.library.types = true
        end,
      },
    },
  },
  {
    "stevearc/dressing.nvim",
  },
  {
    "weizheheng/ror.nvim",
    event = "BufRead",
    config = function()
      require("dressing").setup {
        input = {
          min_width = { 60, 0.9 },
        },
      }
    end,
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
  { "vim-ruby/vim-ruby", event = "BufRead" },
  { "tpope/vim-bundler", cmd = { "Bundle", "Bundler", "Bopen", "Bsplit", "Btabedit" } },
  { "nvim-treesitter/nvim-treesitter-textobjects", event = "BufRead" },
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
  },
  {
    "phaazon/hop.nvim",
    config = function() require("hop").setup() end,
  },
  {
    "amadeus/vim-mjml",
  },
  {
    "windwp/nvim-spectre",
    event = "BufRead",
  },
  {
    "folke/todo-comments.nvim",
    event = "BufRead",
    config = function() require("todo-comments").setup() end,
  },
  {
    "ThePrimeagen/refactoring.nvim",
    event = "BufRead",
    requires = {
      { "nvim-lua/plenary.nvim" },
      { "nvim-treesitter/nvim-treesitter" },
    },
    config = function() require("refactoring").setup() end,
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
    config = function() require("numb").setup() end,
  },
}
