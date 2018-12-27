#!/bin/sh

lftp -c "set ftp:ssl-allow no; open -u $USERNAME,$PASSWORD $HOST; mkdir -f /public_html/pumps/necawards/"

if [ $? -eq 0 ]
then  
     echo 1
else 
     echo 0
fi

