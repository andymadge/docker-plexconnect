FROM resin/rpi-raspbian:jessie

WORKDIR /usr/src/app

RUN apt-get update \
  && apt-get install -y git python vim \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

COPY start-plexconnect.sh /usr/src/app/

RUN git clone https://github.com/iBaa/PlexConnect.git \
  && cd PlexConnect \
  && perl -pi -e 's/\r\n/\n/g' *py

CMD /usr/src/app/start-plexconnect.sh
