-- You can also add or configure plugins by creating files in this `plugins/` folder
-- Here are some examples:

local function configure()
  local dashboard = require "alpha.themes.dashboard"
  local p = require "catppuccin.palettes.mocha"

  vim.api.nvim_set_hl(0, "AlphaNeovimLogoBlue", { fg = p.blue })

  local logo = require("plugins.tables.banners")["random"]
  dashboard.section.header.val = logo
  dashboard.section.header.opts.hl = "AlphaNeovimLogoBlue"

  return dashboard.config
end

---@type LazySpec
return {

  -- == Examples of Adding Plugins ==

  "andweeb/presence.nvim",
  {
    "ray-x/lsp_signature.nvim",
    event = "BufRead",
    config = function() require("lsp_signature").setup() end,
  },
  -- == Examples of Overriding Plugins ==

  -- customize alpha options
  {
    "goolord/alpha-nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "nvim-lua/plenary.nvim",
      { "juansalvatore/git-dashboard-nvim", dependencies = { "nvim-lua/plenary.nvim" } },
    },
    opts = function(_, opts)
      local git_dashboard = require("git-dashboard-nvim").setup {
        show_only_weeks_with_commits = true,
        show_contributions_count = false,
        use_current_branch = false,
        branch = "main",
        title = "owner_with_repo_name",
        top_padding = 0,
        empty_square = "",
        filled_squares = { "", "", "", "", "", "" },
        centered = false,
        days = { "s", "m", "t", "w", "t", "f", "s" },
        colors = {
          --catpuccin theme
          days_and_months_labels = "#8FBCBB",
          empty_square_highlight = "#3B4252",
          filled_square_highlights = { "#88C0D0", "#88C0D0", "#88C0D0", "#88C0D0", "#88C0D0", "#88C0D0", "#88C0D0" },
          branch_highlight = "#88C0D0",
          dashboard_title = "#88C0D0",
        },
      }
      local header = {}
      local header_size = 0
      for _, line in ipairs(git_dashboard) do
        table.insert(header, line)
        header_size = header_size + line:len()
      end

      -- If header returns empty, insert logo
      if header_size == 0 then header = require("plugins.tables.banners")["random"] end

      opts.section.header.val = header
    end,
    -- config = function(_, dashboard) require("alpha").setup(configure_git_dashboard()) end,
  },

  -- You can disable default plugins as follows:
  -- { "goolord/alpha-nvim", enabled = false },

  {
    "max397574/better-escape.nvim",
    config = function()
      require("better_escape").setup {
        timeout = vim.o.timeoutlen,
        default_mappings = false,
        mappings = {
          i = {
            j = {
              -- These can all also be functions
              k = "<Esc>",
              j = "<Esc>",
            },
          },
        },
      }
    end,
  },

  -- You can also easily customize additional setup of plugins that is outside of the plugin's setup call
  {
    "L3MON4D3/LuaSnip",
    config = function(plugin, opts)
      require "astronvim.plugins.configs.luasnip"(plugin, opts) -- include the default astronvim config that calls the setup call
      -- add more custom luasnip configuration such as filetype extend or custom snippets
      local luasnip = require "luasnip"
      luasnip.filetype_extend("javascript", { "javascriptreact" })
    end,
  },

  {
    "windwp/nvim-autopairs",
    config = function(plugin, opts)
      require "astronvim.plugins.configs.nvim-autopairs"(plugin, opts) -- include the default astronvim config that calls the setup call
      -- add more custom autopairs configuration such as custom rules
      local npairs = require "nvim-autopairs"
      local Rule = require "nvim-autopairs.rule"
      local cond = require "nvim-autopairs.conds"
      npairs.add_rules(
        {
          Rule("$", "$", { "tex", "latex" })
            -- don't add a pair if the next character is %
            :with_pair(cond.not_after_regex "%%")
            -- don't add a pair if  the previous character is xxx
            :with_pair(
              cond.not_before_regex("xxx", 3)
            )
            -- don't move right when repeat character
            :with_move(cond.none())
            -- don't delete if the next character is xx
            :with_del(cond.not_after_regex "xx")
            -- disable adding a newline when you press <cr>
            :with_cr(cond.none()),
          Rule("|", "|", { "rust", "go", "lua" }):with_move(cond.after_regex "|"),
        },
        -- disable for .vim files, but it work for another filetypes
        Rule("a", "a", "-vim")
      )
    end,
  },
}
