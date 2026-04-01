-- if true then return end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- This will run last in the setup process and is a good place to configure
-- things like custom filetypes. This just pure lua so anything that doesn't
-- fit in the normal config locations above can go here

-- Set up custom filetypes
-- vim.filetype.add {
--   extension = {
--     foo = "fooscript",
--   },
--   filename = {
--     ["Foofile"] = "fooscript",
--   },
--   pattern = {
--     ["~/%.config/foo/.*"] = "fooscript",
--   },
-- }

vim.g.neo_show_hidden = 1
vim.g.translator_target_lang = "fr"
vim.g.translator_source_lang = "en"

vim.diagnostic.config {
  virtual_text = true,
}

-- Terminal theme integration for AI assistants
-- Makes Claude Code and opencode blend with tokyonight-moon theme
vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "*",
  callback = function()
    -- Disable line numbers and sign column in terminal
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn = "no"
    
    -- Blend terminal with editor background (tokyonight-moon: #1e2030)
    vim.api.nvim_set_hl(0, "Terminal", { bg = "#1e2030" })
    
    -- Ensure terminal background matches Normal background
    local normal_bg = vim.api.nvim_get_hl(0, { name = "Normal" }).bg
    if normal_bg then
      vim.api.nvim_set_hl(0, "Terminal", { bg = normal_bg })
    end
  end,
})

-- Additional styling for snacks terminal windows
vim.api.nvim_create_autocmd("FileType", {
  pattern = "snacks_terminal",
  callback = function()
    -- Match border colors with tokyonight-moon theme
    vim.api.nvim_set_hl(0, "SnacksBorder", { link = "FloatBorder" })
    vim.api.nvim_set_hl(0, "SnacksBackdrop", { bg = "#000000", blend = 60 })
    -- Disable heirline statusline and winbar for terminal windows
    vim.opt_local.winbar = ""
    vim.opt_local.statusline = ""
    vim.opt_local.statuscolumn = ""
  end,
})
