# escape=`
ARG WINDOWS_NANOSERVER_IMAGE

FROM golang:1.18.4 AS builder
WORKDIR /Users/ContainerUser/go/src/info
COPY go.* *.go ./
RUN go build

FROM ${WINDOWS_NANOSERVER_IMAGE}
WORKDIR /app
COPY --from=builder /Users/ContainerUser/go/src/info/info.exe ./
ENTRYPOINT ["/app/info.exe"]
