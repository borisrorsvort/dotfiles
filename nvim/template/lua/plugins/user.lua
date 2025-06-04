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

  { "max397574/better-escape.nvim" },
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
    "benfowler/telescope-luasnip.nvim",
    config = function() require("telescope").load_extension "luasnip" end,
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
  { "gennaro-tedesco/nvim-jqx", ft = { "json", "yaml" } },
  { "kristijanhusak/vim-carbon-now-sh", event = "BufRead" },
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
    "yetone/avante.nvim",
    event = "VeryLazy",
    lazy = false,
    version = false, -- Set this to "*" to always pull the latest release version, or set it to false to update to the latest code changes.
    opts = {
      provider = "copilot",
      providers = {
        copilot = {
          model = "claude-3.7-sonnet",
          endpoint = "https://api.githubcopilot.com",
          allow_insecure = false,
          timeout = 10 * 60 * 1000,
          extra_request_body = {
            temperature = 0,
          },
          max_completion_tokens = 1000000,
          reasoning_effort = "high",
        },
      },
    },
    -- providers.copilot.extra_request_body.temperature
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    build = "make",
    -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
    behaviour = {
      auto_suggestions = true, -- Experimental stage
      auto_set_highlight_group = true,
      auto_set_keymaps = true,
      auto_apply_diff_after_generation = true,
      support_paste_from_clipboard = false,
      minimize_diff = true, -- Whether to remove unchanged lines when applying a code block
      enable_token_counting = false, -- Whether to enable token counting. Default to true.
      enable_cursor_planning_mode = true, -- Whether to enable Cursor Planning Mode. Default to false.
    },
    mappings = {
      sidebar = {
        apply_all = "A",
        apply_cursor = "a",
        retry_user_request = "r",
        edit_user_request = "e",
        switch_windows = "<Tab>",
        reverse_switch_windows = "<S-Tab>",
        remove_file = "d",
        add_file = "@",
        close = { "<Esc>", "q" },
        close_from_input = nil, -- e.g., { normal = "<Esc>", insert = "<C-d>" }
      },
    },
    dependencies = {
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      --- The below dependencies are optional,
      "echasnovski/mini.pick", -- for file_selector provider mini.pick
      "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
      "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
      "ibhagwan/fzf-lua", -- for file_selector provider fzf
      "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
      "zbirenbaum/copilot.lua", -- for providers='copilot'
      "MeanderingProgrammer/render-markdown.nvim",
      {
        -- support for image pasting
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          -- recommended settings
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            -- required for Windows users
            use_absolute_path = true,
          },
        },
      },
    },
  },
}
