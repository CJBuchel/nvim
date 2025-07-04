return {
  {
    "mason-org/mason-lspconfig.nvim",
    opts = {
      auto_install = true,
    },
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      {
        "neovim/nvim-lspconfig",
        opts = {},
        config = function()
          local capabilities = require("cmp_nvim_lsp").default_capabilities()
          local lspconfig = require("lspconfig")

          lspconfig.lua_ls.setup({
            capabilities = capabilities
          })

          vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
          vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, {})
          vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, {})
          vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})
        end,
      },
    },
  },
}
