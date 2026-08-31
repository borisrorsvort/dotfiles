return {
  "Vigemus/iron.nvim",
  ft = { "python" },
  config = function()
    require("iron.core").setup {
      config = {
        scratch_repl = true,
        repl_definition = {
          python = { command = { "ipython", "--no-autoindent" } },
        },
        repl_open_cmd = require("iron.view").bottom(40),
      },
      keymaps = {
        send_motion = "<leader>sc",
        visual_send = "<leader>sc",
        send_file = "<leader>sf",
        send_line = "<leader>sl",
        send_mark = "<leader>sm",
        mark_motion = "<leader>mc",
        mark_visual = "<leader>mc",
        remove_mark = "<leader>md",
        cr = "<leader>s<cr>",
        interrupt = "<leader>s<space>",
        exit = "<leader>sq",
        clear = "<leader>cl",
      },
      highlight = { italic = true },
      ignore_blank_lines = true,
    }
  end,
}
