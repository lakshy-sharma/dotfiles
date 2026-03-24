-- ==============================================================================
-- LunarVim Configuration
-- ==============================================================================

-- --- Core ---
lvim.colorscheme = "tokyonight-night"
vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.scrolloff = 8
vim.opt.clipboard = "unnamedplus"
vim.opt.timeoutlen = 300
vim.opt.wrap = false

-- --- Leader ---
lvim.leader = "space"

-- --- Keymaps ---
lvim.keys.normal_mode["<C-s>"] = ":w<CR>"
lvim.keys.normal_mode["<S-l>"] = ":BufferLineCycleNext<CR>"
lvim.keys.normal_mode["<S-h>"] = ":BufferLineCyclePrev<CR>"

-- --- Treesitter ---
lvim.builtin.treesitter.ensure_installed = {
  "go", "python", "cpp", "c", "lua",
  "bash", "json", "yaml", "toml", "markdown",
}
lvim.builtin.treesitter.highlight.enable = true

-- --- LSP ---
lvim.lsp.installer.setup.ensure_installed = {
  "gopls",
  "basedpyright",
  "clangd",
}

-- Python: use Conda base interpreter
vim.g.python3_host_prog = vim.fn.expand("$HOME/miniconda/bin/python")

-- basedpyright settings
require("lvim.lsp.manager").setup("basedpyright", {
  settings = {
    basedpyright = {
      analysis = {
        typeCheckingMode = "basic",
        autoImportCompletions = true,
        diagnosticMode = "workspace",
      },
    },
  },
})

-- gopls settings
require("lvim.lsp.manager").setup("gopls", {
  settings = {
    gopls = {
      analyses = { unusedparams = true },
      staticcheck = true,
      gofumpt = true,
    },
  },
})

-- --- Formatters ---
local formatters = require("lvim.lsp.null-ls.formatters")
formatters.setup({
  { name = "gofumpt",   filetypes = { "go" } },
  { name = "black",     filetypes = { "python" } },
  { name = "clang_format", filetypes = { "cpp", "c" } },
  { name = "prettier",  filetypes = { "json", "yaml", "markdown" } },
})

-- --- Linters ---
local linters = require("lvim.lsp.null-ls.linters")
linters.setup({
  { name = "golangci_lint", filetypes = { "go" } },
  { name = "flake8",        filetypes = { "python" } },
})

-- --- Telescope (FZF integration) ---
lvim.builtin.telescope.defaults.file_ignore_patterns = {
  ".git/", "node_modules/", "vendor/", "__pycache__/", "*.pyc",
}

-- --- Which-key additions ---
lvim.builtin.which_key.mappings["G"] = {
  name = "Git (LazyGit)",
  g = { "<cmd>LazyGit<CR>", "Open LazyGit" },
}
lvim.builtin.which_key.mappings["z"] = {
  name = "Zoxide",
  z = { "<cmd>!zoxide query -i<CR>", "Jump to directory" },
}

-- --- Extra Plugins ---
lvim.plugins = {
  -- Colorscheme
  { "folke/tokyonight.nvim" },

  -- LazyGit integration
  {
    "kdheepak/lazygit.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
  },

  -- Better Go support
  {
    "olexsmir/gopher.nvim",
    ft = "go",
    config = function()
      require("gopher").setup()
    end,
  },

  -- Improved diagnostics list
  {
    "folke/trouble.nvim",
    cmd = "TroubleToggle",
  },

  -- Surround motions
  { "tpope/vim-surround" },
}
