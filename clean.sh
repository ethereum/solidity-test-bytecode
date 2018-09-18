#!/usr/bin/env bash

set -e

git fetch origin
git checkout origin/master
MONTHS=$(ls -d ????-??-* | cut -c-7 | sort -u)
for month in $MONTHS
do
    ls -rtd $month* | head -n -1 | xargs rm -rf --
done
git add -A
git checkout --orphan newMaster
git commit -m "Pruned history." || exit 0

git branch -D master
git branch -m master
git push -f origin master
