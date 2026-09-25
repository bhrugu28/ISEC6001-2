#!/bin/sh
set -eu

secret_file=/run/secrets/jenkins_agent_secret

if [ ! -r "$secret_file" ] || [ ! -s "$secret_file" ]; then
    echo "Jenkins agent secret is missing or unreadable." >&2
    exit 1
fi

# Read the connection secret from its mounted file.
JENKINS_SECRET=$(cat "$secret_file")
export JENKINS_SECRET

# Start the official Jenkins agent process.
exec /usr/local/bin/jenkins-agent "$@"