#!/bin/sh

docker image rm first-tedsearch:latest


docker rm -f first-ted-cont


new image  from mavn : embedash-ted-search:1.0
docker build -t first-tedsearch:latest  .


docker run -it --name first-ted-cont -dp 8087:9191 first-tedsearch:latest 

sleep 9

curl -i http://localhost:8087


