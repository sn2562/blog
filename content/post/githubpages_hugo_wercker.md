+++
date = "2017-06-18T17:18:51+09:00"
draft = true
title = "githubpages_hugo_wercker"

+++
#GitHub Pages + Hugo + werckerで日記を公開する

GitHubでブログを公開している人たちがいて([こことか](http://r9y9.github.io))なんだカッコイイ！と思ったのでやってみる．

## 使用技術

- Hugo
	- [Hugo](https://gohugo.io/)
	- ブログとかポートフォリオみたいなサイトを作るサイトジェネレータ．Go製．
	- .mdとか書いたらいい感じにサイトっぽくしたヤツをつくってくれる.
- GitHub Pages
	- [GitHub Pages](https://pages.github.com)
	- githubのリポジトリ下にhtmlファイルとかおいて公開できる．
- wercker
	- [wercker](https://app.wercker.com)
	- CIツール．デプロイ自動化したければ使う．
	- http://gohugo.io/tutorials/automated-deployments/　のチュートリアルに従って設定を進めていく．

## Hugoを使ってみる
基本的には[Hugo Quickstart Guide](http://gohugo.io/overview/quickstart/)を見ながら進めれば大丈夫．不安になったら[hugo + Github Pagesでブログ作成に挑戦した話](https://eichann.github.io/post/first/)や[HugoとGitHub Pagesで静的サイトを公開する](http://qiita.com/satzz/items/e24bd703fc04fb45f7ef)が丁寧に教えてくれているので参考にする．だいたいは新しいページを作ってローカル環境で確認後Github Pagesで公開するって流れだった．

### Quickstart Guideのメモ

#### Step 3. 記事の追加
記事コンテンツを新しく追加したいときは`hugo new`コマンドを使う.
```
$ hugo new post/poyo.md
```
これで`content/post`下に`poyo.md`が生成されるので書き換えて記事をつくる．

```
+++
date = "2017-06-18T16:11:58+05:30"
draft = true
title = "poyo"

+++

記事の内容.
```
`+++`で囲まれた所をfront matterっていって記事の設定とかができるらしい．記事内容はその下に書いていく。
- date	日付
- draft	記事の下書き設定．デフォルトは`true`．
- title	記事の表示タイトル
- image	記事のキャッチとして画像urlを文字列で設定できる．画像の置場所は`static/images`下．

あと

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

任意のテーマ`hugo_theme_robust`を適用させたいときは`--theme=`の引数か`-t`で指定してあげる．あと`–watch`でオートリロードを効かせられる．

```
$ hugo server --theme=hugo_theme_robust --buildDrafts
# あるいは
$hugo server -t hugo_theme_robust --watch
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

```
$ hugo server --theme=hugo_theme_robust
```

#### Step 10. Disqusとコメント機能
[Disqus](https://disqus.com)というサービスと連携してコメント機能をつけれるらしい．試していない．

#### Step 11. websiteを公開する

下準備として`config.toml`ファイルに公開先のGithubリポジトリの設定をする．
hugoコマンドで

```:config.toml
baseURL = "https://<your GitHub username>.github.io/<githubのリポジトリ名>/"
```

hugoコマンドを実行．

```
$ hugo --theme=hugo_theme_robust
```

設定したURLに対応した公開用の`/public`ディレクトリを作ってくれる，

#### GihHub Pagesにデプロイする
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


## デプロイの自動化
### デプロイってなーに？
作ったものをサーバにアップロードし、他の人も利用できる状態にすること．ソフトウェアのリリースやインストールも含んだ意味の広い言葉．

### hugoのデプロイ
[Hugo tutorials - Automated deployment](http://gohugo.io/tutorials/automated-deployments/)にデプロイ自動化チュートリアルがあった．[wercker](https://app.wercker.com) を使って記事の追加がリポジトリにpushされるたびにその他のところを全部自動でやるように設定する．

正直gh-pages使ってないし，記事書いてhugoコマンド実行して変更をpushするだけだから自動化してもあんまり美味しい所ない?と思ったけどCIツールを勉強したかったのでやってみる．

.ymlにwelckerがどういうふうに処理をすすめていくかの設定を書いてあげると、welckerが勝手にそのファイルを読んで自動で処理をしてくれる．

### 参考
- welckerを使うにあたって以下を一度読んでから始めると、ymlファイルの書き方とかとてもわかり易くてよかった．
	-[Werckerの仕組み，独自のboxとstepのつくりかた](http://deeeet.com/writing/2014/10/16/wercker/)

### Hugo tutorials - Automated deploymentのメモ

#### Using Hugo-Build
このステップで実際に.ymlファイルを使って`git push`した時にいろいろ自動でやってくれるのを確認している．BuildフェーズはGitHubとかにpushが来た時に、ビルドとかテストとかコンパイルをymlファイルに書かれた順番で走らせてくれる．何か変更があればそれをPackageとして次のDeployフェーズに渡してくれる．チュートリアルではBuildフェーズで以下の3つのステップを行っていた．
1. gitコマンドが使えるようにインストール
2. テーマのダウンロード
3. [arjen/hugo-build](https://app.wercker.com/applications/54a7744c6b3ba8733de4dcde/tab/details/)を実行

wercker.ymlのなかみ
```
box: debian
build:
  steps:
    - install-packages:
        packages: git
    - script:
        name: download theme
        code: |
            $(git clone https://github.com/spf13/herring-cove ./themes/herring-cove)
    - arjen/hugo-build:
        version: "0.14"
        theme: herring-cove
        flags: --buildDrafts=true
```



プッシュしてwerckerのサイト見に行ったら途中で怒られて止まってた．

```
ERROR: 2017/06/18 Current theme does not support Hugo version 0.14. Minimum version required is 0.2
ERROR: 2017/06/18 Unable to find Static Directory: /pipeline/source/static/
ERROR: 2017/06/18 template: theme/partials/footer.html:3: function "now" not defined
ERROR: 2017/06/18 Error while rendering section post: html/template:theme/_default/list.html:9:12: "theme/partials/footer.html" is an incomplete or empty template
```

テンプレートの問題っぽいエラーだったのでテンプレートを別なのに変えてみる．

```
$(git clone https://github.com/MunifTanjim/minimo ./theme/minimo)
```

通った．よかった．ちゃんと動いたので確認おわり．

#### Adding a deploy pipeline
さっきまではBuildフェーズしかなかったのでDeployフェーズを追加してGitHub Pagesにデプロイするところまで自動でやってもらう．
"Add new pipeline"で以下の設定でCreateボタンを押す．

- Add new pipeline
	- Name : deploy-production とか deployとか(なんでもいい)
	- YML Pipeline name : deploy
	- hook type : Default

#### deployフェーズを追加する

Wercker から GitHub Pagesへの自動デプロイを許可を出すためにGitHub側でpublic_repo 権限を与えたトークンを生成して登録する．[Harp & Wercker 自動デプロイ](https://syon.github.io/refills/rid/1462287/)での説明がとてもわかりやすかった．

- Wercker > Applications > Environment
	- Key: GIT_TOKEN
	- Value: <生成したトークン> [ ✔ Protected ]

これでwercker.ymlから$GIT_TOKENで参照できるようになる．

pipelineを変更する．welcker > applicationからbuildの右側にくっついている+を押してさっきつくったdeployをくっつける．
で、.ymlの方にdeployフェーズを追記してあげる．

- buildフェーズ
	1. [arjen/hugo-build](https://app.wercker.com/applications/54a7744c6b3ba8733de4dcde/tab/details/)を実行
- deployフェーズ
	1. gitとssh-clientを使えるようにインストール
	2. [leipert/git-push](https://app.wercker.com/applications/53f202b50705e3656b000033/tab/details/)をバージョン0.7.6指定で実行

wercker.ymlのなかみ

```
box: debian
build:
  steps:
    - arjen/hugo-build:
        version: "0.14"
        theme: slim
        flags: --buildDrafts=true
deploy:
  steps:
    - install-packages:
        packages: git ssh-client
    - leipert/git-push@0.7.6:
        gh_oauth: $GIT_TOKEN
        gh_pages_domain: https://github.com/sn2562/blog.git
```


#### チュートリアルにそってdeployフェーズを追加する
チュートリアルだと以下の通り．

- buildフェーズ
	1. [arjen/hugo-build](https://app.wercker.com/applications/54a7744c6b3ba8733de4dcde/tab/details/)を実行
- deployフェーズ
	1. gitとssh-clientを使えるようにインストール
	2. [lukevivier/gh-pages](https://app.wercker.com/applications/51f71ee369cd738a32001822/tab/details/)をバージョン2.1指定で実行

wercker.ymlのなかみ

```
box: debian
build:
  steps:
    - arjen/hugo-build:
        version: "0.14"
        theme: herring-cove
        flags: --buildDrafts=true
deploy:
  steps:
    - install-packages:
        packages: git ssh-client
    - lukevivier/gh-pages@0.2.1:
        token: $GIT_TOKEN
        domain: hugo-wercker.ig.nore.me
        basedir: public
```

ただ、lukevivier/gh-pages使っちゃうと`gh-pages`ブランチ切ってそっちに追加していく感じになってしまうので今回みたいにmasterブランチのdocsフォルダで公開したいとき使えない...．

#### deploy
- lukevivier/gh-pagesの実際の処理は[lvivier/step-gh-pages/run.sh](https://github.com/lvivier/step-gh-pages/blob/master/run.sh)から見ることができる．

[hugo + Github Pagesでブログ作成に挑戦した話](http://eichann.github.io/post/first/)を参考にしながら、まずはローカルでシェルスクリプト`run.sh`を実行すれば記事の変更が適用されるようにする．

`run.sh`のなかみ

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


[GitHubアクセストークンとWerckerの設定](https://syon.github.io/refills/rid/1462280/)
