#!/bin/sh


editor="kate"
pingprefix="ping -c 4"


#Check base-path param
if [ "$1" = "" ]
then

	echo "Usage: $0 [<base-path>] <host>"
	exit

fi

#Check host param
if [ "$2" = "" ]
then

	path=`pwd`
	host="$1"
	
else

	path="$1"
	host="$2"
	
fi

#Get user consent
clear

echo "Ready to start Netscan."
echo
echo "Host:          $host"
echo "Report Path:   $path"
echo
echo "Hit ENTER to continue or ^C to abort."

read dummy

if [ $? != 0 ]
then 
	exit
fi

#Create and change to path
mkdir -p $path
cd $path
path=`pwd`
path="$path/$host"
mkdir -p $path
cd $path
path=`pwd`


#=== PING ===

echo "Starting Netscan on $host into `pwd` ..."
echo
echo "Starting ping ..."
$pingprefix $host | tee ping.txt


#=== NMAP (SHORT) ===

echo
sudo nmap -p21-25,80,88,110,135-140,143,179,389,443,445,989,990,1433,3306,5900,5985,6200-6210,8080 -Pn $host | tee nmap_short.txt


#=== NMAP (UDP) ===

echo
sudo nmap -p53,67-69,123,161,162 -sU -T4 -Pn $host | tee nmap_udp.txt


#=== NAMP (LONG) ===

echo
sudo nmap -T4 -A -sS -p- -Pn $host | tee nmap_long.txt


#=== GREP OPEN PORTS ===

grep -E "^[0-9]+\/(udp|tcp)" nmap_long.txt | cut -d ' ' -f 1 | cut -d '/' -f 1 > open_ports.txt


#=== SCAN FOR VULNERABILITIES ===

echo
nmap $host -p `paste -sd ',' open_ports.txt` -Pn --script vuln | tee nmap_vuln.txt


#=== DIG ===

echo
echo "Starting dig ..."
dig @$host $host ANY | tee dig.txt


#=== GENERATE TL;DR ===

echo
echo "Generating TL;DR ..."

grep -h "open" nmap_long.txt nmap_udp.txt > tldr.txt
grep -v "failed: connection refused" dig.txt >> tldr.txt

echo
echo "Generating report ..."


#=== GENERATE REPORT ===

echo "================   BEGIN OF NETWORKING REPORT FOR {$host}   ================" > netscan_report.txt

echo >> netscan_report.txt
echo "--- TL;DR --------------------------------------------------" >> netscan_report.txt
cat tldr.txt >> netscan_report.txt
echo "------------------------------------------------------------" >> netscan_report.txt

echo >> netscan_report.txt
echo "--- ping ---------------------------------------------------" >> netscan_report.txt
cat ping.txt >> netscan_report.txt
echo "------------------------------------------------------------" >> netscan_report.txt


#=== DIG ===

echo >> netscan_report.txt
echo "--- dig ----------------------------------------------------" >> netscan_report.txt
cat dig.txt >> netscan_report.txt
echo "------------------------------------------------------------" >> netscan_report.txt


#=== NMAP (SHORT) ===

echo >> netscan_report.txt
echo "--- nmap (short) -------------------------------------------" >> netscan_report.txt
cat nmap_short.txt >> netscan_report.txt
echo "------------------------------------------------------------" >> netscan_report.txt


#=== NMAP (UDP) ===

echo >> netscan_report.txt
echo "--- nmap (UDP) -------------------------------------------" >> netscan_report.txt
cat nmap_udp.txt >> netscan_report.txt
echo "------------------------------------------------------------" >> netscan_report.txt


#=== NAMP (LONG) ===

echo >> netscan_report.txt
echo "--- nmap (long) --------------------------------------------" >> netscan_report.txt
cat nmap_long.txt >> netscan_report.txt
echo "------------------------------------------------------------" >> netscan_report.txt


#=== NAMP (VULN) ===

echo >> netscan_report.txt
echo "--- nmap (vuln) --------------------------------------------" >> netscan_report.txt
cat nmap_vuln.txt >> netscan_report.txt
echo "------------------------------------------------------------" >> netscan_report.txt


#=== FINISH REPORT ===

echo >> netscan_report.txt
echo "================   END OF NETWORKING REPORT FOR {$host}   ================" >> netscan_report.txt
echo
echo "Scan finished."

$editor netscan_report.txt 2>/dev/null &



echo >> netscan_report.txt
echo "================   END OF NETWORKING REPORT FOR {$host}   ================" >> netscan_report.txt
echo
echo "Scan finished."

$editor netscan_report.txt 2>/dev/null &

