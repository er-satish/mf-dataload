#! /bin/bash

echo "executing stocks data load script"
PGKEY="$1"
if [ -z "$PGKEY" ]; then
  echo "Please set a PGKEY environment variable" >&2
  exit 1
fi

export PGPASSWORD=$PGKEY;

today=`date +"%d%b%Y"`
tod="${today^^}"
echo "Today's formatted dat: $tod"
year=`date +"%Y"`
month=`date +"%b"`
mon="${month^^}"
fileName="cm"
fileName+=$tod
url="https://archives.nseindia.com/content/historical/EQUITIES/$year/$mon/"
fileName+="bhav.csv.zip"
echo "Going to download fileName: $fileName"
url+=$fileName

curl -O $url -H 'Connection: keep-alive' -H 'Accept: */*' -H 'X-Requested-With: XMLHttpRequest' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/79.0.3945.88 Safari/537.36' -H 'Sec-Fetch-Site: same-origin' -H 'Sec-Fetch-Mode: cors' -H 'Referer: https://www.nseindia.com/products/content/equities/equities/homepage_eq.htm' -H 'Accept-Encoding: gzip, deflate, br' -H 'Accept-Language: en-GB,en-US;q=0.9,en;q=0.8' -H 'Cookie: ak_bmsc=157BB0792946E1F70F308F4C5C3562A317CB3F0E17760000C502FD5D8C2BBA1B~plaSA8+sYKpDCCBlzhofjRzO15L8nmKYkhAARdugMJqbZuaGV/DFTw8siOfUWPnqtTlQkUqrO2muRZOQAyn8X53yQ7A+mqpkItY8yGy3LT6jWHgmvJvsBtqF+qMpqck11Vvhd6ocohtaytd8S0cImLT6xfiTSWvUc+BiT4xEyMXOSTtgMYFQO8cx2hgbpC1Ye4vp38No2vlyrSHtPBXOG2xKLRfREZNHLBYO3FEWwW1FGyY+tekHGYLOu8/aMhkZlMyX4NXrF3nbIOTrBCml9AEium8a0bt3Bh0LIv66r7hM8eoVUIpVytDJYtpOaOeSVcOKjPxSyBUR5LP6ZFKJL/uQ==; bm_mi=8311BA17388BE42CA7676139C7508B69~kDYc40TPBIRrOerfTya86b0FzyQ7Wwfb/ne5qKdi4eQ5ypVNw7I+9rygcsfPhZ+RNj5/cxbYzWlg/eNTx4HPNiTujF55BGWGj+8Py4rExyCN1qfZS3ocjpfcmcvXSyoYuA0AZ3BQxR5e0ACo7WkQZmTmWwlq9bxxf+KeQN1NcnRNJpgvCgJTlVOXiSsmO3seXgZjpQt+0RrgaRW2TOtjbQRLes01yVVFuVVycpDGH/A1cIh8dNq4YtWNgr8B4KNQU6RiSy2A0+czPxyhmbHPcw==; NSE-TEST-1=1977622538.20480.0000; RT="z=1&dm=nseindia.com&si=4a3440ed-dc6f-4314-b22d-dacaf1059540&ss=k4ef5wrl&sl=6&tt=xiu&bcn=%2F%2F684fc53d.akstat.io%2F&obo=1&nu=d65463751abcc57590e4373bbb93a7b9&cl=zhom"; bm_sv=9017DE3BA306A028A7FE8E2CD89194F6~yUEFQoNiC4XgLA3+LqyzVCfZn8f8ASvXbrpaEmfKnjkBTHpqDffKcRXvtR+jfkfgJMbgR77/Zy54DmtpZgUIzPw9rt9qS5oo50xnUMNjXmoeAZAs5mc0tLsL2AmPM9wkbFTy02xen91ce1/yJqRc35W53udCWLLh0mzs0TSpmC0=' --compressed 
unzip $fileName  -d .
newFileName=${fileName::-4}
echo "Going to load fileName: $newFileName to db"
psql -d awesomedb -h postgres-service -p 5432 -U amazinguser -c "\copy nav FROM './$newFileName' DELIMITER ',' CSV HEADER"
echo "data load is completed..going to insert record in main table"
psql -d awesomedb -h postgres-service =p 5432 -U amazinguser -f "./post-data-load.sql" -a
echo "post data load sql script execution is completed"

