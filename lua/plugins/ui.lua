-- Look and feel: colorscheme, which-key, statusline additions.

return {
  -- Cyberdream: high-contrast, vibrant. Matches kitty, zellij and the prompt.
  -- Preview others live with <leader>uC.
  {
    "scottmckendry/cyberdream.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      italic_comments = true,
      borderless_pickers = false,
    },
  },
  { "LazyVim/LazyVim", opts = { colorscheme = "cyberdream" } },

  -- which-key: shows the keys you can press next as soon as you start a prefix
  -- (<leader>, g, z, [, ], <C-w>, d/y/c operators, " registers, ' marks).
  -- LazyVim ships it already; this makes it appear instantly for <leader> and
  -- as a full-width bar at the bottom instead of a small floating box.
  --
  --   <leader>?      every keybind for the current buffer
  --   <leader>sk     search all keymaps
  --   <C-w><space>   window-management menu
  {
    "folke/which-key.nvim",
    opts = {
      preset = "classic", -- full-width bar at the bottom ("helix" = small box bottom-right)
      delay = function(ctx)
        -- Instant for <leader> and the built-in menus (marks, registers, spelling),
        -- a short delay for everything else so a quick `dd` or `gg` doesn't flash it.
        if ctx.plugin or vim.startswith(ctx.keys, vim.g.mapleader or "\\") then
          return 0
        end
        return 100
      end,
      show_help = true, -- footer with <bs> back / <esc> close
      show_keys = true, -- echo the keys typed so far
      win = {
        border = "rounded",
        padding = { 1, 2 },
      },
      layout = {
        width = { min = 20 },
        spacing = 3,
      },
    },
  },

  -- Statusline: show the active code style (see util.codestyle) for the
  -- filetypes it affects, e.g. "google (auto)" or "ros2".
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      table.insert(opts.sections.lualine_x, 1, {
        function()
          return require("util.codestyle").describe()
        end,
        cond = function()
          return vim.tbl_contains({ "c", "cpp", "cuda", "objc", "python" }, vim.bo.filetype)
        end,
      })
    end,
  },
}
