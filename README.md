# Docker image for MongoDB router (mongos)

This image is for mongos (i.e. MongoDB router) *not* MongoDB. It uses `mongo:3.4.6` as a base and created to workaround limitations with passing in SSL related files.

# Usage

`entrypoint.sh` accepts multiple environment variables in base64 and decodes + saves them to specified locations in the container for mongos to access.

## Example

Using the following as an example:

```
# mongod.conf

# for documentation of all options, see:
#   http://docs.mongodb.org/manual/reference/configuration-options/

# Where and how to store data.
storage:
  dbPath: /var/lib/mongodb
  journal:
    enabled: true

# where to write logging data.
systemLog:
  destination: file
  logAppend: true
  path: /var/log/mongodb/mongod.log

# network interfaces
net:
  port: 27017
  ssl:
    mode: requireSSL
    PEMKeyFile: /etc/mongod.pem

security:
  keyFile: /etc/mongod.keyfile
```

```
# mongod.pemfile

examplepemfile
```

```
# mongod.keyfile

examplekeyfile
```

The official MongoDB image does not have a way for configuring the contents of `security.keyFile` or `net.ssl.PEMKeyFile` unless they're mounted in a volume.

This image can accept the contents of `net.ssl.PEMKeyFile` and `security.keyFile` through the environment variables `B64_SSL_PEM_KEY` and `B64_KEY_FILE` in base64 format and will automatically decode the values and save them to appropriate file locations in the container specified by `SSL_PEM_KEYFILE_FILEPATH` and `KEY_FILEPATH`, respectively.

Begin with base64 encoding the contents of the above files:
```
# mongod.conf

IyBtb25nb2QuY29uZgoKIyBmb3IgZG9jdW1lbnRhdGlvbiBvZiBhbGwgb3B0aW9ucywgc2VlOgojICAgaHR0cDovL2RvY3MubW9uZ29kYi5vcmcvbWFudWFsL3JlZmVyZW5jZS9jb25maWd1cmF0aW9uLW9wdGlvbnMvCgojIFdoZXJlIGFuZCBob3cgdG8gc3RvcmUgZGF0YS4Kc3RvcmFnZToKICBkYlBhdGg6IC92YXIvbGliL21vbmdvZGIKICBqb3VybmFsOgogICAgZW5hYmxlZDogdHJ1ZQoKIyB3aGVyZSB0byB3cml0ZSBsb2dnaW5nIGRhdGEuCnN5c3RlbUxvZzoKICBkZXN0aW5hdGlvbjogZmlsZQogIGxvZ0FwcGVuZDogdHJ1ZQogIHBhdGg6IC92YXIvbG9nL21vbmdvZGIvbW9uZ29kLmxvZwoKIyBuZXR3b3JrIGludGVyZmFjZXMKbmV0OgogIHBvcnQ6IDI3MDE3CiAgc3NsOgogICAgbW9kZTogcmVxdWlyZVNTTAogICAgUEVNS2V5RmlsZTogL2V0Yy9tb25nb2QucGVtCgpzZWN1cml0eToKICBrZXlGaWxlOiAvZXRjL21vbmdvZC5rZXlmaWxl
```

```
#mongod.pemfile

IyBtb25nb2QucGVtZmlsZQoKZXhhbXBsZXBlbWZpbGU=
```

```
# mongod.keyfile

IyBtb25nb2Qua2V5ZmlsZQoKZXhhbXBsZWtleWZpbGU=
```

and then run your image with the following:

```
docker run -e B64_SSL_PEM_KEY=IyBtb25nb2QucGVtZmlsZQoKZXhhbXBsZXBlbWZpbGU= \
           -e SSL_PEM_KEYFILE_FILEPATH=/etc/mongod.pem \ # should match what's specified in mongod.conf
           -e B64_KEY_FILE=IyBtb25nb2Qua2V5ZmlsZQoKZXhhbXBsZWtleWZpbGU= \
           -e KEY_FILEPATH=/etc/mongod.keyfile \ # should match what's specified in mongod.conf
           -e B64_CONFIG=IyBtb25nb2QuY29uZgoKIyBmb3IgZG9jdW1lbnRhdGlvbiBvZiBhbGwgb3B0aW9ucywgc2VlOgojICAgaHR0cDovL2RvY3MubW9uZ29kYi5vcmcvbWFudWFsL3JlZmVyZW5jZS9jb25maWd1cmF0aW9uLW9wdGlvbnMvCgojIFdoZXJlIGFuZCBob3cgdG8gc3RvcmUgZGF0YS4Kc3RvcmFnZToKICBkYlBhdGg6IC92YXIvbGliL21vbmdvZGIKICBqb3VybmFsOgogICAgZW5hYmxlZDogdHJ1ZQoKIyB3aGVyZSB0byB3cml0ZSBsb2dnaW5nIGRhdGEuCnN5c3RlbUxvZzoKICBkZXN0aW5hdGlvbjogZmlsZQogIGxvZ0FwcGVuZDogdHJ1ZQogIHBhdGg6IC92YXIvbG9nL21vbmdvZGIvbW9uZ29kLmxvZwoKIyBuZXR3b3JrIGludGVyZmFjZXMKbmV0OgogIHBvcnQ6IDI3MDE3CiAgc3NsOgogICAgbW9kZTogcmVxdWlyZVNTTAogICAgUEVNS2V5RmlsZTogL2V0Yy9tb25nb2QucGVtCgpzZWN1cml0eToKICBrZXlGaWxlOiAvZXRjL21vbmdvZC5rZXlmaWxl
           -e CONFIG_FILEPATH=/etc/mongos.conf \
           mongos
```
           