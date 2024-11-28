#!/usr/bin/env bash
set -euo pipefail

echo -e "\nInstalling https://skaffold.dev/"

# Determine Skaffold version
SKAFFOLD_VERSION="${VERSION:-latest}"

if [ "$SKAFFOLD_VERSION" == "latest" ]; then
  SKAFFOLD_VERSION=$(curl -s https://api.github.com/repos/GoogleContainerTools/skaffold/releases/latest | grep -Po '"tag_name": "\K.*?(?=")')
  echo "Latest version resolved to: $SKAFFOLD_VERSION"
fi

# If SKAFFOLD_VERSION does not start with 'v', prepend 'v'
if [[ "$SKAFFOLD_VERSION" != v* ]]; then
  SKAFFOLD_VERSION="v$SKAFFOLD_VERSION"
fi

# Determine system architecture and operating system
OS=$(uname -s | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)

case "$ARCH" in
  x86_64) ARCH="amd64" ;;
  arm64 | aarch64) ARCH="arm64" ;;
  *) echo "Unsupported architecture: $ARCH"; exit 1 ;;
esac

# URLs
SKAFFOLD_URL="https://github.com/GoogleContainerTools/skaffold/releases/download/${SKAFFOLD_VERSION}/skaffold-${ARCH}"
CHECKSUM_URL="https://github.com/GoogleContainerTools/skaffold/releases/download/${SKAFFOLD_VERSION}/skaffold-${ARCH}.sha256"
echo "Downloading Skaffold version: $SKAFFOLD_URL"
echo "Downloading Skaffold checksum: $CHECKSUM_URL"

# Download the Skaffold binary and its checksum
curl -Lo skaffold "$SKAFFOLD_URL"
curl -Lo skaffold.sha256 "$CHECKSUM_URL"

# Verify the checksum
echo "Verifying checksum..."
CHECKSUM_OK=$(sha256sum -c skaffold.sha256 | grep -c ": OK")

if [ "$CHECKSUM_OK" -ne 1 ]; then
  echo "Checksum verification failed! Exiting."
  exit 1
fi

# Make the Skaffold binary executable
chmod +x skaffold

# Move the Skaffold binary to a directory in your PATH (e.g., /usr/local/bin)
sudo mv skaffold /usr/local/bin/skaffold

# Cleanup
rm skaffold.sha256

# Verify the installation
skaffold version
