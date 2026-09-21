# dotfiles

![](https://github.com/ta1m1kam/dotfiles/workflows/macos/badge.svg)

macOS 用の dotfiles。chezmoi, mise, sheldon, starship, fzf, ghq, eza, delta などを使った開発環境を、新しい Mac にコマンド 1 つで再現します。

## 新しい Mac のセットアップ

クリーンインストール直後のターミナルで次を実行します。Xcode Command Line Tools、Homebrew、GitHub ログイン、SSH 鍵の作成と登録、dotfiles の適用までを対話しながら進めます。途中で失敗しても再実行できます。

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/ta1m1kam/dotfiles/master/bootstrap.sh)"
```

`chezmoi init` で次の項目を一度だけ聞かれます。回答は `~/.config/chezmoi/chezmoi.toml` に保存されます。

| 質問 | 内容 |
|------|------|
| Git user name / email | `~/.gitconfig` の user 設定 |
| Is this a work machine | 仕事用マシンなら `y`。以下の work 用の質問が続く |
| Work GitHub org | この org の https URL を ssh に書き換える |
| Work main repo path | Raycast の「Selection to Claude Code」が worktree を作るリポジトリ |
| 1Password account / vault | 仕事用 SSH 設定と Claude Code の OTEL 設定を読む 1Password の場所。空なら 1Password 連携をスキップ |
| Obsidian vault directory | vault の clone 先 (既定 `~/Records`) |
| Private agents repo | `~/.agents` に clone する非公開リポジトリ (skills 置き場)。空ならスキップ |

### 1Password に置く秘密情報

公開リポジトリには社内情報や秘密情報を置きません。work 用の設定は個人の 1Password から chezmoi の `onepasswordRead` で読み込みます。指定した vault に次のアイテムを用意します。

| アイテム名 | 種類 | フィールド | 用途 |
|-----------|------|-----------|------|
| `dotfiles-ssh-config-work` | Secure Note | `notesPlain` | `~/.ssh/config` に追記する work 用の Host 定義 |
| `dotfiles-claude-otel` | 任意 | `endpoint`, `headers` | Claude Code のテレメトリ送信先と `Authorization=Bearer ...` ヘッダ |

1Password が未設定のマシンでは `~/.ssh/config` は chezmoi の管理対象外になり、既存ファイルを上書きしません。

一度答えた質問は再度聞かれません (空で答えた場合も同じ)。後から変えるときは `~/.config/chezmoi/chezmoi.toml` の `[data]` を直接編集して `mise run apply` します。

```toml
[data]
    onepassword_account = "my.1password.com"
    onepassword_vault = "Personal"
    agents_repo = "git@github.com:ta1m1kam/agents.git"
```

### bootstrap 後に手動でやること

- 1Password アプリにログインし、CLI 連携を有効化してから `mise run apply`（work 用設定の反映）
- bastion など GitHub 以外への新しい SSH 公開鍵の登録
- Karabiner-Elements の入力監視とアクセシビリティの許可
- Raycast にログイン（設定は Cloud Sync で復元）し、Script Commands のディレクトリに `~/.config/raycast/scripts` を追加
- 古い Mac から `~/.local/share/atuin` を AirDrop でコピー（シェル履歴）
- `mise run ghq-restore` で必要なリポジトリを clone（一覧は古い Mac で `mise run ghq-save`）
- Homebrew 外のアプリ: Orca, Homerow, Shottr と App Store 系（Magnet, RunCat, Skitch, Xcode, Kindle）。会社の Jamf 配布アプリは自動で入る
- 各アプリのログイン（Slack, Arc, Chrome, Claude, ChatGPT など）

## コマンド

```bash
mise run install       # 初回セットアップ (bootstrap.sh から呼ばれる。再実行可)
mise run apply         # dotfiles の適用
mise run diff          # 差分確認
mise run update        # brew / mise / sheldon / dotfiles の更新
mise run doctor        # シェルと主要ツールの動作確認
mise run link-agents   # ~/.agents を clone し skills を symlink
mise run ghq-save      # ghq の一覧を ~/.agents/ghq-list.txt に保存
mise run ghq-restore   # 一覧から一括 clone
mise run clean         # 旧バージョン管理ツールと不要 brew パッケージの削除
```

## ディレクトリ構成

```
dotfiles/
├── bootstrap.sh              # 新 Mac の最初の 1 コマンド
├── Brewfile                  # Homebrew パッケージ定義 (formulae, casks, fonts)
├── mise.toml                 # mise tasks 定義
├── .chezmoiroot              # chezmoi ソースルート (home/)
└── home/                     # chezmoi ソースディレクトリ
    ├── .chezmoi.toml.tmpl    # chezmoi 設定 (初回 init で対話入力)
    ├── .chezmoiignore.tmpl   # 管理対象外の指定
    ├── dot_zshrc.tmpl        # → ~/.zshrc
    ├── dot_zprofile          # → ~/.zprofile
    ├── dot_gitconfig.tmpl    # → ~/.gitconfig
    ├── dot_tmux.conf, dot_tigrc, dot_vimrc, dot_ideavimrc
    ├── private_dot_ssh/config.tmpl        # Include + 1Password から work 用設定
    ├── run_once_after_macos-defaults.sh   # macOS のシステム設定
    ├── run_once_after_link-agents.sh.tmpl # ~/.agents の clone と symlink
    ├── dot_config/dotfiles/executable_link-agents.tmpl
    ├── dot_claude/           # Claude Code (hooks, commands, statusline, modify_settings.json.tmpl)
    ├── dot_codex/            # Codex (AGENTS.md symlink, hooks symlink, modify_hooks.json.tmpl)
    └── dot_config/
        ├── mise/config.toml  # 言語ランタイムとグローバル CLI の宣言 (唯一の置き場)
        ├── sheldon/plugins.toml
        ├── starship.toml
        ├── nvim/             # LazyVim (lazy-lock.json でバージョン固定)
        ├── ghostty/, karabiner/, zed/, cmux/, borders/
        ├── raycast/scripts/  # Raycast スクリプトコマンド
        ├── claude/marketplaces/taiga-local/  # ローカルの Claude Code プラグイン
        ├── gwq/, gh/, atuin/
        └── zsh/functions/    # カスタム関数 (分割管理)
