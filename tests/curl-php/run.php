#!/usr/bin/env php
<?php

$ch = curl_init('http://www.example.com/');

curl_setopt($ch, CURLOPT_TIMEOUT, 5000);
curl_setopt($ch, CURLOPT_CONNECTTIMEOUT, 3000);

curl_exec($ch);
curl_close($ch);
