.DEFAULT: image
.PHONY: image stage3

STAGE3_VERSION := 20200108T214502Z
DOCKER_REPOSITORY := adborden/gentoo

STAGE3_TARBALL := stage3-amd64-$(STAGE3_VERSION).tar.xz
STAGE3_DIGESTS := $(STAGE3_TARBALL).DIGESTS.asc

$(STAGE3_TARBALL):
	wget http://distfiles.gentoo.org/releases/amd64/autobuilds/$(STAGE3_VERSION)/$(STAGE3_TARBALL)

$(STAGE3_DIGESTS):
	wget http://distfiles.gentoo.org/releases/amd64/autobuilds/$(STAGE3_VERSION)/$(STAGE3_DIGESTS)

sha512sum.txt: $(STAGE3_DIGESTS)
	sed -n -e '/SHA512 HASH/ {n;p}' $(STAGE3_DIGESTS) | grep $(STAGE3_TARBALL)$$ > $@

stage3: $(STAGE3_TARBALL) sha512sum.txt
	gpg --verify $(STAGE3_DIGESTS)
	sha512sum -c sha512sum.txt

image: stage3
	docker import $(STAGE3_TARBALL) $(DOCKER_REPOSITORY):$(STAGE3_VERSION)

tag:
	docker tag $(DOCKER_REPOSITORY):$(STAGE3_VERSION) $(DOCKER_REPOSITORY):latest
