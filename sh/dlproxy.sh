#!/bin/bash

if [ "$#" -le 1 ]; then
        echo "Usage: $0 [-l] <local listener port 1> <local listener port 2>"
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

if $LISTEN; then
	sed 's/^/ => /' <"$SENT" &
	sed 's/^/<=  /' <"$RCVD" &
	nc -lvnp $2 <"$BACK" | tee "$SENT" | nc -lvnp $3 | tee "$RCVD" >"$BACK"
else
	nc -lvnp $1 < "$BACK" | nc -lvnp $2 > "$BACK"
fi


