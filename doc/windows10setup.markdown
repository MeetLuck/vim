# path from win7 c:\
    - gadget(sidebar) C:\Users\meetluck\AppData\Local\Microsoft\Windows Sidebar\Gadgets
    - winamp:       A:\nProgram Files (x86)\WinAMP_v2.95_Kor_Portable\winamp.exe
    - ev editor:    E:\home\utils\Eveditor\Eveditor.exe
    - conEmu64:     A:\64bit\ConEmuPack.180626\ConEmu64.exe
    - utorrent

# firefox
    - bookmark
    - profile

# darkmode
    - 개인설정 - 색 - 어둡게

# firefox profile location
    - %APPDATA%\Roaming\Mozilla\Firefox\Profiles\
    - profile: xxx.setup foler

# 정품인증
    - cmd.exe
    - slmgr/ipk W269N-WFGWX-YVC9B-4J6C9-T83GX
    - slmgr /skms kms.digiboy.ir
    - slmgr /ato
# 테마 설정
     - dark mode
     - theme save

# D드라이브(불룸축소)
    - compmgmt.msc
# msconfig
    - 최대프로세스,최대메모리(*메모리 인식오류*)
    - GUI부팀없슴
# remove all apps list from Start Menu
    - gpedit.msc -> 관리템플릿-시작메뉴및 작업표시줄 ->시작메뉴에서 모든 프로그램항목 제거
                 -> 사용함 -> 제거 및 설정사용안함
                 -> reboot
# window defender anti-virus
    - gpedit.msc -> 관리템플릿 - windows구성요> windows defender virus> 실시간 보호>
    - >실시간 보호 끄기
# 검색창 숨기기
    - 작업표시줄 우클릭
# 불필요한scheduler 제거(*window experience등등*)
    - control-schedtask
# MCSS(Multimedia Class Scheduler Service)
    - not found
# 인터넷 예약 대역폭 제한 해제
    - gpedit.msc -> 컴퓨터구성>관리템플릿>네트워크> Qos패킷 스케줄러

# memory 인식오료
    - msconfig > booting > 최대메모리 사용 해제
# 탐색기 라이브러리 제거
    - 3D객체,사진,비디오,음악등등
    - using regedit
# 로컬보안정책
    -secpol.msc > 로컬정책 > 관리자승인 ....

# path설정
    * powershell
        - $env:UserVariable=%userprofile%
        - [Environment]::SetEnviroment('UserVariable',$env:UserVariable,'users')
        - $env:SystemVariable=%userprofile%
        - [Environment]::SetEnviroment('SystemVariable',$env:SystemVariable,'Machine')
    * rapid...
    * ev...

# 미리보기
    -폴더옵션 -> 보기 -> 고급설정 : 아이콘은 항상표시하고 미리보기는 표시하지 않음

# searchUI.exe
    - cd %windir%\SystemApps\Microsoft.Windows.Cortana_cw5n1h2txyewy
    - takeown /f SearchUI.exe
    - icacls SearchUI.exe /grant administrators:F
    - taskkill /f /im SearchUI.exe
    - rename SearchUI.exe SearchUI.exe.001
