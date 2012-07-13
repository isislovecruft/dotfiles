#!/bin/bash

#echo Your external IP Adress is: 
lynx -dump http://www.whatismyip.com | awk '/Your\ IP\ Address\ Is\:/{print $5}'

