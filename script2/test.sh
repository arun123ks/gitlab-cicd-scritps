#!/bin/bash
#curl -v -s  http://81.4.102.27:9333 1> /dev/null
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
done < <(curl -sI http://35.244.116.74:9333)
#echo $STATUS
if [ "$STATUS"="200" ]
then 
	echo 0
	exit 0 

else
        echo 1
	exit 1
fi	
#echo $SERVER
#echo $CT
