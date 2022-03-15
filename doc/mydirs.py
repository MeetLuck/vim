import os
class Folders:
    def __init__(self):
        self.folders = dict()
        Cdrive = type('',(),{})
        Cdrive.path = 'C:\\'
        programfiles = type('',(),{})
        programfiles.path = os.environ['programfiles']
        print(programfiles.path)
        programfiles.dirs = self.getpaths(programfiles.path)
        print(programfiles.dirs)

def listdir_fullpath(d):
    return [os.path.join(d, f) for f in os.listdir(d)]

def listdir(root,depth=[-1]):
    depth[0] += 1
    if depth[0] > 4: return
    dirs = [os.path.join(root,path) for path in os.listdir(root) if os.path.isdir(os.path.join(root,path))]
    print(f'{root}({depth[0]})  -->  {dirs}\n')

    for dir in dirs:
        listdir(dir)
        depth[0] -= 1

def original(x,recursive = [-1]):
    recursive[0] += 1
    if recursive[0] > 3: return
    print(f'->original call {original.__name__}({x}) \trecursion depth = {recursive[0]}')
    # we are calling globals['original'],that is,<function NEW_func at 0x...>
    original(x)   

#original(3)
path = os.path.join(os.environ['userprofile'],r'.vim\doc\root')
listdir(path)
