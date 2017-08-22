+++
date = "2017-08-23T00:14:29+09:00"
draft = false
title = "PythonのYieldキーワードとの初めての出会い"
tags = ["python"]
+++

pythonのサンプルを見てて初めて yield に出会ってなんだ君は，ってなったのでメモ．

## 調べた
個人的に [stack overflow - What does the “yield” keyword do?](https://stackoverflow.com/questions/231767/what-does-the-yield-keyword-do) で回答してくださってる方の説明がとてもとてもわかりやすかったので，英語の説明を自分なりに解釈したものをつらつらと載せます．

どうやら，`yield`を理解するにはまず`generator`なものたちについて理解したほうがよくて，そのためには`generator`なものたちのモトである`iterable`なものたちについて知っておくといいようです．

## Iterable なものたち
for... in... の形で書いて中身をじゅんぐりに取り出せるようなもののこと全部．
```
>>> mylist = [1, 2, 3]
>>> for i in mylist:
...    print(i)
1
2
3

>>> mylist = [x*x for x in range(3)]
>>> for i in mylist:
...    print(i)
0
1
4
```
使いやすいけど，全部の値をはじめに持っておかないといけないから沢山の値が必要なときに良くないし，そもそも全部使わないこともあるから無駄．そういうときは Generator 使うと良いらしい．

## Generator たちをつかおう
GeneratorたちもIterable なものたちのうちのひとつ．だけどその要素はその都度生成されるもので，**一度だけ**　しか使わない．全ての値をメモリに取っておくということはしないし，このこたちは **その場で即座に** 必要な値を作ってくれる．
```
>>> mygenerator = (x*x for x in range(3))
>>> for i in mygenerator:
...    print(i)
0
1
4
```
`()`の代わりに`[]`を使ってもおんなじ．mygenerator は二度使うことはできない．0を出力したら，もうそのことを忘れて次は1を，最後に4を，じゅんぐりに一つずつ出力するだけ．

## Yield，君はなんなんだ
`yield`キーワードは，使い方は`return`とにてる．関数から Generator を返すときに使う．
```
>>> def createGenerator():
...    mylist = range(3)
...    for i in mylist:
...        yield i*i
...
>>> mygenerator = createGenerator() # create a generator
>>> print(mygenerator) # mygenerator is an object!
<generator object createGenerator at 0xb7555c34>
>>> for i in mygenerator:
...     print(i)
0
1
4
```
generator を作っている関数は，呼び出された時には関数の内部に書かれたコード自体は処理されないということを理解しなくちゃいけない．生成した generator が使われるたびに，関数の中の処理が実行される．

肝心なところ:
最初に`for`文で関数を使って作った generator を呼び出した時に，その元の関数も最初から`yield`キーワードが出てくるまで実行される．で，`yield`キーワードを見つけたらそのタイミングでループの一番最初の値の`0`を返す．その後， generator が使われるたび関数の中のloop文が繰り返され，返す値がなくなるまで続ける．

なんとなくわかった気がする...．

## LINKS
- [stack overflow - What does the “yield” keyword do?](https://stackoverflow.com/questions/231767/what-does-the-yield-keyword-do)
    - Iterables, Generatorsのさんこうに
- [Writing an Hadoop MapReduce Program in Python](http://www.michael-noll.com/tutorials/writing-an-hadoop-mapreduce-program-in-python/)
    - はじめての出会いはこっち．今だにyieldキーワードを使うとなにがよくなるのかわかってない...．
