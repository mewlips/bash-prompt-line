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

cols() {
    tput cols
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
move_right() {
    tput cuf1
}

theme_basic() {
    THEME_LINE_BG=234
    THEME_LINE=$(set_bg ${THEME_LINE_BG})$(set_fg ${THEME_LINE_BG})
    THEME_TIME=$(set_bg ${THEME_LINE_BG})$(set_fg blue)
    THEME_EXIT_NUM=$(bold)$(set_fg black)$(set_bg red)
    THEME_GIT_BRANCH=$(bold)$(set_bg ${THEME_LINE_BG})$(set_fg yellow)
    THEME_USER=$(bold)$(set_fg green)$(set_bg ${THEME_LINE_BG})
    THEME_AT=$(set_fg red)
    THEME_HOST=$(bold)$(set_fg blue)$(set_bg ${THEME_LINE_BG})
    THEME_PATH_SEP=$(reset_color)$(set_bg ${THEME_LINE_BG})$(set_fg white)
}

prompt_bg_line() {
    exit_num=$?
    if [ "$exit_num" != "0" ]; then
        exit_num="${THEME_EXIT_NUM}${exit_num}$(move_right)"
    else
        exit_num=
    fi

    date=$(date +%T)
    date_len=${#date}

    line=
    for i in $(seq $(( $(cols) - date_len)) ); do
        line="${line}_"
    done
    line="${THEME_LINE}${line}${THEME_TIME}${date}$(tput cr)${exit_num}$(reset_color)"
    echo -n $line
}

show_git_branch() {
    branch=$(git branch 2> /dev/null)
    if [ $? == 0 ]; then
        echo "${THEME_GIT_BRANCH} (on $(git branch | grep ^\* | cut -d ' ' -f 2)) $(reset_color)"
    fi
}

show_pwd() {
    local dir=$(pwd)
    local awesome_dir=
    local color=214
    if [ "$dir" == "/" ]; then
        awesome_dir="${THEME_PATH_SEP}/$(reset_color)"
    elif [ "$dir" == "$HOME" ]; then
        awesome_dir="$(set_fg $color)~$(reset_color)"
    else
        while [ "$dir" != "/" ]; do
            local dn="$(dirname "$dir")"
            local bn="$(basename "$dir")"
            awesome_dir="${THEME_PATH_SEP}/$(bold)$(set_fg $color)$bn$awesome_dir"
            color=$((color + 1))
            dir="$dn"
            if [ "$dir" == "$HOME" ]; then
                awesome_dir="$(set_fg $color)~$awesome_dir"
                break
            fi
        done
        awesome_dir="$awesome_dir$(reset_color)"
    fi
    echo $awesome_dir
}

theme_basic

PS1="\n\
\$(prompt_bg_line)\
${THEME_USER}\u\
${THEME_AT}@\
${THEME_HOST}\h\
$(move_right)\
\$(show_pwd)\
\$(show_git_branch)\n\
\$ "
