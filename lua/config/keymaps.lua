-- Keymaps are loaded on the VeryLazy event.
-- LazyVim's defaults: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
--
-- Everything here is a VSCode-style alias for something LazyVim already binds
-- under <leader>. The keys are unused (or rarely used) in vim, so they sit
-- alongside the <leader> keys rather than replacing them; the <leader>
-- equivalent is in each description. The README lists both sets.
--
-- Note: <C-S-...> and <C-`> need a terminal that supports the kitty keyboard
-- protocol (kitty, wezterm, ghostty). Elsewhere they may silently do nothing;
-- the <leader> keys always work.

local map = vim.keymap.set

-- Files and search
map({ "n", "i" }, "<C-b>", function() Snacks.explorer({ cwd = LazyVim.root() }) end, { desc = "Explorer (<leader>e)" })
map("n", "<C-p>", function() LazyVim.pick("files", { root = false })() end, { desc = "Find Files in cwd (<leader>fF)" })
map({ "n", "i" }, "<C-S-f>", function() LazyVim.pick("grep", { root = false })() end, { desc = "Grep in cwd (<leader>sG)" })
map({ "n", "i" }, "<C-S-p>", function() Snacks.picker.commands() end, { desc = "Command Palette (<leader>sC)" })
map({ "n", "t" }, "<C-`>", function() Snacks.terminal.focus(nil, { cwd = LazyVim.root() }) end, { desc = "Terminal (<C-/>)" })

-- LSP
map("n", "<F12>", function() Snacks.picker.lsp_definitions() end, { desc = "Go to Definition (gd)" })
map("n", "<S-F12>", function() Snacks.picker.lsp_references() end, { desc = "References (gr)" })
map("n", "<F2>", vim.lsp.buf.rename, { desc = "Rename Symbol (<leader>cr)" })
map({ "n", "i", "x" }, "<C-.>", vim.lsp.buf.code_action, { desc = "Code Action (<leader>ca)" })
map({ "n", "i", "x" }, "<S-A-f>", function() LazyVim.format({ force = true }) end, { desc = "Format (<leader>cf)" })
map("n", "<F8>", function() vim.diagnostic.jump({ count = 1, float = true }) end, { desc = "Next Diagnostic (]d)" })
map("n", "<S-F8>", function() vim.diagnostic.jump({ count = -1, float = true }) end, { desc = "Prev Diagnostic ([d)" })

-- Move lines with alt+arrows (LazyVim already binds alt+j/k)
map("n", "<A-Down>", "<cmd>execute 'move .+' . v:count1<cr>==", { desc = "Move Line Down" })
map("n", "<A-Up>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Move Line Up" })
map("i", "<A-Down>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Line Down" })
map("i", "<A-Up>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Line Up" })
map("v", "<A-Down>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Move Lines Down" })
map("v", "<A-Up>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move Lines Up" })
