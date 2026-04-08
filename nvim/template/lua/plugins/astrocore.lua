-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- AstroCore provides a central place to modify mappings, vim options, autocommands, and more!
-- Configuration documentation can be found with `:h astrocore`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

-- Shared functions for keymaps used across modes
local function hop_words() require("hop").hint_words() end
local function spectre_open_visual() require("spectre").open_visual() end

local function opencode_toggle() require("opencode").toggle() end
local function opencode_ask() require("opencode").ask("@this: ", { submit = false }) end
local function opencode_ask_submit() require("opencode").ask("@this: ", { submit = true }) end
local function opencode_select() require("opencode").select() end
local function opencode_new_session() require("opencode").command "session.new" end
local function opencode_compact() require("opencode").command "session.compact" end
local function opencode_interrupt() require("opencode").command "session.interrupt" end

---@type LazySpec
return {
  -- ── AstroCore ────────────────────────────────────────────────────
  {
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
      -- Treesitter configuration (moved from treesitter.lua for AstroNvim v6)
      treesitter = {
        ensure_installed = {
          "lua",
          "javascript",
          "vimdoc",
          "json",
          "vim",
          "ruby",
          "html",
          "css",
          "tsx",
          "styled",
          "yaml",
          "markdown",
          "bash",
        },
        highlight = true,
        indent = true,
        incremental_selection = {
          keymaps = {
            init_selection = "<c-space>",
            node_incremental = "<c-space>",
            scope_incremental = "<c-s>",
            node_decremental = "<c-backspace>",
          },
        },
        textobjects = {
          select = {
            select_textobject = {
              ["aa"] = { query = "@parameter.outer", desc = "around parameter" },
              ["ia"] = { query = "@parameter.inner", desc = "inside parameter" },
              ["af"] = { query = "@function.outer", desc = "around function" },
              ["if"] = { query = "@function.inner", desc = "inside function" },
              ["ac"] = { query = "@class.outer", desc = "around class" },
              ["ic"] = { query = "@class.inner", desc = "inside class" },
            },
          },
          move = {
            goto_next_start = {
              ["]m"] = { query = "@function.outer", desc = "Next function start" },
              ["]]"] = { query = "@class.outer", desc = "Next class start" },
            },
            goto_next_end = {
              ["]M"] = { query = "@function.outer", desc = "Next function end" },
              ["]["] = { query = "@class.outer", desc = "Next class end" },
            },
            goto_previous_start = {
              ["[m"] = { query = "@function.outer", desc = "Previous function start" },
              ["[["] = { query = "@class.outer", desc = "Previous class start" },
            },
            goto_previous_end = {
              ["[M"] = { query = "@function.outer", desc = "Previous function end" },
              ["[]"] = { query = "@class.outer", desc = "Previous class end" },
            },
          },
          swap = {
            swap_next = {
              ["<leader>a"] = { query = "@parameter.inner", desc = "Swap next parameter" },
            },
            swap_previous = {
              ["<leader>A"] = { query = "@parameter.inner", desc = "Swap previous parameter" },
            },
          },
        },
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
          foldexpr = "v:lua.vim.treesitter.foldexpr()", -- set Treesitter based folding
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
        -- ── Normal mode ──────────────────────────────────────────────
        n = {
          -- Navigation overrides
          ["<C-h>"] = false,
          ["<C-j>"] = false,
          ["<C-k>"] = false,
          ["<C-l>"] = false,
          ["k"] = false, -- cancel overwrite in https://github.com/AstroNvim/AstroNvim/blob/148a513072e6fc2a40fe8ad89534d4b6d00db5e7/lua/astronvim/mappings.lua#L23
          ["j"] = false, -- cancel overwrite in https://github.com/AstroNvim/AstroNvim/blob/148a513072e6fc2a40fe8ad89534d4b6d00db5e7/lua/astronvim/mappings.lua#L24

          -- Disable AstroNvim default <Leader>o (Neo-tree focus) to use as which-key group for Opencode
          ["<Leader>o"] = false,

          ["<C-s>"] = { ":w!<cr>", desc = "Save File" },
          ["f"] = { hop_words, desc = "Hop toggle" },

          -- Buffers
          ["<Tab>"] = {
            function() require("astrocore.buffer").nav(vim.v.count > 0 and vim.v.count or 1) end,
            desc = "Next buffer",
          },
          ["<S-Tab>"] = {
            function() require("astrocore.buffer").nav(-(vim.v.count > 0 and vim.v.count or 1)) end,
            desc = "Previous buffer",
          },
          ["<Leader>bn"] = { "<cmd>tabnew<cr>", desc = "New tab" },
          ["<Leader>bD"] = {
            function()
              require("astroui.status").heirline.buffer_picker(
                function(bufnr) require("astrocore.buffer").close(bufnr) end
              )
            end,
            desc = "Pick to close",
          },

          -- Surround (nvim-surround v4 <Plug> mappings)
          ["ys"] = { "<Plug>(nvim-surround-normal)", desc = "Add surround" },
          ["yss"] = { "<Plug>(nvim-surround-normal-cur)", desc = "Add surround (line)" },
          ["yS"] = { "<Plug>(nvim-surround-normal-line)", desc = "Add surround (new lines)" },
          ["ySS"] = { "<Plug>(nvim-surround-normal-cur-line)", desc = "Add surround (new lines, line)" },
          ["ds"] = { "<Plug>(nvim-surround-delete)", desc = "Delete surround" },
          ["ls"] = { "<Plug>(nvim-surround-change)", desc = "Change surround" },
          ["lS"] = { "<Plug>(nvim-surround-change-line)", desc = "Change surround (line)" },

          -- Quickfix
          ["<C-q>"] = { "<cmd>lua require'qf'.toggle('c', false)<CR>", noremap = { true }, desc = "Toggle quickfix" },

          -- Search / Replace (Telescope, Spectre)
          ["<Leader>fS"] = {
            function() require("telescope").extensions.luasnip.luasnip {} end,
            desc = "Find snippets",
          },
          ["<Leader>ff"] = {
            "<cmd>lua require'telescope.builtin'.find_files(require('telescope.themes').get_dropdown({}))<cr>",
            desc = "Find files",
          },
          ["<Leader>fs"] = { "<cmd>lua require('spectre').toggle()<cr>", desc = "Open Spectre" },
          ["<Leader>fc"] = {
            function() require("spectre").open_visual { select_word = true } end,
            desc = "Spectre (current word)",
          },

          -- Rails
          ["<Leader>rc"] = { "<cmd>lua require('ror.commands').list_commands()<CR>", desc = "Open Rails menu" },

          -- Opencode (which-key group auto-detected from sub-mappings)
          ["<Leader>ot"] = { opencode_toggle, desc = "Toggle" },
          ["<Leader>oa"] = { opencode_ask, desc = "Ask" },
          ["<Leader>os"] = { opencode_select, desc = "Select action" },
          ["<Leader>on"] = { opencode_new_session, desc = "New session" },
          ["<Leader>oc"] = { opencode_compact, desc = "Compact session" },
          ["<Leader>oi"] = { opencode_interrupt, desc = "Interrupt" },

          -- Claude Code
          ["<Leader>O"] = { desc = "Claude Code" },
          ["<Leader>Ot"] = { "<cmd>ClaudeCode<cr>", desc = "Toggle" },
          ["<Leader>Of"] = { "<cmd>ClaudeCodeFocus<cr>", desc = "Focus" },
          ["<Leader>Or"] = { "<cmd>ClaudeCode --resume<cr>", desc = "Resume" },
          ["<Leader>Oc"] = { "<cmd>ClaudeCode --continue<cr>", desc = "Continue" },
          ["<Leader>Om"] = { "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select model" },
          ["<Leader>Ob"] = { "<cmd>ClaudeCodeAdd %<cr>", desc = "Add buffer" },
          ["<Leader>Oa"] = { "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
          ["<Leader>Od"] = { "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
          ["<Leader>OD"] = { "<cmd>ClaudeCode --dangerously-skip-permissions<cr>", desc = "Toggle (dangerous)" },
        },

        -- ── Visual mode ──────────────────────────────────────────────
        v = {
          -- Navigation
          ["f"] = { hop_words, desc = "Hop toggle" },

          -- Search / Replace
          ["<Leader>fs"] = { spectre_open_visual, desc = "Open Spectre" },

          -- Refactoring
          ["<Leader>rr"] = {
            "<Esc><cmd>lua require('telescope').extensions.refactoring.refactors()<CR>",
            desc = "Bring up the refacoring menu",
          },

          -- Opencode (which-key group auto-detected from sub-mappings)
          ["<Leader>ot"] = { opencode_toggle, desc = "Toggle" },
          ["<Leader>oa"] = { opencode_ask_submit, desc = "Ask (selection)" },
          ["<Leader>os"] = { opencode_select, desc = "Select action" },

          -- Claude Code
          ["<Leader>O"] = { desc = "Claude Code" },
          ["<Leader>Ot"] = { "<cmd>ClaudeCode<cr>", desc = "Toggle" },
          ["<Leader>Os"] = { "<cmd>ClaudeCodeSend<cr>", desc = "Send to Claude" },
          ["<Leader>Ob"] = { "<cmd>ClaudeCodeAdd %<cr>", desc = "Add buffer" },
        },

        -- ── Visual-only mode (x) ────────────────────────────────────
        x = {
          -- Surround
          ["S"] = { "<Plug>(nvim-surround-visual)", desc = "Add surround" },
          ["gS"] = { "<Plug>(nvim-surround-visual-line)", desc = "Add surround (new lines)" },
        },

        -- ── Insert mode ─────────────────────────────────────────────
        i = {
          -- Surround
          ["<C-g>s"] = { "<Plug>(nvim-surround-insert)", desc = "Add surround" },
          ["<C-g>S"] = { "<Plug>(nvim-surround-insert-line)", desc = "Add surround (new lines)" },
        },

        -- ── Terminal mode ────────────────────────────────────────────
        t = {
          ["<Esc>"] = "<C-\\><C-n>",
        },
      },
    },
  },

  -- ── Surround (v4: disable defaults, keymaps live in astrocore) ──
  {
    "kylechui/nvim-surround",
    init = function() vim.g.nvim_surround_no_mappings = true end,
    opts = {},
  },
}
