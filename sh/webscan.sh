/opt/gobuster/gobuster dir -u $1 -k -w ~/wordlists/dirb/big.txt | tee gobuster_dir_big.txt
/opt/gobuster/gobuster vhost -u $1 -k -w ~/wordlists/Discovery/DNS/subdomains-top1million-20000.txt | tee gobuster_vhost_20k.txt
/opt/nikto/program/nikto.pl --url=$1 | tee nikto.txt
dirsearch.sh $1 dirsearch.txt

