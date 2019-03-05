#!/bin/bash

rm -rf /opt/analytics-tracking-dev

cp -r /opt/analytics-tracking /opt/analytics-tracking-dev

cd /opt/analytics-tracking-dev

sudo sed -i 's/4200, 4201, 4202, 4203, 4204, 4205/5203/' /opt/analytics-tracking-dev/backend-python/Global_config.py


if [ $? -eq 0 ]
   then 
	echo "changed db host for test deploy"
   else 
        exit 1	   
fi 


oldpid=`sudo netstat -nalp | grep 0.0.0.0:5203 | awk {'print $7'} | cut -d "/" -f 1` 

if [ ! -z $oldpid ];

   then 
           sudo kill -9 $oldpid
   else 
           echo "old process not running"
fi           

cd /opt/analytics-tracking-dev/backend-python


sudo python3.6 run.py & >/dev/null 2>&1

#sudo /bin/bash  scripts/starttest.sh  >/dev/null 2>&1


sleep 5

echo "checking URL status"

shopt -s extglob # Required to trim whitespace; see below

while IFS=':' read key value; do
    # trim whitespace in "value"
    value=${value##+([[:space:]])}; value=${value%%+([[:space:]])}

    case "$key" in
        Server) SERVER="$value"
                ;;
        Content-Type) CT="$value"
                ;;
        HTTP*) read PROTO STATUS MSG <<< "$key{$value:+:$value}"
                ;;
     esac
done < <(curl -sI http://127.0.0.1:5203)
echo $STATUS
if [ "$STATUS" = "200" ]
then 
	echo "URL status is $STATUS"
	oldpid=`sudo netstat -nalp | grep 0.0.0.0:5203 | awk {'print $7'} | cut -d "/" -f 1` 

if [ ! -z $oldpid ]

   then 
           sudo kill -9 $oldpid
   else 
           echo "old process not running"
fi   

	
	exit 0 

else
        echo "URL status is $STATUS"
	exit 1
fi	