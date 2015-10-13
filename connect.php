<?php

require 'vendor/autoload.php';

use GuzzleHttp\Client;

$client = new Client();

$request = $client->get('http://example.com/', [
    'timeout' => 5,
    'connect_timeout' => 3,
]);
