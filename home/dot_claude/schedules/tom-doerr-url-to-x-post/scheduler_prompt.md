@tom_doerr のXアカウントの最新ポストからURL付きのポストを見つけ、各URLの記事をサマリーしてXの下書きとして保存する。

手順:
1. Playwright MCPで https://x.com/tom_doerr にアクセスしてスナップショットを取得
2. ポストからx.com以外の外部URLを全て抽出
3. /Users/taiga.mikami.001/.local/state/claude-schedules/tom-doerr-url-to-x-post/processed_urls.txt を読み込み、既に処理済みのURLを除外
4. 未処理のURL各件について以下を実行:
   a. mcp__shepherd__read_url でURLの記事を取得（失敗時はWebFetchを使用）
   b. 記事を日本語で詳細に要約（タイトル、概要、主なポイント3-5個、所感）
   c. X投稿テキストを生成（280文字以内、日本語1文字=2、URL=23文字、箇条書きで要点凝縮、末尾にURL）
   d. Playwright MCPで https://x.com/compose/post を開く
   e. テキスト入力欄(textbox "Post text")にslowly:trueで入力
   f. Closeボタン→「Save post?」ダイアログ→「Save」で下書き保存
   g. 処理済みURLを /Users/taiga.mikami.001/.local/state/claude-schedules/tom-doerr-url-to-x-post/processed_urls.txt に追記
5. 全URL処理完了後、処理件数を報告

注意:
- 投稿ボタン(Post)は絶対にクリックしない。下書き保存のみ
- ログイン画面が出た場合はスキップして報告
- t.coリンクはリダイレクト先の実URLを使用
- 各ポスト処理後はbrowser_snapshot()でref再取得
