#!/usr/bin/env python3
"""Generate a CycloneDX 1.5 SBOM for an OpenSSL build."""

import argparse
import json
import uuid
from datetime import datetime, timezone


def main():
    parser = argparse.ArgumentParser(
        description="Generate a CycloneDX SBOM for OpenSSL"
    )
    parser.add_argument(
        "--openssl-version",
        required=True,
        help="OpenSSL version string (e.g. openssl-3.5.5)",
    )
    parser.add_argument(
        "--openssl-sha256",
        required=True,
        help="SHA-256 hash of the source tarball",
    )
    parser.add_argument(
        "--architecture",
        required=True,
        help="Target architecture (e.g. x86_64, arm64)",
    )
    parser.add_argument(
        "--operating-system",
        required=True,
        help="Target OS (e.g. linux, macos, windows)",
    )
    parser.add_argument(
        "--build-flags",
        required=True,
        help="OpenSSL build configuration flags",
    )
    parser.add_argument(
        "--output",
        required=True,
        help="Output path for the SBOM JSON file",
    )
    args = parser.parse_args()

    version = args.openssl_version.removeprefix("openssl-")

    source_url = (
        f"https://github.com/openssl/openssl/releases/download/"
        f"{args.openssl_version}/{args.openssl_version}.tar.gz"
    )

    sbom = {
        "bomFormat": "CycloneDX",
        "specVersion": "1.5",
        "version": 1,
        "serialNumber": f"urn:uuid:{uuid.uuid4()}",
        "metadata": {
            "timestamp": datetime.now(timezone.utc).strftime(
                "%Y-%m-%dT%H:%M:%SZ"
            ),
        },
        "components": [
            {
                "type": "library",
                "name": "openssl",
                "version": version,
                "purl": (
                    f"pkg:generic/openssl@{version}"
                    f"?download_url={source_url}"
                ),
                "hashes": [
                    {
                        "alg": "SHA-256",
                        "content": args.openssl_sha256,
                    }
                ],
                "externalReferences": [
                    {
                        "type": "distribution",
                        "url": source_url,
                    }
                ],
                "properties": [
                    {
                        "name": "build:operating-system",
                        "value": args.operating_system,
                    },
                    {
                        "name": "build:architecture",
                        "value": args.architecture,
                    },
                    {
                        "name": "build:flags",
                        "value": args.build_flags,
                    },
                ],
            }
        ],
    }

    with open(args.output, "w") as f:
        json.dump(sbom, f, indent=2)
        f.write("\n")


if __name__ == "__main__":
    main()
