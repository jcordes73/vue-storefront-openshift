FROM registry.redhat.io/ubi8/nodejs-12

ENV VS_ENV=prod

WORKDIR /var/www

COPY . .

RUN npm install --global yarn \
  && yarn global add lerna \
  && git submodule add -b master https://github.com/DivanteLtd/vsf-default.git src/themes/default \
  && git submodule update --init --remote \
  && yarn install \
  && year add add vue-gtm@2.2.0 \
  && yarn cache clean \
  && yarn install again \
  && lerna bootstrap \
  && yarn build

COPY vue-storefront.sh /usr/local/bin/

RUN \
    chown -R 1001:0 /var/www && \
    chgrp -R 0 /var/www && \
    chmod -R g=u /var/www

EXPOSE 8080

USER 1001

CMD ["vue-storefront.sh"]
