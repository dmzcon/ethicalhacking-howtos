import socket
import sys
import time

smtpserver = '127.0.0.1' # SOME IP of SMTP-server
# use: nslookup -type=mx DOMAIN to find the corresponding MAIL-server domainname

port = 25  # SOME integer Port number of SMTP-server

mailsrv = 'DOMAIN' # DOMAINNAME for testing: will be used in 'boxname@DOMAIN'
fakedomain = 'FakeDomainNameHere'

lines = []
with open("emails-wordlist.txt") as file:
    for line in file:
        line = line.strip()
        print (line)
        mailbox=line

# Create a TCP/IP socket

        sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

# Connect the socket to the port where the server is listening

        server_address = (smtpserver, port)
        sock.connect(server_address)
        data = sock.recv(100)
        message = "helo "+fakedomain+"\r\n"
        sock.sendall(message.encode())
        data = sock.recv(100)
        message = "mail from: "+mailbox+"@"+fakedomain+"\r\n"
        sock.sendall(message.encode())
        data = sock.recv(100)
        message = "rcpt to: "+mailbox+"@"+mailsrv+"\r\n"
        sock.sendall(message.encode())
        data = sock.recv(100)
        f = open('./results-of-enumeration.txt', 'a')
        f.write(mailsrv+": "+mailbox+" => "+str(data)+"\n")
        f.close()
        print(data)
        message = "quit\r\n"
        sock.sendall(message.encode())
        sock.shutdown(2)
        time.sleep(1)
