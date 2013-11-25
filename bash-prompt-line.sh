#!/usr/bin/env bash

if [[ $COLORTERM = gnome-* && $TERM = xterm ]] && infocmp gnome-256color >/dev/null 2>&1; then
    export TERM=gnome-256color
elif [[ $TERM != dumb ]] && infocmp xterm-256color >/dev/null 2>&1; then
    export TERM=xterm-256color
fi

case ${TERM} in
    xterm*|rxvt*|Eterm*|aterm|kterm|gnome*|interix)
        BPL_TITLE='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/~}\007"'
        ;;
    screen*)
        BPL_TITEL='echo -ne "\033_${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/~}\033\\"'
        ;;
esac

BASH_PROMPT_LINE_UTILS_SCRIPT="$(dirname $(readlink ~/.bash-prompt-line))/utils.sh"
source "$BASH_PROMPT_LINE_UTILS_SCRIPT"

bpl-print-command() {
    if ! [[ $BASH_COMMAND =~ "$BPL_TITLE" ]]; then
        echo "$(bpl-cr)$(tput cuu1)[$(date +%T)] \$ $BASH_COMMAND"; echo
    else
        echo "$(bpl-cr)$(tput cuu1)$(tput cuu1)$(tput cuu1)$(tput cuu1)"
    fi
}

PROMPT_COMMAND="${BPL_TITLE}; trap 'bpl-print-command; trap DEBUG' DEBUG"

bpl-show-return() {
    exit_num=$?
    if [[ $exit_num -ne 0 ]]; then
        echo $(bpl-theme-exit_num ${exit_num})
    fi
}

bpl-show-bg-line() {
    date=$(date +%T)
    date_len=${#date}

    line=
    for i in $(seq $(( $(bpl-cols) - date_len)) ); do
        line="${line} "
    done
    line="${line}$(bpl-theme-time ${date})$(bpl-cr)"
    bpl-theme-line "$line"
}

bpl-show-git-branch() {
    branch=$(git branch 2> /dev/null)
    if [[ $? -eq 0 ]]; then
        bpl-theme-git_branch "($(git branch | grep ^\* | cut -d ' ' -f 2-))"
    fi
}

bpl-show-pwd() {
    local dir=$(pwd)
    local awesome_dir=
    local color=${BPL_THEME_PWD_COLOR}
    if [[ $dir = "/" ]]; then
        awesome_dir="${BPL_THEME_PATH_SEP}/$(bpl-reset)"
    elif [[ $dir = $HOME ]]; then
        awesome_dir="$(bpl-fg $color)~$(bpl-reset)"
    else
        while [[ $dir != / ]]; do
            local dn="$(dirname "$dir")"
            local bn="$(basename "$dir")"
            awesome_dir="${BPL_THEME_PATH_SEP}/$(bpl-bold)$(bpl-fg $color)$bn$awesome_dir"
            color=$((color + 1))
            dir="$dn"
            if [[ $dir = $HOME ]]; then
                awesome_dir="$(bpl-fg $color)~$awesome_dir"
                break
            fi
        done
        awesome_dir="$awesome_dir$(bpl-reset)"
    fi
    echo $awesome_dir
}

bpl-show-user() {
    local user=$1
    bpl-theme-user ${user}
}

bpl-show-at() {
    echo ${BPL_THEME_AT}@
}

bpl-show-host() {
    local host=$1
    echo ${BPL_THEME_HOST}${host}
}

bpl-theme-basic

PS1_LINE_1="\
\$(bpl-show-return)\n"

PS1_LINE_2="\
\$(bpl-show-bg-line)\
\$(bpl-show-user \u)\
\$(bpl-show-at)\
\$(bpl-show-host \h)\
$(bpl-move-right)\
\$(bpl-show-pwd)\
$(bpl-move-right)\
\$(bpl-show-git-branch)\n"

PS1_LINE_3="\
\$ "

PS1=${PS1_LINE_1}${PS1_LINE_2}${BPL_PS1_LINE_ADDON}${PS1_LINE_3}
