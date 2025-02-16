return {
  "akinsho/toggleterm.nvim",
  cmd = { "ToggleTerm", "TermExec" },
  specs = {
    {
      "AstroNvim/astrocore",
      opts = function(_, opts)
        local maps = opts.mappings
        local astro = require "astrocore"
        if vim.fn.executable "jj" == 1 and vim.fn.executable "lazyjj" == 1 then
          local lazyjj = {
            callback = function() astro.toggle_term_cmd { cmd = "lazyjj ", direction = "float" } end,
            desc = "ToggleTerm lazyjj",
          }
          maps.n["<Leader>jj"] = { lazyjj.callback, desc = lazyjj.desc }
          maps.n["<Leader>lj"] = { lazyjj.callback, desc = lazyjj.desc }
        end
      end,
    },
  },
  opts = {
    float_opts = { border = "rounded" },
  },
}
