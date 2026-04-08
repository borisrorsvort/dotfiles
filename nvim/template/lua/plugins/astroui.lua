-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- AstroUI provides the basis for configuring the AstroNvim User Interface
-- Configuration documentation can be found with `:h astroui`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

---@type LazySpec
return {
  "AstroNvim/astroui",
  ---@type AstroUIOpts
  opts = {
    -- change colorscheme
    colorscheme = "nord",
    -- colorscheme = "habamax",
    -- colorscheme = "kanagawa",
    -- colorscheme = "astromars",
    -- AstroUI allows you to easily modify highlight groups easily for any and all colorschemes
    highlights = {
      -- init applies to all themes, used as fallback
      init = {
        -- Unified tabline background to eliminate visual triangles
        TabLineFill = { bg = "#2E3440" },
      },

      -- Nord-specific overrides for better buffer tab visibility
      nord = {
        -- Background for empty tabline space - unified dark background (nord0)
        TabLineFill = { bg = "#2E3440" },

        -- Inactive buffer tabs - improved contrast (nord4 text on nord1 bg)
        TabLine = { fg = "#D8DEE9", bg = "#3B4252" },

        -- Active buffer tab - Frost blue with dark text for high contrast
        TabLineSel = { fg = "#2E3440", bg = "#88C0D0", bold = true },

        -- Modified buffer indicator - warm accent for visibility
        TabLineMod = { fg = "#EBCB8B", bg = "#3B4252" },
      },
    },
    -- Icons can be configured throughout the interface
    icons = {
      -- configure the loading of the lsp in the status line
      LSPLoading1 = "⠋",
      LSPLoading2 = "⠙",
      LSPLoading3 = "⠹",
      LSPLoading4 = "⠸",
      LSPLoading5 = "⠼",
      LSPLoading6 = "⠴",
      LSPLoading7 = "⠦",
      LSPLoading8 = "⠧",
      LSPLoading9 = "⠇",
      LSPLoading10 = "⠏",
    },
  },
}
