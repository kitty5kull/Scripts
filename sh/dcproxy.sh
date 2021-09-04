#!/bin/bash

if [ "$#" -le 3 ]; then
        echo "Usage: $0 [-l] <host 1> <port 1> <host 2> <port 2>"
        echo "   Creates a double-listener proxy on the given ports."
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

while :
do
	if $LISTEN; then
		sed 's/^/ => /' <"$SENT" &
		sed 's/^/<=  /' <"$RCVD" &
		nc $2 $3 <"$BACK" | tee "$SENT" | nc $4 $5 | tee "$RCVD" >"$BACK"
	else
		nc $1 $2 < "$BACK" | nc $3 $4 > "$BACK"
	fi

        if [ $? -ne 0 ]; then
            exit
        fi

done


