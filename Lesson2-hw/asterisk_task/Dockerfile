FROM alpine:latest
WORKDIR /nodejs

RUN apk update && apk add git npm

RUN git clone https://github.com/nodejs/nodejs.org.git

COPY entrypoint.sh entrypoint.sh

RUN chmod u+x entrypoint.sh

CMD ["sh", "-c", "./entrypoint.sh"]