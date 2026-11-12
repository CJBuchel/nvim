-- Docker
--
-- LazyVim's docker extra provides dockerls and hadolint. There is no conform
-- formatter for Dockerfiles, so format-on-save falls back to dockerls, which
-- re-indents every continuation line to 'shiftwidth'. Our Dockerfiles are
-- hand-indented (mostly 4, some 2), so multi-line instructions are left as
-- written; single-line instructions are still formatted.

return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        dockerls = {
          settings = {
            docker = {
              languageserver = {
                formatter = { ignoreMultilineInstructions = true },
              },
            },
          },
        },
      },
    },
  },
}
