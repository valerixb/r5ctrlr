#!/usr/bin/python

import socket
import select
import os
import urllib.parse
import time
from datetime import datetime
import numpy as np

# don't import matplotlib here: on A53/petalinux it's slow;
# importing it here jeopardizes interactivity with the user;
# I import it later in the code, right before plotting,
# when the user is already waiting on the message 'downloading...'
#
#import matplotlib.pyplot as plt
#import io
#import base64

# constants
MAXSAMPLES=16383
MAXCNTS=32768.
# seconds to wait before checking again for end of acquisition
TRIG_IDLE_RETRY_DELAY_SEC=1

# acquisition state machine
ACQ_IDLE=0
ACQ_START=1
ACQ_WAIT_COMPLETION=2
ACQ_DOWNLOAD=3

# defaults
trig_ch=1
trig_slope='RISING'
trig_level=0.0
trig_mode='ARM'
acq_state=ACQ_IDLE

# --------- open a connection to r5ctrlr SCPI server ----------
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.connect(("127.0.0.1", 8888))
#s.connect(("192.168.0.18", 8888))

# ---------  get current config  -------------

# get sampling freq

s.sendall(b"FSAMPL?\n") 
ans=(s.recv(1024)).decode("utf-8")
tok=ans.split(" ",2)
if(tok[0].strip()=="OK:"):
  fsampl=float(tok[1])
else:
  fsampl=10000.0


# get trigger setup

cmd_s='RECORD:TRIGGER:SETUP?\n'
# print(cmd_s)
s.sendall(cmd_s.encode('ascii')) 
ans=(s.recv(1024)).decode('utf-8')
tok=ans.split(" ",5)
if tok[0].strip()=='ERR:':
  print('<br>Error reading trigger setup<br>')
  # print(f'trigger setup readback')
else:
  trig_ch=int(tok[1].strip())
  trig_ch=max(trig_ch,1)
  trig_ch=min(trig_ch,4)
  if tok[2].strip()=='SLOPE':
    # if trigger is already in slope mode, read rising/falling and level
    trig_slope=tok[3].strip()
    trig_level=float(tok[4].strip())
  else:
    # if trigger is in sweep mode, we must put it into slope mode
    # and use defaults
    cmd_s='RECORD:TRIGGER:SETUP '+str(trig_ch)+' SLOPE '+trig_slope+' '+str(trig_level)+'\n'
    # print(cmd_s)
    s.sendall(cmd_s.encode('ascii')) 
    ans=(s.recv(1024)).decode('utf-8')
    tok=ans.split(" ",2)
    if tok[0].strip()=='ERR:':
      print('<br>Error setting trigger to SLOPE mode<br>')
      # print(f'OK trigger SLOPE')



# ---------  get the query string of the GET form  ------------

# It is passed to cgi scripts as the environment
# variable QUERY_STRING
query_string = os.environ['QUERY_STRING']
#query_string = 'startacq=1'
# convert the query string to a dictionary
arguments = urllib.parse.parse_qs(query_string)

# ---------  check the fields of the GET form query string ----
# ---------            and act accordingly                 ----
for name in arguments.keys():
  # -------- new sampling frequency
  if name=='fsampl':
    fsampl=float(arguments[name][0])
    cmd_s='FSAMPL '+str(fsampl)+'\n'
    # print(cmd_s)
    s.sendall(cmd_s.encode('ascii')) 
    ans=(s.recv(1024)).decode('utf-8')
    tok=ans.split(" ",2)
    if tok[0].strip()=='ERR:':
      print('<br>Error commanding the new sampling frequency<br>')
      # print(f'new commanded sampling freq is {v_fsampl} Hz')

  # -------- new trigger channel
  elif name=='trig_ch':
    trig_ch=int(arguments[name][0])

  # -------- new trigger slope
  elif name=='trig_slope':
    trig_slope=arguments[name][0]

  # -------- new trigger level
  elif name=='trig_level':
    trig_level=float(arguments[name][0])

  #------------ update state machine state -------------
  elif name=='acqstate':
    acq_state=int(arguments[name][0])

  #------------ start a new acquisition -------------
  elif name=='trigger':
    acq_state=ACQ_START
    trig_mode=arguments[name][0]


  # ---------- just ignore unknown parameters
#    else:
#      print('unknown parameter')


# ------------------  if IDLE, do the changes requested by the GET form query string  --------------------

if(acq_state==ACQ_IDLE):
  # ---------- stop trigger
  cmd_s='RECORD:TRIGGER OFF\n'
  # print(cmd_s)
  s.sendall(cmd_s.encode('ascii')) 
  ans=(s.recv(1024)).decode('utf-8')
  tok=ans.split(" ",2)
  if tok[0].strip()=='ERR:':
    print('<br>Error turning the trigger OFF<br>')
    # print(f'OK trigger OFF')
  
