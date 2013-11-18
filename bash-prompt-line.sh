#!/usr/bin/env bash

if [[ $COLORTERM = gnome-* && $TERM = xterm ]] && infocmp gnome-256color >/dev/null 2>&1; then
    export TERM=gnome-256color
elif [[ $TERM != dumb ]] && infocmp xterm-256color >/dev/null 2>&1; then
    export TERM=xterm-256color
fi

BASH_PROMPT_LINE_UTILS_SCRIPT="$(dirname $(readlink ~/.bash-prompt-line))/utils.sh"
source "$BASH_PROMPT_LINE_UTILS_SCRIPT"

show_return() {
    exit_num=$?
    if [[ $exit_num -ne 0 ]]; then
        echo ${THEME_EXIT_NUM}${exit_num}$(reset_color)
    fi
}

prompt_bg_line() {
    date=$(date +%T)
    date_len=${#date}

    line=
    for i in $(seq $(( $(cols) - date_len)) ); do
        line="${line} "
    done
    line="${THEME_LINE}${line}${THEME_TIME}${date}$(tput cr)$(reset_color)"
    echo -n "$line"
}

show_git_branch() {
    branch=$(git branch 2> /dev/null)
    if [[ $? -eq 0 ]]; then
        echo "${THEME_GIT_BRANCH} (on $(git branch | grep ^\* | cut -d ' ' -f 2-)) $(reset_color)"
    fi
}

show_pwd() {
    local dir=$(pwd)
    local awesome_dir=
    local color=214
    if [[ $dir = "/" ]]; then
        awesome_dir="${THEME_PATH_SEP}/$(reset_color)"
    elif [[ $dir = $HOME ]]; then
        awesome_dir="$(set_fg $color)~$(reset_color)"
    else
        while [[ $dir != / ]]; do
            local dn="$(dirname "$dir")"
            local bn="$(basename "$dir")"
            awesome_dir="${THEME_PATH_SEP}/$(bold)$(set_fg $color)$bn$awesome_dir"
            color=$((color + 1))
            dir="$dn"
            if [[ $dir = $HOME ]]; then
                awesome_dir="$(set_fg $color)~$awesome_dir"
                break
            fi
        done
        awesome_dir="$awesome_dir$(reset_color)"
    fi
    echo $awesome_dir
}

show_user() {
    local user=$1
    echo ${THEME_USER}${user}
}

show_at() {
    echo ${THEME_AT}@
}

show_host() {
    local host=$1
    echo ${THEME_HOST}${host}
}

theme_basic

PS1_LINE_1="\
\$(show_return)\n"

PS1_LINE_2="\
\$(prompt_bg_line)\
\$(show_user \u)\
\$(show_at)\
\$(show_host \h)\
$(move_right)\
\$(show_pwd)\
\$(show_git_branch)\n"

PS1_LINE_3="\
\$ "

PS1=${PS1_LINE_1}${PS1_LINE_2}${PS1_LINE_ADDON}${PS1_LINE_3}
