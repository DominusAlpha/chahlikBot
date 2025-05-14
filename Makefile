VERSION=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)
TARGET_OS=linux #linux darwin windows
REGISTRY=ghcr.io/dominusalpha
APP=chahlikbot
TARGETARCH=arm64

format:
	gofmt -s -w ./

lint:
	golint

test:
	go test -v	

build: format
	CGO_ENABLED=0 GOOS=${TARGET_OS} GOARCH=${TARGETARCH} go build -v -o chahlikBot -ldflags "-X="github.com/DominusAlpha/chahlikBot/cmd.appVersion=${VERSION}

image:
	docker build . -t ${REGISTRY}/${APP}:${VERSION}-${TARGET_OS}

push:
	docker push ${REGISTRY}/${APP}:${VERSION}-${TARGET_OS}

clean:
	rm -rf chahlikBot	