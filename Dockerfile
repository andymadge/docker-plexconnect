FROM resin/rpi-raspbian:jessie

MAINTAINER Alex Varju

RUN apt-get update \
  && apt-get install -y git python vim \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

COPY start-plexconnect.sh ip-self-external.patch /usr/src/app/

RUN cd /usr/src/app \
  && git clone https://github.com/iBaa/PlexConnect.git \
  && cd PlexConnect \
  && perl -pi -e 's/\r\n/\n/g' *py

# persistent storage for ssl certificates
VOLUME /plexconnect

CMD /usr/src/app/start-plexconnect.sh
