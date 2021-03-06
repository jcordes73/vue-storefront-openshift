FROM registry.redhat.io/ubi8/nodejs-12

ENV VS_ENV=prod

WORKDIR /opt/app-root/src

COPY . .
COPY vue-storefront.sh /usr/local/bin/

RUN test -z "$NPM_MIRROR" || npm config set registry $NPM_MIRROR
RUN npm install --global yarn \
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

RUN chown -R 1001:0 /opt/app-root/src && chmod -R 777 /opt/app-root/src

EXPOSE 3000

USER 1001

CMD ["vue-storefront.sh"]
