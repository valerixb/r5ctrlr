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
print('      <H1>Balder Monochromator</H1>')
print('      <H2>Vertical beam control with R5 controller</H2>')
print('      </td>')
print('    </tr>')
print('  </table>')
print('</head>')

print('<body>')


# --------- open a connection to r5ctrlr SCPI server ----------
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.connect(("127.0.0.1", 8888))
#s.connect(("192.168.0.24", 8888))


# ------------------  get current config from R5  --------------------


# ----- get ON/OFF state

qstr='CTRLLOOP:CH:STATE? 1\n'
s.sendall(bytes(qstr,encoding='ascii')) 
ans=(s.recv(1024)).decode("utf-8")
tok=ans.split(" ",2)
if(tok[0].strip()=="OK:"):
  loop_onoff=tok[1].strip()
else:
  loop_onoff='OFF'




# ------------------  do the changes requested by the GET form query string  --------------------

# the query string of the GET form
# It is passed to cgi scripts as the environment
# variable QUERY_STRING
query_string = os.environ['QUERY_STRING']
#query_string = ''
# convert the query string to a dictionary
arguments = urllib.parse.parse_qs(query_string)

# ---------  check the fields of the GET form query string ----
# ---------            and act accordingly                 ----

# take note of what channel we change, because we'll have to make some calculations
# and R5 update after reading all the settings from the GET query string
ch_to_update=0

for name in arguments.keys():

  # -------- now check channel enable request; channel number is a suffix;
  # -------- I use fnmatch to test with wildcard

  # --------  channel enable  ----------
  if fnmatch.fnmatch(name,'ch_enbl?'):
    ch_to_update=int(name[-1])
    if int(arguments[name][0])==1:
      loop_onoff='ON'
    else:
      loop_onoff='OFF'


# ---------  write back the updated channel config to the R5  ------------

if(ch_to_update==1):
  qstr='CTRLLOOP:CH:STATE 1 '+loop_onoff+'\n'
  s.sendall(bytes(qstr,encoding='ascii')) 
  ans=(s.recv(1024)).decode("utf-8")
  tok=ans.split(" ",2)
  if(tok[0].strip()!="OK:"):
    print(f'ON/OFF error\n')



# --------------------  now display html page  -----------------------


print('<form action="" method="GET" >')

# -- Prevent implicit submission of the form hitting <enter> key
print('  <button type="submit" disabled style="display: none" aria-hidden="true"></button>')

print('  <table>')
  
#-------  channel enable  -----------------------------
print('    <tr>')
print('      <td>Controller </td>')
print('      <td>')
print(f'        <select name="ch_enbl1" id = "ch_enbl1" onchange="javascript:this.form.submit()">')
if loop_onoff=="ON" :
  print('          <option value = "0"         >OFF</option>')
  print('          <option value = "1" selected>ON</option>')
else:
  print('          <option value = "0" selected>OFF</option>')
  print('          <option value = "1"         >ON</option>')
print('        </select>')
print('      </td>')
print('    </tr>')

print('    <tr><td>&nbsp</td></tr>')

print('  </table>')
print('</form>')


# -------- readback page

print('  <iframe src="/cgi-bin/balderMonitor.cgi" scrolling=no style="border:none; height: 350px; width: 600px" title="Monitor"></iframe>')
print('')


print('</body>')
print('</html>')

s.close


