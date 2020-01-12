FROM scratch

ARG STAGE3_VERSION

ADD downloads/stage3-amd64-$STAGE3_VERSION.tar.xz /
ADD downloads/portage-latest.tar.xz /var/db/repos/

# Portage tarball contests are rooted in /portage/
RUN mv /var/db/repos/portage /var/db/repos/gentoo

RUN emerge --quiet app-editors/vim
