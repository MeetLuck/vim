import subprocess as sp
cmd=r'fd -H -L -t d . C:\Users|fzf'
#result1 = sp.Popen(cmd)
result = sp.Popen(cmd,shell=True)
