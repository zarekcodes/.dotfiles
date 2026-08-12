return {
  "saghen/blink.cmp",
  opts = {
    completion = {
      menu = { auto_show = true },
      list = {
        selection = {
          preselect = false, -- nothing highlighted on open
          auto_insert = false, -- navigating doesn't touch the buffer
        },
      },
    },
    keymap = {
      preset = "default",
      ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
      ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
      ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
      ["<M-CR>"] = { "accept", "fallback" },
    },
  },
}
-- return {
--   "saghen/blink.cmp",
--   opts = {
--     completion = {
--       -- Option A: menu doesn't auto-open; you call it on demand
--       menu = { auto_show = true },
--       -- Option B (keep A or not): nothing ever preselected
--       list = { selection = { preselect = false } },
--     },
--     keymap = {
--       preset = "default",
--       -- summon it only when you actually want it:
--       ["<C-Space>"] = { "show" },
--     },
--   },
-- }
