#!/usr/bin/env bash
set -euo pipefail

echo -e "\nInstalling https://skaffold.dev/"

# Check if curl is installed
if ! command -v curl &> /dev/null
then
    echo "curl is not installed. Installing..."

    # Check if the package manager is apt (for Ubuntu/Debian)
    if command -v apt &> /dev/null; then
        # apt update
        apt install -y curl
    else
        echo "No supported package manager found. Please install curl manually."
        exit 1
    fi
else
    echo "curl is already installed."
fi

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

if [[ "$OS" != "linux" && "$OS" != "darwin" && "$OS" != "windows" ]]; then
  echo "Unsupported operating system: $OS. Supported OS are Linux, macOS, and Windows."
  exit 1
fi

case "$ARCH" in
  x86_64) ARCH="amd64" ;;
  arm64 | aarch64) ARCH="arm64" ;;
  *) echo "Unsupported architecture: $ARCH"; exit 1 ;;
esac

# URLs
SKAFFOLD_URL="https://github.com/GoogleContainerTools/skaffold/releases/download/${SKAFFOLD_VERSION}/skaffold-${OS}-${ARCH}"
CHECKSUM_URL="https://github.com/GoogleContainerTools/skaffold/releases/download/${SKAFFOLD_VERSION}/skaffold-${OS}-${ARCH}.sha256"
echo "Downloading Skaffold version:  $SKAFFOLD_URL"
echo "Downloading Skaffold checksum: $CHECKSUM_URL"

# Download the Skaffold binary and its checksum
BINARY_FILE="skaffold-${OS}-${ARCH}"
CHECKSUM_FILE="${BINARY_FILE}.sha256"
curl -LO "$SKAFFOLD_URL"
curl -LO "$CHECKSUM_URL"

# Verify the checksum
echo "Verifying checksum..."
CHECKSUM_OK=$(sha256sum -c ${CHECKSUM_FILE} | grep -c ": OK")

if [ "$CHECKSUM_OK" -ne 1 ]; then
  echo "Checksum verification failed! Exiting."
  exit 1
fi

# Make the Skaffold binary executable
chmod +x ${BINARY_FILE}

# Move the Skaffold binary to a directory in your PATH (e.g., /usr/local/bin)
mv ${BINARY_FILE} /usr/local/bin/skaffold

# Cleanup
rm ${CHECKSUM_FILE}

# Verify the installation
skaffold version
