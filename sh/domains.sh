if [ $# -lt 1 ]
then
        echo "Searches the current directory including all subdirectory for domain names."
        echo "Usage: $0 <top-level-domain>"
        echo "Example: $0 thm"
        exit
fi

grep -ariohE "([a-z0-9\-\_]+\.)+$1" . | sort | uniq

