---@type LazySpec
return {
  "nvim-neotest/neotest",
  lazy = true,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "antoinemadec/FixCursorHold.nvim",
    "olimorris/neotest-rspec",
    "haydenmeade/neotest-jest",
  },
  -- Add options here
  opts = function(_, opts)
    opts.icons = {
      child_indent = "│",
      child_prefix = "├",
      collapsed = "─",
      expanded = "╮",
      failed = "❌",
      final_child_indent = " ",
      final_child_prefix = "╰",
      non_collapsible = "─",
      passed = "✅",
      running = "🕥",
      running_animated = { "/", "|", "\\", "-", "/", "|", "\\", "-" },
      skipped = "🚫",
      unknown = "❓",
    }
    opts.quickfix = {
      enabled = false,
      open = false,
    }
    -- opts.output_panel = {
    --   enabled = true,
    --   open = "rightbelow vsplit | resize 30",
    -- }
    opts.status = {
      enabled = true,
      virtual_text = false,
      signs = true,
    }
    opts.adapters = {
      require "neotest-rspec",
      require "neotest-jest" {
        jestCommand = "npm test --",
        jestConfigFile = "jest.config.js",
        env = { CI = true },
      },
    }
    -- Add a hook to attach the panel when byebug is triggered
    opts.hooks = {
      before_test_run = function()
        -- Check if byebug is active
        if vim.fn.exists ":Byebug" == 2 then
          -- Attach the neotest panel
          require("neotest").run.attach()
        end
      end,
    }
  end,
}
