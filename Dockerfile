FROM docker:cli 

WORKDIR /app

COPY ./package/certimate .

ENTRYPOINT [ "./certimate", "serve", "--http", "0.0.0.0:8090" ]