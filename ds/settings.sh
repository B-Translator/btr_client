APP=btr_client/ds

### Docker settings.
IMAGE=btr_client
CONTAINER=bcl-example-org
DOMAIN="bcl.example.org"

### Uncomment if this installation is for development.
DEV=true

### Other domains.
[[ -n $DEV ]] && DOMAINS="dev.bcl.example.org tst.bcl.example.org"

### DB settings
DBHOST=mariadb
DBPORT=3306
DBNAME=bcl
DBUSER=bcl
DBPASS=bcl

### Gmail account for notifications. This will be used by ssmtp.
### You need to create an application specific password for your account:
### https://www.lifewire.com/get-a-password-to-access-gmail-by-pop-imap-2-1171882
GMAIL_ADDRESS=bcl.example.org@gmail.com
GMAIL_PASSWD=

### Admin settings.
ADMIN_PASS=123456

### Translation language of B-Translator Client.
### Can be: 'fr', 'de', 'sq' etc. or can be 'all'
TRANSLATION_LNG='all'

### Settings for OAuth2 Login.
OAUTH2_SERVER_URL='https://dev.btranslator.org'
OAUTH2_CLIENT_ID='client1'
OAUTH2_CLIENT_SECRET='0123456789'
