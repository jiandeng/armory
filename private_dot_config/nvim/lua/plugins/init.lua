return {
  -- Theme: Catppuccin (High Quality)
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "mocha", -- latte, frappe, macchiato, mocha
        transparent_background = false,
        integrations = {
          lualine = true,
          cmp = true,
          gitsigns = true,
          nvimtree = true,
          treesitter = true,
          notify = true,
          mini = { enabled = true },
          telescope = { enabled = true },
          mason = true,
          native_lsp = {
            enabled = true,
            virtual_text = {
              errors = { "italic" },
              hints = { "italic" },
              warnings = { "italic" },
              information = { "italic" },
            },
          },
        },
      })
      vim.cmd.colorscheme("catppuccin-mocha")
    end,
  },

  -- Icons (Essential for UI)
  { "nvim-tree/nvim-web-devicons", lazy = true },

  -- Buffer Delete (Gracefully close buffers without closing windows)
  { "famiu/bufdelete.nvim" },

  -- Lualine (Statusline)
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons", "catppuccin" },
    config = function()
      require("lualine").setup({
        options = {
          theme = "auto", -- Automatically match the active colorscheme
          globalstatus = true,
        },
        sections = {
          lualine_c = {
            {
              function()
                return "Arch: " .. (vim.fn.system("uname -m"):gsub("%s+", ""))
              end,
              color = { fg = "#fab387", gui = "bold" },
            },
            { "filename", file_status = true, path = 1 },
          },
        },
      })
    end,
  },

  -- Neo-tree (File Explorer replacement for NERDTree)
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    config = function()
      require("neo-tree").setup({
        close_if_last_window = true,
        filesystem = {
          follow_current_file = { enabled = true },
          use_libuv_file_watcher = true,
        },
      })
    end,
  },

  -- Telescope (Fuzzy Finder replacement for ctrlp/LeaderF)
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local telescope = require("telescope")
      telescope.setup()
    end,
  },

  -- Treesitter (Modern Syntax Highlighting)
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    lazy = false,
    priority = 1000,
    config = function()
      local status, configs = pcall(require, "nvim-treesitter.configs")
      if status then
        configs.setup({
          ensure_installed = { "c", "cpp", "python", "lua", "vim", "go", "bash", "make", "cmake" },
          highlight = { enable = true },
          indent = { enable = true },
        })
      else
        vim.notify("Treesitter config delayed: dependencies still installing", vim.log.levels.WARN)
      end
    end,
  },

  -- Mason: LSP/DAP Manager
  {
    "williamboman/mason.nvim",
    config = function() require("mason").setup() end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = { "clangd", "pyright", "gopls" },
      })
    end,
  },

  -- LSP Config (Optimized for modern Neovim 0.11+)
  {
    "neovim/nvim-lspconfig",
    dependencies = { "hrsh7th/cmp-nvim-lsp" },
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      local servers = { "clangd", "cmake", "pyright", "gopls" }

      for _, lsp in ipairs(servers) do
        -- Use the brand new Neovim 0.11+ API if available, fallback for stability
        if vim.lsp.config then
          vim.lsp.config(lsp, { capabilities = capabilities })
          vim.lsp.enable(lsp)
        else
          require("lspconfig")[lsp].setup({ capabilities = capabilities })
        end
      end

      -- Diagnostics UI enhancements
      vim.diagnostic.config({
        virtual_text = true,
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
      })
    end,
  },

  -- Autocomplete
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-nvim-lsp",
      "L3MON4D3/LuaSnip",
    },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        mapping = cmp.mapping.preset.insert({
          ["<C-k>"] = cmp.mapping.select_prev_item(),
          ["<C-j>"] = cmp.mapping.select_next_item(),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({ select = false }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "buffer" },
          { name = "path" },
        }),
      })
    end,
  },

  -- Gitsigns (Git status in gutter)
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup({
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns

          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          -- Navigation
          map("n", "<leader>gn", function()
            if vim.wo.diff then return "]c" end
            vim.schedule(function() gs.next_hunk() end)
            return "<Ignore>"
          end, { expr = true })

          map("n", "<leader>gp", function()
            if vim.wo.diff then return "[c" end
            vim.schedule(function() gs.prev_hunk() end)
            return "<Ignore>"
          end, { expr = true })

          -- Actions (Matched to user's classic habits)
          map("n", "<leader>gu", gs.reset_hunk) -- Git Undo/Restore
          map("v", "<leader>gu", function() gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end)
          
          map("n", "<leader>gv", gs.preview_hunk) -- Git preview
          map("n", "<leader>gb", function() gs.blame_line({ full = true }) end) -- Git blame
          map("n", "<leader>gd", gs.diffthis) -- Git Diff (inline)
        end,
      })
    end,
  },

  -- Flash (Ultra-fast Jumping replacement for easymotion)
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
    },
  },

  -- Indent-blankline (Visualizing indent hierarchy)
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {},
  },

  -- Comment.nvim (Modern commenting)
  {
    "numToStr/Comment.nvim",
    opts = function()
      local ft = require("Comment.ft")

      return {
        pre_hook = function(ctx)
          return ft.get(vim.bo.filetype, ctx.ctype) or vim.bo.commentstring
        end,
      }
    end,
  },

  -- Autopairs
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {},
  },

  -- Which-key (Discoverability)
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {},
  },

  -- Tmux Navigation
  {
    "christoomey/vim-tmux-navigator",
    lazy = false,
  },

  -- Aerial (Code Outline - Modern Tagbar)
  {
    "stevearc/aerial.nvim",
    opts = {},
    -- Optional dependencies
    dependencies = {
       "nvim-treesitter/nvim-treesitter",
       "nvim-tree/nvim-web-devicons"
    },
    config = function()
      require("aerial").setup({
        on_attach = function(bufnr)
          -- Jump forwards/backwards with '{' and '}'
          vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { buffer = bufnr })
          vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { buffer = bufnr })
        end,
      })
    end,
  },

  -- Toggleterm (Integrated Terminal)
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      require("toggleterm").setup({
        size = 20,
        open_mapping = [[<c-\>]], -- Default C-\ to toggle
        direction = "horizontal",
        shade_terminals = true,
      })
    end,
  },

  -- Rainbow Delimiters (Treesitter based)
  {
    "HiPhish/rainbow-delimiters.nvim",
    dependencies = "nvim-treesitter/nvim-treesitter",
  },
}
