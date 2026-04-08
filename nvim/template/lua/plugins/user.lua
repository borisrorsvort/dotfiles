-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- You can also add or configure plugins by creating files in this `plugins/` folder
-- Here are some examples:

---@type LazySpec
return {
  "andweeb/presence.nvim",
  {
    "ray-x/lsp_signature.nvim",
    event = "BufRead",
    config = function() require("lsp_signature").setup() end,
  },
  {
    "goolord/alpha-nvim",
    enabled = false, -- AstroNvim v6 uses snacks.nvim dashboard instead
  },

  { "max397574/better-escape.nvim" },
  {
    "L3MON4D3/LuaSnip",
    config = function(_, opts)
      require("luasnip").setup(opts)
      require("luasnip").filetype_extend("javascript", { "javascriptreact" })
    end,
  },
  {
    "benfowler/telescope-luasnip.nvim",
    config = function() require("telescope").load_extension "luasnip" end,
  },
  {
    "windwp/nvim-autopairs",
    config = function(_, opts)
      local npairs = require "nvim-autopairs"
      npairs.setup(opts)
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
  { "sheerun/vim-polyglot" }, -- Language packs
  { "gennaro-tedesco/nvim-jqx", ft = { "json", "yaml" } }, -- List and manipulate JSON objects
  { "kristijanhusak/vim-carbon-now-sh", event = "BufRead" }, -- Code screenshots
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
  { "vim-ruby/vim-ruby", event = "BufRead" },
  { "tpope/vim-bundler", cmd = { "Bundle", "Bundler", "Bopen", "Bsplit", "Btabedit" } },
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
  },
  {
    "phaazon/hop.nvim",
    config = function() require("hop").setup() end,
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
    config = function() vim.g.matchup_matchparen_offscreen = { method = "popup" } end,
  },
  {
    "nacro90/numb.nvim", -- line preview when using :[num]
    event = "BufRead",
    config = function() require("numb").setup() end,
  },
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "suketa/nvim-dap-ruby",
    },
    config = function() require("dap-ruby").setup() end,
  },
  {
    "nickjvandyke/opencode.nvim",
    version = "*",
    event = "VeryLazy",
    config = function()
      local snacks_opts = {
        win = {
          position = 'right',
          width = 0.40,
          backdrop = 60,
          wo = {
            winblend = 0,
            number = false,
            relativenumber = false,
            signcolumn = 'no',
            winbar = '',
            statusline = '',
          },
        },
      }
      ---@type opencode.Opts
      vim.g.opencode_opts = {
        server = {
          start = function()
            require('snacks.terminal').open('opencode --port', snacks_opts)
          end,
          stop = function()
            require('snacks.terminal').get('opencode --port', {}):close()
          end,
          toggle = function()
            require('snacks.terminal').toggle('opencode --port', snacks_opts)
          end,
        },
      }
      vim.o.autoread = true
    end,
  },
  {
    "coder/claudecode.nvim",
    dependencies = { "folke/snacks.nvim" },
    event = "VeryLazy",
    opts = {
      terminal = {
        provider = "snacks",
        snacks_win_opts = {
          position = "right",
          width = 0.40,
          backdrop = 60,
          wo = {
            winblend = 0,
            number = false,
            relativenumber = false,
            signcolumn = 'no',
          },
        },
      },
    },
  },
}
