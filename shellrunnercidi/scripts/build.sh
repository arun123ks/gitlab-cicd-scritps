#!/bin/bash
rm -rf /opt/scripts/imagename.txt
dat=`date +"%Y%m%d%H%M%S"`
imagename=build$dat
echo $imagename > /opt/scripts/imagename.txt
cd /opt/build/
rm -rf *
git clone git@gitlab.com:sanjay.poongs/living-cost-estimator.git
cd living-cost-estimator
perl -pi -e "s/localhost/81.4.102.27/g;"  $(find /opt/build/living-cost-estimator/routes  -type f  -name  api_call.js)
perl -pi -e "s/localhost/81.4.102.27/g;"  $(find /opt/build/living-cost-estimator -type f  -name  pushToMongo.js)
docker build -t $imagename .
contid=`docker container ls | grep build |  awk {'print $1'}`
docker container rm -f $contid
docker run -d --name build -p 9333:5000 $imagename
