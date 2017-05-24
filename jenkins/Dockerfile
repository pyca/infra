FROM jenkinsci/jenkins:lts

USER root
RUN apt-get -qq update && apt-get -qq -y install curl

RUN curl -sSL https://get.docker.com/ | sh

RUN usermod -a -G staff,docker jenkins

RUN /usr/local/bin/install-plugins.sh \
    "AnsiColor" \
    "Blue Ocean" \
    "GitHub Authentication plugin" \
    "IRC Plugin" \
    "MapDB API Plugin" \
    "Pipeline" \
    "Pipeline Utility Steps" \
    "Simple Theme Plugin" \
    "SSH Slaves plugin" \
    "Timestamper" \
    "Workspace Cleanup Plugin"

USER jenkins
