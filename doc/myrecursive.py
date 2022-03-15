import os

def listdir(root,depth=[0]):
    if depth[0] <= 3:
        dirs = [os.path.join(root,path) for path in os.listdir(root) if os.path.isdir(os.path.join(root,path))]
        print(f'{root}({depth[0]})  -->  {dirs}\n')
        depth[0] += 1
        for dir in dirs:
            listdir(dir)
            #depth[0] -= 1
        return
    else:
        return


def original(x,recursive = [0]):
    # depth=0
    #...depth=1
    #.....depth=2
    #.......depth=3
    if recursive[0] <= 3:
        recursive[0] += 1
        print(f'->original call {original}({x}) \trecursion depth = {recursive[0]}')
        original(x)   
        recursive[0] -= 1
        return print(f'->original call {original}({x}) \trecursion depth = {recursive[0]}')
    else:
        return print(f'->original call {original}({x}) \trecursion depth = {recursive[0]}')
    # we are calling globals['original'],that is,<function NEW_func at 0x...>

#original(3)
#path = os.path.join(os.environ['userprofile'],r'.vim\doc\root')
path = os.environ['programfiles']
listdir(path)
