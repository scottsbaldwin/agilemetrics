# ----------------------------------------------------------------
# Variables to be used in other variables
# ----------------------------------------------------------------
APP=measure-up

IMAGE_REPO := scottsbaldwin
APP_IMAGE_TAG := latest

IMAGE_NAME := $(IMAGE_REPO)/$(APP)

# ----------------------------------------------------------------
# TAGGED_IMAGE: the full image:tag of the app's Docker image
# GEMS_IMAGE:   the image name of the Gem cache Docker image
#
# The GEMS_IMAGE must be built (or in the registry) before
# building the TAGGED_IMAGE.
# ----------------------------------------------------------------
TAGGED_IMAGE:=$(IMAGE_NAME)-app:$(APP_IMAGE_TAG)
GEMS_IMAGE:=$(IMAGE_NAME)-gems

# ----------------------------------------------------------------
# Docker image building targets
# ----------------------------------------------------------------
build-gems:
	docker build --platform linux/amd64 \
		--rm . -f dockerfiles/Dockerfile-gems -t $(GEMS_IMAGE)

push-gems: build-gems
	docker push $(GEMS_IMAGE)

build-app:
	docker build --platform linux/amd64 \
		--rm . -f dockerfiles/Dockerfile-app \
		--build-arg CACHE_IMAGE=$(GEMS_IMAGE) \
		-t $(TAGGED_IMAGE)

push-app: build-app
	docker push $(TAGGED_IMAGE)

# ----------------------------------------------------------------
# Local dev targets
# ----------------------------------------------------------------
local-db: 
	docker run --rm --platform linux/x86_64 --name metrics_db \
		-e POSTGRES_PASSWORD=badwolf \
		-e PGDATA=/tmp/pgdata \
		-v $(PWD)/tmp/db/metrics_db:/tmp/pgdata \
		-p 5432:5432 postgres:13

local-app:
	rails s

local-install-helm:
	helm --kube-context docker-desktop upgrade --install dev helm/chart -f helm/values/devk8s.yaml

local-uninstall-helm:
	helm --kube-context docker-desktop uninstall dev