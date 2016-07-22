FROM mhart/alpine-node:6.3

RUN mkdir -p /src
WORKDIR /src
ADD . .

RUN apk add --no-cache make gcc g++ python \
  && npm install \
  && npm run build

EXPOSE 3000

CMD npm run start
