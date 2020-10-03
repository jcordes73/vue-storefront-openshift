FROM ubi8/nodejs-12

ENV VS_ENV=prod

WORKDIR /var/www

COPY . .

RUN dnf install -y git \
  && yarn install \
  && yarn build

COPY vue-storefront.sh /usr/local/bin/

RUN \
    chown -R 1001:0 /var/www && \
    chgrp -R 0 /var/www && \
    chmod -R g=u /var/www

EXPOSE 8080

USER 1001

CMD ["vue-storefront.sh"]
