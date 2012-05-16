#!/bin/sh
# Shell script that return $1+ or $1- weither Mutt version is greater or
# equal than $1
# (c) 2004, Luc Hermitte
mutt_ver=`mutt -v | head -1 | cut -d "+" -f 1 | cut -d " " -f 2`
if [ $# -eq 3 ] ; then
    res_true=$2
    res_false=$3
else
    res_true="$1+"
    res_false="$1-"
fi

if [ `expr "$mutt_ver" ">=" "$1"` -gt 0  ] ; then
    echo "$res_true"
else
    echo "$res_false"
fi
