# dotfiles

![](https://github.com/TaigaMikami/dotfiles/workflows/macos/badge.svg)

macOS用のdotfiles管理リポジトリ。chezmoi, mise, sheldon, fzf, ghq, tig などのモダンなCLIツールを活用した開発環境を構築します。

## セットアップ

```bash
# 1. Homebrewインストール
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 2. dotfilesクローン
git clone https://github.com/TaigaMikami/dotfiles.git ~/dotfiles

# 3. セットアップ実行
cd ~/dotfiles
brew install mise
mise run install
```

## コマンド

```bash
mise run install   # 初回セットアップ
mise run apply     # dotfilesの適用
mise run diff      # 差分確認
mise run update    # ツールの更新
mise run clean     # 旧バージョン管理ツールの削除
```

## ディレクトリ構成

```
dotfiles/
├── home/                    # chezmoi ソースディレクトリ
│   ├── dot_zshrc            # → ~/.zshrc
│   ├── dot_zprofile         # → ~/.zprofile
│   ├── dot_vimrc            # → ~/.vimrc
│   ├── dot_ideavimrc        # → ~/.ideavimrc
│   ├── dot_gitconfig.tmpl   # → ~/.gitconfig (テンプレート)
│   ├── dot_gitignore_global # → ~/.gitignore_global
│   ├── dot_gitmessage.txt   # → ~/.gitmessage.txt
│   ├── dot_tmux.conf        # → ~/.tmux.conf
│   ├── dot_tigrc            # → ~/.tigrc
│   └── dot_config/          # → ~/.config/
│       ├── mise/config.toml  # 言語バージョン + npm グローバルパッケージ
│       ├── sheldon/plugins.toml
│       └── zsh/functions/   # カスタム関数（分割管理）
│           ├── ghq.zsh
│           ├── fzf.zsh
│           ├── git.zsh
│           ├── docker.zsh
│           ├── zoxide.zsh
│           ├── atuin.zsh
│           ├── tig.zsh
│           ├── peco.zsh
│           ├── yazi.zsh
│           ├── just.zsh
│           ├── procs.zsh
│           ├── modern-cli.zsh
│           └── custom.zsh
├── .chezmoi.toml.tmpl       # chezmoi設定テンプレート
├── .chezmoiroot             # ソースルート指定
├── Brewfile                 # Homebrewパッケージ定義
└── mise.toml                # mise tasks定義
```

---

## chezmoi の仕組み

このリポジトリは [chezmoi](https://www.chezmoi.io/) で dotfiles を管理しています。

### 基本的な流れ

```
~/dotfiles/home/dot_zshrc    ソース（このリポジトリで編集）
         │
         │  chezmoi apply
         ▼
~/.zshrc                     ターゲット（実際に使われるファイル）
```

**ソースディレクトリ**（`home/`）のファイルを編集し、`chezmoi apply` で実際の場所に適用します。

### 命名規則

chezmoi はファイル名のプレフィックス/サフィックスで動作を制御します。

| 記法 | 意味 | 例 |
|------|------|-----|
| `dot_` | `.` で始まるファイル | `dot_zshrc` → `.zshrc` |
| `private_` | パーミッション 600 | `private_ssh_config` → `ssh_config`（600） |
| `.tmpl` | Go テンプレート | `dot_gitconfig.tmpl` → `.gitconfig` |
| `exact_` | ディレクトリ内を完全同期 | 余分なファイルを削除 |
| `run_` | スクリプトとして実行 | `run_setup.sh` → 適用時に実行 |

### テンプレート変数

`.tmpl` ファイルでは Go テンプレートが使えます。変数は `.chezmoi.toml.tmpl` で定義：

```toml
[data]
name = "Your Name"
email = "your@email.com"
work = false
```

テンプレート内での使用例：

```
[user]
    name = {{ .name }}
    email = {{ .email }}
{{ if .work }}
    signingkey = XXXXX
{{ end }}
```

### よく使うコマンド

| コマンド | 説明 |
|---------|------|
| `chezmoi diff` | 適用前に差分を確認 |
| `chezmoi apply` | ソースをターゲットに適用 |
| `chezmoi add ~/.zshrc` | 既存ファイルを chezmoi 管理下に追加 |
| `chezmoi edit ~/.zshrc` | ソースファイルを編集 |
| `chezmoi cd` | ソースディレクトリに移動 |
| `chezmoi data` | テンプレート変数を確認 |
| `chezmoi doctor` | 設定の問題を診断 |

### 典型的なワークフロー

#### 設定を変更する場合

```bash
# 1. ソースファイルを編集
vim ~/dotfiles/home/dot_zshrc

# 2. 差分を確認
chezmoi diff

# 3. 問題なければ適用
chezmoi apply

# 4. 変更をコミット
cd ~/dotfiles
git add -A && git commit -m "Update zshrc"
```

#### 新しいファイルを管理下に追加する場合

```bash
# 既存の設定ファイルを chezmoi に追加
chezmoi add ~/.config/starship.toml

# → home/dot_config/starship.toml が作成される
```

#### 別のマシンで同期する場合

```bash
# リポジトリを更新
cd ~/dotfiles && git pull

# 差分を確認して適用
chezmoi diff
chezmoi apply
```

### mise タスクとの対応

このリポジトリでは mise でコマンドをラップしています：

| mise コマンド | 実行内容 |
|--------------|---------|
| `mise run apply` | `chezmoi apply` |
| `mise run diff` | `chezmoi diff` |
| `mise run install` | Homebrew + chezmoi 初期化 |

### mise での npm グローバルパッケージ管理

mise は言語バージョンだけでなく、npm グローバルパッケージも管理できます。

`~/.config/mise/config.toml`:

```toml
[tools]
node = "lts"
python = "3.12"
ruby = "3.3"
go = "latest"

# npm global packages
"npm:gitmoji-cli" = "latest"
```

npm パッケージを追加するには：

```bash
# config.toml に追加後
mise install

# 確認
gitmoji --version
```

---

## Zsh カスタムコマンド

エイリアス、カスタム関数、キーバインドの詳細は **[docs/zsh-commands.md](docs/zsh-commands.md)** を参照してください。

### クイックリファレンス

| キー | 説明 |
|------|------|
| `Ctrl+G` | ghq + fzf でリポジトリ移動 |
| `Ctrl+F` | fzf でファイル選択 → vim |
| `Ctrl+B` | fzf で Git ブランチ切替 |
| `Ctrl+]` | zoxide + fzf でディレクトリ移動 |
| `Ctrl+H` | カレントディレクトリの履歴検索 |

| コマンド | 説明 |
|---------|------|
| `gs` / `gd` / `ga` | git status / diff / add |
| `gc` / `gp` / `gpl` | git commit / push / pull |
| `gu` / `lg` | gitui / lazygit |
| `gpr` / `gis` | fzf で PR/Issue 選択 |

---

## 主要ツールスタック

| カテゴリ | ツール | 用途 |
|---------|--------|------|
| dotfiles管理 | [chezmoi](https://www.chezmoi.io/) | テンプレート・暗号化対応 |
| 言語バージョン管理 | [mise](https://mise.jdx.dev/) | Node.js, Python, Ruby, Go, npm グローバルパッケージ |
| zshプラグイン管理 | [sheldon](https://sheldon.cli.rs/) | pure, autosuggestions, syntax-highlighting |
| ファジーファインダー | [fzf](https://github.com/junegunn/fzf) | ファイル検索、履歴検索 |
| リポジトリ管理 | [ghq](https://github.com/x-motemen/ghq) | Git リポジトリの一元管理 |
| Git UI | [tig](https://github.com/jonas/tig), [gitui](https://github.com/extrawurst/gitui), [lazygit](https://github.com/jesseduffield/lazygit) | TUI ベースの Git 操作 |
| 高速検索 | [ripgrep](https://github.com/BurntSushi/ripgrep) | 高速ファイル内検索 |
| cat 代替 | [bat](https://github.com/sharkdp/bat) | シンタックスハイライト付き表示 |
| cd 代替 | [zoxide](https://github.com/ajeetdsouza/zoxide) | スマートディレクトリ移動 |
| 履歴管理 | [atuin](https://github.com/atuinsh/atuin) | シェル履歴の同期・検索 |

### モダン CLI ツール（2024-2025 追加）

| カテゴリ | ツール | 用途 |
|---------|--------|------|
| ファイルマネージャー | [yazi](https://github.com/sxyazi/yazi) | 非同期・Vim風 TUI ファイルマネージャー |
| Git TUI | [gitui](https://github.com/extrawurst/gitui) | 高速な Git TUI（Rust製、軽量） |
| Git TUI | [lazygit](https://github.com/jesseduffield/lazygit) | 直感的な Git TUI（多機能） |
| タスクランナー | [just](https://github.com/casey/just) | Makefile 代替のシンプルなタスクランナー |
| ps 代替 | [procs](https://github.com/dalance/procs) | カラフルなプロセス表示、ツリービュー |
| htop 代替 | [bottom](https://github.com/ClementTsang/bottom) | GPU対応システムモニター（`btm`） |
| ベンチマーク | [hyperfine](https://github.com/sharkdp/hyperfine) | コマンドベンチマーク・統計分析 |
| du 代替 | [dust](https://github.com/bootandy/dust) | ディスク使用量の可視化 |
| sed 代替 | [sd](https://github.com/chmln/sd) | 直感的な検索・置換 |
| curl 代替 | [xh](https://github.com/ducaale/xh) | モダンな HTTP クライアント |
| 一括更新 | [topgrade](https://github.com/topgrade-rs/topgrade) | 全ツールを一括アップデート |

各ツールの使い方・カスタム関数の詳細は **[docs/zsh-commands.md](docs/zsh-commands.md)** を参照してください。
