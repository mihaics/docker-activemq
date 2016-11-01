# Use phusion/baseimage as base image. To make your builds reproducible, make
# sure you lock down to a specific version, not to `latest`!
# See https://github.com/phusion/baseimage-docker/blob/master/Changelog.md for
# a list of version numbers.
FROM phusion/baseimage:0.9.19
MAINTAINER "Mihai Csaky" <mihai.csaky@sysop-consulting.ro>

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

ENV DEBIAN_FRONTEND="noninteractive"

RUN rm -f /etc/service/sshd/down
RUN /etc/my_init.d/00_regen_ssh_host_keys.sh
ADD authorized_keys /tmp/authorized_keys
RUN cat /tmp/authorized_keys > /root/.ssh/authorized_keys && rm -f /tmp/authorized_keys
RUN apt-get update && apt-get upgrade -y

RUN apt install -y activemq

VOLUME /etc/activemq

EXPOSE 8161
EXPOSE 61616
EXPOSE 5672
EXPOSE 61613
EXPOSE 1883
EXPOSE 61614

#RUN mkdir /etc/service/activemq/
#ADD activemq.sh /etc/service/activemq/run
# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
