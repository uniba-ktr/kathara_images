BASEIMAGE = alpine debian

$(BASEIMAGE):
	@docker login -u $(DOCKER_USER) -p $(DOCKER_PASS)
	@docker buildx build \
			--build-arg BUILD_DATE=$(shell date -u +"%Y-%m-%dT%H:%M:%SZ") \
			--build-arg VCS_REF=$(shell git rev-parse --short HEAD) \
			--build-arg VCS_URL=$(shell git config --get remote.origin.url) \
			--platform $(PLATFORMS) \
			--push \
			-f $@.dockerfile \
			-t $(REPO)/$@:latest .
	@docker logout
