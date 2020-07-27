#!/bin/bash

CONFIG_FILEPATH=${CONFIG_FILEPATH:="/etc/mongod.conf.orig"}

if [[ $B64_SSL_PEM_KEY && $SSL_PEM_KEYFILE_PATH ]]; then
  mkdir -p $(dirname $SSL_PEM_KEYFILE_PATH)
  echo $B64_SSL_PEM_KEY | base64 --decode >> "$SSL_PEM_KEYFILE_PATH"
fi

if [[ $B64_SSL_CLUSTER && $SSL_CLUSTER_FILEPATH ]]; then
  mkdir -p $(dirname $SSL_CLUSTER_FILEPATH)
  echo $B64_SSL_CLUSTER | base64 --decode >> "$SSL_CLUSTER_FILEPATH"
fi

if [[ $B64_SSL_CA && $SSL_CA_FILEPATH ]]; then
  mkdir -p $(dirname $SSL_CA_FILEPATH)
  echo $B64_SSL_CA | base64 --decode >> "$SSL_CA_FILEPATH"
fi

if [[ $B64_SSL_CRL && $SSL_CRL_FILEPATH ]]; then
  mkdir -p $(dirname $SSL_CRL_FILEPATH)
  echo $B64_SSL_CRL | base64 --decode >> "$SSL_CRL_FILEPATH"
fi

if [[ $B64_KEY_FILE && $KEY_FILEPATH ]]; then
  mkdir -p $(dirname $KEY_FILEPATH)
  echo $B64_KEY_FILE | base64 --decode >> "$KEY_FILEPATH"
fi

if [[ $B64_CONFIG && $CONFIG_FILEPATH ]]; then
  mkdir -p $(dirname $CONFIG_FILEPATH)
  echo $B64_CONFIG | base64 --decode >> "$CONFIG_FILEPATH"
fi

if [[ ! -z $SYSTEM_LOGPATH ]]; then
  mkdir -p $SYSTEM_LOGPATH
fi

if [[ ! -z $PROC_MGMT_PID_PATH ]]; then
  mkdir -p $PROC_MGMT_PID_PATH
fi

mongos --config $CONFIG_FILEPATH
tail -f /dev/null