-- C / C++
--
-- LazyVim's clangd extra provides the LSP side (clangd, clang-tidy, <leader>ch
-- to switch source/header). This file only changes formatting: it goes through
-- the clang-format binary via conform instead of clangd, so the style can be
-- chosen per buffer.
--
--   1. a .clang-format above the file  -> used as-is (the project wins)
--   2. otherwise                        -> styles/clang-format/<style>.clang-format
--                                         where <style> comes from util.codestyle

local function style_file(style)
  return vim.fn.stdpath("config") .. "/styles/clang-format/" .. style .. ".clang-format"
end

return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        c = { "clang-format" },
        cpp = { "clang-format" },
        cuda = { "clang-format" },
        objc = { "clang-format" },
      },
      formatters = {
        ["clang-format"] = {
          args = function(_, ctx)
            local project = vim.fs.find(".clang-format", { path = ctx.dirname, upward = true })[1]
            local style = project and "file" or ("file:" .. style_file(require("util.codestyle").get(ctx.buf)))
            return { "--style=" .. style, "--assume-filename", ctx.filename }
          end,
        },
      },
    },
  },
}
