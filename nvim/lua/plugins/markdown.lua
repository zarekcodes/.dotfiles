-- Normal mode = fully rendered "reading view" (cursor line included)
-- Insert mode = raw markdown source
return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    opts = {
      -- modes that render; anything else (insert, visual) shows raw text
      render_modes = { "n", "c", "t" },
      -- by default the cursor line is shown raw in normal mode; keep it rendered
      anti_conceal = { enabled = false },
      win_options = {
        -- default = not rendering (insert): conceal nothing so every character shows
        -- rendered = normal mode: hide markup, including on the cursor line
        conceallevel = { default = 0, rendered = 3 },
        concealcursor = { default = "", rendered = "nc" },
      },
    },
  },
}
