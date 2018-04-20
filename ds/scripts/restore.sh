#!/bin/bash -x

# go to the backup directory
backup=$1
cd /host/$backup

# restore bcl users
drush @bcl sql-query --file=$(pwd)/bcl_users.sql

# enable features
while read feature; do
    drush --yes @bcl pm-enable $feature
    drush --yes @bcl features-revert $feature
done < bcl_features.txt

# restore private variables
drush @bcl php-script $(pwd)/restore-private-vars-bcl.php

# restore twitter configuration
[[ -f trc ]] && cp trc /home/twitter/.trc

# custom restore script
[[ -f /host/restore.sh ]] && source /host/restore.sh
