#!/bin/bash -x

source /host/settings.sh

### settings for the database and the drupal site
site_name="B-Translator"
site_mail="$GMAIL_ADDRESS"
account_name=admin
account_pass="$ADMIN_PASS"
account_mail="$GMAIL_ADDRESS"

### start site installation
sed -e '/memory_limit/ c memory_limit = -1' -i /etc/php/7.1/cli/php.ini
cd $DRUPAL_DIR
drush site-install --verbose --yes btr_client \
      --db-url="mysql://$DBUSER:$DBPASS@$DBHOST:$DBPORT/$DBNAME" \
      --site-name="$site_name" --site-mail="$site_mail" \
      --account-name="$account_name" --account-pass="$account_pass" --account-mail="$account_mail"

### install additional features
drush="drush --root=$DRUPAL_DIR --yes"

### install btrProject and btrVocabulary
$drush pm-enable btrProject
$drush pm-enable btrVocabulary

### install additional features
$drush pm-enable bcl_btrClient
$drush features-revert bcl_btrClient

$drush pm-enable bcl_misc
$drush features-revert bcl_misc

$drush pm-enable bcl_layout
$drush features-revert bcl_layout

$drush pm-enable bootstrap
$drush pm-enable btr_client

$drush pm-enable bcl_content

$drush pm-enable bcl_permissions
$drush features-revert bcl_permissions

#$drush pm-enable bcl_captcha
#$drush features-revert bcl_captcha

#$drush pm-enable bcl_discus
#$drush features-revert bcl_discus
#$drush pm-enable bcl_invite
#$drush pm-enable bcl_simplenews
#$drush pm-enable bcl_mass_contact
#$drush pm-enable bcl_googleanalytics
#$drush pm-enable bcl_drupalchat

### update to the latest version of core and modules
#$drush pm-refresh
#$drush pm-update

### set drupal variable btrClient_translation_lng
$drush --exact vset btrClient_translation_lng $TRANSLATION_LNG

### add $TRANSLATION_LNG as a drupal language
drush dl drush_language
if [[ "$TRANSLATION_LNG" != 'all' ]]; then
    $drush language-add $TRANSLATION_LNG
fi
