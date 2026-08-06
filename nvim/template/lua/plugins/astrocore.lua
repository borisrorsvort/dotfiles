-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- AstroCore provides a central place to modify mappings, vim options, autocommands, and more!
-- Configuration documentation can be found with `:h astrocore`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

-- Shared functions for keymaps used across modes
local function hop_words() require("hop").hint_words() end
local function spectre_open_visual() require("spectre").open_visual() end

local function opencode_toggle()
  require "opencode"
  vim.g.opencode_opts.server.toggle()
end
local function opencode_ask() require("opencode").ask("@this: ", { submit = false }) end
local function opencode_ask_submit() require("opencode").ask("@this: ", { submit = true }) end
local function opencode_select() require("opencode").select() end
local function opencode_new_session() require("opencode").command "session.new" end
local function opencode_compact() require("opencode").command "session.compact" end
local function opencode_interrupt() require("opencode").command "session.interrupt" end

-- ── Terminal window options (shared across all AI providers) ──
local function ai_terminal_opts()
  return {
    win = {
      position = "right",
      width = 0.40,
      backdrop = 60,
      wo = {
        winblend = 0,
        number = false,
        relativenumber = false,
        signcolumn = "no",
        winbar = "",
        statusline = "",
      },
    },
  }
end

-- ── Send text to a running snacks terminal ───────────────────
local function send_to_terminal(cmd, text, opts)
  local Snacks = require "snacks"
  local terminal = Snacks.terminal.get(cmd, vim.tbl_deep_extend("force", opts or {}, { create = false }))
  if not terminal or not terminal.buf or not vim.api.nvim_buf_is_valid(terminal.buf) then return false end
  local channel = vim.bo[terminal.buf].channel
  if not channel or channel == 0 then return false end
  vim.api.nvim_chan_send(channel, text .. "\r")
  return true
end

-- ── AntiGravity helpers ─────────────────────────────────────
local function agy_toggle() require("snacks.terminal").toggle("agy", ai_terminal_opts()) end

local function agy_ask(mode)
  local file = vim.fn.expand "%"
  if file == "" then
    vim.notify("No file in current buffer", vim.log.levels.WARN)
    return
  end

  local line_info = ""
  if mode == "v" then
    -- Get line range of visual selection
    local s_start = vim.fn.getpos "'<"
    local s_end = vim.fn.getpos "'>"
    local start_line = s_start[2]
    local end_line = s_end[2]
    if start_line == end_line then
      line_info = ":" .. start_line
    else
      line_info = "#L" .. start_line .. "-L" .. end_line
    end
  else
    -- Single cursor line
    local cursor_line = vim.fn.line "."
    line_info = ":" .. cursor_line
  end

  vim.ui.input({ prompt = "Ask AntiGravity (" .. file .. line_info .. "): " }, function(input)
    if not input or input == "" then return end
    local prompt = "Review " .. file .. line_info .. ": " .. input
    local opts = ai_terminal_opts()
    if not send_to_terminal("agy", prompt, opts) then
      require("snacks.terminal").open({ "agy", prompt }, opts)
    end
  end)
end

local function agy_continue() require("snacks.terminal").open("agy --continue", ai_terminal_opts()) end

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

          -- Disable AstroNvim default <Leader>o (Neo-tree focus) - AI now lives under <Leader>a
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

          -- OpenCode (under <Leader>ao prefix)
          ["<Leader>aot"] = { opencode_toggle, desc = "Toggle" },
          ["<Leader>aoa"] = { opencode_ask, desc = "Ask" },
          ["<Leader>aos"] = { opencode_select, desc = "Select action" },
          ["<Leader>aon"] = { opencode_new_session, desc = "New session" },
          ["<Leader>aoc"] = { opencode_compact, desc = "Compact session" },
          ["<Leader>aoi"] = { opencode_interrupt, desc = "Interrupt" },

          -- Claude Code (under <Leader>ac prefix)
          ["<Leader>ac"] = { desc = "Claude Code" },
          ["<Leader>act"] = { "<cmd>ClaudeCode --dangerously-skip-permissions<cr>", desc = "Toggle (dangerous)" },
          ["<Leader>acf"] = { "<cmd>ClaudeCodeFocus<cr>", desc = "Focus" },
          ["<Leader>acr"] = { "<cmd>ClaudeCode --resume<cr>", desc = "Resume" },
          ["<Leader>acc"] = { "<cmd>ClaudeCode --continue<cr>", desc = "Continue" },
          ["<Leader>acm"] = { "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select model" },
          ["<Leader>acb"] = { "<cmd>ClaudeCodeAdd %<cr>", desc = "Add buffer" },
          ["<Leader>aca"] = { "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
          ["<Leader>acd"] = { "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },

          -- AntiGravity (under <Leader>aa prefix)
          ["<Leader>aa"] = { desc = "AntiGravity" },
          ["<Leader>aat"] = { agy_toggle, desc = "Toggle" },
          ["<Leader>aaa"] = { agy_ask, desc = "Ask" },
          ["<Leader>aac"] = { agy_continue, desc = "Continue" },
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

          -- OpenCode (under <Leader>ao prefix)
          ["<Leader>aot"] = { opencode_toggle, desc = "Toggle" },
          ["<Leader>aoa"] = { opencode_ask_submit, desc = "Ask (selection)" },
          ["<Leader>aos"] = { opencode_select, desc = "Select action" },

          -- Claude Code (under <Leader>ac prefix)
          ["<Leader>ac"] = { desc = "Claude Code" },
          ["<Leader>act"] = { "<cmd>ClaudeCode --dangerously-skip-permissions<cr>", desc = "Toggle (dangerous)" },
          ["<Leader>acs"] = { "<cmd>ClaudeCodeSend<cr>", desc = "Send to Claude" },
          ["<Leader>acb"] = { "<cmd>ClaudeCodeAdd %<cr>", desc = "Add buffer" },

          -- AntiGravity (under <Leader>aa prefix)
          ["<Leader>aa"] = { desc = "AntiGravity" },
          ["<Leader>aat"] = { agy_toggle, desc = "Toggle" },
          ["<Leader>aaa"] = { function() agy_ask "v" end, desc = "Ask (selection)" },
        },

        -- ── Visual-only mode (x) ────────────────────────────────────
        x = {
          -- Surround
          ["S"] = { "<Plug>(nvim-surround-visual)", desc = "Add surround" },
          ["gS"] = { "<Plug>(nvim-surround-visual-line)", desc = "Add surround (new lines)" },
        },

        -- ── Insert mode ─────────────────────────────────────────────
        i = {
          ["<C-s>"] = { "<Esc>:w!<cr>", desc = "Save File" },

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
