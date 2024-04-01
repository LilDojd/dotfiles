local utils = require "astronvim.utils"

local on_attach = function(client, bufnr)
    -- Mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local bufopts = { silent=true, buffer=bufnr, noremap = true }
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer=bufnr, desc = "Go to Definition" })
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { buffer=bufnr, desc = "Go to Declaration" })

    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, { buffer=bufnr, desc = "Go to implementation" })
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
    vim.keymap.set("n", "<leader>le", function()
      vim.cmd.RustLsp("explainError")
    end, { desc = "Explain Error", buffer = bufnr })
    vim.keymap.set('n', '<leader>lm', function()
      vim.cmd.RustLsp('expandMacro')
    end, { desc = "Expand Macro", buffer = bufnr })
    vim.keymap.set("n", "<leader>lR", function()
      vim.cmd.RustLsp("codeAction")
    end, { desc = "Code Action", buffer = bufnr })
    vim.keymap.set("n", "<leader>dr", function()
      vim.cmd.RustLsp("debuggables")
    end, { desc = "Rust Debuggables", buffer = bufnr })

    require("lsp-inlayhints").on_attach(client, bufnr)
    vim.keymap.set("n", "<leader>lI", function()
      require("lsp-inlayhints").toggle()
    end, { desc = "Toggle Inlay Hints", buffer = bufnr })
end

return {

  -- Extend auto completion
  {
    "Saecki/crates.nvim",
    lazy = true,
    event = { "BufRead Cargo.toml" },
    dependencies = {
      {
        "hrsh7th/nvim-cmp",
        ---@param opts cmp.ConfigSchema
        opts = function(_, opts)
          opts.sources = opts.sources or {}
          table.insert(opts.sources, { name = "crates" })
          return opts
        end,
      },
    },
    opts = {
      src = {
        cmp = { enabled = true },
      },
      null_ls = {
        enabled = true,
        name = "crates.nvim",
      },
    },
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    optional = true,
    opts = function(_, opts)
      -- dap
      opts.ensure_installed = utils.list_insert_unique(opts.ensure_installed, { "codelldb" })
    end,
  },
  {
    "mrcjkb/rustaceanvim",
    version = "^4", -- Recommended
    ft = { "rust" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "mfussenegger/nvim-dap",
      {
        "lvimuser/lsp-inlayhints.nvim",
        opts = {
            inlay_hints = {
                parameter_hints = {
                    show = true,
                    prefix = "<- ",
                    separator = ", ",
                    remove_colon_start = false,
                    remove_colon_end = true,
                },
                type_hints = {
                    -- type and other hints
                    show = true,
                    prefix = "-> ",
                    separator = ", ",
                    remove_colon_start = true,
                    remove_colon_end = false,
                },
                only_current_line = false,
                -- separator between types and parameter hints. Note that type hints are
                -- shown before parameter
                labels_separator = "  ",
                -- whether to align to the length of the longest line in the file
                max_len_align = false,
                -- padding from the left if max_len_align is true
                max_len_align_padding = 1,
                -- highlight group
                highlight = "LspInlayHint",
                -- virt_text priority
                priority = 0,
            },
            enabled_at_startup = true,
            debug_mode = false,
        },
      }
    },
    opts = {
      server = {
        on_attach = on_attach,
        default_settings = {
          -- rust-analyzer language server configuration
          ["rust-analyzer"] = {
            cargo = {
              allFeatures = true,
              loadOutDirsFromCheck = true,
              runBuildScripts = true,
            },
            -- Add clippy lints for Rust.
            checkOnSave = {
              allFeatures = true,
              command = "clippy",
              extraArgs = { "--no-deps" },
            },
            procMacro = {
              enable = true,
              ignored = {
                ["async-trait"] = { "async_trait" },
                ["napi-derive"] = { "napi" },
                ["async-recursion"] = { "async_recursion" },
              },
            },
          },
        },
      },
    },
    config = function(_, opts)
      vim.g.rustaceanvim = vim.tbl_deep_extend("keep", vim.g.rustaceanvim or {}, opts or {})
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if opts.ensure_installed ~= "all" then
        opts.ensure_installed = utils.list_insert_unique(opts.ensure_installed, { "rust", "toml", "ron" })
      end
    end,
  },
    -- Correctly setup lspconfig for Rust 🚀
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        rust_analyzer = {},
        taplo = {
          keys = {
            {
              "K",
              function()
                if vim.fn.expand("%:t") == "Cargo.toml" and require("crates").popup_available() then
                  require("crates").show_popup()
                else
                  vim.lsp.buf.hover()
                end
              end,
              desc = "Show Crate Documentation",
            },
          },
        },
      },
      setup = {
        rust_analyzer = function()
          return true
        end,
      },
    },
  },
  {
    "rust-lang/rust.vim",
    ft = "rust",
    init = function ()
      vim.g.rustfmt_autosave = 1
    end
  },
  {
    "nvim-neotest/neotest",
    optional = true,
    opts = function(_, opts)
      if not opts.adapters then opts.adapters = {} end
      local rustaceanvim_avail, rustaceanvim = pcall(require, "rustaceanvim.neotest")
      if rustaceanvim_avail then table.insert(opts.adapters, rustaceanvim) end
    end,
  },
}
