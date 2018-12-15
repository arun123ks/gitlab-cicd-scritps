#!/bin/bash
dat=`date +"%Y%m%d%H%M%S"`
imagename=`cat /opt/imagename.txt`
contid=`docker container ls | grep prod |  awk {'print $1'}`
docker container stop $contid
docker container rename prod oldprod$dat
docker run -d --name prod --mount source=searchenginestatic-vol,destination=/opt/searchengine/app/files \
        --mount source=searcheninelog-vol,destination=/opt/searchengine/Logs -p 80:80 $imagename
