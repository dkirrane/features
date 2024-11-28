#!/bin/bash

# This test file will be executed against an auto-generated devcontainer.json that
# includes the 'az-aks-cli' Feature with no options.
#
# For more information, see: https://github.com/devcontainers/cli/blob/main/docs/features/test.md
#
# Eg:
# {
#    "image": "<..some-base-image...>",
#    "features": {
#      "az-aks-cli": {}
#    },
#    "remoteUser": "root"
# }
#
# Thus, the value of all options will fall back to the default value in 
# the Feature's 'devcontainer-feature.json'.
# For the 'skaffold' feature, that means the default favorite greeting is 'hey'.
#
# These scripts are run as 'root' by default. Although that can be changed
# with the '--remote-user' flag.
# 
# This test can be run with the following command:
#
# devcontainer features test --features az-aks-cli --skip-scenarios
#
set -e

# Optional: Import test library bundled with the devcontainer CLI
# See https://github.com/devcontainers/cli/blob/HEAD/docs/features/test.md#dev-container-features-test-lib
# Provides the 'check' and 'reportResults' commands.
source dev-container-features-test-lib

# Feature-specific tests
# The 'check' command comes from the dev-container-features-test-lib. Syntax is...
# check <LABEL> <cmd> [args...]
check "execute command" bash -c "kubectl | grep 'kubectl controls the Kubernetes cluster manager'"
check "execute command" bash -c "kubelogin | grep 'login to azure active directory and populate kubeconfig with AAD tokens'"

# Report results
# If any of the checks above exited with a non-zero exit code, the test will fail.
reportResults