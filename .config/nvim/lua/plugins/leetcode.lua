---@type LazySpec
return {
  "kawre/leetcode.nvim",
  cmd = "Leet",
  dependencies = {
    { "nvim-telescope/telescope.nvim" },
    { "nvim-lua/plenary.nvim" }, -- required by telescope
    { "MunifTanjim/nui.nvim" },

    -- optional
    { "rcarriga/nvim-notify", optional = true },
    { "nvim-tree/nvim-web-devicons", optional = true },
    {
      "nvim-treesitter/nvim-treesitter",
      optional = true,
      opts = function(_, opts)
        if opts.ensure_installed ~= "all" then
          opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, { "html" })
        end
      end,
    },
    {
      "AstroNvim/astrocore",
      ---@type AstroCoreOpts
      opts = {
        autocmds = {
          leetcode_autostart = {
            {
              event = "VimEnter",
              desc = "Start leetcode.nvim on startup",
              nested = true,
              callback = function()
                if vim.fn.argc() ~= 1 then return end -- return if more than one argument given
                local arg = vim.tbl_get(require("astrocore").plugin_opts "leetcode.nvim", "arg") or "leetcode.nvim"
                if vim.fn.argv()[1] ~= arg then return end -- return if argument doesn't match trigger
                local lines = vim.api.nvim_buf_get_lines(0, 0, -1, true)
                if #lines > 1 or (#lines == 1 and lines[1]:len() > 0) then return end -- return if buffer is non-empty
                require("leetcode").start(true)
              end,
            },
          },
        },
      },
    },
  },
  opts = {
    lang = "python3",
    injector = { ---@type table<lc.lang, lc.inject>
      ["python3"] = {
        before = true,
      },
    },
    hooks = {
      ---@type fun(question: lc.ui.Question)[]
      ["question_enter"] = {
        function()
          -- os.execute "sleep 1"
          local file_extension = vim.fn.expand "%:e"
          if file_extension == "rs" then
            local bash_script = tostring(vim.fn.stdpath "data" .. "/leetcode/rust_init.sh")
            local success, error_message = os.execute(bash_script)
            if success then
              print "Successfully updated rust-project.json"
              vim.cmd "LspRestart rust_analyzer"
            else
              print("Failed update rust-project.json. Error: " .. error_message)
            end
          end
        end,
      },
    },
  },
}
