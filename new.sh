#!/bin/sh

#日付ベースのタイトル付け
name=`date '+%Y%m%d'`
if [ $# -eq 1 ]
  then name=$name"_$1"
fi

#hugoの新しいページを作る
hugo new post/$name.md
