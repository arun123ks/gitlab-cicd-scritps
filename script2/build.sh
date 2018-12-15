#!/bin/bash
#rm -rf /home/gitlab-runner/scripts/imagename.txt
dat=`date +"%Y%m%d%H%M%S"`
imagename=build$dat
echo $imagename > /opt/imagename.txt
#cd /home/gitlab-runner/build/
#rm -rf *
#git clone git@gitlab.com:khemistry/searchengine.git
#cd searchengine
docker build -t $imagename .
contid=`docker container ls | grep build |  awk {'print $1'}`
docker container rm -f $contid
docker run -d --name build$dat -p 9333:80 $imagename 
