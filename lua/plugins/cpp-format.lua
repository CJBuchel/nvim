-- C/C++ formatting: ROS 2 style by default.
--
-- Formats with the clang-format binary via conform (instead of clangd's LSP
-- formatting). If the file lives under a directory that has its own
-- .clang-format (e.g. the missim Unreal project), that file wins. Otherwise the
-- ROS 2 style bundled with this nvim config is used.

local ros2_style = vim.fn.stdpath("config") .. "/clang-format/ros2.clang-format"

return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        c = { "clang-format" },
        cpp = { "clang-format" },
        objc = { "clang-format" },
        cuda = { "clang-format" },
      },
      formatters = {
        ["clang-format"] = {
          args = function(_, ctx)
            local project_style = vim.fs.find(".clang-format", { path = ctx.dirname, upward = true })[1]
            local style = project_style and "--style=file" or ("--style=file:" .. ros2_style)
            return { style, "--assume-filename", ctx.filename }
          end,
        },
      },
    },
  },
}
