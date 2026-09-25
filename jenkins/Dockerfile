FROM jenkins/jenkins:lts-jdk21

# Install the plugins needed for this assessment.
COPY --chown=jenkins:jenkins plugins.txt /usr/share/jenkins/ref/plugins.txt

RUN jenkins-plugin-cli --plugin-file /usr/share/jenkins/ref/plugins.txt

# Apply the controller configuration when Jenkins starts.
COPY --chown=jenkins:jenkins init.groovy.d/ /usr/share/jenkins/ref/init.groovy.d/

USER jenkins