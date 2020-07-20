.PHONY: build test clean fmt docker

GO=CGO_ENABLED=1 GO111MODULE=on go

MICROSERVICES=rfid-inventory

.PHONY: $(MICROSERVICES)

DOCKERS=docker_rfid_inventory

.PHONY: $(DOCKERS)

VERSION=$(shell cat ./VERSION 2>/dev/null || echo 0.0.0)
GIT_SHA=$(shell git rev-parse HEAD)

GOFLAGS=-ldflags "-X github.impcloud.net/RSP-Inventory-Suite/rfid-inventory.Version=$(VERSION)"

build: $(MICROSERVICES)
	$(GO) build ./...

rfid-inventory:
	$(GO) build $(GOFLAGS) -o $@ ./main.go

test:
	$(GO) test ./... -coverprofile=coverage.out

clean:
	rm -f $(MICROSERVICES)

fmt:
	go fmt ./...

docker: $(DOCKERS)

docker_rfid_inventory:
	docker build \
		--build-arg http_proxy \
		--build-arg https_proxy \
			--label "git_sha=$(GIT_SHA)" \
			-t edgexfoundry/docker-rfid-inventory:$(GIT_SHA) \
			-t edgexfoundry/docker-rfid-inventory:$(VERSION)-dev \
			.

