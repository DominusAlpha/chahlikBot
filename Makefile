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

define make
$(1): format
	CGO_ENABLED=0 GOOS=${2} GOARCH=${3} go build -v -o chahlikBot -ldflags "-X="github.com/DominusAlpha/chahlikBot/cmd.appVersion=${VERSION}
	docker build . -t ${REGISTRY}/${APP}:${VERSION}-${2}
	docker push ${REGISTRY}/${APP}:${VERSION}-${2}

endef

$(eval $(call make,linux,linux,amd64))
$(eval $(call make,windows,windows,amd64))
$(eval $(call make,macos,darwin,amd64))
$(eval $(call make,linux-arm,linux,arm64))
$(eval $(call make,windows-arm,windows,arm64))
$(eval $(call make,macos-arm,darwin,arm64))

build: format
	CGO_ENABLED=0 GOOS=${TARGET_OS} GOARCH=${TARGETARCH} go build -v -o chahlikBot -ldflags "-X="github.com/DominusAlpha/chahlikBot/cmd.appVersion=${VERSION}

image:
	docker build . -t ${REGISTRY}/${APP}:${VERSION}-${TARGET_OS}

push:
	docker push ${REGISTRY}/${APP}:${VERSION}-${TARGET_OS}

clean:
	rm -rf chahlikBot
	docker rmi -f ${REGISTRY}/${APP}:${VERSION}-${TARGET_OS}