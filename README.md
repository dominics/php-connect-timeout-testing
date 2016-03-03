# DNS Connect Timeout Testing

Some PHP HTTP clients show some weird definitions of a 'connect timeout'.
This repository contains a bunch of test cases and docker containers.

They're all wired up to the bash script `./test`. You run it, and
the results appear in `build/out`.

## Test process

### Dependencies

You'll need:

* Docker
* Docker compose
* Composer (we do the initial install of things like Guzzle outside of any container)

### Overview

The first thing the test script does is build a bunch of testing environments
in `build/env`. These are added to `docker-compose.override.yml`. Next, a few 
common services are started up: a good DNS server, and a bad one that times out. 
Finally, each test in the `tests` directory is run against each test environment.

The environments tested are combinations of:

* `good-dns` or `bad-dns`, where a bad environment is configured with a DNS
    server that never responds.
* `good-hostname` or `bad-hostname`, where a bad environment is configured with
    a name that doesn't resolve.
* `trusty-php5.5`, `trusty-php5.6`, `trusty-php7.0`, Ubuntu distro and PHP version.
    
So, that's 2 x 2 x 3 = 12 environments for each test. So far... :)

### Included Tests

* `curl-sh` is a test using the command line cURL distributed with Ubuntu Trusty
* `curl-php` is a test using PHP's cURL extension (in simple `curl_exec` mode)
* `guzzle` is a test using Guzzle 6 with its default (multi-cURL) handler

### Criteria

A *pass* is simply when the `time` command shows the wallclock time as 3 seconds or less (it often doesn't.)
Even though we always specify a connect timeout of 3 seconds, we observe run times
of 20 seconds or more!

### Summarizing 

The `./summarize` script will summarize various `.out` files in the `build/out`
directory. Run it after running `./test` to get the output in a format for convenient
further analysis.

## Notes

To test the handling of connection timeouts caused by DNS timing out yourself, you can:

* Disable any DNS servers running on your test machine
* Set 127.0.0.1 as the resolver (`echo "nameserver 127.0.0.1" | sudo tee /etc/resolv.conf`)
* Run a listener on UDP port 53
    * Don't use `nc`/netcat for this, because of http://stackoverflow.com/questions/7696862/strange-behavoiur-of-netcat-with-udp#answer-7696956
    * Socat works, and is what we use in the docker environments for this repo: `sudo socat UDP-RECV:53 STDOUT`
