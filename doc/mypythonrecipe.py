import os, win32api, win32con

def get_sys_env_variable(system_var:str) -> str:
    env_value = 'failed'
    try:
        rkey = win32api.RegOpenKey(win32con.HKEY_LOCAL_MACHINE, r'SYSTEM\CurrentControlSet\Control\Session Manager\Environment')
        try:
            env_value = str(win32api.RegQueryValueEx(rkey, system_var)[0])
            env_value = win32api.ExpandEnvironmentStrings(env_value)
        except:
            pass
    finally:
        win32api.RegCloseKey(rkey)
    return env_value

if __name__ == '__main__':
    print(f'SYSTEM.TEMP = {get_sys_env_variable("TEMP")}')
    print(f'USER.TEMP = {os.getenv("TEMP")}')
