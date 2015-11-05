FROM phusion/baseimage:0.9.17

CMD ["/sbin/my_init"]

RUN apt-get update && apt-get install -y \
  dnsmasq
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 53

RUN mkdir /etc/service/dnsmasq
ADD dnsmasq.sh /etc/service/dnsmasq/run
