# logspout-gelf

Logspout with GELF adapter. This image contains [Logspout](https://github.com/gliderlabs/logspout)
which is compiled with [GELF adapter](https://github.com/rickalm/logspout-gelf) so you can forward
Docker logs in GELF format using gelf://hostname:port as the Logspout command.

## Usage

Always read the official instructions first. This image should work the same way. Just use
`gelf` as the protocol scheme.

### docker-compose example

You could use this image with the following docker-compose file:

```
version: '2'

services:
  logspout:
    image: vincit/logspout-gelf
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
    command: gelf://my.log.server:12201
    restart: unless-stopped
```

## Disclaimer

This image is provided as-is and only with best effort. We try to update this image
with the latest Logspout stable version.
