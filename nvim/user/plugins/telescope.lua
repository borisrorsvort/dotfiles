local actions = require "telescope.actions"
return {
  "nvim-telescope/telescope.nvim",
  opts = {
    defaults = {
      path_display = { "absolute" },
      mappings = {
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
    }
  }
}
