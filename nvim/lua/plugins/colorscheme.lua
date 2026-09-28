return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    opts = {
      flavour = "frappe",
      transparent_background = true,
      styles = {
        comments = { "italic" },
        keywords = { "italic" },
      },
    },
  },
  {
    "LazyVim/LazyVim",
    opts = { colorscheme = "catppuccin-frappe" },
  },
}
