FROM golang
ENV LOGSPOUT_VERSION=3.1
ENV LOGSPOUT_DOWNLOAD_SHA256 a26b3d1ee4e79149e4ae91d2e3c222fb7f80b97836be0b6a5e3b22b9552f4e1b
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
