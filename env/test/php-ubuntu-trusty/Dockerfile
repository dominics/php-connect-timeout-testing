FROM phusion/baseimage:0.9.17

CMD ["/sbin/my_init"]

RUN apt-get update && apt-get install -y \
  php5-cli \
  php5-curl
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY tests /usr/src/tests
