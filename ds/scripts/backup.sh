#!/bin/bash -x

#source /host/settings.sh

# create the backup dir
backup="backup-data-$(date +%Y%m%d)"
cd /host/
rm -rf $backup
rm -f $backup.tgz
mkdir $backup
cd $backup/

# disable the site for maintenance
drush --yes @local_bcl vset maintenance_mode 1

# clear the cache
drush --yes @local_bcl cache-clear all

# backup bcl users
mysqldump=$(drush @bcl sql-connect | sed -e 's/^mysql/mysqldump/' -e 's/--database=/--databases /')
table_list="users users_roles"
$mysqldump --tables $table_list > $(pwd)/bcl_users.sql

# backup enabled features
drush @bcl features-list --pipe --status=enabled \
      > $(pwd)/bcl_features.txt

# backup drupal variables
local dir
dir=/var/www/bcl/profiles/bcl_server/modules/features
$dir/save-private-vars.sh @bcl
mv restore-private-vars.php restore-private-vars-bcl.php

# make the backup archive
cd /host/
tar --create --gzip --preserve-permissions --file=$backup.tgz $backup/
rm -rf $backup/

# enable the site
drush --yes @local_bcl vset maintenance_mode 0
