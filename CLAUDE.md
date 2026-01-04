# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## リポジトリ概要

macOS用のdotfiles管理リポジトリ。chezmoi, mise, sheldon, fzf, ghq, tig などのモダンなCLIツールを活用した開発環境を構築する。

## コマンド

```bash
# 初回セットアップ
mise run install

# dotfilesの適用
mise run apply

# 差分確認
mise run diff

# ツールの更新
mise run update

# 旧バージョン管理ツールの削除
mise run clean
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
│       ├── mise/config.toml
│       ├── sheldon/plugins.toml
│       └── zsh/functions/   # カスタム関数（分割管理）
├── .chezmoi.toml.tmpl       # chezmoi設定テンプレート
├── .chezmoiroot             # ソースルート指定
├── Brewfile                 # Homebrewパッケージ定義
├── mise.toml                # mise tasks定義
└── z/                       # 計画・ドキュメント
```

## chezmoi 命名規則

| プレフィックス | 意味 |
|---------------|------|
| `dot_` | ドットファイル (`.`で始まるファイル) |
| `private_` | パーミッション 600 |
| `.tmpl` サフィックス | Go テンプレート |

## テンプレート変数 (.chezmoi.toml.tmpl)

| 変数 | 説明 |
|------|------|
| `{{ .name }}` | Git ユーザー名 |
| `{{ .email }}` | Git メールアドレス |
| `{{ .work }}` | 仕事用マシンかどうか (ホスト名で判定) |

## 主要ツールスタック

| カテゴリ | ツール | 用途 |
|---------|--------|------|
| dotfiles管理 | chezmoi | テンプレート・暗号化対応 |
| 言語バージョン管理 | mise | Node.js, Python, Ruby, Go, npm グローバルパッケージ |
| zshプラグイン管理 | sheldon | pure, autosuggestions, syntax-highlighting |
| ファジーファインダー | fzf | ファイル検索、履歴検索 |
| リポジトリ管理 | ghq | Gitリポジトリの一元管理 |
| Git UI | tig, gitui, lazygit | TUIベースのGit操作 |
| ファイルマネージャー | yazi | Vim風TUIファイルマネージャー |
| タスクランナー | just | Makefile代替 |
| プロセス表示 | procs | ps代替（カラフル表示） |
| システムモニター | bottom | htop代替 |
| ベンチマーク | hyperfine | コマンド計測 |

## カスタム関数

関数は `~/.config/zsh/functions/` に分割管理。

| 関数 | キーバインド | 説明 |
|------|-------------|------|
| `repo` | Ctrl+G | ghq + fzf でリポジトリに移動 |
| `vf` | Ctrl+F | fzf でファイルを選択してvimで開く |
| `gb` | Ctrl+B | fzf でGitブランチを切り替え |
| `zf` | Ctrl+J | zoxide + fzf でディレクトリ移動 |
| `hd` | Ctrl+H | atuin でカレントディレクトリの履歴検索 |
| `yy` | - | yazi起動、終了時にディレクトリ移動 |
| `jf` | - | just レシピを fzf で選択実行 |
| `pk` | - | procs + fzf でプロセス kill |
| `gu` | - | gitui 起動（エイリアス） |
| `lg` | - | lazygit 起動（エイリアス） |
| `gpr` | - | fzf で PR 選択して checkout |
| `gprv` | - | fzf で PR 選択してブラウザ表示 |
| `gis` | - | fzf で Issue 選択してブラウザ表示 |

詳細は README.md を参照。

## 新しいマシンへのセットアップ

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
