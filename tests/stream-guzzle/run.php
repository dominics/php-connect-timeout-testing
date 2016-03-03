#!/usr/bin/env php
<?php

require 'vendor/autoload.php';

use GuzzleHttp\Client;
use GuzzleHttp\Handler\StreamHandler;

if (empty($_SERVER['TEST_HOSTNAME'])) {
    throw new Exception('Test hostname not found');
}

$client = new Client();

$request = $client->get(sprintf('http://%s/', $_SERVER['TEST_HOSTNAME']), [
    'timeout'         => 5,
    'connect_timeout' => 3,
    'handler'         => new StreamHandler(),
]);
