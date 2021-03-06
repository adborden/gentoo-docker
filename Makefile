.DEFAULT: image
.PHONY: image verify verify-stage3 verify-portage-snapshot

DOCKER_REPOSITORY := adborden/gentoo
DOWNLOADS_DIR := downloads
DOWNLOADS_TOUCH := downloads/.keep

PORTAGE_SNAPSHOT_TARBALL := $(DOWNLOADS_DIR)/portage-latest.tar.xz
PORTAGE_SNAPSHOT_TARBALL_SIG := $(DOWNLOADS_DIR)/portage-latest.tar.xz.gpgsig
STAGE3_VERSION_FILE := $(DOWNLOADS_DIR)/stage3_version
STAGE3_IDENTIFIER := $(DOWNLOADS_DIR)/latest-stage3-amd64.txt

STAGE3_VERSION = $(shell cat $(STAGE3_VERSION_FILE))
STAGE3_DIGESTS = $(DOWNLOADS_DIR)/$(notdir $(STAGE3_TARBALL)).DIGESTS.asc
STAGE3_TARBALL = $(DOWNLOADS_DIR)/stage3-amd64-$(STAGE3_VERSION).tar.xz

$(DOWNLOADS_TOUCH):
	mkdir -p downloads
	touch $(DOWNLOADS_TOUCH)

$(STAGE3_IDENTIFIER): $(DOWNLOADS_TOUCH)
	cd $(DOWNLOADS_DIR) && wget --timestamping http://distfiles.gentoo.org/releases/amd64/autobuilds/$(notdir $@)

$(PORTAGE_SNAPSHOT_TARBALL) $(PORTAGE_SNAPSHOT_TARBALL_SIG): $(DOWNLOADS_TOUCH)
	cd $(DOWNLOADS_DIR) && wget --timestamping http://distfiles.gentoo.org/snapshots/$(notdir $@)

$(STAGE3_TARBALL) $(STAGE3_DIGESTS): $(STAGE3_VERSION_FILE) $(DOWNLOADS_TOUCH)
	cd $(DOWNLOADS_DIR) && wget --timestamping http://distfiles.gentoo.org/releases/amd64/autobuilds/$(STAGE3_VERSION)/$(notdir $@)

$(STAGE3_VERSION_FILE): $(STAGE3_IDENTIFIER) $(DOWNLOADS_TOUCH)
	tail -n 1 $(STAGE3_IDENTIFIER) | sed -e 's!/.*$$!!' > $@

# Parse out the SHA512 hash for tarball. DIGESTS contains digests for several
# algorithms and several files, we only need one.
$(DOWNLOADS_DIR)/sha512sum.txt: $(STAGE3_DIGESTS)
	gpg --verify $(STAGE3_DIGESTS)
	sed -n -e '/# SHA512 HASH/ {n;p}' $(STAGE3_DIGESTS) | grep $(notdir $(STAGE3_TARBALL))$$ > $@

verify-portage-snapshot: $(PORTAGE_SNAPSHOT_TARBALL_SIG) $(PORTAGE_SNAPSHOT_TARBALL)
	gpg --verify $^

verify-stage3: $(STAGE3_TARBALL) $(DOWNLOADS_DIR)/sha512sum.txt
	cd $(DOWNLOADS_DIR) && sha512sum -c sha512sum.txt

verify: verify-stage3 verify-portage-snapshot

image: verify
	docker build --build-arg STAGE3_VERSION=$(STAGE3_VERSION) -t $(DOCKER_REPOSITORY):$(STAGE3_VERSION) .

tag:
	docker tag $(DOCKER_REPOSITORY):$(STAGE3_VERSION) $(DOCKER_REPOSITORY):latest
