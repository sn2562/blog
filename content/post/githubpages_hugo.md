+++
date = "2017-06-18T17:19:15+09:00"
draft = false
title = "githubpages_hugo"

+++
# GitHub Pages + Hugoで日記を公開する

GitHubでブログを公開している人たちがいてカッコイイ！と思ったのでやってみる．

## 使用技術

- Hugo
	- [Hugo](https://gohugo.io/)
	- ブログとかポートフォリオみたいなサイトを作るサイトジェネレータ．Go製．
	- .mdとか書いたらいい感じにサイトっぽくしたヤツをつくってくれる.
- GitHub Pages
	- [GitHub Pages](https://pages.github.com)
	- githubのリポジトリ下にhtmlファイルとかおいて公開できる．

## Hugoを使ってみる
基本的には[Hugo Quickstart Guide](http://gohugo.io/overview/quickstart/)を見ながら進めれば大丈夫．不安になったら[hugo + Github Pagesでブログ作成に挑戦した話](https://eichann.github.io/post/first/)や[HugoとGitHub Pagesで静的サイトを公開する](http://qiita.com/satzz/items/e24bd703fc04fb45f7ef)が丁寧に教えてくれているので参考にする．だいたいは新しいページを作ってローカル環境で確認後Github Pagesで公開するって流れだった．

### Quickstart Guideのメモ

#### Step 3. 記事の追加
記事コンテンツを新しく追加したいときは`hugo new`コマンドを使う.
```
$ hugo new post/poyo.md
```
これでcontent/post下にpoyo.mdが生成されるので書き換えて記事をつくる．

```
+++
date = "2017-06-18T16:11:58+05:30"
draft = true
title = "poyo"

+++

記事の内容.
```
+++で囲まれた所をfront matterっていって記事の設定とかができるらしい．記事内容はその下に書いていく。

- date	日付
- draft	記事の下書き設定．デフォルトは`true`．
- title	記事の表示タイトル
- image	記事のキャッチとして画像urlを文字列で設定できる．画像の置場所はstatic/images下．


#### Step 4. hugo起動 - Step 5. テーマの適用
まずはhugoを起動する．

```
$ hugo server
```

[http://localhost:1313](http://localhost:1313)で作ったサイトにアクセスできるようになるけれどドラフト(下書き)指定されてる記事は反映されないので見えないし，テーマ設定もしてない．

下書きを含めて見たいときは`---buildDrafts`してあげればいい．

```
$ hugo server --buildDrafts
```

これで下書きも含めて表示させることができる．

任意のテーマpiyo_themeを適用させたいときは`--theme=`の引数か`-t`で指定してあげる．

```
$ hugo server --theme=piyo_theme --buildDrafts
# あるいは
$ hugo server -t piyo_theme
```

#### Step 6. いろいろなテーマを試す
ちょっと試したいテーマ`hoge`があったときに`/themes`に入れておけば`hugo server --theme=hoge`とか`hugo server -t hoge`するだけで試せるぞって話．

#### Step 7. Update config.toml and live reloading in action
サーバ起動しながらconfig.tomlのtitleとか変更したらリアルタイムで反映されるよって話．

#### Step 8. Customize robust theme
テーマをカスタマイズしよう！って話だとおもう．試してない．画像を置くパスの話とかテーマのhtmlファイルを変更する話をしてた．

#### Step 9. 記事を下書きから公開にする
作成済みの記事を下書きから公開に設定する．

```
$ hugo undraft content/post/good-to-great.md
```

これでhugoを起動すれば、`---buildDrafts`無しの状態で記事が見れるようになる．

#### Step 10. Disqusとコメント機能
[Disqus](https://disqus.com)というサービスと連携してコメント機能をつけれるらしい．試していない．

#### Step 11. websiteを公開する

下準備としてconfig.tomlファイルに公開先のGithubリポジトリの設定をする．

```:config.toml
baseURL = "https://<your GitHub username>.github.io/<リポジトリ名>/"
```

hugoコマンドを実行．

```
$ hugo --theme=hugo_theme_robust
```

設定したURLに対応した公開用の/publicディレクトリを作ってくれる．

#### GihHub Pagesにデプロイする
##### デプロイってなーに？
作ったものをサーバにアップロードし、他の人も利用できる状態にすること．ソフトウェアのリリースやインストールも含んだ意味の広い言葉らしい．

まずはファイル全体をgitの管理下に置くための下準備から公開まで．公式ドキュメントは`gh-pages`ブランチを使ってGihHub Pagesを公開する方法で説明しているけれど、2016年8月からmasterブランチに`docs`フォルダを作ってページを公開する方法が使えるようになったのでそちらを使う．GitHubのユーザ名がsn2562，リポジトリ名がpiyoとして以下のコマンドを順番に実行する．

```
$ git init
$ echo "/themes/" >> .gitignore
$ git add --all
$ git commit -m "Initial commit"
$ git remote add origin git@github.com:sn2562/piyo.git
$ git push origin master
```

これで https://sn2562.github.io/piyo へアクセスしてサイトが表示されていればOK．

#### deployの半自動化

[hugo + Github Pagesでブログ作成に挑戦した話](http://eichann.github.io/post/first/)を参考にしながら、必要な作業を`sh run.sh`を実行すれば全部してくれるように設定する．

run.shのなかみ
```
#!/bin/bash

echo -e "\033[0;32mDeploying updates to GitHub...\033[0m"

# Build the project.
hugo -t slim

# Add contents and draft changes to git.
git add content/

# Go To Public(docs) folder
cd docs

# Add site changes to git.
git add .

# Commit changes.引数があれば第一引数をcommit messageに設定.
msg="rebuilding site `date`"
if [ $# -eq 1 ]
  then msg="$1"
fi
git commit -m "$msg"

# Push source and build repos.
git push origin master

# Come Back
cd ..
```

できた．

## まとめ
| Command    | Description     |
| :------------- | :------------- |
| $ hugo new post/poyo.md    | 新しい記事poyo.mdの生成 |
| $ hugo server    | http://localhost:1313 で表示確認 |
| $ hugo server --buildDrafts   | 下書きも表示確認 |
| $ hugo undraft content/post/poyo.md    | poyo.mdを下書きから公開に設定 |
| $ hugo --theme=slim   | slimテンプレートで公開用のディレクトリ作成 |
| $ sh run.sh    | run.shシェルスクリプトを実行 |
