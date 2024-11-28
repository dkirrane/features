#!/bin/bash

# This test file will be executed the 'test_az-aks-cli_latest' scenario

set -e

# Optional: Import test library bundled with the devcontainer CLI
source dev-container-features-test-lib

# Feature-specific tests
# The 'check' command comes from the dev-container-features-test-lib.
# https://github.com/teslamotors/devcontainers-cli/blob/main/docs/features/test.md#dev-container-features-test-lib
check "kubectl is available" bash -c "kubectl version"
check "kubelogin is available" bash -c "kubelogin --version"

# Report results
# If any of the checks above exited with a non-zero exit code, the test will fail.
reportResults
