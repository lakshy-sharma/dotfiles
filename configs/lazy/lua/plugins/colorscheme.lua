return {
  {
    "rose-pine/neovim",
    name = "rose-pine",
    priority = 1000, -- make sure it loads first
    config = function()
      require("rose-pine").setup({
        variant = "moon",
        dark_variant = "main",
        disable_background = true,
        disable_float_background = false,
      })

      vim.cmd.colorscheme("rose-pine")
    end,
  },
}
