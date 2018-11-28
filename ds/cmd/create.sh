cmd_create_help() {
    cat <<_EOF
    create
        Create the container '$CONTAINER'.

_EOF
}

rename_function cmd_create orig_cmd_create
cmd_create() {
    local code_dir=$(dirname $(realpath $APP_DIR))
    mkdir -p var-www drush-cache
    orig_cmd_create \
        --mount type=bind,src=$code_dir,dst=/usr/local/src/btr_client \
        --mount type=bind,src=$(pwd)/var-www,dst=/var/www \
        --mount type=bind,src=$(pwd)/drush-cache,dst=/root/.drush/cache \
        --workdir /var/www \
        --env CODE_DIR=/usr/local/src/btr_client \
        --env DRUPAL_DIR=/var/www/bcl \
        "$@"    # accept additional options, e.g.: -p 2201:22

    rm -f btr_client
    ln -s var-www/bcl/profiles/btr_client .

    # create the database
    ds mariadb create

    # copy local commands
    mkdir -p cmd/
    [[ -f cmd/remake.sh ]] || cp $APP_DIR/misc/remake.sh cmd/
}
