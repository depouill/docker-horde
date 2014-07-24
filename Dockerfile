FROM phusion/baseimage:latest

MAINTAINER Martijn van Maurik <docker@vmaurik.nl>

ENV HOME /root

RUN apt-get update
RUN apt-get install -y apache2 php-pear php-horde php-horde-imp php-horde-groupware

EXPOSE 80

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN mv /etc/horde /etc/.horde
ADD horde-init.sh /etc/my_init.d/horde-init.sh
RUN chmod +x /etc/my_init.d/horde-init.sh

RUN mkdir -p /etc/service/apache2
ADD run /etc/service/apache2/run
RUN chmod +x /etc/service/apache2/run
RUN a2dissite 000-default && a2disconf php-horde

ADD horde.conf /etc/apache2/sites-available/horde.conf
RUN a2ensite horde

VOLUME /etc/horde

CMD ["/sbin/my_init"]
