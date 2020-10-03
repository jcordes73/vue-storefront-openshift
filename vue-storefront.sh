#!/bin/sh
set -e

yarn install --verbose || exit $?

if [ "$VS_ENV" = 'dev' ]; then
  yarn dev
else
  yarn build || exit $?
  yarn start
fi
