#!/bin/bash
alias cnpm="npm --registry=https://registry.npm.taobao.org \
--cache=$HOME/.npm/.cache/cnpm \
--disturl=https://npm.taobao.org/dist \
--userconfig=$HOME/.cnpmrc"
BASE_PATH=$(pwd)

echo "Install talk-api2x dependencies"

cd $BASE_PATH/talk-api2x && cnpm i --production

[[ $? -ne 0 ]] && exit $?

echo 'Install talk-web dependencies and build front-end assets'

cd $BASE_PATH/talk-web && cnpm i && cnpm run static

[[ $? -ne 0 ]] && exit $?

echo 'Install talk-account dependencies and build front-end assets'

cd $BASE_PATH/talk-account && cnpm i && cnpm run static

[[ $? -ne 0 ]] && exit $?

echo 'Install talk-snapper dependencies'

cd $BASE_PATH/talk-snapper && cnpm i --production

[[ $? -ne 0 ]] && exit $?

echo 'Install talk-os dependencies'

cd $BASE_PATH && cnpm i --production

[[ $? -ne 0 ]] && exit $?

exit 0
