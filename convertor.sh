#!/bin/bash

# 文字列変換をする
echo "\033[0;32mConvert...\033[0m"

if [ $# -eq 1 ]
  then
  sed -i "" -e "s/。/．/g" $1
  sed -i "" -e "s/、/，/g" $1
fi

if [ $? -gt 0 ]
then
	echo "\033[0;32merror.\033[0m"
else
	echo "\033[0;32mfinish.\033[0m"
fi