#!/bin/bash
function bar()
{
    i=0
    idx=0
    str=''
    arr=('|' '/' '-' '\\')
    while [ $i -le 100 ]
    do
        printf "\e[1;46;31m[%-100s]\e[42;30m[%d%%]\e[40;41;43;30m%c\e[0m\\r" "$str" "$i" "${arr[$idx]}"
        let i++
        str+='#'
        let idx++
        let idx=idx%4
        usleep 100000
    done
    printf '\n'
}
bar
