return {
  -- GitLens 風: 行末に blame (author・日付・コミットメッセージ) を表示
  {
    "f-person/git-blame.nvim",
    event = "LazyFile",
    opts = {
      enabled = true,
      date_format = "%Y-%m-%d",
      message_template = "  <author> • <date> • <summary>",
      message_when_not_committed = "  Not committed yet",
    },
    keys = {
      { "<leader>go", "<cmd>GitBlameOpenCommitURL<cr>", desc = "コミットをブラウザで開く" },
      { "<leader>gY", "<cmd>GitBlameCopyCommitURL<cr>", desc = "コミットURLをコピー" },
    },
  },
}
