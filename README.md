
# B-Translator Client

Drupal installation profile for B-Translator Client.

The codename *B-Translator* can be decoded like *Bee Translator*,
since it aims at collecting very small translation contributions from
a wide crowd of people and to dilute them into something useful.

It can also be decoded like *Be Translator*, as an invitation to
anybody to give his small contribution for translating programs or
making their translations better.

For more detailed information see: http://info.btranslator.org


## Installation

  - First install Docker:
    https://docs.docker.com/engine/installation/linux/docker-ce/ubuntu/#install-using-the-repository

  - Then install `ds`,`wsproxy` and `mariadb`:
     + https://github.com/docker-scripts/ds#installation
     + https://github.com/docker-scripts/wsproxy#installation
     + https://github.com/docker-scripts/mariadb#installation


  - Get the code from GitHub:
    ```
    git clone https://github.com/B-Translator/btr_client /opt/docker-scripts/btr_client
    ```

  - Create a directory for the container: `ds init btr_client/ds @bcl.example.org`

  - Fix the settings:
    ```
    cd /var/ds/bcl.example.org/
    vim settings.sh
    ```

  - Build image, create the container and configure it: `ds make`


## Access the website

  - Tell `wsproxy` to manage the domain of this container: `ds wsproxy add`

  - Tell `wsproxy` to get a free letsencrypt.org SSL certificate for this domain:
    ```
    ds wsproxy ssl-cert --test
    ds wsproxy ssl-cert
    ```

  - If installation is not on a public server, add to `/etc/hosts` the
    line `127.0.0.1 bcl.example.org` and then try in browser:
    https://bcl.example.org


## Other commands

    ds help

    ds shell
    ds stop
    ds start
    ds snapshot

    ds setup-oauth2-login @<btr-server>

    ds inject set-oauth2-login.sh [<@alias> <server-url> <client-key> <client-secret>]
    ds inject set-emailsmtp.sh 'smtp_server' <smtp-server> <smtp-domain>
    ds inject set-emailsmtp.sh 'gmail_account' <gmail-user> <gmail-passwd>
    ds inject set-adminpass.sh <new-drupal-admin-passwd>
    ds inject set-domain.sh <new.domain>
    ds inject set-translation-lng.sh

    ds inject dev/clone.sh test
    ds inject dev/clone-del.sh test
    ds inject dev/clone.sh 01

    ds backup [proj1]
    ds restore <backup-file.tgz> [proj1]
