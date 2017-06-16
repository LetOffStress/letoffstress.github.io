#!/bin/bash

set -eu

# ユーザー情報
git config user.name letoffstress
git config user.email letoffxxx@gmail.com
USER=letoffstress
REPO=letoffstress.github.io

# hugo関係のファイルを置く場所。
HUGO_DIR=./hugo
echo "HUGO_DIR : ${HUGO_DIR}"

# hugoのバイナリファイル
HUGO_BIN="${HUGO_DIR}/hugo"
echo "HUGO_BIN : ${HUGO_BIN}"

# サイトを生成するディレクトリ
DIST_DIR=./public
echo "DIST_DIR : ${DIST_DIR}"

# hugoのファイルがなかったらダウンロード
if [ ! -e "${HUGO_DIR}" ];then
  echo "Download hugo bin"

  HUGO_PACKAGE=hugo.tgz
  echo "HUGO_PACKAGE : ${HUGO_PACKAGE}"

  echo "Create '${HUGO_DIR}'"
  mkdir ${HUGO_DIR}

  cd ${HUGO_DIR}
  wget -O ${HUGO_PACKAGE} https://github.com/gohugoio/hugo/releases/download/v0.22.1/hugo_0.22.1_Linux-64bit.tar.gz
  tar -xvf ${HUGO_PACKAGE}
  cd ..
fi

# DIST_DIRが無かったらGitHubからclone
if [ ! -d "${DIST_DIR}" ];then
  echo "Clone via GitHub"
  echo "Clone to '${DIST_DIR}'"
  git clone https://${GITHUB_TOKEN}@github.com/${USER}/${REPO} ${DIST_DIR} --depth 1 --branch master > /dev/null 2>&1
fi

# サイトを生成
echo "Compile site"
${HUGO_BIN}

# 変更があったらcommit
cd ${DIST_DIR}
git add .
d=`date +"%Y/%m/%d %k:%M:%S"`
git diff --cached --exit-code --quiet || git commit -m "Update blog at ${d}"

# GitHubにpush
echo "Push to GitHub"
git push origin master > /dev/null 2>&1
echo "Successfully deployed."
