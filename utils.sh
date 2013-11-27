#!/usr/bin/env bash

bpl_color_to_number() {
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

bpl_cols() {
    tput cols
}
bpl_bold() {
    tput bold
}
bpl_fg() {
    tput setaf $(bpl_color_to_number $1)
}
bpl_bg() {
    tput setab $(bpl_color_to_number $1)
}
bpl_reset() {
    tput sgr0
}
bpl_move_right() {
    tput cuf1
}
bpl_cr() {
    tput cr
}

bpl_theme_basic() {
    BPL_THEME_LINE_BG=234
    BPL_THEME_PWD_FG=214
    BPL_THEME_TIME=$(bpl_bg 24)$(bpl_fg 11)
    BPL_THEME_EXIT_NUM=$(bpl_bold)$(bpl_fg yellow)$(bpl_bg red)
    BPL_THEME_GIT_BRANCH=$(bpl_bold)$(bpl_bg ${BPL_THEME_LINE_BG})$(bpl_fg yellow)
    BPL_THEME_USER=$(bpl_bold)$(bpl_fg green)$(bpl_bg ${BPL_THEME_LINE_BG})
    BPL_THEME_AT=$(bpl_bg ${BPL_THEME_LINE_BG})$(bpl_bold)$(bpl_fg red)
    BPL_THEME_HOST=$(bpl_bold)$(bpl_fg blue)$(bpl_bg ${BPL_THEME_LINE_BG})
    BPL_THEME_PATH_SEP=$(bpl_reset)$(bpl_bg ${BPL_THEME_LINE_BG})$(bpl_fg white)
    BPL_THEME_APPLET=$(bpl_bg 238)$(bpl_fg 11)
}

bpl_theme_bg() {
    echo $(bpl_bg $BPL_THEME_LINE_BG)"$*"$(bpl_reset)
}
bpl_theme_time() {
    echo ${BPL_THEME_TIME}"$*"$(bpl_reset)
}
bpl_theme_exit_num() {
    echo ${BPL_THEME_EXIT_NUM}"$*"$(bpl_reset)
}
bpl_theme_git_branch() {
    echo ${BPL_THEME_GIT_BRANCH}"$*"$(bpl_reset)
}
bpl_theme_user() {
    echo ${BPL_THEME_USER}"$*"$(bpl_reset)
}
bpl_theme_at() {
    echo ${BPL_THEME_AT}@$(bpl_reset)
}
bpl_theme_host() {
    echo ${BPL_THEME_HOST}"$*"$(bpl_reset)
}
bpl_theme_applet() {
    echo ${BPL_THEME_APPLET}"$*"$(bpl_reset)
}
