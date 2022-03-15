import os
import subprocess

cmd = r'control desktop'

try:
    subprocess.Popen(cmd,shell=False)
except Exception as e:
    print('error' + e)
