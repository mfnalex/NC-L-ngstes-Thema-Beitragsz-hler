#!/bin/bash

# Benutzung: ./laengstesthema.sh <username>

set -e

USER=$1
if [[ "$1" == "" ]]; then
  read -p "Username: " USER
fi


mkdir -p /tmp/laengstesthema
cd /tmp/laengstesthema


PATTERN="<span itemprop=\"name\">$USER</span>"
URL="https://forum.netcup.de/sonstiges/smalltalk/1051-das-längste-thema/?pageNo="

wget -q -O - "${URL}"999999999 > lastpage
LASTPAGE=$(grep "<title>Das längste Thema - Seite" lastpage)
LASTPAGE=$(echo "$LASTPAGE" | awk '{print $6}')

{
for PAGE in $(seq 1 "$LASTPAGE"); do
        if [ ! -f "$PAGE" ] || [ "$PAGE" -eq "$LASTPAGE" ]; then
                echo Lade Seite "$PAGE"... >&2
                wget -q -O - "${URL}${PAGE}" > "$PAGE"
        fi

        grep "$PATTERN" "$PAGE" || true
done
} | wc -l > count

COUNT=$(cat count)
rm -f count

echo "Posts von $USER: $COUNT"
