FROM node:10-alpine

ENV VS_ENV prod

WORKDIR /var/www

COPY package.json ./
COPY tsconfig-build.json ./
COPY core ./

RUN apk add --virtual .build-deps ca-certificates wget python make g++ \
  && apk add git \
  && yarn install --network-timeout 1000000 \
#  && yarn run build --verbose \
  && yarn run \
  && apk del .build-deps

COPY vue-storefront.sh /usr/local/bin/

RUN \
    chown -R 1001:0 /var/www && \
    chgrp -R 0 /var/www && \
    chmod -R g=u /var/www

EXPOSE 8080

USER 1001

CMD ["vue-storefront.sh"]
