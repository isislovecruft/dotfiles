#!/bin/bash
###############################################################################
#
# boilerplate.sh
# --------------
# A simple utility to copy a file to a new location with a new name, and then
# immediately start editing it. For boilerplates.
#
# @author Isis Agora Lovecruft, 0x2cdb8b35
# @date 16 May 2012
# @version 0.0.1
#______________________________________________________________________________
# Changelog:
###############################################################################

if [[ "$#" != "2" ]]; then
    echo "Usage: ./boilerplate.sh <boilerplate_file> <new_file>"
else
    cp $1 $2
    emacs -nw $2
fi
