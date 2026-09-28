return {
  {
    "hwartig/vim-seeing-is-believing",
    ft = "ruby",
    keys = {
      { "<leader>rr", "<Plug>(seeing-is-believing-mark-and-run)", mode = "n", desc = "Seeing Is Believing: Run" },
      { "<leader>rr", "<Plug>(seeing-is-believing-run-visual)", mode = "x", desc = "Seeing Is Believing: Run" },
      { "<leader>rm", "<Plug>(seeing-is-believing-mark)", mode = { "n", "x" }, desc = "Seeing Is Believing: Mark Line" },
      { "<leader>rc", "<cmd>%!seeing_is_believing --clean<cr>", mode = "n", desc = "Seeing Is Believing: Clean Marks" },
    },
  },
}
