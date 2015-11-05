# DNS Connect Timeout Testing

`connect.php` uses curl to make a connection to example.com. To test the handling of connection timeouts caused by DNS timing out, you can:

* Disable any DNS servers running on your test machine
* Set 127.0.0.1 as the resolver (`echo "nameserver 127.0.0.1" | sudo tee /etc/resolv.conf`)
* Run a listener on UDP port 53
  * Don't use `nc`/netcat for this, because of http://stackoverflow.com/questions/7696862/strange-behavoiur-of-netcat-with-udp#answer-7696956
  * Socat works: `sudo socat UDP-RECV:53 STDOUT`
* Execute the php: `time php connect.php`

## Criteria

A *pass* is when the `time` command shows the wallclock time as around 3 seconds. (Hint: it often doesn't.)

## Example

```
$ lsb_release -dcr
Description:	Ubuntu 14.04.3 LTS
Release:	14.04
Codename:	trusty

$ dpkg -l | grep php5-curl
ii  php5-curl                            5.5.30+dfsg-1+deb.sury.org~trusty+1              amd64        CURL module for php5

$ time php connect.php

Fatal error: Uncaught exception 'GuzzleHttp\Exception\ConnectException' with message 'cURL error 28: Resolving timed out after 3000 milliseconds (see http://curl.haxx.se/libcurl/c/libcurl-errors.html)' in .../vendor/guzzlehttp/guzzle/src/Handler/CurlFactory.php on line 186

GuzzleHttp\Exception\ConnectException: cURL error 28: Resolving timed out after 3000 milliseconds (see http://curl.haxx.se/libcurl/c/libcurl-errors.html) in .../vendor/guzzlehttp/guzzle/src/Handler/CurlFactory.php on line 186

Call Stack:
    0.0002     224232   1. {main}() .../connect.php:0
    0.0169    1114736   2. GuzzleHttp\Client->get() .../connect.php:12
    0.0170    1115256   3. GuzzleHttp\Client->__call() .../connect.php:12
    0.0170    1115328   4. GuzzleHttp\Client->request() .../vendor/guzzlehttp/guzzle/src/Client.php:87
    0.0265    1553760   5. GuzzleHttp\Promise\Promise->wait() .../vendor/guzzlehttp/guzzle/src/Client.php:129


real	0m20.122s [!!!!!!!!!!!!]
user	0m0.836s
sys	0m0.065s
```

## Docker

The setup uses docker-compose and requires 1.5.0 or higher.
