#!/bin/bash -x

#source /host/settings.sh

# disable the site for maintenance
drush --yes @local_bcl vset maintenance_mode 1
drush --yes @local_bcl cache-clear all

# extract the backup archive
file=$1
cd /host/
tar --extract --gunzip --preserve-permissions --file=$file
backup=${file%%.tgz}
backup=$(basename $backup)
cd $backup/

# restore
restore_data
restore_config

# restore bcl users
drush @bcl sql-query --file=$(pwd)/bcl_users.sql

# enable features
while read feature; do
    drush --yes @bcl pm-enable $feature
    drush --yes @bcl features-revert $feature
done < bcl_features.txt

# restore private variables
drush @bcl php-script $(pwd)/restore-private-vars-bcl.php

# clean up
cd /host/
rm -rf $backup

# enable the site
drush --yes @local_bcl cache-clear all
drush --yes @local_bcl vset maintenance_mode 0
