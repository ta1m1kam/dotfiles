return {
  -- ファイルツリー (snacks explorer) を右側に表示
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        sources = {
          explorer = {
            layout = { layout = { position = "right" } },
          },
        },
      },
    },
  },

  -- 今いる関数・クラス名を画面上部に固定表示
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "LazyFile",
    opts = { max_lines = 3 },
  },

  -- 括弧をネストの深さごとに色分け
  {
    "HiPhish/rainbow-delimiters.nvim",
    event = "LazyFile",
  },

  -- diagnostics をカーソル行の下に整形して表示
  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "LazyFile",
    priority = 1000,
    opts = {
      preset = "modern",
    },
  },
  -- 標準の virtual_text は tiny-inline-diagnostic と重複するため無効化
  {
    "neovim/nvim-lspconfig",
    opts = {
      diagnostics = { virtual_text = false },
    },
  },
}
