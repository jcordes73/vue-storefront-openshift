FROM node:10-alpine

ENV VS_ENV prod

WORKDIR /var/www

COPY package.json ./
COPY yarn.lock ./

RUN apk add --no-cache --virtual .build-deps ca-certificates wget python make g++ \
  && apk add --no-cache git \
  && yarn install --no-cache \
  && apk del .build-deps

COPY docker/vue-storefront/vue-storefront.sh /usr/local/bin/

RUN \
    chown -R 1001:0 /var/www && \
    chgrp -R 0 /var/www && \
    chmod -R g=u /var/www

EXPOSE 8080

USER 1001

CMD ["vue-storefront.sh"]
