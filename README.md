# dotfiles

![](https://github.com/TaigaMikami/dotfiles/workflows/macos/badge.svg)

<div align="center">
  <img src="https://pbs.twimg.com/profile_images/877083522850201600/TtN6ZbNY_400x400.jpg">
</div>

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
│       ├── mise/config.toml
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

---

## Zsh カスタムコマンド リファレンス

### キーバインド

| キー | 関数 | 説明 |
|------|------|------|
| `Ctrl+G` | `repo` | ghq + fzf でリポジトリに移動 |
| `Ctrl+F` | `vf` | fzf でファイルを選択して vim で開く |
| `Ctrl+B` | `gb` | fzf で Git ブランチを切り替え |
| `Ctrl+J` | `zf` | zoxide + fzf でディレクトリに移動 |
| `Ctrl+H` | `hd` | atuin でカレントディレクトリの履歴検索 |

### エイリアス

#### ディレクトリ移動

| エイリアス | 展開先 | 説明 |
|-----------|--------|------|
| `d` | `cd ~/Desktop` | デスクトップに移動 |
| `dotfiles` | `cd ~/dotfiles` | dotfiles ディレクトリに移動 |
| `W` | `cd ~/workspace` | ワークスペースに移動 |
| `..` | `cd ..` | 親ディレクトリに移動 |

#### ファイル操作

| エイリアス | 展開先 | 説明 |
|-----------|--------|------|
| `c` | `clear` | ターミナルをクリア |
| `rm` | `rm -i` | 削除前に確認 |
| `mv` | `mv -i` | 移動前に確認 |
| `cp` | `cp -i` | コピー前に確認 |
| `ls` | `ls -G` | カラー表示付き一覧 |
| `la` | `ls -a` | 隠しファイル含む一覧 |
| `ll` | `ls -l` | 詳細一覧 |
| `tree` | `tree -C` | カラー表示付きツリー |
| `mkdir` | `mkdir -p` | 中間ディレクトリも作成 |
| `cat` | `bat` | シンタックスハイライト付きファイル表示 |

#### エディター

| エイリアス | 展開先 | 説明 |
|-----------|--------|------|
| `vi` | `vim` | vim を起動 |
| `f` | `open .` | Finder でカレントディレクトリを開く |
| `od` | `open ~/Desktop` | Finder でデスクトップを開く |

#### Git

| エイリアス | 展開先 | 説明 |
|-----------|--------|------|
| `gs` | `git status` | ステータス確認 |
| `gd` | `git diff` | 差分表示 |
| `ga` | `git add` | ステージング |
| `gc` | `gitmoji -c` | gitmoji でコミット |

#### Docker / Tmux / その他

| エイリアス | 展開先 | 説明 |
|-----------|--------|------|
| `dc` | `docker-compose` | docker-compose 短縮形 |
| `t` | `tmux` | tmux を起動 |
| `zshrc` | `source ~/.zshrc` | zshrc を再読み込み |

#### グローバルエイリアス

| エイリアス | 展開先 | 使用例 |
|-----------|--------|--------|
| `G` | `\| grep` | `ps aux G node` |

### カスタム関数

#### ghq + fzf 関連

| 関数 | 説明 |
|------|------|
| `repo` | リポジトリを fzf で選択して移動（プレビュー: README.md） |
| `repo-browse` | リポジトリを選択して GitHub をブラウザで開く |
| `get <url>` | ghq get でクローンし、そのディレクトリに移動 |

```bash
repo              # Ctrl+G でも可
repo-browse
get user/repo
```

#### fzf + ripgrep 関連

| 関数 | 説明 |
|------|------|
| `rgf <pattern>` | ファイル内検索し、該当行を vim で開く |
| `vf` | ファイルを選択して vim で開く |
| `cdf` | ディレクトリを選択して移動 |

```bash
rgf "検索ワード"     # 正規表現も使用可能
vf                   # Ctrl+F でも可
cdf
```

#### fzf + Git 関連

| 関数 | 説明 |
|------|------|
| `gb` | ブランチを選択してチェックアウト（コミット日時順） |
| `gshow` | コミットを選択して詳細表示 |
| `gcp` | コミットを選択して cherry-pick |
| `gstash` | stash を選択して適用 |
| `gadd` | 変更ファイルを選択してステージング（複数選択可） |

```bash
gb                   # Ctrl+B でも可
gshow
gcp
gstash
gadd                 # Tab で複数選択
```

#### peco 関連

| 関数 | 説明 |
|------|------|
| `peco-kill` | プロセスを選択して終了 |
| `peco-ip` | IP アドレスを選択して出力 |

#### Docker 関連

| 関数 | 説明 |
|------|------|
| `dex [shell]` | コンテナを選択してシェルに入る（デフォルト: sh） |
| `drmi` | イメージを選択して削除 |

```bash
dex           # sh でコンテナに入る
dex bash      # bash でコンテナに入る
drmi          # 複数選択可能
```

#### zoxide + fzf 関連

| 関数 | 説明 |
|------|------|
| `zf` | zoxide のディレクトリ履歴を fzf で選択して移動 |
| `zrm` | zoxide のエントリを fzf で選択して削除 |
| `zs` | zoxide のスコア付き一覧を表示 |
| `zcd` | zoxide で移動後、そのディレクトリの履歴を表示 |

```bash
zf            # Ctrl+J でも可
zrm           # 複数選択可能
zs
zcd           # 移動 + 履歴表示
```

#### atuin + fzf 関連

| 関数 | 説明 |
|------|------|
| `hd` | カレントディレクトリで実行したコマンド履歴を検索 |
| `hs` | 成功したコマンド（exit 0）のみを検索 |
| `hstats` | コマンド使用統計を表示 |

```bash
hd            # Ctrl+H でも可
hs
hstats
```

#### tig + fzf 関連

| 関数 | 説明 |
|------|------|
| `tb` | ファイルを fzf で選択して tig blame |
| `tl` | ファイルを fzf で選択してファイル履歴を表示 |
| `ts` | tig stash を開く |
| `tr` | tig refs を開く（ブランチ・タグ一覧） |

```bash
tb            # ファイル選択 → blame
tl            # ファイル選択 → log
ts            # stash 一覧
tr            # refs 一覧
```

#### カスタム

| 関数 | 説明 |
|------|------|
| `yo` | Obsidian ディレクトリを参照して Claude Code を起動 |
| `oo` | Obsidian ディレクトリに移動 |

### fzf 操作キー

| キー | 動作 |
|------|------|
| `Enter` | 選択を確定 |
| `Tab` | 複数選択モードで選択/解除 |
| `Ctrl+U` | プレビューを半ページ上スクロール |
| `Ctrl+D` | プレビューを半ページ下スクロール |
| `Ctrl+C` / `Esc` | キャンセル |

---

## 主要ツールスタック

| カテゴリ | ツール | 用途 |
|---------|--------|------|
| dotfiles管理 | [chezmoi](https://www.chezmoi.io/) | テンプレート・暗号化対応 |
| 言語バージョン管理 | [mise](https://mise.jdx.dev/) | Node.js, Python, Ruby, Go |
| zshプラグイン管理 | [sheldon](https://sheldon.cli.rs/) | pure, autosuggestions, syntax-highlighting |
| ファジーファインダー | [fzf](https://github.com/junegunn/fzf) | ファイル検索、履歴検索 |
| リポジトリ管理 | [ghq](https://github.com/x-motemen/ghq) | Git リポジトリの一元管理 |
| Git UI | [tig](https://github.com/jonas/tig) | TUI ベースの Git 操作 |
| 高速検索 | [ripgrep](https://github.com/BurntSushi/ripgrep) | 高速ファイル内検索 |
| cat 代替 | [bat](https://github.com/sharkdp/bat) | シンタックスハイライト付き表示 |
| cd 代替 | [zoxide](https://github.com/ajeetdsouza/zoxide) | スマートディレクトリ移動 |
| 履歴管理 | [atuin](https://github.com/atuinsh/atuin) | シェル履歴の同期・検索 |

### モダン CLI ツール（2024-2025 追加）

| カテゴリ | ツール | 用途 |
|---------|--------|------|
| ファイルマネージャー | [yazi](https://github.com/sxyazi/yazi) | 非同期・Vim風 TUI ファイルマネージャー |
| Git UI | [gitui](https://github.com/extrawurst/gitui) | 高速な Git TUI（tig より軽量） |
| タスクランナー | [just](https://github.com/casey/just) | Makefile 代替のシンプルなタスクランナー |
| ps 代替 | [procs](https://github.com/dalance/procs) | カラフルなプロセス表示、ツリービュー |
| htop 代替 | [bottom](https://github.com/ClementTsang/bottom) | GPU対応システムモニター（`btm`） |
| ベンチマーク | [hyperfine](https://github.com/sharkdp/hyperfine) | コマンドベンチマーク・統計分析 |
| du 代替 | [dust](https://github.com/bootandy/dust) | ディスク使用量の可視化 |
| sed 代替 | [sd](https://github.com/chmln/sd) | 直感的な検索・置換 |
| curl 代替 | [xh](https://github.com/ducaale/xh) | モダンな HTTP クライアント |
| 一括更新 | [topgrade](https://github.com/topgrade-rs/topgrade) | 全ツールを一括アップデート |

---

## モダン CLI ツール 使い方

### yazi（ファイルマネージャー）

Vim風キーバインドの高速ファイルマネージャー。画像プレビュー、zoxide/fzf連携に対応。

```bash
yazi              # カレントディレクトリで起動
yy                # 起動 → 終了時にそのディレクトリへ移動（推奨）
yz                # zoxide履歴から選択してyaziで開く
yg                # ghqリポジトリを選択してyaziで開く
```

**yazi 内の操作キー：**

| キー | 動作 |
|------|------|
| `j/k` | 上下移動 |
| `h/l` | 親ディレクトリ / ディレクトリに入る |
| `Enter` | ファイルを開く |
| `Space` | 選択 |
| `y` | コピー |
| `d` | 削除 |
| `p` | ペースト |
| `/` | 検索 |
| `q` | 終了 |

### gitui（Git TUI）

キーボード操作に最適化された高速な Git インターフェース。

```bash
gitui             # または gu（エイリアス）
```

**gitui 内の操作キー：**

| キー | 動作 |
|------|------|
| `1-5` | タブ切り替え（Status/Log/Stash/Stash changes/Stage） |
| `Enter` | ファイル差分を展開 |
| `s` | ステージ/アンステージ |
| `c` | コミット |
| `p` | プッシュ |
| `f` | フェッチ |
| `?` | ヘルプ |

### just（タスクランナー）

Makefile より簡潔なタスク定義。プロジェクトルートに `Justfile` を作成。

```just
# Justfile の例
default:
    @just --list

build:
    npm run build

test:
    npm test

deploy: build test
    ./deploy.sh
```

```bash
just              # デフォルトレシピを実行
just build        # 指定レシピを実行
just --list       # レシピ一覧
jf                # fzf でレシピを選択して実行（カスタム関数）
je                # Justfile を編集（カスタム関数）
```

### procs（プロセス表示）

カラフルで見やすいプロセス表示。Docker コンテナ情報も表示可能。

```bash
procs             # プロセス一覧
procs --tree      # ツリー表示（pt エイリアス）
procs --watch     # リアルタイム更新（pw エイリアス）
procs node        # "node" を含むプロセスを検索
pk                # fzf で選択して kill（カスタム関数）
pk9               # fzf で選択して kill -9（カスタム関数）
```

### bottom（システムモニター）

グラフィカルなシステムモニター。`btm` コマンドで起動。

```bash
btm               # システムモニターを起動
```

**bottom 内の操作キー：**

| キー | 動作 |
|------|------|
| `e` | プロセスツリーを展開 |
| `s` | ソート順変更 |
| `/` | プロセス検索 |
| `dd` | プロセスを kill |
| `?` | ヘルプ |
| `q` | 終了 |

### hyperfine（ベンチマーク）

コマンドの実行時間を統計的に計測。

```bash
hyperfine 'sleep 0.3'                    # 単一コマンド
hyperfine 'fd . -e js' 'find . -name "*.js"'  # 比較
bench 'cmd1' 'cmd2'                      # カスタム関数（warmup付き）
bench-export 'cmd1' 'cmd2'               # Markdown出力（カスタム関数）
```

### dust（ディスク使用量）

直感的なディスク使用量の可視化。

```bash
dust              # カレントディレクトリ
dust -d 2         # 深さ2まで表示
dust /path        # 指定パス
duf               # fzf でディレクトリ選択後に dust（カスタム関数）
```

### sd（検索・置換）

sed より直感的な文字列置換。

```bash
sd 'before' 'after' file.txt            # 単一ファイル
sd 'foo' 'bar' **/*.js                  # 複数ファイル
echo 'hello' | sd 'l' 'L'               # パイプ入力
sdr 'old' 'new' '*.js'                  # 再帰置換（プレビュー付き、カスタム関数）
```

### xh（HTTP クライアント）

curl より直感的な HTTP リクエスト。

```bash
xh httpbin.org/get                       # GET
xh POST httpbin.org/post name=test       # POST with JSON
xh PUT httpbin.org/put < data.json       # PUT from file
GET httpbin.org/get                      # エイリアス
POST httpbin.org/post key=value          # エイリアス
xj httpbin.org/post name=test            # JSON POST（カスタム関数）
```

### topgrade（一括更新）

インストールされているパッケージマネージャーを検出し、すべて更新。

```bash
topgrade          # または tg（エイリアス）
topgrade --dry-run  # 何が更新されるか確認
topgrade -y       # 確認なしで実行
```

---

## 関数ファイル一覧

関数は `~/.config/zsh/functions/` に分割管理されています：

| ファイル | 内容 |
|---------|------|
| `ghq.zsh` | ghq + fzf 連携（`repo`, `repo-browse`, `get`） |
| `fzf.zsh` | fzf + ripgrep 連携（`rgf`, `vf`, `cdf`） |
| `git.zsh` | fzf + Git 連携（`gb`, `gshow`, `gcp`, `gstash`, `gadd`） |
| `docker.zsh` | Docker 関連（`dex`, `drmi`） |
| `zoxide.zsh` | zoxide + fzf 連携（`zf`, `zrm`, `zs`, `zcd`） |
| `atuin.zsh` | atuin + fzf 連携（`hd`, `hs`, `hstats`） |
| `tig.zsh` | tig + fzf 連携（`tb`, `tl`, `ts`, `tr`） |
| `peco.zsh` | peco 関連（`peco-kill`, `peco-ip`） |
| `yazi.zsh` | yazi 連携（`yy`, `yz`, `yg`） |
| `just.zsh` | just + fzf 連携（`jf`, `je`） |
| `procs.zsh` | procs + fzf 連携（`pk`, `pk9`, `pw`, `pt`） |
| `modern-cli.zsh` | その他モダンツール（`duf`, `bench`, `sdr`, `xj` など） |
| `custom.zsh` | 個人用カスタム関数 |
