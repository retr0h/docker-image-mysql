VERSION=focal
NAME=mysql
PYTHON_VERSION=3.8
TAG?=$(shell git describe --tags --always)

CONTAINER=$(CI_REGISTRY_IMAGE)/$(NAME)
TAGS = $(PYTHON_VERSION)-$(VERSION)-$(TAG) $(PYTHON_VERSION)-$(VERSION) latest

.PHONY: dep
dep:
	pip install poetry
	poetry install

.PHONY: build
build: image-build

.PHONY: push
push: build image-tag image-push

.PHONY: image-build
image-build:
	@docker build -t $(CONTAINER):_build .

.PHONY: image-tag
image-tag:
	@for i in $(TAGS); do \
		echo "Tagging $$i"; \
		docker tag $(CONTAINER):_build $(CONTAINER):$$i; \
	done

.PHONY: image-push
image-push:
	@for i in $(TAGS); do \
		echo "Pushing $$i"; \
		docker push $(CONTAINER):$$i; \
	done
