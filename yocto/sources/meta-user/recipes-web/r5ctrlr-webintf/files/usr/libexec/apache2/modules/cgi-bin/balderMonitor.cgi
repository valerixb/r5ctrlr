#!/usr/bin/python

import socket
#import select
import os
#import urllib.parse
#import time
#from datetime import datetime
#import numpy as np
#import matplotlib.pyplot as plt
#import io
#import base64
#import fnmatch

# constants
ERR_STRING='&ltERR&gt'
# threshold to declare beam present; it's in percentage (range 1-100)
BEAM_THRESHOLD=2.0
NO_BEAM_STR='NO BEAM'

# defaults


# --------------------  open html page right away, so we can print errors on it -----------------------

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
#s.connect(("192.168.0.24", 8888))

## offset not needed because it's automatically added to the DAC value
## ----- get DAC offset (=working point)

#qstr='DAC:CH:OFFS? 1\n'
#s.sendall(bytes(qstr,encoding='ascii')) 
#ans=(s.recv(1024)).decode("utf-8")
#tok=ans.split(" ",2)
#if(tok[0].strip()=="OK:"):
#  loop_offs_cnts=int(tok[1].strip())
#else:
#  # default
#  loop_offs_cnts=1638


# ----- get output command swing
    
qstr='CTRLLOOP:CH:PID:THR? 1 2\n'
s.sendall(bytes(qstr,encoding='ascii')) 
ans=(s.recv(1024)).decode("utf-8")
tok=ans.split(" ",3)
if(tok[0].strip()=="OK:"):
  loop_swing_cnts=int(float(tok[2].strip())*32767)
else:
  # default
  loop_swing_cnts=1475


# ----- get current DAC status

qstr='DAC?\n'
s.sendall(bytes(qstr,encoding='ascii')) 
ans=(s.recv(1024)).decode("utf-8")
tok=ans.split(" ",5)
if(tok[0].strip()=="OK:"):
  piezo_cmd_raw=tok[1].strip()
  piezo_cmd=str(100*float(tok[1].strip())/(float(loop_swing_cnts)))
  beam_intensity=str(100*float(int(tok[2].strip()))/32767.)
  beam_deflection=str(100*float(int(tok[3].strip()))/32767.)
else:
  piezo_cmd=ERR_STRING
  beam_intensity=ERR_STRING
  beam_deflection=ERR_STRING


# --------------------  now display body of html page  -----------------------

## debug
#print('DAC offs (default: 1638) = '+str(loop_offs_cnts)+' <br>\n')
#print('normalized DAC swing (default: 0.045) = '+str(float(loop_swing_cnts)/32767.)+' <br>\n')
#print('raw piezo cmd (cnts) = ' + piezo_cmd_raw + ' <br>\n')
#print('<br><br>\n')

print('<table>')

if piezo_cmd!=ERR_STRING:
  piezo_cmd_str="{:+d}".format(round(float(piezo_cmd)))
else:
  piezo_cmd_str=piezo_cmd

print('  <tr>')
print('    <td>Piezo Command:</td>')
print('    <td align="right">'+piezo_cmd_str+'</td>')
print('    <td>%</td>')
print('  </tr>')


if beam_intensity!=ERR_STRING:
  if(float(beam_intensity)>BEAM_THRESHOLD):
    beam_intensity_str="{:d}".format(round(float(beam_intensity)))
  else:
    beam_intensity_str=NO_BEAM_STR
else:
  beam_intensity_str=beam_intensity

print('  <tr>')
print('    <td>Beam Intensity:</td>')
print('    <td align="right">'+beam_intensity_str+'</td>')
print('    <td>%</td>')
print('  </tr>')


if beam_deflection!=ERR_STRING:
  if(float(beam_intensity)>BEAM_THRESHOLD):
    beam_deflection_str="{:+d}".format(round(float(beam_deflection)))
  else:
    beam_deflection_str=NO_BEAM_STR
else:
  beam_deflection_str=beam_deflection

print('  <tr>')
print('    <td>Beam Deflection:</td>')
print('    <td align="right">'+beam_deflection_str+'</td>')
print('    <td>%</td>')
print('  </tr>')


print('  <tr>')
print('    <td> <br> </td>')
print('  </tr>')

print('</table>')

print('<br>')
print('<br>')

print('</body>')
print('</html>')






