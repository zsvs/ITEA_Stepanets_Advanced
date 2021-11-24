FROM alpine:latest AS build

RUN apk update && apk add git npm

RUN git clone https://github.com/nodejs/nodejs.org.git
WORKDIR /nodejs.org

RUN npm install




FROM build AS builder
WORKDIR /nodejs_srv
RUN apk update && apk add npm

COPY --from=build /nodejs.org/build/ /build
COPY --from=build /nodejs.org/layouts/ /layouts
COPY --from=build /nodejs.org/locale/ /locale
COPY --from=build /nodejs.org/node_modules/ /node_modules
COPY --from=build /nodejs.org/scripts/ /scripts
COPY --from=build /nodejs.org/source/ /source
COPY --from=build /nodejs.org/static/ /static
COPY --from=build /nodejs.org/build.js /build.js
COPY --from=build /nodejs.org/package-lock.json /package-lock.json
COPY --from=build /nodejs.org/package.json /package.json
COPY --from=build /nodejs.org/server.js /server.js

CMD [ "npm", "start" ]