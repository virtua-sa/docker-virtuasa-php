<?php
/**
 * Default configuration for XHGUI
 */
return array(
  'debug' => false,
  'mode' => 'development',

  'save.handler' => 'mongodb',
  'db.host' => '${XHGUI_DB_HOST}',
  'db.db' => '${XHGUI_DB_NAME}',
  'db.options' => array(),

  'templates.path' => dirname(__DIR__) . '/src/templates',
  'date.format' => 'd.m.Y H:i:s',
  'detail.count' => 6,
  'page.limit' => 25,

  'profiler.options' => array(
    'ignored_functions' => array(
      'call_user_func',
      'call_user_func_array',
    ),
  ),

  'profiler.enable' => function() {
    return (bool) ${XHGUI_ACTIVE};
  },
  'profiler.simple_url' => function(${DOLLAR}url) {
    return preg_replace('/\=\d+/', '', ${DOLLAR}url);
  },
);
