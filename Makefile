PLATFORMS = linux/amd64,linux/i386,linux/arm64,linux/arm/v7
BASEIMAGE = alpine
#DOCKER_USER = test
#DOCKER_PASS = test
ifeq ($(REPO),)
  REPO = unibaktr
endif

SUBDIRS = base_images singlestage_images multistage_images
.PHONY: all init $(SUBDIRS) clean

all: init $(SUBDIRS) clean

init: clean
	@docker run --rm --privileged multiarch/qemu-user-static --reset -p yes
	@docker buildx create --name kathara_images_builder
	@docker buildx use kathara_images_builder
	@docker buildx inspect --bootstrap

$(SUBDIRS): init
	$(MAKE) PLATFORMS=$(PLATFORMS) REPO=$(REPO) BASEIMAGE="$(BASEIMAGE)" -C $@

clean:
	@docker buildx rm kathara_images_builder | true
