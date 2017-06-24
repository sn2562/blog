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
msg="rebuilding site `date '+%Y%m%d %H:%S'`"
if [ $# -eq 1 ]
  then msg = "$msg $1"
fi
git commit -m "$msg"

# Push source and build repos.
git push origin master

# Come Back
cd ..
