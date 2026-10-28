-- Java
--
-- LazyVim's java extra provides jdtls, which needs a JDK 17+ on PATH (see the
-- README). On top of that, format with google-java-format instead of jdtls'
-- built-in Eclipse formatter so Java follows the same Google style as C++.

return {
  {
    "mason-org/mason.nvim",
    opts = { ensure_installed = { "google-java-format" } },
  },

  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        java = { "google-java-format" },
      },
    },
  },
}
