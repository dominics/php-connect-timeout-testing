FROM phusion/baseimage:0.9.17

CMD ["/sbin/my_init"]

RUN apt-get update && apt-get install -y \
  socat
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 53

RUN mkdir /etc/service/socat
ADD socat.sh /etc/service/socat/run
