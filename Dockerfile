FROM scratch

ADD downloads/stage3-amd64.tar.xz /
ADD downloads/portage-latest.tar.xz /var/db/repos/

# Portage tarball contents are rooted in /portage/
RUN mv /var/db/repos/portage /var/db/repos/gentoo

RUN echo FEATURE="-sandbox" >> /etc/portage/make.conf

RUN emerge --quiet app-editors/vim
