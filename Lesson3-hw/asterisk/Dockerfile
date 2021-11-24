FROM alpine:latest AS build

WORKDIR /myapp

RUN apk update && apk add git npm

RUN git clone https://github.com/nodejs/nodejs.org.git

RUN cd nodejs.org/ && npm install




FROM alpine:latest
RUN apk update && apk add npm

COPY --from=build /myapp/nodejs.org/layouts/ /layouts/
COPY --from=build /myapp/nodejs.org/locale/ /locale/
COPY --from=build /myapp/nodejs.org/node_modules /node_modules/
COPY --from=build /myapp/nodejs.org/scripts/ /scripts/
COPY --from=build /myapp/nodejs.org/source/ /source/
COPY --from=build /myapp/nodejs.org/static/ /static/
COPY --from=build /myapp/nodejs.org/build.js /build.js
COPY --from=build /myapp/nodejs.org/package-lock.json /package-lock.json
COPY --from=build /myapp/nodejs.org/package.json /package.json
COPY --from=build /myapp/nodejs.org/server.js /server.js

CMD [ "npm", "start" ]