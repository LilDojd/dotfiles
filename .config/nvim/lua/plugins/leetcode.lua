return {
  "kawre/leetcode.nvim",
  build = ":TSUpdate html",
  dependencies = {
    "nvim-telescope/telescope.nvim",
    "nvim-lua/plenary.nvim", -- required by telescope
    "MunifTanjim/nui.nvim",

    -- optional
    "nvim-treesitter/nvim-treesitter",
    "rcarriga/nvim-notify",
    "nvim-tree/nvim-web-devicons",
  },
  opts = {
    lang = "rust",
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
            vim.cmd "SupermavenStop"
          end
        end,
      },
    },
  },
}
