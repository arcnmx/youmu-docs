#!/bin/bash
set -eu

chmod 0600 $TRAVIS_BUILD_DIR/.travis/id

cp -a youmu/pages/* docs/
mkdir -p docs/_data
cp -a crates.yml docs/_data/

cd docs

git init
git config user.name "ghost"
git config user.email "ghost@konpaku.2hu"

git remote add origin "git@github.com:$TRAVIS_REPO_SLUG"
ssh-agent bash -c 'ssh-add $TRAVIS_BUILD_DIR/.travis/id; git fetch origin'
git checkout -b gh-pages
git reset origin/gh-pages

git add -A .
COMMIT="$TRAVIS_COMMIT`[ "$TRAVIS_PULL_REQUEST" = "false" ] || echo " #$TRAVIS_PULL_REQUEST"`"
git commit -m "$COMMIT"

ssh-agent bash -c 'ssh-add $TRAVIS_BUILD_DIR/.travis/id; git push -q origin HEAD:gh-pages'

if [ "$TRAVIS_PULL_REQUEST" != "false" ]; then
	git checkout master
	git merge --no-ff -m "Merge pull request #$TRAVIS_PULL_REQUEST" origin "pull/$TRAVIS_PULL_REQUEST/head"

	ssh-agent bash -c 'ssh-add $TRAVIS_BUILD_DIR/.travis/id; git push -q origin HEAD:master'
fi
