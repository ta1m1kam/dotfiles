return {
  {
    "sainnhe/sonokai",
    init = function()
      vim.g.sonokai_style = "default"
      vim.g.sonokai_better_performance = 1
    end,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "sonokai",
    },
  },
}
