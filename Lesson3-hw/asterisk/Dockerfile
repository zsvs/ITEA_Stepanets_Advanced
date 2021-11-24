FROM alpine:latest AS Builder
WORKDIR /nodejs_build

RUN apk update && apk add git npm

RUN git clone https://github.com/nodejs/nodejs.org.git

RUN cd nodejs.org && npm install



FROM alpine:latest
WORKDIR /nodejs_srv

COPY --from=Builder /nodejs_build/build ./
COPY --from=Builder /nodejs_build/layouts ./
COPY --from=Builder /nodejs_build/locale ./
COPY --from=Builder /nodejs_build/node_modules ./
COPY --from=Builder /nodejs_build/scripts ./
COPY --from=Builder /nodejs_build/source ./
COPY --from=Builder /nodejs_build/static ./
COPY --from=Builder /nodejs_build/build.js ./
COPY --from=Builder /nodejs_build/package-lock.json ./
COPY --from=Builder /nodejs_build/package.json ./
COPY --from=Builder /nodejs_build/server.js ./

CMD [ "npm", "start" ]