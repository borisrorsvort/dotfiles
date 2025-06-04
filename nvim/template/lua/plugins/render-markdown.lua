-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- Customize Treesitter
---@type LazySpec
return {
  -- Make sure to set this up properly if you have lazy=true
  "MeanderingProgrammer/render-markdown.nvim",
  opts = {
    file_types = { "markdown" },
    indent = {
      -- Turn on / off org-indent-mode.
      enabled = false,
      -- Additional modes to render indents.
      render_modes = false,
      -- Amount of additional padding added for each heading level.
      per_level = 3,
    },
  },
  ft = { "markdown", "Avante" },
}
