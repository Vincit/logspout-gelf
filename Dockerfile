FROM golang:alpine as build
MAINTAINER timo.taskinen@vincit.com
LABEL maintainer "timo.taskinen@vincit.com"
ENV LOGSPOUT_VERSION=3.2.4
ENV LOGSPOUT_DOWNLOAD_SHA256=bcf4661c751eeaadec310f829acb0abd4ed2f0b4001d6eef10ba52016210dc4b
RUN mkdir -p /go/src
WORKDIR /go/src
VOLUME /mnt/routes
EXPOSE 80

RUN apk --no-cache add curl git gcc musl-dev
RUN curl -fSL -o logspout.tar.gz "https://github.com/gliderlabs/logspout/archive/v${LOGSPOUT_VERSION}.tar.gz" \
    && echo "$LOGSPOUT_DOWNLOAD_SHA256 *logspout.tar.gz" | sha256sum -c - \
    && tar -zxvf logspout.tar.gz \
    && rm logspout.tar.gz \
    && mkdir -p /go/src/github.com/gliderlabs/ \
    && mv logspout-${LOGSPOUT_VERSION} /go/src/github.com/gliderlabs/logspout

WORKDIR /go/src/github.com/gliderlabs/logspout
RUN echo 'import ( _ "github.com/micahhausler/logspout-gelf" )' >> /go/src/github.com/gliderlabs/logspout/modules.go
RUN go get -d -v ./...
RUN go build -v -ldflags "-X main.Version=$(cat VERSION)" -o ./bin/logspout

FROM alpine:latest
COPY --from=build /go/src/github.com/gliderlabs/logspout/bin/logspout /go/bin/logspout
ENTRYPOINT ["/go/bin/logspout"]
