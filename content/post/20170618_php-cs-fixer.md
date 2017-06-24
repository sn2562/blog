+++
date = "2017-06-18T21:29:34+09:00"
draft = true
title = "20170618_php cs fixer"

+++
## php 5.6を使う

参考
https://gist.github.com/nw-tsubo/4f9f30a53e232b4de5ad014f075de8db

### brew レポジトリの追加
```
$ brew tap homebrew/dupes
$ brew tap homebrew/versions
$ brew tap homebrew/php
```
### PHP v5.6 のインストール
```
$ brew install php56
$ brew install php56-mcrypt
```

## コードをPHPのコーディング規約に則って書く
- php-cs-fixer
  - PHP CS Fixer (PHP Coding Standards Fixer) とは、その名の通り PHP コードをコーディング規約に沿うよう修正してくれるツールです。

###　インストール
```
$ curl -L https://github.com/FriendsOfPHP/PHP-CS-Fixer/releases/download/v1.11.4/php-cs-fixer.phar -o php-cs-fixer
$ sudo chmod a+x php-cs-fixer
$ sudo mv php-cs-fixer /usr/local/bin/php-cs-fixer
$ php-cs-fixer --version
```

v2もあるらしい...うーむ

```
$ curl -L http://cs.sensiolabs.org/download/php-cs-fixer-v2.phar -o php-cs-fixer
```

```
brew install php-cs-fixer
```

### 参考
- [PHP CS Fixerで快適PHPライフ](http://fivestar.hatenablog.com/entry/2014/12/08/033345) 古い情報
- [](http://fivestar.hatenablog.com/entry/2017/03/30/233744)
- [Atomにatom-beautifyを入れてPHPのソースコードを整形する](http://qiita.com/hachijirou/items/ea00005ff4910f89d6bf)

http://loumo.jp/wp/archive/20150905000005/
