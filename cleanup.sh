#!/usr/bin/env bash
set -euo pipefail

# cleanup.sh -- destroy the Docker resources created by .devcontainer/devcontainer.json:
# the dev container, Dev Containers-generated images, and named cache volumes.
# Run from the host, NOT from inside of the container.
#
# The upstream image gtomscs6200/fall26-environment:latest is intentionally retained.

workspace_name="$(basename "$PWD" | tr '[:upper:]' '[:lower:]')"

volumes=(
  cs-6200-gios-dev-env-pip-cache
  cs-6200-gios-dev-env-gh-config
  cs-6200-gios-dev-env-vscode-ext-cache
)

# container
container="$(docker ps --all --quiet --filter "name=^/?cs-6200-gios-dev-env$")"
if [ -n "$container" ]; then
docker rm --force --volumes "$container"
fi

# Dev Containers-generated images
images="$(docker images --quiet --filter "reference=vsc-${workspace_name}-*")"
if [ -n "$images" ]; then
docker rmi --force $images
fi

# named volumes
docker volume rm --force "${volumes[@]}"
