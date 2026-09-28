return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        clangd = {
          cmd = {
            "clangd",
            "--background-index",
            "--clang-tidy",
            "--header-insertion=never",
            -- This line tells clangd it is allowed to use your arm toolchain
            "--query-driver=/**/arm-none-eabi-*",
          },
        },
      },
    },
  },
}
