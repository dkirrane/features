#!/usr/bin/env bash
set -euo pipefail

echo -e "\nInstalling https://learn.microsoft.com/en-us/cli/azure/aks?view=azure-cli-latest#az-aks-install-cli"

# Check if curl is installed
if ! command -v kubectl &> /dev/null
then
    echo "kubectl is not installed. Installing..."
    az aks install-cli
else
    echo "kubectl is already installed."
fi

KUBECTL_VERSION="${VERSION:-latest}"
KUBELOGIN_VERSION="${VERSION:-latest}"

# Install
az aks install-cli --client-version ${KUBECTL_VERSION} --kubelogin-version ${KUBELOGIN_VERSION}