# ---------  

acqtime=MAXSAMPLES/fsampl

# ----------  start html  ---------------------

print('Content-type:text/html\r\n\r\n')
print('<!DOCTYPE html>')
print('<html>')
print('<head>')

# --- reload script for the state machine

if ((acq_state!=ACQ_IDLE) and (acq_state!=ACQ_DOWNLOAD)) :
  print('<script>')
  print('    window.addEventListener("load", () => {')
  print('      const url = new URL(window.location.href);')
  print('      const params = url.searchParams;')
  print('')
  
  if acq_state==ACQ_START:
    print(f'        params.set("acqstate", "{ACQ_WAIT_COMPLETION}");')
  elif acq_state==ACQ_WAIT_COMPLETION:
    print(f'        params.set("acqstate", "{ACQ_DOWNLOAD}");')
    
  print('        url.search = params.toString();')
  print('        window.location.replace(url.toString());')
  print('    });')
  print('  </script>')

# --- end of reload script

print('  <table>')
print('    <tr>')
print('      <td> <a href="/cgi-bin/index.cgi"> <img src="/MAX-IV_logo1_rgb-300x104.png" alt="MaxIV Laboratory"> </a> </td>')
print('      <td>')
print('      <H1>Max IV R5 controller</H1>')
print('      <H2>Scope Facility</H2>')
print('      </td>')
print('    </tr>')
print('  </table>')
print('</head>')

print('<body>')


print('  <table>')

#-------  Fsampl  -----------------------------

print('    <tr>')
print('      <td>Sampling Frequency:</td>')
print('      <td>')
print('          <form action="" method="GET" >')
print(f'          <input type="number" name="fsampl" id="fsampl" value={fsampl} min="1" max="10000" step=1 onchange="javascript:this.form.submit()"> Hz')
print('          </form>')
print('      </td>')
print('    </tr>')

print('<form action="" method="GET" >')
# -- Prevent implicit submission of the form hitting <enter> key
print('  <button type="submit" disabled style="display: none" aria-hidden="true"></button>')

#-------  Trigger Channel  -----------------------------

print('    <tr>')
print('      <td>Trigger Channel:</td>')
print('      <td>')
print('        <select name="trig_ch" id = "trig_ch">')
for i in range(1,5):
  print(f'          <option value = "{i}" ')
  if( i==trig_ch ):
    print('selected="selected"')
  print(f'>{i}</option>')
print('        </select>')
print('      </td>')
print('    </tr>')

#-------  Trigger Slope  -----------------------------

print('    <tr>')
print('      <td>Trigger Slope:</td>')
print('      <td>')
print('        <select name="trig_slope" id = "trig_slope">')

print('          <option value = "RISING" ')
if(trig_slope=="RISING"):
  print('selected="selected"')
print('>RISING</option>')

print('          <option value = "FALLING" ')
if(trig_slope=="FALLING"):
  print('selected="selected"')
print('>FALLING</option>')

print('        </select>')
print('      </td>')
print('    </tr>')

#-------  Trigger Level  -----------------------------

print('    <tr>')
print('      <td>Trigger level (range [-1,1]):</td>')
print('      <td>')
print(f'          <input type="number" name="trig_level" id="trig_level" value="{trig_level}"  size="5em" min="-1.0" max="+1.0" step="any">')
print('      </td>')
print('    </tr>')

print('  </table>')

print(f'  <br>Acquisition time in this configuration is {acqtime:.3f} sec<br><br>')

print('  <button type="submit" name="trigger" value="ARM"')
if((acq_state==ACQ_START) or (acq_state==ACQ_WAIT_COMPLETION)):
  print(' disabled')
print('>ARM Trigger</button>')

print('  <button type="submit" name="trigger" value="FORCE"')
if((acq_state==ACQ_START) or (acq_state==ACQ_WAIT_COMPLETION)):
  print(' disabled')
print('>FORCE Trigger</button>')

print('</form>')
print('  <br>')

# ------------------  acquire  --------------------------

# ----- it's a state machine to allow page reload during acquisition
# ----- and data downloading, to give some feedback to the user

if acq_state==ACQ_IDLE :
  pass
  
