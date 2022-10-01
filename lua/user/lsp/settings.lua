-- sumneko lua
require'lspconfig'.sumneko_lua.setup {
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