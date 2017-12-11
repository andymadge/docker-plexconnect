#!/bin/bash -e

cd /usr/src/app/PlexConnect

COMMIT_URL=https://github.com/iBaa/PlexConnect/commit/$(git rev-parse HEAD)
echo
echo "PlexConnect build ${COMMIT_URL}"
echo

if [ ! -f /data/trailers.cer ]; then
  echo "Generating SSL certificate"
  openssl req -new -nodes -newkey rsa:2048 \
    -out /data/trailers.pem -keyout /data/trailers.key \
    -x509 -days 7300 -subj "/C=US/CN=trailers.apple.com"
  openssl x509 -in /data/trailers.pem -outform der -out /data/trailers.cer \
    && cat /data/trailers.key >> /data/trailers.pem
fi

if [ ! -f ATVSettings.cfg ]; then
  ln -s /data/ATVSettings.cfg
fi

cp /data/trailers.* assets/certificates/

echo [PlexConnect] > Settings.cfg
env | grep ^PLEXCONNECT_ | sed -E -e 's/^PLEXCONNECT_//' -e 's/(.*)=/\L\1 = /' >> Settings.cfg

echo
echo 'Using Settings.cfg:'
grep . Settings.cfg
echo

touch PlexConnect.log

./PlexConnect.py &
tail -f PlexConnect.log
