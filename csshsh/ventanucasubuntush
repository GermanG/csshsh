#!/bin/bash

 set -x

OFFSET=0
VOFFSET=30
ANCHO=1280
ALTO=1024

function reacomodo()
{
  cv=$1
  shift 
  cc=`echo "sqrt($cv)" | bc`
  let cf=cv/cc
  let resto=cv%cc
  if [ $resto -gt 0 ]
  then
    let cf++
    let resto=(cf*cc)-cv
  fi
  let anv=$ANCHO/cc
  let alv=($ALTO-84)/cf
  let alv_r=alv-25
  let anv_r=anv-10

  let cc=cc-1
  let cf=cf-1
  for col in `seq 0 $cc`
  do
    if [ $col -eq $cc ]
    then
       let tmp=cf+1-resto
       let alv=($ALTO-84)/tmp
       let alv_r=alv-25
    fi 
    for fil in `seq 0 $cf`
    do
       let columna=(col*anv)+$OFFSET
       let fila=(fil*alv)+$VOFFSET
       # echo wmctrl -ir $1 -e 0,$columna,$fila,$anv_r,$alv_r
       wmctrl -ir $1 -e 0,$columna,$fila,$anv_r,$alv_r
       shift
    done
  done
}


while getopts o:x:h c
do 
  case $c in
   o)   OFFSET=$OPTARG;;
   x)	DIMENSIONS=$OPTARG;
	ALTO=`echo $DIMENSIONS | awk -F"x" '{print $2}'`;
	ANCHO=`echo $DIMENSIONS | awk -F"x" '{print $1}'`;;
   h)   echo '-o OFFSET';
	echo '-x <ANCHOxALTO> / dimensiones';
	exit;;
  esac
done


ppid=`ps -ef | mawk '/cssh/&&/perl/&&!/awk/{print $2}'`
#ppid=`ps -ef | awk '/cssh/&&/perl/&&!/awk/{print $2}'`
cant_ppid=`echo $ppid | wc -w`
echo $cant_ppid
let x_ppid=ANCHO-197+OFFSET
let y_ppid=ALTO-81
v_ppid=`wmctrl -lp | gawk '$3==0&&/CSSH/{print $1}'`
for i in $ppid
do
  #pids=`ps -ef | mawk 'BEGIN{printf"(";pipe=""}$3=="'$i'"{printf("%s$3==\"%s\"",pipe,$2);pipe="||"}END{printf")"}'`
  buggypids=`ps -ef | awk 'BEGIN{printf"(";pipe=""}$3=="'$i'"{printf("%s$3==\"%s\"",pipe,$2);pipe="||"}END{printf")"}'`
  pids=`ps -ef | awk 'BEGIN{printf"(";pipe=""}'$buggypids'{printf("%s$3==\"%s\"",pipe,$2);pipe="||"}END{printf")"}'`
   echo wmctrl -lp \| mawk ''$pids'{print $1}'
  #echo wmctrl -lp \| awk ''$pids'{print $1}'
   ventanas=`wmctrl -lp | sort -k3 -n | gawk ''$pids'{print $1}'`
  #ventanas=`wmctrl -lp | sort -k3 -n | awk ''$pids'{print $1}'`
  cv_=`echo $ventanas | wc -w`
  echo "*******************************************"
  echo pids $pids
  echo "*******************************************"

  printf "ps :"

  ps -fp $i

  echo VENTANA PPID : $v_ppid
  echo VENTANAS : $cv_

   wmctrl -ir $v_ppid -e 0,$x_ppid,$y_ppid,184,55

  if [ $cv_ > 4 ]
  then 
    reacomodo $cv_ $ventanas
  fi


done 

for i in $v_ppid
do
  wmctrl -ir $i -e 0,$x_ppid,$y_ppid,184,55
done
