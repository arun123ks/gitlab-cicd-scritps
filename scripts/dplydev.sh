#!/bin/bash
##dat=`date +%Y-%m-%d_%H-%M`
oldpid=`sudo netstat -nalp | grep 0.0.0.0:4203 | awk {'print $7'} | cut -d "/" -f 1` 

if [ ! -z $oldpid ];

   then 
           sudo kill -9 $oldpid
   else 
           echo "old process not running"
fi           
rm -rf /var/www/analytics-tracking-old
sudo service cron stop
sudo mv /var/www/analytics-tracking /var/www/analytics-tracking-old
sudo cp -r /opt/analytics-tracking /var/www/
if [ $? -eq 0 ]
   then 
	echo "latest files are copied succesffuly to prod deploy"
   else 
        exit 1	   
fi 

sudo service cron start
sleep 90
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
done < <(curl -sI http://127.0.0.1:4203)
echo $STATUS
if [ "$STATUS" = "200" ]
then 
	echo 0
	exit 0 

else
        echo 1
	exit 1
fi	

