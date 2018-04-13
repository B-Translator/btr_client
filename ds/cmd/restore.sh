cmd_restore_help() {
    cat <<_EOF
    restore <backup-file.tgz>
        Restore application from the given backup file.

_EOF
}

cmd_restore() {
    # get the backup file
    local file=$1
    test -f "$file" || fail "Usage:\n$(cmd_restore_help)"
    [[ $file != ${file%%.tgz} ]] || fail "Usage:\n$(cmd_restore_help)"

    # get the type of backup and
    # call the appropriate restore function
    local type=$(echo $file | cut -d- -f2)
    set -x
    case $type in
        full)
            _make_full_restore $file
            ;;
        data)
            _make_data_restore $file
            ds inject restore.sh $file
            ;;
        *)
            _make_app_restore $file
    esac
}

_make_app_restore() {
    local file=$1
    local app=$(echo $file | cut -d- -f2)
    local backup=${file%%.tgz}
    backup=$(basename $backup)

    # disable the site for maintenance
    ds exec drush @$app vset maintenance_mode 1

    # extract the backup archive
    tar --extract --gunzip --preserve-permissions --file=$file

    # restore the database
    ds exec drush @$app sql-drop --yes
    ds exec drush @$app sql-query \
       --file=/host/$backup/$app.sql

    # restore application files
    rm -rf var-www/$app
    cp -a $backup/$app var-www/

    # clean up
    rm -rf $backup

    # enable the site
    ds exec drush @$app vset maintenance_mode 0
}

_make_full_restore() {
    local file=$1
    local backup=${file%%.tgz}
    backup=$(basename $backup)

    # disable the site for maintenance
    ds exec drush --yes @local_bcl vset maintenance_mode 1

    # extract the backup archive
    tar --extract --gunzip --preserve-permissions --file=$file

    # restore the content of the database
    ds exec drush @bcl sql-drop --yes
    ds exec drush @bcl sql-query \
       --file=/host/$backup/bcl.sql

    # restore application files
    rm -rf var-www/{bcl,downloads}
    cp -a $backup/{bcl,downloads} var-www/

    # restore bcl_dev
    if [[ -f $backup/bcl_dev.sql ]]; then
        ds exec drush @bcl_dev sql-drop --yes
        ds exec drush @bcl_dev sql-query \
           --file=/host/$backup/bcl_dev.sql

        rm -rf var-www/bcl_dev
        cp -a $backup/bcl_dev var-www/
    fi

    # clean up
    rm -rf $backup

    # enable the site
    ds exec drush --yes @local_bcl vset maintenance_mode 0
}

_make_data_restore() {
    # disable the site for maintenance
    ds exec drush --yes @local_bcl vset maintenance_mode 1

    # extract the backup archive
    tar --extract --gunzip --preserve-permissions --file=$file

    # get the name of the backup dir
    local file=$1
    local backup=${file%%.tgz}
    backup=$(basename $backup)

    # restore the data from the backup dir
    ds inject restore.sh $backup
    [[ -f restore.sh ]] && source restore.sh

    # clean up
    rm -rf $backup

    # enable the site
    ds exec drush --yes @local_bcl vset maintenance_mode 0
}
