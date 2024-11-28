# Dessie's Dev Container Features

> This repo contains custom [dev container Features](https://containers.dev/implementors/features/), hosted on GitHub Container Registry.

## Example Contents

This repository contains a _collection_ of Features:
- `skaffold`

Each sub-section below shows a sample `devcontainer.json` alongside example usage of the Feature.

### `skaffold`

Running `skaffold` inside the built container will install https://skaffold.dev/ with the specified version.

```jsonc
{
    "image": "mcr.microsoft.com/devcontainers/base:ubuntu",
    "features": {
        "ghcr.io/dkirrane/features/skaffold:1": {
            "version": "v2.13.2"
        }
    }
}
```

```bash
$ hello

Hello, user.
```

## Repo and Feature Structure

Similar to the [`devcontainers/features`](https://github.com/devcontainers/features) repo, this repository has a `src` folder.  Each Feature has its own sub-folder, containing at least a `devcontainer-feature.json` and an entrypoint script `install.sh`. 

```
├── src
│   ├── skaffold
│   │   ├── devcontainer-feature.json
│   │   └── install.sh
|   ├── ...
│   │   ├── devcontainer-feature.json
│   │   └── install.sh
...
```
