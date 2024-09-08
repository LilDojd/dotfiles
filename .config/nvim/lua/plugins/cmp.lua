return {
  { -- override nvim-cmp plugin
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-emoji", -- add cmp source as dependency of cmp
      {
        "hrsh7th/cmp-cmdline",
        keys = { ":", "/", "?" }, -- lazy load cmp on more keys along with insert mode
        dependencies = { "hrsh7th/nvim-cmp" },
        opts = function()
          local cmp = require "cmp"
          return {
            {
              type = "/",
              mapping = cmp.mapping.preset.cmdline(),
              sources = {
                { name = "buffer" },
              },
            },
            {
              type = ":",
              mapping = cmp.mapping.preset.cmdline(),
              sources = cmp.config.sources({
                { name = "path" },
              }, {
                {
                  name = "cmdline",
                  option = {
                    ignore_cmds = { "Man", "!" },
                  },
                },
              }),
            },
          }
        end,
        config = function(_, opts)
          local cmp = require "cmp"
          vim.tbl_map(function(val) cmp.setup.cmdline(val.type, val) end, opts)
        end,
      },
    },
    -- override the options table that is used in the `require("cmp").setup()` call
    opts = function(_, opts)
      -- opts parameter is the default options table
      -- the function is lazy loaded so cmp is able to be required
      local cmp = require "cmp"
      -- modify the sources part of the options table
      opts.sources = cmp.config.sources {
        { name = "nvim_lsp", priority = 1000 },
        { name = "luasnip", priority = 750 },
        {
          name = "buffer",
          priority = 500,
          option = {
            get_bufnrs = function() return vim.api.nvim_list_bufs() end,
          },
        },
        { name = "path", priority = 250 },
      }

      -- return the new table to be used
      return opts
    end,
  },
}
