require 'user.lsp.settings'
-- sumneko lua
Settings = {
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
      },
      diagnostics = {
        globals = { "vim" },
      },
      workspace = {
        library = {
          library = vim.api.nvim_get_runtime_file("", true),
        checkThirdParty = false,
        },
      },
      telemetry = {
        enable = false,
      },
    },
  },
}
