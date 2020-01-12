FROM scratch

ARG STAGE3_VERSION

ADD downloads/stage3-amd64-$STAGE3_VERSION.tar.xz /