```

## 管理方針

| 対象 | 置き場 |
|------|--------|
| 言語ランタイム・グローバル CLI (node, go, rust, python, ruby, claude-code, npm/go ツール) | mise (`~/.config/mise/config.toml`) |
| GUI アプリ・CLI パッケージ・フォント | Brewfile |
| プロジェクト固有の CLI | 各リポジトリの `aqua.yaml` / `mise.toml` |
| 仕事固有の skills / zsh 関数 / ghq 一覧 | 非公開リポジトリ `~/.agents` (`skills/`, `zsh/`, `ghq-list.txt`) |
| 秘密情報 (SSH の work 設定, OTEL トークン) | 個人の 1Password |
| マシン固有のシェル設定 | `~/.zshrc.local` (chezmoi 管理外) |
| VS Code / Cursor / Raycast 本体の設定 | 各アプリの同期機能 |

`~/.claude/settings.json` と `~/.codex/hooks.json` は丸ごと上書きせず、`modify_` スクリプトで dotfiles 管理のキーだけをマージします。Orca や auto mode が書き込む設定はそのまま残ります。

## chezmoi の使い方

```
~/dotfiles/home/dot_zshrc.tmpl   ソース (このリポジトリで編集)
         │  chezmoi apply
         ▼
~/.zshrc                         ターゲット (実際に使われるファイル)
```

| 記法 | 意味 |
|------|------|
| `dot_` | `.` で始まるファイル |
| `private_` | パーミッション 600 |
| `executable_` | 実行権限を付ける |
| `symlink_` | symlink を作る |
| `modify_` | 既存ファイルを標準入力で受け取り、出力で置き換えるスクリプト |
| `run_once_` / `run_onchange_` | 一度だけ / 内容が変わったときに実行するスクリプト |
| `.tmpl` | Go テンプレート。`{{ .chezmoi.homeDir }}` や `chezmoi init` で答えた値が使える |

```bash
# 設定を変更する
vim ~/dotfiles/home/dot_zshrc.tmpl
mise run diff
mise run apply

# 既存ファイルを管理下に追加する
chezmoi add --source ~/dotfiles ~/.config/starship.toml

# 別のマシンで同期する
cd ~/dotfiles && git pull && mise run apply
```

## Zsh カスタムコマンド

関数は `~/.config/zsh/functions/` に分割管理。詳細は [docs/zsh-commands.md](docs/zsh-commands.md)。

| コマンド | キー | 説明 |
|---------|------|------|
| `grepo` | Ctrl+G | ghq + gwq + fzf でリポジトリ / worktree に移動 |
| `gwt` / `gwta` | - | worktree の選択 / 作成 |
| `vf` | Ctrl+F | fzf でファイルを選んで nvim で開く |
| `gb` | Ctrl+B | fzf でブランチ切り替え |
| `zf` | Ctrl+] | zoxide + fzf でディレクトリ移動 |
| `hd` | Ctrl+H | atuin でカレントディレクトリの履歴検索 |
| `yy` | - | yazi 起動、終了時にディレクトリ移動 |
| `jf` | - | just レシピを fzf で選択実行 |
| `pk` | - | procs + fzf でプロセス kill |
| `gu` / `lg` | - | gitui / lazygit |
| `gpr` / `gprv` / `gis` | - | fzf で PR checkout / PR 表示 / Issue 表示 |
| `tb` / `tl` / `ts` / `trf` | - | tig blame / log / stash / refs |

## 主要ツールスタック

| カテゴリ | ツール |
|---------|--------|
| dotfiles 管理 | chezmoi |
| ランタイム・CLI 管理 | mise |
| zsh プラグイン | sheldon (zsh-defer, autosuggestions, syntax-highlighting, history-substring-search) |
| プロンプト | starship |
| ターミナル | Ghostty, cmux |
| エディタ | Neovim (LazyVim), Zed, GoLand |
| Git | gh, ghq, gwq, tig, gitui, lazygit, delta |
| 検索・ナビゲーション | fzf, ripgrep, fd, zoxide, atuin |
| モダン CLI | eza, bat, just, yazi, procs, bottom, hyperfine, dust, sd, xh, topgrade |
| キーボード・ウィンドウ | Karabiner-Elements, borders, Raycast |
| AI エージェント | Claude Code (mise), Codex (brew), agent-browser, defuddle |
