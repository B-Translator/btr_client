cmd_setup-oauth2-login_help() {
    cat <<_EOF
    setup-oauth2-login @<btr-server>
        Setup the oauth2 login between the client and the btr server.
        The argument '@<btr-server>' is the container of the server.

_EOF
}

cmd_setup-oauth2-login() {
    set -x
    # get the container of the server
    local btr_server=$1
    [[ ${btr_server:0:1} == '@' ]] || fail "Usage:\n$(cmd_setup-oauth2-login_help)"

    # get variables
    local client_url=$(ds exec drush @bcl php-eval 'print $GLOBALS["base_url"]')
    local server_url=$(ds $btr_server exec drush @btr php-eval 'print $GLOBALS["base_url"]')
    local redirect_uri="$client_url/oauth2/authorized"
    local client_key="$CONTAINER"
    local client_secret=$(mcookie)

    # register an oauth2 client on btr_server
    ds $btr_server inject oauth2-client-add.sh @btr $client_key $client_secret $redirect_uri
    # set the variable btr_client of the server
    ds $btr_server exec drush --yes @btr vset btr_client $client_url
    # setup oauth2 login on btr_client
    ds inject set-oauth2-login.sh @bcl $server_url $client_key $client_secret

    # fix cache
    ds exec drush @bcl cc all
    ds $btr_server exec drush @btr cc all
    ds exec chown www-data: -R /var/www/bcl/cache
    ds $btr_server exec chown www-data: -R /var/www/btr/cache

    if [[ -n $DEV ]]; then
        # get variables
        client_url=$(ds exec drush @bcl_dev php-eval 'print $GLOBALS["base_url"]')
        server_url=$(ds $btr_server exec drush @btr_dev php-eval 'print $GLOBALS["base_url"]')
        redirect_uri="$client_url/oauth2/authorized"
        client_key='localclient'
        client_secret=$(mcookie)

        # register an oauth2 client on btr_server
        ds $btr_server inject oauth2-client-add.sh @btr_dev $client_key $client_secret $redirect_uri
        # set the variable btr_client of the server
        ds $btr_server exec drush --yes @btr_dev vset btr_client $client_url
        # setup oauth2 login on btr_client
        ds inject set-oauth2-login.sh @bcl_dev $server_url $client_key $client_secret

        # fix cache
        ds exec drush @bcl_dev cc all
        ds $btr_server exec drush @btr_dev cc all
        ds exec chown www-data: -R /var/www/bcl_dev/cache
        ds $btr_server exec chown www-data: -R /var/www/btr_dev/cache
    fi
}
