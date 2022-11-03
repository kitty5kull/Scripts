if [ $# -lt 1 ]
then
	echo "Scans the given URL with a list of predefined tools."
	echo "Usage: $0 <URL>"
	exit
fi

mkdir webscan
cd webscan

wget $1/robots.txt
wget $1/security.txt
wget $1/sitemap.xml

mousepad robots.txt security.txt sitemap.xml &

/opt/gobuster/gobuster dir -u $1 -k -w ~/wordlists/dirb/big.txt | tee gobuster_dir_big.txt
/opt/gobuster/gobuster vhost -u $1 -k -w ~/wordlists/Discovery/DNS/subdomains-top1million-20000.txt | tee gobuster_vhost_20k.txt
dirsearch.sh $1 dirsearch.txt

cewl --with-numbers -w cewl.txt $1
grep -v "\/$" dirsearch.txt | downall.sh
grep -Eroh "[0-9a-zA-Z]*" cewl.txt dl/*.txt | sort | uniq > ../wordlist.txt
dirsearch -u "$1" -o dirsearch_cewl.txt --format=plain --wordlist=../wordlist.txt -e html,htm,php,asp,aspx,js,txt,old,bak,cfg,conf,jsp,do,action,zip,tar,gz -f -r -R 3

cat dir*.txt | grep "^200" | cut -b 14- > direarch_clean.txt

/opt/nikto/program/nikto.pl --url=$1 | tee nikto.txt

cat gobuster_dir_big.txt nikto.txt dirsearch.txt dirsearch_cewl.txt > webscan.txt
mousepad webscan.txt &

cd ..
