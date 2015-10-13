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
