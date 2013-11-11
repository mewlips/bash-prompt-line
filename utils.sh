#!/usr/bin/env bash

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

