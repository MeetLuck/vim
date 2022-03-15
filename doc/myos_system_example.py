import os

cmd = 'pydoc.py os.system'
os.startfile('python')
try:
    os.system('cmd.exe /k '+cmd)
except:
    os.startfile(cmd)
    #os.system(cmd)
