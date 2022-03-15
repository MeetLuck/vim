# vim on cygwin
    # install SCOOP
        * using windows Powershell
        * set custom directory
            - `$env:SCOOP = 'D:\Applications\Scoop'`
            - `$env:SCOOP_GLOBAL='D:\Applications\Scoop'`
            - `$[Enviroment]::SetEnviromentVariables('Scoop','$env:SCOOP','User')`
            - `$[Enviroment]::SetEnviromentVariables('Scoop_GLOBAL','$env:SCOOP_GLOBAL','Machine')`
        * install scoop
            - `$Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://get.scoop.sh')`
            - `$iwr -useb get.scoop.sh | iex`
            - `$scoop bucket add extras`
            - `$scoop bucket add Versions`
            - https://github.com/lukesampson/scoop/wiki/Switching-Ruby-and-Python-Versions
    # install cygwin
        - `$scoop install cygwin`
        * install apt-cyg
            * install wget using cygwin setup
            * install apt-cyg using wget
                - `$wget https://raw.githubusercontent.com/transcode-open/apt-cyg/master/apt-cyg`
                - `$install apt-cyg /bin`
        * install git
            * make sure not using *git for windows*
            - `$which git`
            - `$apt-cyg install git`
        * install curl
            - `$apt-cyg install curl`
    # install vim
        - `$apt-cyg install vim`
        * terminal as minttyrc
            * ctrl (numpad)+ to increase fontsize
            * ctrl (numpad)- to increase fontsize
            * ctrl (numpad)0 to reset fontsize
            * alt Enter to full size
        * .inputrc for GNU readline library
            - `set show-mode-in-prompt on`
            - `set editing-mode vi`
            - `set vi-ins-mode-string \1\e[3 q\2`
            - `set vi-cmd-mode-string \1\e[2 q\2`
            - `set bell-style audiable`
        * modify .bashrc
            * makesure NO SPACE between equal sign('=')
            * alias ls='ls -a --color=auto'
            * alias cls='clear'
            * change Title
                - `export PROMPT_COMMAND=functionname`
            * change Prompt
                - `PS1 = `
        * makesure $TERM=xterm-256color
            - `$echo $TERM`
        # .vimrc
            * set term   -> makesure xterm-256color
            * install pathogen
              * makesure which git
                  - `$mkdir -p ~/.vim/autoload ~/.vim/bundle`
                  - `$curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim`
                  - :set nocompatible
                  - :execute pathogen#infect() in .vimrc
                  - :filetype Plugin indent on
                  - :syntax on
            * install solarized colorscheme
                  - `$git clone https://github.com/altercation/vim-colors-solarized`
                  - :set background=dark
                  - :let g:solarized_termcolors=256
                  - :let g:solarized_termtrans=0
                  - :let g:solarized_contrast="high"
                  - :colors solarized
            * setup mappings




