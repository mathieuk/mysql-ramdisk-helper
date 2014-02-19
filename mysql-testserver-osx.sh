#!/bin/bash

##################################
# CONFIGURE THIS                 #
##################################
RAMDISK_SIZE=256
RAMDISK_NAME="MyRamdisk"

MYSQL_ROOTPW="secret"
MYSQL_SOCKET=/tmp/myramdisk.sock
MYSQL_CONFIG=/tmp/myramdisk.cnf

MYSQLD=`which mysqld`
BASEDIR=`dirname $MYSQLD`/..
DATADIR=/Volumes/$RAMDISK_NAME/mysql
USER=`whoami`

##################################
# NO NEED TO TOUCH THIS          #
##################################

cleanup()
{
	PID=`cat $DATADIR/*.pid`
	echo "Asking MySQL ($PID) to quit"
	kill -TERM $PID

	echo "hold on....";
	sleep 4

	rm $MYSQL_CONFIG
	rm $MYSQL_SOCKET

	echo "Unmounting /Volumes/$RAMDISK_NAME"
	hdiutil detach /Volumes/$RAMDISK_NAME

	echo "Hope you had a pleasant flight. Good day."
	return $?
}

control_c()
{
	echo -en "\n*** Ouch! Exiting ***\n"
	cleanup
	exit $?
}

SCRIPTPATH=$(cd `dirname $0` && pwd)

# Setup ramdisk
RAMDISK_BLOCKS=$((2048*$RAMDISK_SIZE))
diskutil erasevolume HFS+ "$RAMDISK_NAME" `hdiutil attach -nomount ram://$RAMDISK_BLOCKS` &> /dev/null

if [ $? != "0" ]; then
	echo "Could not create ramdisk."
	exit 1
fi

mkdir $DATADIR

# Prepare a my.cnf
cat ${SCRIPTPATH}/my.cnf.tpl | sed "s|%DATADIR%|$DATADIR|g;s|%SOCKET%|$MYSQL_SOCKET|;s|%USER%|$USER|" > $MYSQL_CONFIG

# Configure & startup mysql instance
$BASEDIR/scripts/mysql_install_db --defaults-file=$MYSQL_CONFIG --basedir=$BASEDIR --datadir=$DATADIR
$BASEDIR/bin/mysqld_safe --defaults-file=$MYSQL_CONFIG --basedir=$BASEDIR &
sleep 2
echo "STARTED MYSQL"
$BASEDIR/bin/mysqladmin --defaults-file=$MYSQL_CONFIG -u root password "$MYSQL_ROOTPW"

trap control_c SIGINT
wait

