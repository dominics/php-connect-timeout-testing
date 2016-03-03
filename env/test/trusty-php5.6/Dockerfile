FROM phusion/baseimage:0.9.17

CMD ["/sbin/my_init"]

RUN \
apt-get install -y language-pack-en-base && \
LC_ALL=en_US.UTF-8 apt-add-repository ppa:ondrej/php && \
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E5267A6C && \
apt-get update && \
DEBIAN_FRONTEND=noninteractive apt-get install -y php5.6 php5.6-curl

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY tests /usr/src/tests
