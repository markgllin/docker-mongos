#!/bin/bash

CONFIG_FILEPATH=${CONFIG_FILEPATH:"/etc/mongod.conf.orig"}

if [[ $B64_SSL_PEM_KEY && $SSL_PEM_KEYFILE_PATH ]]; then
  echo $B64_SSL_PEM_KEY | base64 --decode >> "$SSL_PEM_KEYFILE_PATH"
fi

if [[ $B64_SSL_CLUSTER && $SSL_CLUSTER_FILEPATH ]]; then
  echo $B64_SSL_CLUSTER | base64 --decode >> "$SSL_CLUSTER_FILEPATH"
fi

if [[ $B64_SSL_CA && $SSL_CA_FILEPATH ]]; then
  echo $B64_SSL_CA | base64 --decode >> "$SSL_CA_FILEPATH"
fi

if [[ $B64_SSL_CRL && $SSL_CRL_FILEPATH ]]; then
  echo $B64_SSL_CRL | base64 --decode >> "$SSL_CRL_FILEPATH"
fi

if [[ $B64_KEY_FILE && $KEY_FILEPATH ]]; then
  echo $B64_KEY_FILE | base64 --decode >> "$KEY_FILEPATH"
fi

if [[ $B64_CONFIG && $CONFIG_FILEPATH ]]; then
  echo $B64_CONFIG | base64 --decode >> "$CONFIG_FILEPATH"
fi

mongos --config $CONFIG_FILEPATH