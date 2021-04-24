FROM golang:1.11-stretch AS builder

ENV GO111MODULE=on \
    CGO_ENABLED=1

WORKDIR /build

RUN mkdir go-jenkins-ci

WORKDIR ./go-jenkins-ci

COPY go.mod .
## COPY go.sum .
RUN go mod download

COPY . .

RUN GOOS="linux" GOARCH=amd64 CGO_ENABLED=0 go build -o main main.go

WORKDIR /dist
RUN mkdir go-jenkins-ci
RUN cp /build/go-jenkins-ci/* ./go-jenkins-ci/

RUN mkdir /data

FROM scratch

COPY --chown=0:0 --from=builder /dist /

COPY --chown=65534:0 --from=builder /data /data
USER 65534
WORKDIR /data

ENTRYPOINT ["/go-jenkins-ci"]

