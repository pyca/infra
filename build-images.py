#!/usr/bin/env python

import collections
import os
import subprocess


Image = collections.namedtuple("Image", ["tag", "path", "build_args"])

IMAGES = [
    Image(
        tag="crypto-jenkins", path=["jenkins"], build_args=None
    ),
    Image(
        tag="caddy", path=["caddy"], build_args=None
    ),
    Image(
        tag="cryptography-runner:centos7",
        path=["runners", "centos7"],
        build_args=None
    ),
    Image(
        tag="cryptography-runner:jessie",
        path=["runners", "jessie"],
        build_args=None
    ),
    Image(
        tag="cryptography-runner:stretch",
        path=["runners", "stretch"],
        build_args=None
    ),
    Image(
        tag="cryptography-runner:jessie-libressl-2.4.5",
        path=["runners", "jessie-libressl"],
        build_args=["LIBRE_VERSION=2.4.5"],
    ),
    Image(
        tag="cryptography-runner:jessie-libressl-2.5.3",
        path=["runners", "jessie-libressl"],
        build_args=["LIBRE_VERSION=2.5.3"],
    ),
]


def docker_build(image):
    shell_cmd = ["docker", "build", "-t", image.tag, os.path.join(*image.path)]
    if image.build_args is not None:
        for build_arg in image.build_args:
            shell_cmd += ["--build-arg", build_arg]

    subprocess.check_call(shell_cmd)


def main():
    for image in IMAGES:
        print("=== Building {}".format(image.tag))
        docker_build(image)


if __name__ == "__main__":
    main()
