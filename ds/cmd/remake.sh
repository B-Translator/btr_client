cmd_remake_help() {
    cat <<_EOF
    remake [full | data]
        Reconstruct again the container, preserving the existing data.
        By default it will make a full backup of the database and application
        files, but with option 'data' only a partial backup of the application
        and database will be saved and restored.

_EOF
}

cmd_remake() {
    local full='full'
    [[ $1 == 'data' ]] && full='data'

    # backup
    ds backup $full

    # reinstall
    ds remove
    ds make
    ds restart
    ds wsproxy ssl-cert

    # restore
    local backup_file="backup-$full-$(date +%Y%m%d).tgz"
    ds restore $backup_file
}
