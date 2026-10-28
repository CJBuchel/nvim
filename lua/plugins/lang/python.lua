-- Python
--
-- LazyVim's python extra provides pyright (types, navigation) and ruff (lint,
-- imports). Two changes on top of that:
--
--   * pyright is pointed at the nearest pixi environment so ROS imports resolve
--   * formatting follows the code style from util.codestyle:
--       ros2   -> isort + black at 99 columns, same as the ROS repos' pre-commit
--       google -> ruff, which reads the project's pyproject.toml / ruff.toml

return {
  {
    "mason-org/mason.nvim",
    opts = { ensure_installed = { "black", "isort" } },
  },

  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        python = function(bufnr)
          if require("util.codestyle").get(bufnr) == "ros2" then
            return { "isort", "black" }
          end
          return { "ruff_organize_imports", "ruff_format" }
        end,
      },
      formatters = {
        black = { prepend_args = { "--line-length", "99" } },
        isort = { prepend_args = { "--profile", "black", "--line-length", "99" } },
      },
    },
  },

  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        pyright = {
          before_init = function(_, config)
            local root = config.root_dir or vim.fn.getcwd()
            local pixi = vim.fs.find(".pixi", { path = root, upward = true, type = "directory" })[1]
            local python = pixi and (pixi .. "/envs/default/bin/python")
            if python and vim.fn.executable(python) == 1 then
              config.settings.python = config.settings.python or {}
              config.settings.python.pythonPath = python
            end
          end,
        },
      },
    },
  },
}
