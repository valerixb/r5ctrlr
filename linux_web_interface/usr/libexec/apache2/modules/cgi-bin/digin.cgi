#!/usr/bin/python

import socket
#import select
#import os
#import urllib.parse
#import time
#from datetime import datetime
#import numpy as np
#import matplotlib.pyplot as plt
#import io
#import base64
#import fnmatch

# constants


# defaults


# ----------  html header  ---------------------

print('Content-type:text/html\r\n\r\n')
print('<!DOCTYPE html>')
print('<html>')
print('<head>')
print('  <meta http-equiv="refresh" content="1">')
print('</head>')

print('<body>')


# --------- open a connection to r5ctrlr SCPI server ----------
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.connect(("127.0.0.1", 8888))
#s.connect(("192.168.0.18", 8888))


# ---------  first of all, get current config  -------------

# ----- get digital IN
s.sendall(b"DIGIN?\n") 
ans=(s.recv(1024)).decode("utf-8")
tok=ans.split(" ",2)
if(tok[0].strip()=="OK:"):
  digin=int(tok[1],0)
else:
  digin=0
#print(f'{digin:#06X}<br>')


# --------------------  now display html page  -----------------------

# bit 7 downto 0
print('  <table border=1>')
print('    <tr>')
for b in range(7,-1, -1):
  print(f'      <td>bit {b:02}</td>')
print('    </tr>')

print('    <tr>')
for b in range(7,-1, -1):
  print(f'      <td>{digin>>b&0x01}</td>')
print('    </tr>')
print('  </table>')
print('  <br>')

# bit 15 downto 8
print('  <table border=1>')
print('    <tr>')
for b in range(15,7, -1):
  print(f'      <td>bit {b:02}</td>')
print('    </tr>')

print('    <tr>')
for b in range(15,7, -1):
  print(f'      <td>{digin>>b&0x01}</td>')
print('    </tr>')
print('  </table>')
print('  <br>')

print('</body>')
print('</html>')

s.close


