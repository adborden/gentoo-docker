.DEFAULT: image
.PHONY: image verify

STAGE3_VERSION := 20200108T214502Z
DOCKER_REPOSITORY := adborden/gentoo

DOWNLOADS_DIR := downloads
STAGE3_TARBALL := $(DOWNLOADS_DIR)/stage3-amd64-$(STAGE3_VERSION).tar.xz
STAGE3_DIGESTS := $(DOWNLOADS_DIR)/$(notdir $(STAGE3_TARBALL)).DIGESTS.asc


$(STAGE3_TARBALL):
	cd $(DOWNLOADS_DIR) && wget -N http://distfiles.gentoo.org/releases/amd64/autobuilds/$(STAGE3_VERSION)/$(notdir $@)

$(STAGE3_DIGESTS):
	cd $(DOWNLOADS_DIR) && wget -N http://distfiles.gentoo.org/releases/amd64/autobuilds/$(STAGE3_VERSION)/$(notdir $@)

sha512sum.txt: $(STAGE3_DIGESTS)
	sed -n -e '/SHA512 HASH/ {n;p}' $(STAGE3_DIGESTS) | grep $(notdir $(STAGE3_TARBALL))$$ > $@

verify: $(STAGE3_TARBALL) sha512sum.txt
	gpg --verify $(STAGE3_DIGESTS)
	cd $(DOWNLOADS_DIR) && sha512sum -c ../sha512sum.txt

image: verify
	docker build --build-arg STAGE3_VERSION=$(STAGE3_VERSION) -t $(DOCKER_REPOSITORY):$(STAGE3_VERSION) .

tag:
	docker tag $(DOCKER_REPOSITORY):$(STAGE3_VERSION) $(DOCKER_REPOSITORY):latest
