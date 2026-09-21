# =============================================================================
# Homebrew Brewfile
# =============================================================================

# -----------------------------------------------------------------------------
# Taps
# -----------------------------------------------------------------------------
tap "aws/tap"
tap "k1low/tap"
tap "d-kuro/tap"
tap "felixkratz/formulae"
# tap "homebrew/bundle"  # deprecated
# tap "koekeishiya/formulae"  # yabai (CI環境で利用不可)

# -----------------------------------------------------------------------------
# Formulae - Core
# -----------------------------------------------------------------------------
brew "git"
brew "vim"
brew "neovim"
brew "tmux"
brew "readline", link: true
brew "wget"
brew "tree"
brew "pstree"

# -----------------------------------------------------------------------------
# Formulae - Shell & Search
# -----------------------------------------------------------------------------
brew "starship"
brew "fzf"
brew "peco"
brew "ripgrep"
brew "fd"
brew "the_silver_searcher"
brew "bat"
brew "atuin"
brew "zoxide"
brew "direnv"
brew "jq"
brew "terminal-notifier"  # Claude Code の通知 hook で使用
brew "sheldon"
brew "chezmoi"

# -----------------------------------------------------------------------------
# Formulae - Modern CLI Tools
# -----------------------------------------------------------------------------
brew "just"           # タスクランナー（Makefile代替）
brew "yazi"           # TUIファイルマネージャー
brew "gitui"          # 高速Git TUI
brew "procs"          # ps代替（カラフル表示）
brew "bottom"         # htop代替（システムモニター）
brew "hyperfine"      # コマンドベンチマーク
brew "dust"           # du代替（ディスク使用量可視化）
brew "sd"             # sed代替（検索・置換）
brew "xh"             # curl代替（HTTPクライアント）
brew "topgrade"       # 全ツール一括アップデート
brew "git-delta"      # git diff viewer
brew "eza"            # ls代替（カラフル表示）

# -----------------------------------------------------------------------------
# Formulae - Git & Repository
# -----------------------------------------------------------------------------
brew "gh"
brew "ghq"
brew "tig"
brew "lazygit"
brew "k1low/tap/roots"    # ghq + fzf のルートナビゲーション
brew "k1low/tap/mo"       # Markdown ブラウザプレビュー（ライブリロード）
brew "d-kuro/tap/gwq"     # git worktree を ghq 風に管理

# -----------------------------------------------------------------------------
# Formulae - Development Tools
# -----------------------------------------------------------------------------
brew "aqua"  # プロジェクト側の aqua.yaml 用 (グローバルのツール管理は mise)
brew "golangci-lint"
brew "protobuf"
brew "sqlc"

# -----------------------------------------------------------------------------
# Formulae - Version Manager (言語ランタイムと CLI は mise で管理)
# -----------------------------------------------------------------------------
brew "mise"

# -----------------------------------------------------------------------------
# Formulae - Database
# -----------------------------------------------------------------------------
brew "mysql"
brew "postgresql@15"
brew "redis"
brew "sqlite"

# -----------------------------------------------------------------------------
# Formulae - Container & Virtualization
# -----------------------------------------------------------------------------
brew "colima"
brew "docker"
brew "docker-buildx"
brew "docker-compose"
brew "docker-credential-helper"

# -----------------------------------------------------------------------------
# Formulae - Cloud & Infrastructure
# -----------------------------------------------------------------------------
brew "awscli"
brew "azure-cli"
# brew "terraform"  # tfenv で管理
brew "tfenv"

# -----------------------------------------------------------------------------
# Formulae - Media & Misc
# -----------------------------------------------------------------------------
brew "act"  # GitHub Actions local runner

# -----------------------------------------------------------------------------
# Formulae - Window Manager
# -----------------------------------------------------------------------------
brew "felixkratz/formulae/borders"  # アクティブウィンドウの枠線 (brew services で起動)

# -----------------------------------------------------------------------------
# Casks - Browsers
# -----------------------------------------------------------------------------
cask "arc"
cask "google-chrome"

# -----------------------------------------------------------------------------
# Casks - Terminals
# -----------------------------------------------------------------------------
cask "ghostty"
cask "cmux"

# -----------------------------------------------------------------------------
# Casks - Editors & IDEs
# -----------------------------------------------------------------------------
cask "zed"
cask "goland"

# -----------------------------------------------------------------------------
# Casks - Database Tools
# -----------------------------------------------------------------------------
cask "sequel-ace"

# -----------------------------------------------------------------------------
# Casks - Development Tools
# -----------------------------------------------------------------------------
cask "chromedriver"
cask "github"
cask "ngrok"
cask "mitmproxy"

# -----------------------------------------------------------------------------
# Casks - AI & Productivity
# -----------------------------------------------------------------------------
cask "chatgpt"
cask "claude"
cask "codex"
cask "linear-linear"
cask "deepl"
cask "obsidian"
cask "raycast"

# -----------------------------------------------------------------------------
# Casks - Communication
# -----------------------------------------------------------------------------
cask "discord"
cask "gather"
cask "slack"
cask "zoom"

# -----------------------------------------------------------------------------
# Casks - Utilities
# -----------------------------------------------------------------------------
cask "1password"
cask "1password-cli"
cask "karabiner-elements"
cask "smoothcsv"
cask "clipy"
cask "dockdoor"
cask "figma"
cask "jordanbaird-ice"
cask "meetingbar"

# -----------------------------------------------------------------------------
# Casks - Fonts
# -----------------------------------------------------------------------------
cask "font-jetbrains-mono-nerd-font"
