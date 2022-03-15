#import configparser
import configparser 
import os
'''
The only bit of magic involves the DEFAULT sections
which provides default values for all other sections.
'''
config = configparser.ConfigParser()
# read ini file
fname = 'myconfigparser_example.ini'
if os.path.isfile(fname):
    config.read(fname)
    print(f'{config.sections()}')

#print(f'isfile {name}')
# read sections
sections = config.sections()
print(config['Spider man'])
print('sections: ',repr(sections))

for section in sections:
    print('--> section: ',section)
    print('--> config[section]:', config[section])
    mydict = dict(config[section].items())
    print(repr(mydict))
    for key,value in config[section].items():
        print(key,value)
    for key in config[section].keys():
        print(f'...key = {key}')
    for value in config[section].values():
        print(f'...value = {value}')
