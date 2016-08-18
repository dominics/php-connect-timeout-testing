#!/usr/bin/env php
<?php

if (empty($_SERVER['TEST_HOSTNAME'])) {
    throw new Exception('Test hostname not found');
}

$ch = curl_init(sprintf('http://%s/', $_SERVER['TEST_HOSTNAME']));

curl_setopt($ch, CURLOPT_TIMEOUT_MS, 5000);
curl_setopt($ch, CURLOPT_CONNECTTIMEOUT_MS, 3000);

curl_exec($ch);
curl_close($ch);
