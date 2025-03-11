-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- AstroCore provides a central place to modify mappings, vim options, autocommands, and more!
-- Configuration documentation can be found with `:h astrocore`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    -- Configure core features of AstroNvim
    features = {
      large_buf = { size = 1024 * 500, lines = 10000 }, -- set global limits for large files for disabling features like treesitter
      autopairs = true, -- enable autopairs at start
      cmp = true, -- enable completion at start
      diagnostics_mode = 3, -- diagnostic mode on start (0 = off, 1 = no signs/virtual text, 2 = no virtual text, 3 = on)
      highlighturl = true, -- highlight URLs at start
      notifications = true, -- enable notifications at start
      code_lens = true, -- enable code lens at start
    },
    -- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
    diagnostics = {
      virtual_text = true,
      underline = true,
    },
    -- vim options can be configured here
    options = {
      opt = { -- vim.opt.<key>
        relativenumber = true, -- sets vim.opt.relativenumber
        number = true, -- sets vim.opt.number
        spell = false, -- sets vim.opt.spell
        signcolumn = "auto", -- sets vim.opt.signcolumn to auto
        wrap = false, -- sets vim.opt.wrap
        swapfile = false,
        -- background = "dark",
        guifont = "FiraCode_Nerd_Font_Mono:h21",
        conceallevel = 2, -- enable conceal
        foldenable = false,
        foldexpr = "nvim_treesitter#foldexpr()", -- set Treesitter based folding
        foldmethod = "expr",
        linebreak = true, -- linebreak soft wrap at words
        list = true, -- show whitespace characters
        showbreak = "﬌ ",
      },
      g = { -- vim.g.<key>
        -- configure global vim variables (vim.g)
        -- NOTE: `mapleader` and `maplocalleader` must be set in the AstroNvim opts or before `lazy.setup`
        -- This can be found in the `lua/lazy_setup.lua` file
        autoformat_enabled = true, -- enable or disable auto formatting at start (lsp.formatting.format_on_save must be enabled)
        cmp_enabled = true, -- enable completion at start
        autopairs_enabled = true, -- enable autopairs at start
        diagnostics_mode = 3, -- set the visibility of diagnostics in the UI (0=off, 1=only show in status line, 2=virtual text off, 3=all on)
        icons_enabled = true, -- disable icons in the UI (disable if no nerd font is available, requires :PackerSync after changing)
        ui_notifications_enabled = false, -- disable notifications when toggling UI elements
      },
    },
    -- Mappings can be configured through AstroCore as well.
    -- NOTE: keycodes follow the casing in the vimdocs. For example, `<Leader>` must be capitalized
    mappings = {
      n = {
        -- second key is the lefthand side of the map
        -- mappings seen under group name "Buffer"
        ["<C-h>"] = false,
        ["<C-j>"] = false,
        ["<C-k>"] = false,
        ["<C-l>"] = false,
        ["k"] = false, -- cancel overwrite in https://github.com/AstroNvim/AstroNvim/blob/148a513072e6fc2a40fe8ad89534d4b6d00db5e7/lua/astronvim/mappings.lua#L23
        ["j"] = false, -- cancel overwrite in https://github.com/AstroNvim/AstroNvim/blob/148a513072e6fc2a40fe8ad89534d4b6d00db5e7/lua/astronvim/mappings.lua#L24
        ["<Leader>bn"] = { "<cmd>tabnew<cr>", desc = "New tab" },
        ["<Leader>bD"] = {
          function()
            require("astroui.status").heirline.buffer_picker(
              function(bufnr) require("astrocore.buffer").close(bufnr) end
            )
          end,
          desc = "Pick to close",
        },
        ["<C-q>"] = { "<cmd>lua require'qf'.toggle('c', false)<CR>", noremap = { true }, desc = "Toggle quickfix" }, -- toggle("c", false) dont stay in current window
        ["f"] = { "<cmd>lua require'hop'.hint_words()<cr>", desc = "Hop toggle" },
        ["<C-s>"] = { ":w!<cr>", desc = "Save File" },
        ["<Leader>ff"] = {
          "<cmd>lua require'telescope.builtin'.find_files(require('telescope.themes').get_dropdown({}))<cr>",
          desc = "Find files",
        },
        ["<Leader>fs"] = { "<cmd>lua require('spectre').toggle()<cr>", desc = "Open Spectre" },
        ["<Leader>fS"] = {
          function() require("spectre").open_file_search() end,
          desc = "Spectre (current file)",
        },
        ["<Leader>fc"] = {
          function() require("spectre").open_visual { select_word = true } end,
          desc = "Spectre (current word)",
        },
        ["<Tab>"] = {
          function() require("astrocore.buffer").nav(vim.v.count > 0 and vim.v.count or 1) end,
          desc = "Next buffer",
        },
        ["<S-Tab>"] = {
          function() require("astrocore.buffer").nav(-(vim.v.count > 0 and vim.v.count or 1)) end,
          desc = "Previous buffer",
        },
        ["<Leader>T"] = { name = "Test" },
        ["<Leader>Tn"] = {
          function() require("neotest").run.run() end,
          desc = "Run test under cursor",
        },
        ["<Leader>Tf"] = {
          function() require("neotest").run.run(vim.fn.expand "%") end,
          desc = "Run test file",
        },
        ["<Leader>Ts"] = {
          function() require("neotest").summary.toggle() end,
          desc = "Open test summary",
        },
        ["<Leader>tc"] = { "<cmd>lua require('ror.commands').list_commands()<CR>", desc = "Open Rails menu" },
      },
      v = {
        ["f"] = { "<cmd>lua require'hop'.hint_words()<cr>", desc = "Hop toggle" },
        ["<Leader>fs"] = { "<cmd>lua require('spectre').open_visual()<cr>", desc = "Open Spectre" },
        ["<Leader>rr"] = {
          "<Esc><cmd>lua require('telescope').extensions.refactoring.refactors()<CR>",
          desc = "Bring up the refacoring menu",
        },
      },
      t = {
        ["<Esc>"] = "<C-\\><C-n>",
      },
    },
  },
}
