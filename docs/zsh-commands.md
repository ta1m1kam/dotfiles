# Zsh カスタムコマンド リファレンス

このドキュメントでは、dotfilesで定義されているエイリアスとカスタム関数について説明します。

---

## 目次

1. [キーバインド](#キーバインド)
2. [エイリアス](#エイリアス)
3. [カスタム関数](#カスタム関数)

---

## キーバインド

| キー | 関数 | 説明 |
|------|------|------|
| `Ctrl+G` | `repo` | ghq + fzf でリポジトリに移動 |
| `Ctrl+F` | `vf` | fzf でファイルを選択して vim で開く |
| `Ctrl+B` | `gb` | fzf で Git ブランチを切り替え |

---

## エイリアス

### ディレクトリ移動

| エイリアス | 展開先 | 説明 |
|-----------|--------|------|
| `d` | `cd ~/Desktop` | デスクトップに移動 |
| `dotfiles` | `cd ~/dotfiles` | dotfiles ディレクトリに移動 |
| `W` | `cd ~/workspace` | ワークスペースに移動 |
| `..` | `cd ..` | 親ディレクトリに移動 |

### ファイル操作

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

### エディター

| エイリアス | 展開先 | 説明 |
|-----------|--------|------|
| `vi` | `vim` | vim を起動 |
| `f` | `open .` | Finder でカレントディレクトリを開く |
| `od` | `open ~/Desktop` | Finder でデスクトップを開く |

### Git

| エイリアス | 展開先 | 説明 |
|-----------|--------|------|
| `gs` | `git status` | ステータス確認 |
| `gd` | `git diff` | 差分表示 |
| `ga` | `git add` | ステージング |
| `gc` | `gitmoji -c` | gitmoji でコミット |

### Docker

| エイリアス | 展開先 | 説明 |
|-----------|--------|------|
| `dc` | `docker-compose` | docker-compose 短縮形 |

### その他

| エイリアス | 展開先 | 説明 |
|-----------|--------|------|
| `t` | `tmux` | tmux を起動 |
| `zshrc` | `source ~/.zshrc` | zshrc を再読み込み |

### グローバルエイリアス

| エイリアス | 展開先 | 説明 |
|-----------|--------|------|
| `G` | `\| grep` | パイプで grep に接続 |

**使用例:**
```bash
# プロセス一覧から node を検索
ps aux G node
```

---

## カスタム関数

### ghq + fzf 関連

#### `repo`
リポジトリを fzf で選択して移動します。

```bash
repo
```

- **キーバインド:** `Ctrl+G`
- **プレビュー:** README.md の内容（なければディレクトリ一覧）
- ghq で管理しているリポジトリ一覧から選択

#### `repo-browse`
リポジトリを fzf で選択して GitHub をブラウザで開きます。

```bash
repo-browse
```

- gh browse コマンドで GitHub ページを開く

#### `get`
リポジトリを ghq get でクローンし、そのディレクトリに移動します。

```bash
get https://github.com/user/repo
get user/repo
```

---

### fzf + ripgrep 関連

#### `rgf`
ファイル内をキーワード検索し、該当行を vim で開きます。

```bash
rgf "検索ワード"
rgf "function.*export"  # 正規表現も使用可能
```

- **プレビュー:** マッチした行をハイライト表示
- 選択すると vim で該当行にジャンプ

#### `vf`
fzf でファイルを選択して vim で開きます。

```bash
vf
```

- **キーバインド:** `Ctrl+F`
- **プレビュー:** ファイル内容をシンタックスハイライト付きで表示

#### `cdf`
fzf でディレクトリを選択して移動します。

```bash
cdf
```

- **プレビュー:** ディレクトリ内のファイル一覧

---

### fzf + Git 関連

#### `gb`
ブランチを fzf で選択してチェックアウトします。

```bash
gb
```

- **キーバインド:** `Ctrl+B`
- **プレビュー:** ブランチのコミット履歴
- ローカル・リモート両方のブランチを表示
- コミット日時順にソート

#### `gshow`
コミットを fzf で選択して詳細を表示します。

```bash
gshow
```

- **プレビュー:** コミットの差分
- グラフ表示でコミット履歴を確認

#### `gcp`
コミットを fzf で選択して cherry-pick します。

```bash
gcp
```

- **プレビュー:** コミットの差分
- 全ブランチのコミットから選択可能

#### `gstash`
stash を fzf で選択して適用します。

```bash
gstash
```

- **プレビュー:** stash の差分内容
- `git stash apply` で適用

#### `gadd`
変更ファイルを fzf で選択してステージングします。

```bash
gadd
```

- **複数選択:** Tab キーで複数ファイルを選択可能
- **プレビュー:** ファイルの差分
- 選択後、ステータスを表示

---

### peco 関連

#### `peco-kill`
プロセスを peco で選択して終了します。

```bash
peco-kill
```

- ps aux の結果から選択
- 選択したプロセスに kill を送信

#### `peco-ip`
IP アドレスを peco で選択してコピーします。

```bash
peco-ip
```

- ifconfig から inet アドレスを抽出
- 選択した IP アドレスを出力

---

### Docker 関連

#### `dex`
Docker コンテナを peco で選択してシェルに入ります。

```bash
dex        # sh でコンテナに入る
dex bash   # bash でコンテナに入る
```

- 実行中のコンテナから選択
- デフォルトは sh、引数でシェルを指定可能

#### `drmi`
Docker イメージを peco で選択して削除します。

```bash
drmi
```

- イメージ一覧から選択
- 複数選択可能

---

### カスタム関数

#### `yo`
Obsidian ディレクトリを追加して Claude Code を起動します。

```bash
yo
yo "質問内容"
```

- 環境変数 `CLAUDE_CODE_MODEL` でモデル指定可能
- Obsidian のメモを参照しながら Claude と対話

#### `oo`
Obsidian ディレクトリに移動します。

```bash
oo
```

---

## fzf 操作キー

fzf 使用中に利用できる共通キー:

| キー | 動作 |
|------|------|
| `Enter` | 選択を確定 |
| `Tab` | 複数選択モードで選択/解除 |
| `Ctrl+U` | プレビューを半ページ上スクロール |
| `Ctrl+D` | プレビューを半ページ下スクロール |
| `Ctrl+C` / `Esc` | キャンセル |
| `↑` / `↓` | 候補を移動 |

---

## 関連ツール

これらのコマンドは以下のツールに依存しています:

| ツール | 用途 |
|--------|------|
| [fzf](https://github.com/junegunn/fzf) | ファジーファインダー |
| [ghq](https://github.com/x-motemen/ghq) | リポジトリ管理 |
| [ripgrep (rg)](https://github.com/BurntSushi/ripgrep) | 高速検索 |
| [bat](https://github.com/sharkdp/bat) | シンタックスハイライト付き cat |
| [peco](https://github.com/peco/peco) | インタラクティブフィルタリング |
| [gh](https://cli.github.com/) | GitHub CLI |
