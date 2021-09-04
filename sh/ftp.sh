#!/bin/sh
ftp -n "$1" << EOF
quote USER "$2"
quote PASS "$3"
EOF
