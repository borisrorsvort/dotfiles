-- Override heirline-vscode-winbar to disable winbar for terminal windows
return {
  "rebelot/heirline.nvim",
  opts = function(_, opts)
    -- Don't show winbar for terminal or snacks_terminal filetypes
    local winbar = opts.winbar
    if winbar and type(winbar) == "table" then
      -- Add condition at the beginning to skip winbar for terminals
      table.insert(winbar, 1, {
        condition = function()
          local bufnr = vim.api.nvim_get_current_buf()
          local buftype = vim.bo[bufnr].buftype
          local filetype = vim.bo[bufnr].filetype
          return buftype == "terminal" or filetype == "snacks_terminal" or filetype:match("^term")
        end,
        provider = "", -- empty winbar for terminals
      })
    end
    return opts
  end,
}
