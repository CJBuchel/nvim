-- Point pyright at the nearest pixi environment (.pixi/envs/default) so ROS imports resolve.

return {
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
