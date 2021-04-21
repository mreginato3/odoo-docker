#!/bin/bash

#mkdir base-addons

for repo in $(cat $1)
do
    REPO_DIR=$(echo $repo | sed 's/https:\/\/github.com\///' | sed 's/.git//')
    #echo $REPO_DIR
    git clone $repo --branch=$ODOO_VERSION /mnt/base-addons/$REPO_DIR
    python3 -m pip install -r /mnt/base-addons/$REPO_DIR/requirements.txt
done