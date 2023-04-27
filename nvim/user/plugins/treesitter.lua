-- -- lvim.builtin.treesitter.ignore_install = { "haskell" }
-- -- lvim.builtin.treesitter.highlight.enable = true
-- -- lvim.builtin.treesitter.matchup.enable = true
-- --
-- --
-- --   -- Add languages to be installed here that you want installed for treesitter
return {
  "nvim-treesitter/nvim-treesitter",
  opts = {
    ensure_installed = { 'lua', 'javascript', 'vimdoc', 'json', 'vim', 'ruby', 'html', 'css', 'tsx' },
    highlight = { enable = true },
    indent = { enable = true, disable = { 'python' } },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = '<c-space>',
        node_incremental = '<c-space>',
        scope_incremental = '<c-s>',
        -- scope_decremental = '<c-t>', -- waiting for https://github.com/nvim-treesitter/nvim-treesitter/issues/4494
        node_decremental = '<c-backspace>',
      },
    },
    textobjects = {
      select = {
        enable = true,
        lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
        keymaps = {
          -- You can use the capture groups defined in textobjects.scm
          ['aa'] = '@parameter.outer',
          ['ia'] = '@parameter.inner',
          ['af'] = '@function.outer',
          ['if'] = '@function.inner',
          ['ac'] = '@class.outer',
          ['ic'] = '@class.inner',
        },
      },
      move = {
        enable = true,
        set_jumps = true, -- whether to set jumps in the jumplist
        goto_next_start = {
          [']m'] = '@function.outer',
          [']]'] = '@class.outer',
        },
        goto_next_end = {
          [']M'] = '@function.outer',
          [']['] = '@class.outer',
        },
        goto_previous_start = {
          ['[m'] = '@function.outer',
          ['[['] = '@class.outer',
        },
        goto_previous_end = {
          ['[M'] = '@function.outer',
          ['[]'] = '@class.outer',
        },
      },
      swap = {
        enable = true,
        swap_next = {
          ['<leader>a'] = '@parameter.inner',
        },
        swap_previous = {
          ['<leader>A'] = '@parameter.inner',
        },
      },
    }
  }
}
