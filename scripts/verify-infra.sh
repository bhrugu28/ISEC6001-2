#!/usr/bin/env bash
set -euo pipefail

docker compose -f compose.yml config --quiet

docker compose -f compose.yml exec -T agent sh -s <<'CHECK'
set -eu

echo "Checking worker identity"
id
test "$(id -u)" = "1000"

echo "Checking Docker connection"
printf 'Endpoint=%s TLS=%s\n' "$DOCKER_HOST" "$DOCKER_TLS_VERIFY"
test "$DOCKER_HOST" = "tcp://docker:2376"
test "$DOCKER_TLS_VERIFY" = "1"

docker version --format 'Client={{.Client.Version}} Server={{.Server.Version}}'
docker buildx version

echo "Checking shared workspace with a Node 16 container"

# Create a temporary directory owned by the worker.
probe_dir=$(mktemp -d /home/jenkins/agent/workspace-check.XXXXXX)
trap 'rm -rf "$probe_dir"' EXIT

printf 'File from Jenkins worker\n' > "$probe_dir/from-agent"

# Start this container inside DinD using the same workspace.
docker run --rm \
  --user 1000:1000 \
  --mount "type=bind,source=$probe_dir,target=/check" \
  node:16-bullseye-slim \
  sh -eu -c '
    node --version
    test "$(id -u)" = "1000"
    cat /check/from-agent
    printf "File from Node container\n" > /check/from-container
  '

cat "$probe_dir/from-container"

echo "All infrastructure checks passed"
CHECK