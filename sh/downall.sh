i=1
mkdir -p dl

while read -r line
do
	echo "Downloading $line into dl/$i.txt ..."
    wget "$line" --no-check-certificate -O dl/$i.txt 2>/dev/null
    ((i++))
done

find dl/*.txt -empty -delete

