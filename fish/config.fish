set fish_greeting # Supresses fish's intro message
# set TERM "xterm-ghostty"      # Sets the terminal type
set EDITOR nano # $EDITOR use Emacs in terminal
set VISUAL nano # $VISUAL use Emacs in GUI mode
set HISTSIZE 10000
set HISTFILESIZE 20000
set HISTCONTROL ignoreboth

# Function for creating a backup file
# ex: backup file.txt
# result: copies file as file.txt.bak
function backup --argument filename -d 'Function for creating a backup file'
    cp $filename $filename.bak
end

# Function for printing a column (splits input on whitespace)
# ex: echo 1 2 3 | coln 3
# output: 3
function coln --argument index -d 'Function for printing a column (splits input on whitespace)'
    while read -l input
        echo $input | awk '{print $'$index'}'
    end
end

# Function for printing a row
# ex: seq 3 | rown 3
# output: 3
function rown --argument index -d 'Function for printing a row'
    sed -n "$index p"
end

# Function for displaying current git branches in child directories
function gbr
    for d in */
        if [ -d "$d/.git" ]
            set -l name git -C "$d" branch --show-current
            echo -n "$d: $name"
        end
    end
end

# Function for commiting with branch name prefix
function gcommit -d 'Function for commiting with branch name prefix'
    set -l branch (git branch --show-current)
    git commit -m "$branch $argv"
end

# Function for commiting with FIX and branch name prefixes
function gfix -d 'Function for commiting with FIX and branch name prefixes'
    set -l branch (git branch --show-current)
    git commit -m "FIX $branch $argv"
end

# Function for loading .env file to shell session
function envsource --argument envfile -d 'Function for loading .env file to shell session'
    set -q envfile[1]; or set -l envfile '.env'
    if not test -f "$envfile"
        echo "Unable to load $envfile"
        return 1
    end
    while read line
        if not string match -qr '^#|^$' "$line"
            set -l item (string split -m 1 '=' $line)
            set -gx $item[1] $item[2]
        end
    end <"$envfile"
    echo "Loaded $envfile"
end

# TODO: try out abbr

# Git

alias gmd='git commit --amend'
alias gbr='git branch --show-current'
alias gdf='git diff --output-indicator-new=" " --output-indicator-old=" "'
alias gdfs='gdf --staged'
alias gss='git status'
# %x0 -- tab
alias glog='git log --all --graph --pretty=format:"%C(magenta)%h%x09%C(white)%an%x09%ar%C(auto)%x09%D%n%s%n"'

# Docker

alias dcb='docker compose build'
alias dcr='docker compose run --rm --service-ports'
alias dcrnoport='docker compose run --rm'
alias dcu='docker compose up -d'
alias dckill='docker kill $(docker ps -qa) || docker rm $(docker ps -qa)'
alias docker-compose='docker compose'

# Kubernetes

alias kcl='kubectl'

# Adguard

alias vpn='adguardvpn-cli'
alias vpns='adguardvpn-cli status'
alias vpnin='adguardvpn-cli login'
alias vpnout='adguardvpn-cli logout'
alias vpnlist='adguardvpn-cli list-locations'
alias vpnc='adguardvpn-cli connect'
alias vpndc='adguardvpn-cli disconnect'
alias vpnexlusions='adguardvpn-cli site-exclusions show'
alias vpnignore='adguardvpn-cli site-exclusions add'
alias vpnunignore='adguardvpn-cli site-exclusions remove'

# UnixUtils

alias allMy='sudo chown -R $USER ./'
alias ls='ls --color=auto'
alias sl='tree -CF -L 5 --dirsfirst -I .git -I .vscode'
alias sla='sl -a'
alias grep='grep --color=auto'
# alias less='less -RFX'

if status is-interactive
    # envsource
    set -U fish_user_paths /usr/local/bin:/$HOME/go $fish_user_paths
    set -U fish_user_paths /usr/local/go/bin $fish_user_paths
    set -U fish_user_paths /usr/bin $fish_user_paths
    set -U fish_user_paths /snap/bin $fish_user_paths
end
