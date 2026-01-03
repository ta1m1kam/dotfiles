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
│       └── sheldon/plugins.toml
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
| 言語バージョン管理 | mise | Node.js, Python, Ruby, Go |
| zshプラグイン管理 | sheldon | pure, autosuggestions, syntax-highlighting |
| ファジーファインダー | fzf | ファイル検索、履歴検索 |
| リポジトリ管理 | ghq | Gitリポジトリの一元管理 |
| Git UI | tig | TUIベースのGit操作 |

## .zshrc のカスタム関数

| 関数 | キーバインド | 説明 |
|------|-------------|------|
| `repo` | Ctrl+G | ghq + fzf でリポジトリに移動 |
| `vf` | Ctrl+F | fzf でファイルを選択してvimで開く |
| `gb` | Ctrl+B | fzf でGitブランチを切り替え |
| `rgf` | - | ripgrep + fzf でファイル内検索 |
| `gadd` | - | fzf でファイルを選択してgit add |

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
