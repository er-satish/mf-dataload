FROM alpine:3.7

WORKDIR /app

RUN apk add --no-cache curl

COPY mfDataLoad.sh .

RUN chmod +x mfDataLoad.sh

ENTRYPOINT ["./mfDataLoad.sh"]

