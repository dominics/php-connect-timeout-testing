#!/bin/bash

/usr/bin/env php -v
php -i | grep -A 25 ^curl

time /usr/bin/env php -d error_reporting=-1 run.php
