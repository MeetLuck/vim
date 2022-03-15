import os
def getfiles(path) -> dict:
    filedict = dict()
    for root,dirs,files in os.walk(path,followlinks=True):
        print(root,files)
        for file in files:
            path = os.path.join(root,file)
            filedict.update({file:path})
    return filedict

programfiles = os.environ['programfiles']
 
getfiles(programfiles)

