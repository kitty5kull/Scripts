i=1
mkdir dl

while read -r line
do
    wget "$line" -O dl/$i.txt 2>/dev/null
    ((i++))
done

find dl/*.txt -empty -delete

