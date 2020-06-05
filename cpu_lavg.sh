#!/usr/bin/bash

# 20200604 by ds
# this script take one argument for sar report (sar -q)
# If there are more than 5 consecutive cpu load average occurrences, it will be reported at the end

SAFILE="/tmp/DSsafile"
SATEMP="/tmp/DSsatemp"
SATEMP2="/tmp/DSsatemp2"
COLOR=1

#### Color
RED='\e[31m'
GREEN='\e[32m'
YELLOW='\e[33m'
BLUE='\e[34m'
WHITE='\e[39m'

red () {
echo -e $RED`echo "$1"`$WHITE
}

green () {
echo -e $GREEN`echo "$1"`$WHITE
}

yellow () {
echo -e $YELLOW`echo "$1"`$WHITE
}

blue () {
echo -e $BLUE`echo "$1"`$WHITE
}

color_choose () {
if [[ $COLOR -eq 5 ]]; then
 COLOR=1
fi

case $COLOR in
1)
 red "$1"
 ;;
2)
 green "$1"
 ;;
3)
 yellow "$1"
 ;;
4)
 blue "$1"
 ;;
*)
 echo "Wrong Color Code"
 ;;
esac
}

function check_args () {
 if [[ $1 -eq 0 ]]; then 
  echo "Usage: a.sh sa.log"
  exit 0

 fi
}

function trim_input () {
 cat $1 | egrep -v "ldavg-1   ldavg-5" | egrep -v "LINUX|Average:|Linux" | sed '/^$/d' > $SAFILE
 touch $SATEMP $SATEMP2
}

function count_load () {
 while read line 
  do {
  LOAD1=`echo $line | awk '{print $5}'` 
  if [[ ${LOAD1%.*} -ge 10 ]]
  then
   color_choose "$line" >> $SATEMP
  else
   if [[ `cat $SATEMP | wc -l` -gt 5 ]]; then
    cat $SATEMP >> $SATEMP2
    clear_temp $SATEMP
    let "COLOR+=1"
   else
    if [[ `cat $SATEMP | wc -l` -ne 0 ]]; then
     clear_temp $SATEMP
    fi 
   fi
  fi
  } 
  done < $SAFILE
}
function clear_temp () {
 cat /dev/null > $1
}

function display () {
 cat $SATEMP2
}

function rm_temp () {
 rm -f $SAFILE $SATEMP $SATEMP2 
}

check_args $#
trim_input $1
count_load
display
rm_temp

