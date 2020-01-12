# gentoo-docker

Builds a base docker image from the stage3 tarball.

## Usage

Pull the image.

    $ docker pull adborden/gentoo

Run the container, mounting the portage tree for building, and a tmpfs for
building.

    $ docker run --rm -it --name gentoo -v /var/db/repos/gentoo:/var/db/repos/gentoo:ro --tmpfs /var/tmp adborden/gentoo bash

## Development

Build the image.

    $ make image
