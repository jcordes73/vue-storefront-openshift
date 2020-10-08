FROM registry.redhat.io/ubi8/nodejs-12

ENV VS_ENV=prod

WORKDIR /opt/app-root/src

COPY . .
COPY vue-storefront.sh /usr/local/bin/
RUN chown -R 1001:0 /opt/app-root/src

USER 1001

RUN \
    npm install --global yarn \
    && yarn global add lerna \
    && git submodule add -b master https://github.com/DivanteLtd/vsf-default.git src/themes/default \
    && git submodule update --init --remote \
    && yarn install \
    && yarn add vue-gtm@2.2.0 -W \
    && yarn cache clean \
    && yarn add again -W \
    && lerna bootstrap \
    && yarn build \
    && yarn cache clean \
    && yarn cypress cache clear

EXPOSE 3000

CMD ["vue-storefront.sh"]
