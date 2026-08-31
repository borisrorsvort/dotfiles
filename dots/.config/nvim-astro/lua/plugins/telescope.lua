-- Customize Treesitter
return {
  "nvim-telescope/telescope.nvim",
  opts = function(_, opts)
    local actions = require "telescope.actions"
    
    opts.defaults = opts.defaults or {}
    opts.defaults.path_display = { "truncate" }
    opts.defaults.preview = { treesitter = false }
    opts.defaults.file_ignore_patterns = { "node_modules", ".git", "*.lock" }
    
    opts.defaults.mappings = {
      i = {
        ["<C-t>"] = actions.move_selection_next,
        ["<C-s>"] = actions.move_selection_previous,
        ["<C-r>"] = actions.cycle_history_next,
        ["<C-c>"] = actions.cycle_history_prev,
        ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
      },
      n = {
        ["<C-r>"] = actions.move_selection_next,
        ["<C-c>"] = actions.move_selection_previous,
        ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
      },
    }
    
    opts.pickers = opts.pickers or {}
    opts.pickers.find_files = { hidden = true }
    opts.pickers.live_grep = {
      additional_args = function()
        return { "--hidden" }
      end,
    }
    
    return opts
  end,
}
