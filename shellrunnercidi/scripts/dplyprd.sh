#!/bin/bash
imagename=`cat /opt/scripts/imagename.txt`
contid=`docker container ls | grep prod |  awk {'print $1'}`
docker container rm -f $contid
docker run -d --name prod -p 80:5000 $imagename
