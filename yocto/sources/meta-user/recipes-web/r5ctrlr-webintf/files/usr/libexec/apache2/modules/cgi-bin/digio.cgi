#!/usr/bin/python

import socket
#import select
import os
import urllib.parse
#import time
#from datetime import datetime
#import numpy as np
#import matplotlib.pyplot as plt
#import io
#import base64
import fnmatch

# constants


# defaults


# ----------  html header  ---------------------

print('Content-type:text/html\r\n\r\n')
print('<!DOCTYPE html>')
print('<html>')
print('<head>')
print('  <table>')
print('    <tr>')
print('      <td> <a href="/cgi-bin/index.cgi"> <img src="/MAX-IV_logo1_rgb-300x104.png" alt="MaxIV Laboratory"> </a> </td>')
print('      <td>')
print('      <H1>Max IV R5 controller</H1>')
print('      <H2>Digital I/O</H2>')
print('      </td>')
print('    </tr>')
print('  </table>')
print('</head>')

print('<body>')


# --------- open a connection to r5ctrlr SCPI server ----------
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.connect(("127.0.0.1", 8888))
#s.connect(("192.168.0.18", 8888))



# ---------  first of all, get current config  -------------

# ----- get digital out
s.sendall(b"DIGOUT?\n") 
ans=(s.recv(1024)).decode("utf-8")
tok=ans.split(" ",2)
if(tok[0].strip()=="OK:"):
  digout=int(tok[1],0)
else:
  digout=0
#print(f'{digout:#06X}<br>')


# ---------  now get the config change requested by the GET form query string  ------------

# the query string of the GET form
# It is passed to cgi scripts as the environment
# variable QUERY_STRING
query_string = os.environ['QUERY_STRING']
#query_string = ''
# convert the query string to a dictionary
arguments = urllib.parse.parse_qs(query_string)

# ---------  check the fields of the GET form query string ----
# ---------            and act accordingly                 ----
for name in arguments.keys():
  
  # -------- bit set/reset in DIG OUT
  # -------- bit number is a suffix;
  # -------- I use fnmatch to test with wildcard
  if fnmatch.fnmatch(name,'setbit??'):
    the_bit=int(name[-2:])
    if int(arguments[name][0])==1:
      # set bit
      digout = digout | 0x01<<the_bit
    else:
      # reset bit
      digout = digout & ~(0x01<<the_bit)
    #print(f'new digout={digout:#06X}<br>')
    cmd_s='DIGOUT '+str(digout)+'\n'
    #print(f'<br> >>>>> {cmd_s} <<<<< <br>')
    s.sendall(cmd_s.encode('ascii')) 
    ans=(s.recv(1024)).decode('utf-8')
    tok=ans.split(" ",2)
    if tok[0].strip()=='ERR:':
      print('<br>Error commanding new digital OUT<br>')


  # ---------- just ignore unknown parameters
#    else:
#      print('unknown parameter')



# --------------------  now display html page  -----------------------

print('  <h3>Digital OUT</h3>')

# bit 7 downto 0
print('  <table border=1>')
print('    <tr>')
for b in range(7,-1, -1):
  print(f'      <td>bit {b:02}</td>')
print('    </tr>')

print('    <tr>')
for b in range(7,-1, -1):
  print('      <td>')
  print('      <form action="" method="GET" >')
  # -- Prevent implicit submission of the form hitting <enter> key
  print('      <button type="submit" disabled style="display: none" aria-hidden="true"></button>')
  print(f'      <input type="number" name="setbit{b:02}" id="setbit{b:02}" value={digout>>b&0x01} min="0" max="1" step=1 onchange="javascript:this.form.submit()">')
  print('      </form>')
  print('      </td>')
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
  print('      <td>')
  print('      <form action="" method="GET" >')
  # -- Prevent implicit submission of the form hitting <enter> key
  print('      <button type="submit" disabled style="display: none" aria-hidden="true"></button>')
  print(f'      <input type="number" name="setbit{b:02}" id="setbit{b:02}" value={digout>>b&0x01} min="0" max="1" step=1 onchange="javascript:this.form.submit()">')
  print('      </form>')
  print('      </td>')
print('    </tr>')
print('  </table>')
print('  <br>')

print('  <h3>Digital IN</h3>')

print('  <iframe src="/cgi-bin/digin.cgi" scrolling=no style="border:none; height: 350px; width: 600px" title="DigIN"></iframe>')

print('<br><br>')
print('</body>')
print('</html>')

s.close


