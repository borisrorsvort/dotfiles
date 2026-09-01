-- Omarchy theme integration for AstroNvim
--
-- Reads the active Omarchy theme from the state directory and translates
-- the LazyVim-shaped neovim.lua spec into an AstroNvim-compatible one.
-- On non-Omarchy systems (macOS), this file returns {} and astroui.lua's
-- hardcoded colorscheme takes effect as the fallback.

local state_file = vim.fn.expand("~/.local/state/omarchy/current/theme/neovim.lua")

-- On non-Omarchy systems, skip entirely
if vim.fn.filereadable(state_file) ~= 1 then
  return {}
end

local ok, specs = pcall(dofile, state_file)
if not ok or type(specs) ~= "table" then
  return {}
end

local result = {}
local colorscheme = nil

for _, spec in ipairs(specs) do
  if type(spec) == "table" and spec[1] == "LazyVim/LazyVim" then
    -- Extract colorscheme name, discard the LazyVim spec itself
    colorscheme = spec.opts and spec.opts.colorscheme
  elseif type(spec) == "table" and spec[1] then
    -- Keep the theme plugin spec (preserves opts like aether colors)
    table.insert(result, spec)
  end
end

if colorscheme then
  table.insert(result, {
    "AstroNvim/astroui",
    opts = { colorscheme = colorscheme },
  })
end

return result
