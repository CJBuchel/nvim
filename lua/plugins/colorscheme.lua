-- Cyberdream: high-contrast, vibrant. Matches kitty, zellij and the prompt.
-- Try others live with <space>uC
return {
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
}
