#!/usr/bin/env bash
set -euo pipefail

# Check if curl is installed
if ! command -v curl &> /dev/null
then
    echo -e "\ncurl is not installed. Installing..."

    # Check if the package manager is apt (for Ubuntu/Debian)
    if command -v apt &> /dev/null; then
        apt update
        apt install -y curl
    else
        echo "No supported package manager found. Please install curl manually."
        exit 1
    fi
else
    echo "curl is already installed."
fi

# Install chezmoi
echo -e "\nInstalling https://www.chezmoi.io/"
# sh -c "$(curl -fsLS get.chezmoi.io)" -- -b $HOME/.local/bin
sh -c "$(curl -fsLS get.chezmoi.io)" -- -b /usr/local/bin
echo -e "\nInstalled chezmoi"
chezmoi --version

# Setup dotfiles from GitHub (assumes GitHub repo is called dotfiles)
echo -e "\nYou can now install your GitHub dotfiles with the following command..."
# echo -e "chezmoi init --apply <GITHUB_USERNAME>"
echo -e "chezmoi init --apply git@github.com:$GITHUB_USERNAME/dotfiles.git"

# # Setup dotfiles from GitHub (assumes GitHub repo is called dotfiles)
# echo -e "\nInstalling dotfiles for GitHub user ${GITHUB_USERNAME}"
# # chezmoi init --apply $GITHUB_USERNAME
# chezmoi init --apply git@github.com:$GITHUB_USERNAME/dotfiles.git