-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- Customize Treesitter
---@type LazySpec
return {
  -- Make sure to set this up properly if you have lazy=true
  "MeanderingProgrammer/render-markdown.nvim",
  opts = {
    file_types = { "markdown" },
    heading = {
      -- Turn on heading icon & rendering
      enabled = true,
      render_modes = false,
      atx = true,
      setext = true,
      sign = true,
      -- Heading prefixes: use '# ', '## ', '### ', etc. instead of numeric badges
      icons = { "# ", "## ", "### ", "#### ", "##### ", "###### " },
      position = "overlay",
      signs = { "󰫎 " },
      -- Width of the heading: 'full' (window-wide border) or 'block' (text-width border)
      width = "full",
      left_margin = 0,
      left_pad = 0,
      right_pad = 0,
      min_width = 0,
      -- Bottom border: enabled for H1 and H2 (can also be set to `true` for all levels)
      border = { true, true, false, false, false, false },
      -- Always use virtual lines for borders to preserve blank lines as bottom margin
      border_virtual = true,
      border_prefix = false,
      -- Empty above removes the top border while creating a top margin virtual line
      above = "",
      -- Character used for bottom border: '=' for H1 (===), '-' for H2 (---)
      below = { "=", "-" },
      -- No background colors on headings (empty table removes highlight bars)
      backgrounds = {},
      -- Foreground colors per heading level (linked to Treesitter markup.heading.X)
      foregrounds = {
        "RenderMarkdownH1",
        "RenderMarkdownH2",
        "RenderMarkdownH3",
        "RenderMarkdownH4",
        "RenderMarkdownH5",
        "RenderMarkdownH6",
      },
    },
    indent = {
      -- Turn on / off org-indent-mode.
      enabled = false,
      -- Additional modes to render indents.
      render_modes = false,
      -- Amount of additional padding added for each heading level.
      per_level = 3,
    },
  },
  config = function(_, opts)
    -- Allow per-level heading border characters (e.g. { '=', '-' } for H1 and H2)
    local HeadingRender = require "render-markdown.render.markdown.heading"
    local orig_border = HeadingRender.border
    HeadingRender.border = function(self, box, above)
      local key = above and "above" or "below"
      if type(self.config[key]) == "table" then
        local orig = self.config[key]
        self.config[key] = orig[self.data.level] or orig[#orig] or ""
        local ok, res = pcall(orig_border, self, box, above)
        self.config[key] = orig
        if not ok then error(res) end
        return res
      end
      return orig_border(self, box, above)
    end

    require("render-markdown").setup(opts)
  end,
  ft = { "markdown" },
}

