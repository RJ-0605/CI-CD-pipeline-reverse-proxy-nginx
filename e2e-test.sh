#!/bin/bash

echo "runnning e2e tests"

# curl  http://ec2-54-189-152-118.us-west-2.compute.amazonaws.com:8087/api/search?q=rent

# declare search list

SEARCHLIST=("rent" "loud" "hear" "again" "together")

# ip_value=$1

ip_value=$(head -n1 ip_test.txt)

for search in ${SEARCHLIST[@]}; do

    sleep 5
    echo $search
    curl "http://$ip_value:8083/api/search?q=$search"
    

done

