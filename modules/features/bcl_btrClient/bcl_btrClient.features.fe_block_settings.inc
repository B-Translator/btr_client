<?php
/**
 * @file
 * bcl_btrClient.features.fe_block_settings.inc
 */

/**
 * Implements hook_default_fe_block_settings().
 */
function bcl_btrClient_default_fe_block_settings() {
  $export = array();

  $export['version'] = '2.0';

  $export['btrTranslations-latest'] = array(
    'cache' => -2,
    'custom' => 0,
    'delta' => 'latest',
    'module' => 'btrTranslations',
    'node_types' => array(),
    'pages' => '',
    'roles' => array(),
    'themes' => array(
      'bartik' => array(
        'region' => '',
        'status' => 0,
        'theme' => 'bartik',
        'weight' => 0,
      ),
      'bootstrap' => array(
        'region' => '',
        'status' => 0,
        'theme' => 'bootstrap',
        'weight' => 0,
      ),
      'btr_client' => array(
        'region' => '',
        'status' => 0,
        'theme' => 'btr_client',
        'weight' => 0,
      ),
      'seven' => array(
        'region' => '',
        'status' => 0,
        'theme' => 'seven',
        'weight' => 0,
      ),
    ),
    'title' => '',
    'visibility' => 0,
  );

  $export['btrTranslations-statistics'] = array(
    'cache' => -2,
    'custom' => 0,
    'delta' => 'statistics',
    'module' => 'btrTranslations',
    'node_types' => array(),
    'pages' => '',
    'roles' => array(),
    'themes' => array(
      'bartik' => array(
        'region' => '',
        'status' => 0,
        'theme' => 'bartik',
        'weight' => 0,
      ),
      'bootstrap' => array(
        'region' => '',
        'status' => 0,
        'theme' => 'bootstrap',
        'weight' => 0,
      ),
      'btr_client' => array(
        'region' => '',
        'status' => 0,
        'theme' => 'btr_client',
        'weight' => 0,
      ),
      'seven' => array(
        'region' => '',
        'status' => 0,
        'theme' => 'seven',
        'weight' => 0,
      ),
    ),
    'title' => '',
    'visibility' => 0,
  );

  $export['btrTranslations-topcontrib'] = array(
    'cache' => -2,
    'custom' => 0,
    'delta' => 'topcontrib',
    'module' => 'btrTranslations',
    'node_types' => array(),
    'pages' => '',
    'roles' => array(),
    'themes' => array(
      'bartik' => array(
        'region' => '',
        'status' => 0,
        'theme' => 'bartik',
        'weight' => 0,
      ),
      'bootstrap' => array(
        'region' => '',
        'status' => 0,
        'theme' => 'bootstrap',
        'weight' => 0,
      ),
      'btr_client' => array(
        'region' => '',
        'status' => 0,
        'theme' => 'btr_client',
        'weight' => 0,
      ),
      'seven' => array(
        'region' => '',
        'status' => 0,
        'theme' => 'seven',
        'weight' => 0,
      ),
    ),
    'title' => '',
    'visibility' => 0,
  );

  return $export;
}
