return {
  "michaelb/sniprun",
  build = "bash ./install.sh",
  cmd = { "SnipRun", "SnipInfo", "SnipReset", "SnipReplMemoryClean", "SnipClose", "SnipLive" },
  keys = {
    { "<leader>rx", "<Plug>SnipRun", mode = { "n", "v" }, desc = "SnipRun (Line/Selection)" },
    { "<leader>rX", "<Plug>SnipRunOperator", mode = "n", desc = "SnipRun (Operator)" },
    { "<leader>rq", "<Plug>SnipClose", mode = "n", desc = "SnipRun Close" },
    { "<leader>rl", "<cmd>SnipLive<cr>", mode = "n", desc = "SnipRun Live mode" },
  },
  config = function()
    require("sniprun").setup({
      display = {
        "VirtualTextOk",
        "VirtualTextErr",
      },
      live_display = {
        "VirtualTextOk",
        "VirtualTextErr",
      },
      repl_enable = {},
      selected_interpreters = { "Python3_original" },
      live_mode_toggle = "enable",
    })
  end,
}
