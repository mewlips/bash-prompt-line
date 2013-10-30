#!/bin/bash

c2n() {
    case "$1" in
        "black")   echo 0;;
        "red")     echo 1;;
        "green")   echo 2;;
        "yellow")  echo 3;;
        "blue")    echo 4;;
        "magenta") echo 5;;
        "cyan")    echo 6;;
        "white")   echo 7;;
        "BLACK")   echo 8;;
        "RED")     echo 9;;
        "GREEN")   echo 10;;
        "YELLOW")  echo 11;;
        "BLUE")    echo 12;;
        "MAGENTA") echo 13;;
        "CYAN")    echo 14;;
        "WHITE")   echo 15;;
        *)         echo $1;;
    esac
}

bold() {
    tput bold
}

set_fg() {
    tput setaf $(c2n $1)
}

set_bg() {
    tput setab $(c2n $1)
}
reset_color() {
    tput sgr0
}

prompt_bg_line() {
    exit_num=$?
    if [ "$exit_num" != "0" ]; then
        exit_num="$(bold)$(set_fg RED)$exit_num"
    else
        exit_num=
    fi

    cols=$(tput cols)
    line="$(set_bg 234)$(set_fg 234)"
    for i in $(seq $cols); do
        line="${line}_"
    done
    line="${line}$(tput cr)$exit_num$(reset_color)"
    echo -n $line
}

move_right() {
    tput cuf1
}

show_git_branch() {
    branch=$(git branch 2> /dev/null)
    if [ $? == 0 ]; then
        echo "$(set_fg YELLOW)$(bold)$(git branch | cut -d ' ' -f 2) $(reset_color)"
    fi
}

P_USER=$(echo $(set_fg GREEN)$(set_bg 234)$(bold)$USER)
P_USER_LEN=${#USER}
P_AT=$(echo $(set_fg RED)$(set_bg 234)@)
P_HOST=$(echo $(set_fg BLUE)$(set_bg 234)$(bold)$HOSTNAME)
P_HOST_LEN=${#HOSTNAME}
P_PWD="$(echo $(set_fg 51)$(set_bg 31)\\w$(reset_color))"
P_SEP="$(echo $(set_fg WHITE)$(bold))|"

show_pwd() {
    local dir=$(pwd)
    local awesome_dir=
    local color=100
    while [ "$dir" != "/" ]; do
        local dn=$(dirname "$dir")
        local bn=$(basename "$dir")
        awesome_dir="$(set_fg WHITE)/$(set_fg $color)$bn$awesome_dir"
        color=$((color + 1))
        dir=$dn
    done
    awesome_dir="$(set_bg 234)$awesome_dir$(reset_color)"
    echo $awesome_dir
}

PS1="\$(prompt_bg_line)$(move_right)$P_SEP$P_USER$P_AT$P_HOST$P_SEP$(move_right)\$(show_pwd)\n\$(show_git_branch)$(bold)\$$(reset_color) "
