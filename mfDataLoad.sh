#! /bin/sh
echo "going to call the mf data load service"
today=`date +"%Y-%m-%d"`
echo "going to request mf data load for date:" $today
curl -i -H "Accept: application/json" -H "Content-Type: application/json" -X GET http://assetz-backend:8080/mfprice/$today

echo "successfully invoked mf data load service"
