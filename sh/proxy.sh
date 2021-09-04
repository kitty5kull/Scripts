#!/bin/bash

if [ "$#" -le 2 ]; then
        echo "Usage: $0 [-l] <local listener port> <remote host> <remote port>"
        echo "  -l:     Listens in on all communication."
        exit
fi

LISTEN=false

while getopts "l" opt; do
    case $opt in
    l) LISTEN=true ;; # Handle -l
    esac
done

TMP=`mktemp -d`
BACK=$TMP/pipe.back
SENT=$TMP/pipe.sent
RCVD=$TMP/pipe.rcvd

trap 'rm -rf "$TMP"' EXIT
mkfifo -m 0600 "$BACK" "$SENT" "$RCVD"


if $LISTEN; then
	echo "Connecting to $3 $4 ..."
	sed 's/^/ => /' <"$SENT" &
	sed 's/^/<=  /' <"$RCVD" &
	nc -lvnp $2 <"$BACK" | tee "$SENT" | nc $3 $4 | tee "$RCVD" >"$BACK"
else
	echo "Connecting to $2 $3 ..."
	nc -lvnp $1 < "$BACK" | nc $2 $3 > "$BACK"
fi


