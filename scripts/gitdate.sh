#!/bin/bash 
#___________________________________________________________________
# Git Nowhere
#-------------------------------------------------------------------
#
# Use: Run as "$ . ./gitdate.sh" before "$ git commit" to manually set
# the date to GMT in order to obscure timezone-based geodata tracking.
#
# @author Isis Lovecuft, 0x2CDB8B35 isis@patternsinthevoid.net
# @ v0.0.1
#___________________________________________________________________

DAY=$(date | cut -d ' ' -f 1)
MONTH=$(date | cut -d ' ' -f 2)
DATE=$(date | cut -d ' ' -f 3)
TIME=$(date | cut -d ' ' -f 5)
TIMEZONE="+0000"
YEAR=$(date | cut -d ' ' -f 7)
HOUR=$(echo "$TIME" | cut -d ':' -f 1)
MINUTE=$(echo "$TIME" | cut -d ':' -f 2)
SECOND=$(echo "$TIME" | cut -d ':' -f 3)

# Git uses the system time settings through mktime().  Do a "$ git
# log" to see the timezone offset for your system.  This script
# assumes -0700. For example, if "$ git log" says your timezone is
# -0500, you would change all occurences in the next code block of "7"
# to "5" and change "17" to "19".

TIMEOFFSET=7

if [ "$HOUR" -lt "17" ]; then
    let HOUR+=7
else
    let TILMIDNIGHT=24-HOUR
    let FALSEDAWN=TIMEOFFSET-TILMIDNIGHT
    let HOUR=FALSEDAWN
fi

# If the hour is one digit, prepend a zero.

if [ "${#HOUR}" -eq "1" ]; then
    HOUR=$(printf "%02d" $HOUR)
fi 

export GIT_AUTHOR_DATE=$(echo "$DAY $MONTH $DATE $HOUR:$MINUTE:$SECOND $YEAR $TIMEZONE")
export GIT_COMMITTER_DATE=$GIT_AUTHOR_DATE
