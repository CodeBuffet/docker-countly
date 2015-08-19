FROM ubuntu:latest
MAINTAINER peter@codebuffet.co

EXPOSE 3001 6001

RUN apt-get update
RUN apt-get install -y python-software-properties software-properties-common
RUN apt-add-repository -y ppa:chris-lea/node.js
RUN apt-get update
RUN apt-get -y install nodejs supervisor imagemagick sendmail build-essential unzip wget
RUN cd /opt \
    && wget https://github.com/Countly/countly-server/archive/15.06.zip \
    && unzip 15.06.zip \
    && mv countly-server-15.06 countly \
    && rm 15.06.zip

RUN cd /opt/countly/api \
    && sudo npm install time

#install grunt & npm modules
RUN cd /opt/countly \
    && npm install -g grunt-cli --unsafe-perm; npm install

COPY config/api.js /opt/countly/api/config.js
COPY config/frontend.js /opt/countly/frontend/express/config.js
COPY config/javascripts.js /opt/countly/frontend/express/public/javascripts/countly/countly.config.js

ADD /opt/countly/bin/commands/docker/countly-api.sh /etc/service/countly-api/run
ADD /opt/countly/bin/commands/docker/countly-dashboard.sh /etc/service/countly-dashboard/run

bash $DIR/scripts/countly.install.plugins.sh

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
