FROM node:10-alpine

ENV VS_ENV prod

WORKDIR /var/www

COPY package.json ./
COPY yarn.lock ./
COPY tsconfig-build.json ./
COPY core ./

RUN apk add --no-cache --virtual .build-deps ca-certificates wget python make g++ \
  && apk add --no-cache git \
  && yarn install --network-timeout 1000000 --no-cache \
  && yarn run build \
  && apk del .build-deps

COPY vue-storefront.sh /usr/local/bin/

RUN \
    chown -R 1001:0 /var/www && \
    chgrp -R 0 /var/www && \
    chmod -R g=u /var/www

EXPOSE 8080

USER 1001

CMD ["vue-storefront.sh"]
