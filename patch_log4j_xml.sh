#!/bin/sh

UPDATE_NAME=patch_log4j_xml
UPDATE_VERSION=1.0

VERIFIER_DIR=/opt/eurotech/esf/data/persistance/verification/
VERIFIER_PATH1=${VERIFIER_DIR}/${UPDATE_NAME}-${UPDATE_VERSION}.sh_verifier.sh
VERIFIER_PATH2=${VERIFIER_DIR}/${UPDATE_NAME}-${UPDATE_VERSION}_verifier.sh

if [ "$1" != "--no-deploy-v2" ]
then
  install -d ${VERIFIER_DIR}
  ln -sf /bin/false ${VERIFIER_PATH1}
  ln -sf /bin/false ${VERIFIER_PATH2}
fi

set -e

schedule_reboot() {
  trap '' HUP INT
  sleep 60
  /sbin/reboot
}

schedule_reboot &

for file in /opt/eurotech/esf/user/log4j.xml /opt/eurotech/esf/log4j/log4j.xml
do
  if ! [ -e ${file} ]
  then
    continue
  fi
  
  sed -i 's/[%]\(message\|msg\|m\)/%m{nolookups}/g' $file
done

if [ "$1" != "--no-deploy-v2" ]
then
  install -d ${VERIFIER_DIR}
  ln -sf /bin/true ${VERIFIER_PATH1}
  ln -sf /bin/true ${VERIFIER_PATH2}
fi
