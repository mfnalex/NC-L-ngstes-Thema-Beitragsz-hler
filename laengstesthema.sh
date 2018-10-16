#!/bin/bash

# Benutzung: ./laengstesthema.sh <username>

set -e
mkdir -p /tmp/laengstesthema
cd /tmp/laengstesthema

USER=$1
if [[ "$1" == "" ]]; then
  read -p "Username: " USER
fi

PATTERN="<span itemprop=\"name\">$USER</span>"
URL="https://forum.netcup.de/sonstiges/smalltalk/1051-das-längste-thema/?pageNo="
wget -q -O - "${URL}"999999999 > lastpage
LASTPAGE=$(grep "<title>" lastpage | awk '{print $6}')

if [ ! -f 1 ]; then
  echo
  echo "Achtung: Das Script muss einmalig alle Seiten des Themas herunterladen. Dies erfordert $LASTPAGE HTTPS-Requests. Jeder Request erfolgt 0,2 Sekunden nachdem der letzte abgeschlossen ist. Fortfahren auf eigene Gefahr. Nach dem ersten Durchgang werden nur noch geänderte / neue Seiten heruntergeladen."
  read -n 1 -s -r -p "Beliebige Taste drücken zum Fortfahren..."
  echo
fi

{
for PAGE in $(seq 1 "$LASTPAGE"); do
        if [ ! -f "$PAGE" ] || [ "$PAGE" -eq "$LASTPAGE" ]; then
                echo Lade Seite "$PAGE"... >&2
                wget -q -O - "${URL}${PAGE}" > "$PAGE"
                sleep 0.2
        fi

        grep "$PATTERN" "$PAGE" || true
done
} | wc -l > count

COUNT=$(cat count)
rm -f count

echo "Posts von $USER: $COUNT"
