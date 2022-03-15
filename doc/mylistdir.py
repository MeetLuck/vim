import os

def listdir(root,depth=[0]):
    dirs = []
    try:
        dirs = [os.path.join(root,path) for path in os.listdir(root) if os.path.isdir(os.path.join(root,path))]
    except:
        pass
    return dirs
path = os.environ['programfiles']
#path = os.environ['userprofile']
#print(listdir(os.environ['programdata']))
#print(listdir(os.environ['appdata']))
#print(listdir(os.environ['userprofile']))
#print(listdir(os.environ['programfiles']))
#print(listdir(os.environ['programfiles(x86)']))
print(listdir('C:\\'))
print(listdir('D:\\'))
#print(listdir(os.environ['windir']))
#print(listdir(os.path.join(os.environ['windir'],'system')) )
#print(listdir(os.path.join(os.environ['windir'],'system32')) )
