-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- Customize Mason plugins

---@type LazySpec
return {
  {
    "zbirenbaum/copilot.lua",
    opts = function(_, opts)
      -- Merge or override existing options
      opts.suggestion = vim.tbl_deep_extend("force", opts.suggestion or {}, {
        enabled = true,
        auto_trigger = true, -- Ensures auto-trigger for Copilot
        keymap = {
          accept = "<C-a>", -- Custom keymap for accepting suggestions
          next = "<C-é>",
          prev = "<C-b>",
          dismiss = "<C-d>",
        },
      })
      opts.panel = vim.tbl_deep_extend("force", opts.panel or {}, {
        enabled = true,
        auto_refresh = false,
      })
    end,
  },
}
