#!/bin/bash -x

restore_custom_scripts() {
    if [[ ! -f /host/backup.sh ]] && [[ -f backup.sh ]]; then
        cp backup.sh /host/
    fi
    if [[ ! -f /host/restore.sh ]] && [[ -f restore.sh ]]; then
        cp restore.sh /host/
    fi
    if [[ ! -d /host/cmd ]] && [[ -d cmd ]]; then
        cp -a cmd /host/
    fi
    if [[ ! -d /host/scripts ]] && [[ -d scripts ]]; then
        cp -a scripts /host/
    fi
}

# go to the backup directory
backup=$1
cd /host/$backup

# restore bcl users
drush @bcl sql-query --file=$(pwd)/bcl_users.sql

# delete any existing content
drush --yes @bcl pm-enable delete_all
drush --yes @bcl delete-all all --reset

# enable features
while read feature; do
    drush --yes @bcl pm-enable $feature
    drush --yes @bcl features-revert $feature
done < bcl_features.txt

# restore private variables
drush @bcl php-script $(pwd)/restore-private-vars-bcl.php

# restore twitter configuration
[[ -f trc ]] && cp trc /home/twitter/.trc

# restore any custom scripts
restore_custom_scripts

# custom restore script
[[ -f /host/restore.sh ]] && source /host/restore.sh
