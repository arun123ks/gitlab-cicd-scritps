#!/bin/bash
# Written by Aroon Mishra###
echo $pwd

sudo rm -rf /opt/analytics-tracking

sudo cp -r $CI_PROJECT_DIR /opt/

if [ $? -eq 0 ]
   then 
	echo "latest files are copied succesffuly to test deploy"
   else 
        exit 1	   
fi 

cd /opt/analytics-tracking/backend-python

sudo npm install react-scripts
sudo npm audit fix
sudo npm run  build

