-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- VSCode-style shortcuts for the utility actions. These keys are unused (or
-- rarely used) in vim, so they sit alongside LazyVim's <space> keys rather
-- than replacing them. The <space> equivalent is noted for each.
local map = vim.keymap.set

map({ "n", "i" }, "<C-b>", function() Snacks.explorer({ cwd = LazyVim.root() }) end, { desc = "Explorer (<space>e)" })
map("n", "<C-p>", function() LazyVim.pick("files", { root = false })() end, { desc = "Find Files in cwd (<space>fF)" })
map({ "n", "i" }, "<C-S-f>", function() LazyVim.pick("grep", { root = false })() end, { desc = "Search in Files in cwd (<space>sG)" })
map({ "n", "i" }, "<C-S-p>", function() Snacks.picker.commands() end, { desc = "Command Palette (<space>:)" })
map({ "n", "t" }, "<C-`>", function() Snacks.terminal.focus(nil, { cwd = LazyVim.root() }) end, { desc = "Terminal (ctrl+/)" })

-- LSP
map("n", "<F12>", function() Snacks.picker.lsp_definitions() end, { desc = "Go to Definition (gd)" })
map("n", "<S-F12>", function() Snacks.picker.lsp_references() end, { desc = "References (gr)" })
map("n", "<F2>", vim.lsp.buf.rename, { desc = "Rename Symbol (<space>cr)" })
map({ "n", "i", "x" }, "<C-.>", vim.lsp.buf.code_action, { desc = "Code Action (<space>ca)" })
map({ "n", "i", "x" }, "<S-A-f>", function() LazyVim.format({ force = true }) end, { desc = "Format (<space>cf)" })
map("n", "<F8>", function() vim.diagnostic.jump({ count = 1, float = true }) end, { desc = "Next Problem (]d)" })
map("n", "<S-F8>", function() vim.diagnostic.jump({ count = -1, float = true }) end, { desc = "Prev Problem ([d)" })

-- Move lines with alt+arrows (LazyVim already does alt+j/k)
map("n", "<A-Down>", "<cmd>execute 'move .+' . v:count1<cr>==", { desc = "Move Line Down" })
map("n", "<A-Up>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Move Line Up" })
map("i", "<A-Down>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Line Down" })
map("i", "<A-Up>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Line Up" })
map("v", "<A-Down>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Move Lines Down" })
map("v", "<A-Up>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move Lines Up" })
