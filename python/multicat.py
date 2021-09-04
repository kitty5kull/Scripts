#!/bin/python3

#import pwn

import socket
import threading
import time


def bind_server(server_address):
	# Create listener
	sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
	sock.bind(server_address)
	sock.listen(1)
	print("[*] Listening on %s:%d (%s)" % (server_address[0], server_address[1], "TCP"))
	return sock

#returns len of read data or -1 if EOF
def copy_data(direction, source_socket, dest_socket, intercept_handler):
	try:
		inp = source_socket.recv(128)
		if len(inp) <= 0:
			return -1
	except BlockingIOError:
		inp = ""

	if len(inp):
		if intercept_handler(direction, source_socket, dest_socket, inp):
			dest_socket.sendall(inp)

	return len(inp)

def spawn_client(connection, client_address, remote_address, intercept_handler):

	print('[+] %s:%d: Connection established' % (client_address[0], client_address[1]))
	remote = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
	remote.connect(remote_address)
	connection.setblocking(0)
	remote.setblocking(0)

	sent =0
	recd=0

	while sent>-1 and recd>-1:
		sent = copy_data("OUT", connection, remote, intercept_handler)
		recd = copy_data("INC", remote, connection, intercept_handler)

	if sent == 0 and recd == 0:
			time.sleep(0.01)

	connection.close()
	remote.close()
	print('[-] %s:%d: Connection closed' % (client_address[0], client_address[1]))


def setup_proxy(local_address, remote_address, intercept_handler):
	sock = bind_server(local_address)

	try:
		while True:
			connection, client_address = sock.accept()
			thread = threading.Thread(target=spawn_client, args=(connection, client_address, remote_address, intercept_handler))
			thread.start()

	except:
		print("An unknown error has occured")

	finally:
		sock.close()

def default_handler(direction, source_socket, dest_socket, data):
	addr=source_socket.getpeername()
	src = addr[0]+":"+str(addr[1])
	addr=dest_socket.getpeername()
	dst = addr[0]+":"+str(addr[1])
	print('[*] %s -> %s | %s %4x | %s' % (src, dst, direction, len(data), data.hex()))
	return True

if __name__ == "__main__":
	setup_proxy(('localhost', 8080), ('10.1.1.2', 8080), default_handler)