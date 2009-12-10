#!/bin/bash

#set -x 

#We need some default definitions
HOST_N=1
STAY_TAXI="no"
USE_TAXI="no"
CONSOLA="no"
VENTANUCAS="si"
PROXY="no"
_SSH_USER="sysop"
PATH_ENV=~/bin/:$PATH_ENV
TAXI_SERVER=10.0.0.102
MAXHOSTS=35

#csshshrc its a way to alter 
. ~/.csshshrc

[ -z "$TAXI_USER" ] && TAXI_USER=$_SSH_USER

while getopts t:q:u:n:x:o:cdvhpi c
do
  case $c in
     u)       _SSH_USER=$OPTARG;;
     q)       TAXI_USER=$OPTARG;;
     n)       HOST_N=$OPTARG;;
     x)       DIMENSIONS=" -x $OPTARG";;
     o)       OFFSET=" -o $OPTARG";;
     c)       CONSOLA="si";;
     v)       VENTANUCAS="no";;
     d)       STAY_TAXI="si";
              USE_TAXI="si";;
     i)       USE_TAXI="si";;
     t)       TAXI_SERVER=$OPTARG;
              USE_TAXI="si";;
     p)       PROXY="si";;
     h)       echo '-u <user> default: '$_SSH_USER;
              echo '-n <cantidad de veces>';
	      echo '-d / quedarse en taxi ';
	      echo '-c / usar consola';
	      echo '-v / NO usar ventanucas';
	      echo '-p / usar proxy';
	      echo '-i / usar taxi default: '$TAXI_SERVER;
	      echo '-t <taxi> / usar taxi <taxi> ';
	      echo '-q <user> / taxi user ';
	      echo '-x <ANCHOxALTO> / dimensiones';
	      echo '-o OFFSET ';
	      exit;;
  esac
done

echo stay taxi: $STAY_TAXI
export STAY_TAXI CONSOLA PROXY _SSH_USER USE_TAXI PATH_ENV TAXI_USER TAXI_SERVER

shift `expr $OPTIND - 1`

if [ -f $1 ] 
then
HOSTS_TMP=`cat $1`
  if [ $(cat $1 | wc -w ) -gt $MAXHOSTS ]
  then
    echo "too many hosts (MAX $MAXHOSTS)"
    exit 1
  fi
else
HOSTS_TMP=$*
fi

HOSTS_TMP=`echo $HOSTS_TMP | sed -e 's/,/ /g' -e 's/and/ /g'`

for i in `echo ${HOST_N} | awk '{for(i=1;i<=$1;i++) print i;}'`
do
  HOSTS="${HOSTS} ${HOSTS_TMP}"
done


nohup cssh ${HOSTS} &

# deprecated by awesome (awesome!)
#if [ "$VENTANUCAS" == "si" ]
#then
#  echo enter para ventanucas
#  read coso
#  ventanucas2.sh $DIMENSIONS $OFFSET
#fi

