FROM alpine:3.7

WORKDIR /app

RUN apk add --no-cache bash curl postgresql-client

COPY stocksDataLoad.sh .
COPY post-data-load.sql .

RUN chmod +x stocksDataLoad.sh
RUN chmod +x post-data-load.sql

ENTRYPOINT ["./stocksDataLoad.sh"]

