FROM ubuntu:latest
MAINTAINER peter@codebuffet.co

EXPOSE 3001 6001

RUN apt-get update
RUN apt-get install -y python-software-properties software-properties-common
RUN apt-add-repository -y ppa:chris-lea/node.js
RUN apt-get update
RUN apt-get -y install nodejs supervisor imagemagick sendmail build-essential unzip wget
RUN cd /var \
    && wget https://github.com/Countly/countly-server/archive/15.03.zip \
    && unzip 15.03.zip \
    && mv countly-server-15.03 countly \
    && rm 15.03.zip

RUN cd /var/countly/api \
    && sudo npm install time

COPY config/api.js /var/countly/api/config.js
COPY config/frontend.js /var/countly/frontend/express/config.js
COPY config/javascripts.js /var/countly/frontend/express/public/javascripts/countly/countly.config.js

ENTRYPOINT exec /usr/bin/supervisord --nodaemon --configuration /var/countly/bin/config/supervisord.conf