elif acq_state==ACQ_START :
  print('  <br>')
  print(datetime.now())
  print(f' : acquiring {acqtime:.3f} sec of data...')
  
  # ---------- update trigger setup
  cmd_s='RECORD:TRIGGER:SETUP '+str(trig_ch)+' SLOPE '+trig_slope+' '+str(trig_level)+'\n'
  # print(cmd_s)
  s.sendall(cmd_s.encode('ascii')) 
  ans=(s.recv(1024)).decode('utf-8')
  tok=ans.split(" ",2)
  if tok[0].strip()=='ERR:':
    print('<br>Error updating trigger setup<br>')
    # print(f'OK trigger setup update')

  # ---------- arm trigger
  cmd_s='RECORD:TRIGGER '+trig_mode+'\n'
  # print(cmd_s)
  s.sendall(cmd_s.encode('ascii')) 
  ans=(s.recv(1024)).decode('utf-8')
  tok=ans.split(" ",2)
  if tok[0].strip()=='ERR:':
    print('<br>Error arming trigger<br>')
    # print('Trigger armed')

  # here page will reload with new acq_state
    
elif acq_state==ACQ_WAIT_COMPLETION:
  ans=''
  while ans != 'IDLE' :
    cmd_s='RECORD:TRIG?\n'
    # print('<br>'+cmd_s+'<br>')
    s.sendall(cmd_s.encode('ascii')) 
    ans=(s.recv(1024)).decode('utf-8')
    tok=ans.split(" ",2)
    if tok[0].strip()=='ERR:':
      print('<br>'+ans+'<br>')
      break
    ans=tok[1].strip()
    time.sleep(TRIG_IDLE_RETRY_DELAY_SEC)
  
  print('  <br>')
  print(datetime.now())
  print(' : downloading samples')
  # here page will reload with new acq_state
    
elif acq_state==ACQ_DOWNLOAD:
  # -------------  read samples  ------------------
  cmd_s='RECORD:SAMPLES?\n'
  s.sendall(cmd_s.encode('ascii'))
  # now receive a big answer 
  samplebuf=""
  while True:
    s.setblocking(0)
    ## set timeout to twice the acquisition time
    #timeout_in_seconds=2*acqtime
    timeout_in_seconds=1
    ready = select.select([s], [], [], timeout_in_seconds)
    if ready[0]:
      ans=s.recv(1024)
      samplebuf += ans.decode('utf-8')
    else:
      break

  # print('  <br>')
  # print(datetime.now())
  # print(' : acquired ')

  buflines=samplebuf.splitlines()
  
  # while '\n' in samplebuf:
  #   line, samplebuf = samplebuf.split('\n', 1)
  #   print(f"Received line: {line}<br>")
  
  # first line is a header which we ignore
  if len(buflines) > 1:
    samples = [list(map(int, line.split())) for line in buflines[1:]]

  #print("2D Integer Array:<br>")
  #for row in samples:
  #  print(row)
  #  print('<br>')

  # if we have an odd number of samples, discard the first (which should be zero)
  if len(samples)%2 == 1 :
    samples=samples[1:]
  samplenum=len(samples)
  
  # print(f'{samplenum} samples<br>')
  
  # -------------  plot  ------------------
  
  # Ensure this works even if DISPLAY is not set (e.g., on servers)
  #import matplotlib
  #matplotlib.use('Agg')

  import matplotlib.pyplot as plt
  import io
  import base64
  
  Ts=1./fsampl
  timev=np.arange(samplenum)*Ts

  for chan in range(4):
    plt.figure(figsize=(6, 4))
    samplech =np.array([sublist[chan] for sublist in samples])/MAXCNTS
    plt.plot(timev, samplech, linestyle='-', color='red')
    the_title='Channel #'+str(chan+1)
    plt.title(the_title)
    plt.xlabel('time')
    plt.ylabel('normalized output')
    plt.grid(True)
  
    # Save plot to in-memory buffer
    imgbuf = io.BytesIO()
    plt.savefig(imgbuf, format='png')
    plt.close()
    imgbuf.seek(0)
  
    # Encode image to base64
    img_base64 = base64.b64encode(imgbuf.read()).decode('utf-8')
  
    # embed picture into html
    print(f'  <img src="data:image/png;base64,{img_base64}" alt="Bode mag">')

  # ----------  embed raw data for download  ------------
  print('<br>')
  print('Raw data linked <a href="data:text/plain;charset=US-ASCII,')
  
  s='Nsamples '+str(samplenum)+'%0A'
  s.encode("ascii")
  print(s)
  s='Fsampling '+str(int(fsampl))+'%0A'
  s.encode("ascii")
  print(s)
  
  s='      Ch 1       Ch 2       Ch 3       Ch 4 %0A'
  s.encode("ascii")
  print(s)
  for row in samples:
    #s=str(row[in_ch-1])+' '+str(row[out_ch-1])+'%0A'
    s=''
    for c in range(4):
      s=s+f'{row[c]:10} '
    s=s+'%0A'
    s.encode("ascii")
    print(s)
  
  print('">here</a> if you want to download it.')
  
  
print('<br><br>')
print('</body>')
print('</html>')

s.close


