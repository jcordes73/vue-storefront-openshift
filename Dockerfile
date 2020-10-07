FROM registry.redhat.io/ubi8/nodejs-12

ENV VS_ENV=prod

WORKDIR /opt/app-root/src

COPY . .

RUN \
    if [[ -n "$NPM_MIRROR" ]] npm set registry $NPM_MIRROR fi \
    npm install --global yarn \
    && yarn global add lerna \
    && git submodule add -b master https://github.com/DivanteLtd/vsf-default.git src/themes/default \
    && git submodule update --init --remote \
    && yarn install \
    && yarn add vue-gtm@2.2.0 -W \
    && yarn cache clean \
    && yarn add again -W \
    && yarn cache clean \
    && lerna bootstrap \
    && yarn build

COPY vue-storefront.sh /usr/local/bin/

RUN \
    chown -R 1001:0 /opt/app-root/src && \
    chgrp -R 0 /opt/app-root/src && \
    chmod -R g=u /opt/app-root/src

EXPOSE 3000

USER 1001

CMD ["vue-storefront.sh"]
