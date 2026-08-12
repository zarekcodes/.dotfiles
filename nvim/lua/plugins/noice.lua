return {
  "folke/noice.nvim",
  opts = {
    cmdline = { view = "cmdline" },
    routes = {
      {
        filter = {
          event = "lsp",
          kind = "progress",
          find = "jdtls",
        },
        opts = { skip = true },
      },
    },
  },
}
