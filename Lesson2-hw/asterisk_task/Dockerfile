FROM alpine:latest
WORKDIR /myapp

RUN apk update && apk add git npm

COPY entrypoint.sh /bin/entrypoint.sh

RUN chmod u+x /bin/entrypoint.sh

VOLUME /myapp

CMD entrypoint.sh