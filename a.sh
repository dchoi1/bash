#!/usr/bin/bash

SAFILE="/tmp/DSsafile"
SATEMP="/tmp/DSsatemp"

function trim_input () {
 cat $1 | egrep -v "ldavg-1   ldavg-5" | egrep -v "LINUX|Average:|Linux" | sed '/^$/d' > $SAFILE
}

function count_load () {
 while read line 
  do 
  LOAD1=`echo $line | awk '{print $5}'` 
  if [[ $LOAD1 -gt 10 ]]
  the
   
}
trim_input $1
