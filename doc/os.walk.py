import os

def getfiles(path) -> dict:
    filedict = dict()
    for root,dirs,files in os.walk(path,followlinks=True):
        #print(root)
        for file in files:
            path = os.path.join(root,file)
            head,ext = os.path.splitext(path)
            if ext in extensions:
                filedict.update({file:path})
                #print(f'-> {file}:{path}\t\t')
                #print(os.path.abspath(file))
    return filedict

system  = type('',(),{})
user    = type('',(),{})
links   = type('',(),{})
system.files = {}
user.files   = {}
links.files  = {}
system.path = os.path.join(os.environ['allusersprofile'],'microsoft\windows\start menu')
user.path   = os.path.join(os.environ['appdata'],'microsoft\windows\start menu')
links.path  = os.path.join(os.environ['userprofile'],'Documents\Links')
print(links.path)
#extensions = os.environ['PATHEXT'].split(';') #['.lnk','.exe','.bat','.cmd']
extensions = ['.lnk','.exe','.bat','.cmd']
system.files.update( getfiles(system.path))
user.files.update( getfiles(user.path))
links.files.update( getfiles(links.path))
print(links.files)
