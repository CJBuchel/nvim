-- Bootstrap lazy.nvim, then load LazyVim and the plugin specs under lua/plugins.

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    -- LazyVim and the extras listed in lazyvim.json
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },
    -- Our overrides. lazy.nvim imports are not recursive, so each directory is listed.
    { import = "plugins" },
    { import = "plugins.lang" },
  },
  defaults = {
    -- Load our own plugins at startup; LazyVim's are lazy-loaded.
    lazy = false,
    -- Track git HEAD rather than tagged releases; many plugins tag rarely and
    -- stale tags break more often than HEAD. lazy-lock.json pins the commits.
    version = false,
  },
  install = { colorscheme = { "cyberdream", "habamax" } },
  -- No background update checks: updates are done on purpose with :Lazy update
  -- and then committed via lazy-lock.json (see README "Updating").
  checker = { enabled = false },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
