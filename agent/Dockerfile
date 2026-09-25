FROM docker:29-cli AS dockercli
FROM jenkins/inbound-agent:jdk21

# Install the Docker client and Buildx plugin.
# The Docker daemon runs in the separate DinD container.
COPY --from=dockercli /usr/local/bin/docker /usr/local/bin/docker
COPY --from=dockercli /usr/local/libexec/docker/cli-plugins/docker-buildx /usr/local/libexec/docker/cli-plugins/docker-buildx

# Install the startup script with execution permissions.
COPY --chmod=0555 start-agent.sh /usr/local/bin/start-assessment-agent

USER jenkins
WORKDIR /home/jenkins/agent

ENTRYPOINT ["/usr/local/bin/start-assessment-agent"]