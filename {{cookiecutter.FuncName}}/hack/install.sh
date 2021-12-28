#!/bin/sh
set -e

WORKDIR="/tmp/awsinstall"
INSTALL_DIR="/usr/local/aws-cli"
BIN_DIR="/usr/local/bin"

# clean work dir
if [ -d $WORKDIR ]; then
    rm -rf ${WORKDIR}
fi

mkdir -p ${WORKDIR}

# install aws cli
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "${WORKDIR}/awscliv2.zip"
unzip ${WORKDIR}/awscliv2.zip -d ${WORKDIR}

${WORKDIR}/aws/install --update -i ${INSTALL_DIR} -b ${BIN_DIR}

# clean up
rm -rf ${WORKDIR}