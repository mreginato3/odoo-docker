#!/bin/bash

mkdir base-addons

for repo in $(cat $1)
do
    REPO_DIR=$(echo $repo | sed 's/https:\/\/github.com\///' | tr / - | sed 's/.git//')
    # echo $REPO_DIR
    git clone $repo --branch=13.0 ./base-addons/$REPO_DIR
done