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
        #echo "$(bpl-cr)$(tput cuu1)$(bpl-theme-time $(date +%T)) \$ $BASH_COMMAND"
        bpl_last_time="$(date +%s.%N)"
        bpl_last_cmd="${BASH_COMMAND%% *}"
    else
        bpl_last_time=
    fi
}

push_dir() {
    if [[ ${bpl_dir_list[bpl_dir_idx]} != $PWD ]]; then
        bpl_dir_list[++bpl_dir_idx]="$PWD"
    fi
}

list_dir() {
    for idx in $(seq $bpl_dir_idx); do
        echo "[$idx] ${bpl_dir_list[$idx]}"
    done
}

PROMPT_COMMAND="${BPL_TITLE}; push_dir; trap 'bpl-print-command; trap DEBUG' DEBUG"

bpl-show-return() {
    exit_num=$?
    if [[ $exit_num -ne 0 ]]; then
        echo $(bpl-theme-exit_num ${exit_num})
    fi
}

bpl-show-bg-line() {
    local applet_len=0
    if [[ -n $bpl_last_time ]]; then
        local curr_time=$(date +%s.%N)
        local time_elasped=$(                                        \
            awk "BEGIN {                                             \
                t = $curr_time - $bpl_last_time;                     \
                if (t < 60) {                                        \
                    printf \"%0.3f\", t                              \
                } else if (t < 3600) {                               \
                    printf \"%d:%06.3f\", t/60, t%60                 \
                } else {                                             \
                    printf \"%d:%02d:%06.3f\", t/3600, t/60%60, t%60 \
                }                                                    \
            }")
        local cmd_time=" $bpl_last_cmd (${time_elasped}) "
        local applet_len=$((applet_len + ${#cmd_time}))
        local applet="$(bpl-theme-applet "$cmd_time")"
    fi

    local date=" $(date +%H:%M) "
    applet_len=$((applet_len + ${#date}))
    local applet="${applet}$(bpl-theme-time "$date")"

    local line=
    for i in $(seq $(( $(bpl-cols) - applet_len)) ); do
        line="${line} "
    done
    line="${line}${applet}"
    bpl-theme-bg "$line$(bpl-cr)"
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
    local color=${BPL_THEME_PWD_FG}
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
        awesome_dir="$awesome_dir"
    fi
    echo $(bpl-theme-bg "$awesome_dir")
}

bpl-show-user() {
    local user=$1
    bpl-theme-user "${user}"
}

bpl-show-at() {
    echo ${BPL_THEME_AT}@
}

bpl-show-host() {
    local host=$1
    bpl-theme-host "${host}"
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
