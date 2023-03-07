return {
  cmd = { "haskell-language-server", "--lsp" },
  filetypes = { "haskell", "lhaskell" },
  settings = {
    haskell = {
      formattingProvider = "fourmolu",
      plugin = {
        refineImports = {
          codeActionsOn = true,
          codeLensOn = false,
        },
        rename = {
          config = {
            crossModule = true,
          },
        },
      },
    },
  },
}
