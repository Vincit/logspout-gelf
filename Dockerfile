FROM golang
ENV LOGSPOUT_VERSION=3.2.2
ENV LOGSPOUT_DOWNLOAD_SHA256=ac642b9564a874ce5d21ab6e8358a394d46a8b71ff4ded1f7b24289739b09b69
ENV GOPATH=/go
ENTRYPOINT ["/go/bin/logspout"]
VOLUME /mnt/routes
EXPOSE 80

WORKDIR /
RUN curl -fSL -o logspout.tar.gz "https://github.com/gliderlabs/logspout/archive/v${LOGSPOUT_VERSION}.tar.gz" \
    && echo "$LOGSPOUT_DOWNLOAD_SHA256 *logspout.tar.gz" | sha256sum -c - \
    && tar -zxvf logspout.tar.gz \
    && rm logspout.tar.gz \
    && mkdir -p /go/src/github.com/gliderlabs/ \
    && mv /logspout-${LOGSPOUT_VERSION} /go/src/github.com/gliderlabs/logspout

WORKDIR /go/src/github.com/gliderlabs/logspout
COPY ./modules.go /go/src/github.com/gliderlabs/logspout/modules.go
RUN go get
RUN go build -ldflags "-X main.Version=$(cat VERSION)" -o ./bin/logspout
RUN cp /go/src/github.com/gliderlabs/logspout/bin/logspout /go/bin/logspout
