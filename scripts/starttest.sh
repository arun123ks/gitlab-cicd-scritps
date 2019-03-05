#!/bin/bash

oldpid=`sudo netstat -nalp | grep 5203 | awk {'print $7'} | cut -d "/" -f 1` 

if [ ! -z $oldpid ];

   then 
           sudo kill -9 $oldpid
   else 
           echo "old process not running"
fi           

cd /opt/analytics-tracking-dev/backend-python


sudo nohup python3.6 run.py &
exit 0