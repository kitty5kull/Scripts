if [ $# -lt 1 ]
then
	echo "Scans the given URL with a list of predefined tools."
	echo "Usage: $0 <URL>"
	exit
fi

mkdir webscan
cd webscan

mkdir -p dl
curl -k $1 > dl/_main.html
curl -k $1/robots.txt > robots.txt
curl -k $1/security.txt > security.txt
curl -k $1/sitemap.xml > sitemap.xml
curl -I $1 > headers.txt

kate robots.txt security.txt sitemap.xml headers.txt dl/_main.html 2>/dev/null &

host=`echo "$1" | cut -d '/' -f 3`
python /opt/wfuzz/src/wfuzz-cli.py -c -w ~/wordlists/Discovery/DNS/subdomains-top1million-20000.txt -u $1 -H "Host: FUZZ.$host" |tee subfuzz_20k_raw.txt

echo "wfuzz VHOST results for ~/wordlists/Discovery/DNS/subdomains-top1million-20000.txt" > subfuzz_20k.txt
echo "**********************************************************************************" >> subfuzz_20k.txt
parse_subfuzz.py < subfuzz_20k_raw.txt | tee -a subfuzz_20k.txt
echo "**********************************************************************************" >> subfuzz_20k.txt

/opt/feroxbuster/feroxbuster -k -t 50 -L 2 --thorough -u $1 -w ~/wordlists/Discovery/Web-Content/raft-medium-directories-lowercase.txt -o feroxbuster.txt
cat feroxbuster.txt | cut -b 44- | cut -d ' ' -f 1 | downall.sh | tee downall.log

grep -rPzo '<!--([\s\S]*?)-->' dl/ | sed 's/\x0//g' | sed 's/-->/-->\n/g' | uniq | tee comments.txt

gobuster dir -e -u $1 -k -w ~/wordlists/dirb/big.txt | tee gobuster_dir_big.txt
gobuster vhost -u $1 -k -w ~/wordlists/Discovery/DNS/subdomains-top1million-20000.txt | tee gobuster_vhost_20k.txt

dirsearch.sh $1 `pwd`/dirsearch.txt

cewl --with-numbers -w `pwd`/cewl.txt $1

# grep -v "\/$" dirsearch.txt | cut -b 14- | downall.sh

grep -Eroh "[0-9a-zA-Z]*" cewl.txt dl/*.txt | sort | uniq > ../wordlist.txt
sudo dirsearch -u "$1" -o `pwd`/dirsearch_cewl.txt --format=plain --wordlist=`pwd`/../wordlist.txt -e html,htm,php,asp,aspx,js,txt,old,bak,cfg,conf,jsp,do,action,zip,tar,gz -f -r -R 3

cat dir*.txt | grep "^200" | cut -b 14- | sort | uniq > dirsearch_clean.txt 


/opt/nikto/program/nikto.pl -h $1 | tee nikto.txt

cat feroxbuster.txt subfuzz_20k.txt gobuster_dir_big.txt gobuster_vhost_20k.txt subfuzz_20k.txt dirsearch.txt dirsearch_cewl.txt nikto.txt comments.txt > webscan.txt
kate webscan.txt 2>/dev/null &

cd ..
