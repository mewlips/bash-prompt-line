#!/usr/bin/env bash

bpl-color-to-number() {
    case "$1" in
        "black")   echo 0;;
        "red")     echo 1;;
        "green")   echo 2;;
        "yellow")  echo 3;;
        "blue")    echo 4;;
        "magenta") echo 5;;
        "cyan")    echo 6;;
        "white")   echo 7;;
        *)         echo $1;;
    esac
}

bpl-cols() {
    tput cols
}
bpl-bold() {
    tput bold
}
bpl-fg() {
    tput setaf $(bpl-color-to-number $1)
}
bpl-bg() {
    tput setab $(bpl-color-to-number $1)
}
bpl-reset() {
    tput sgr0
}
bpl-move-right() {
    tput cuf1
}
bpl-cr() {
    tput cr
}

bpl-theme-basic() {
    BPL_THEME_LINE_BG=234
    BPL_THEME_LINE=$(bpl-bg ${BPL_THEME_LINE_BG})$(bpl-fg ${BPL_THEME_LINE_BG})
    BPL_THEME_TIME=$(bpl-bg 24)$(bpl-fg 11)
    BPL_THEME_EXIT_NUM=$(bpl-bold)$(bpl-fg black)$(bpl-bg red)
    BPL_THEME_GIT_BRANCH=$(bpl-bold)$(bpl-bg ${BPL_THEME_LINE_BG})$(bpl-fg yellow)
    BPL_THEME_USER=$(bpl-bold)$(bpl-fg green)$(bpl-bg ${BPL_THEME_LINE_BG})
    BPL_THEME_AT=$(bpl-bg ${BPL_THEME_LINE_BG})$(bpl-bold)$(bpl-fg red)
    BPL_THEME_HOST=$(bpl-bold)$(bpl-fg blue)$(bpl-bg ${BPL_THEME_LINE_BG})
    BPL_THEME_PATH_SEP=$(bpl-reset)$(bpl-bg ${BPL_THEME_LINE_BG})$(bpl-fg white)
    BPL_THEME_PWD_COLOR=214
    BPL_THEME_APPLET=$(bpl-bg 19)$(bpl-fg 11)
}

bpl-theme-line() {
    echo ${BPL_THEME_LINE}"$*"$(bpl-reset)
}
bpl-theme-time() {
    echo ${BPL_THEME_TIME}"$*"$(bpl-reset)
}
bpl-theme-exit_num() {
    echo ${BPL_THEME_EXIT_NUM}"$*"$(bpl-reset)
}
bpl-theme-git_branch() {
    echo ${BPL_THEME_GIT_BRANCH}"$*"$(bpl-reset)
}
bpl-theme-user() {
    echo ${BPL_THEME_USER}"$*"$(bpl-reset)
}
bpl-theme-at() {
    echo ${BPL_THEME_AT}@$(bpl-reset)
}
bpl-theme-applet() {
    echo ${BPL_THEME_APPLET}"$*"$(bpl-reset)
}
