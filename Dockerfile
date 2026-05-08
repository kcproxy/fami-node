# Build go
FROM golang:1.26.1-alpine AS builder
WORKDIR /app
COPY . .
ENV CGO_ENABLED=0
RUN GOEXPERIMENT=jsonv2 go mod download
RUN GOEXPERIMENT=jsonv2 go build -v -o ./output/fami-node -trimpath -ldflags "-s -w -buildid="

# Release
FROM  alpine
# 安装必要的工具包
RUN  apk --update --no-cache add tzdata ca-certificates \
    && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
RUN mkdir /etc/fami-node/
COPY --from=builder /app/output/fami-node /usr/local/bin

ENTRYPOINT [ "fami-node", "server", "--config", "/etc/fami-node/config.yml"]
