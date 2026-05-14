return {
  {
    "nvim-telescope/telescope.nvim",
    opts = {
      defaults = {
        file_ignore_patterns = {
          ".git/",
          "node_modules/",
          "vendor/",
          "__pycache__/",
          "%.pyc",
        },
      },
    },
  },
}
