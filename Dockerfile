FROM scratch

ADD downloads/stage3-amd64.tar.xz /
ADD downloads/portage-latest.tar.xz /var/db/repos/

# Portage tarball contents are rooted in /portage/
RUN mv /var/db/repos/portage /var/db/repos/gentoo

# Disable sandbox features which won't work in locked down containers
RUN echo FEATURES=\"-sandbox -ipc-sandbox -network-sandbox -pid-sandbox\" >> /etc/portage/make.conf

# Update the metadata cache
RUN emerge --metadata

WORKDIR /

CMD ["/bin/bash", "-l"]
