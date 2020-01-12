[![CircleCI](https://circleci.com/gh/adborden/gentoo-docker.svg?style=svg)](https://circleci.com/gh/adborden/gentoo-docker)

# gentoo-docker

Builds a base docker image from the stage3 tarball.

## Usage

Pull the image.

    $ docker pull adborden/gentoo

Run the container, mounting the portage tree for building, and a tmpfs for
building.

    $ docker run --rm -it --name gentoo -v /var/db/repos/gentoo:/var/db/repos/gentoo:ro --tmpfs /var/tmp adborden/gentoo bash


## Development


### Prerequisites

- [Docker](https://docs.docker.com/) v19+

Download the Gentoo release signing keys.

    $ gpg --keyserver hkps://keys.gentoo.org --recv-keys 534E4209AB49EEE1C19D96162C44695DB9F6043D E1D6ABB63BFCFB4BA02FDF1CEC590EEAC9189250


### Building

Build the image.

    $ make image

If the image looks good, tag it.

    $ make tag

Give it a spin.

    $ docker run --rm -it adborden/gentoo bash
