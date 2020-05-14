PLATFORMS = linux/amd64,linux/i386,linux/arm64,linux/arm/v7
#VERSION = $(shell cat VERSION)
BINFMT = a7996909642ee92942dcd6cff44b9b95f08dad64
#DOCKER_USER = test
#DOCKER_PASS = test
ifeq ($(REPO),)
  REPO = katharaimages
endif
TAGS = busybox traefik whoami dnsmasq coredns softether

.PHONY: all init $(TAGS) clean

all: init $(TAGS) clean

init: clean
	@docker run --rm --privileged docker/binfmt:$(BINFMT)
	@docker buildx create --name kathara_images_builder
	@docker buildx use kathara_images_builder
	@docker buildx inspect --bootstrap

$(TAGS):
	@docker login -u $(DOCKER_USER) -p $(DOCKER_PASS)
	@docker buildx build \
			--build-arg BUILD_DATE=$(shell date -u +"%Y-%m-%dT%H:%M:%SZ") \
			--build-arg VCS_REF=$(shell git rev-parse --short HEAD) \
			--build-arg VCS_URL=$(shell git config --get remote.origin.url) \
			--platform $(PLATFORMS) \
			--push \
			-f $@.dockerfile \
			-t $(REPO):$@ .
	@docker logout

clean:
	@docker buildx rm kathara_images_builder | true
