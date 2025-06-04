-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- Customize Treesitter
---@type LazySpec
return {
  "andrewferrier/wrapping.nvim",
  config = function()
    require("wrapping").setup {
      softener = { markdown = true },
    }
  end,
  opts = {
    auto_set_mode_filetype_allowlist = {
      "asciidoc",
      "gitcommit",
      "markdown",
      "text",
    },
  },
}
