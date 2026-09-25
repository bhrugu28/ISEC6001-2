#!/usr/bin/env bash
set -euo pipefail

mkdir -p .secrets
chmod 700 .secrets

read -r -s -p 'Paste the docker-agent secret, then press Enter: ' agent_secret
printf '\n'

if [[ -z "$agent_secret" || "$agent_secret" =~ [[:space:]] ]]; then
    echo "Expected one nonempty secret without spaces."
    exit 1
fi

printf '%s' "$agent_secret" > .secrets/jenkins_agent_secret
unset agent_secret

# Allow the container user to read the mounted file.
chmod 644 .secrets/jenkins_agent_secret

echo "Agent secret saved locally."