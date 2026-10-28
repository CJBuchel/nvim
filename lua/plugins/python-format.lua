-- Python formatting: match the pre-commit hooks used in our ROS repos
-- (isort --profile black, black --line-length=99) instead of ruff's 88-column default.

return {
  {
    "mason-org/mason.nvim",
    opts = { ensure_installed = { "black", "isort" } },
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        python = { "isort", "black" },
      },
      formatters = {
        black = { prepend_args = { "--line-length", "99" } },
        isort = { prepend_args = { "--profile", "black", "--line-length", "99" } },
      },
    },
  },
}
