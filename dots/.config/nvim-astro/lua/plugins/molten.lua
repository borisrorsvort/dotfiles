return {
    {
        "benlubas/molten-nvim",
        version = "^1.0.0", -- use version <2.0.0 to avoid breaking changes
        build = ":UpdateRemotePlugins",
        init = function()
            -- these are examples, not defaults
            -- Please see the readme
            vim.g.molten_output_win_max_height = 20
        end,
        keys = {
            { "<leader>mi", ":MoltenInit<CR>", desc = "Initialize Molten" },
            { "<leader>me", ":MoltenEvaluateOperator<CR>", desc = "Evaluate operator" },
            { "<leader>mr", ":MoltenEvaluateLine<CR>", desc = "Evaluate line" },
            { "<leader>mv", ":<C-u>MoltenEvaluateVisual<CR>gv", mode = "v", desc = "Evaluate visual selection" },
            { "<leader>mo", ":MoltenShowOutput<CR>", desc = "Show output" },
            { "<leader>mx", ":MoltenDeinit<CR>", desc = "Deinitialize Molten" },
        },
    }
}
