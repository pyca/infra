FROM jenkinsci/jenkins:lts

USER root
RUN apt-get -qq update && apt-get -qq -y install curl

RUN curl -sSL https://get.docker.com/ | sh

RUN usermod -a -G staff,docker jenkins

RUN /usr/local/bin/install-plugins.sh \
    "ansicolor" \
    "blueocean" \
    "github-oauth" \
    "ircbot" \
    "mapdb-api" \
    "workflow-aggregator" \
    "pipeline-utility-steps" \
    "simple-theme-plugin" \
    "ssh-slaves" \
    "timestamper" \
    "ws-cleanup"

USER jenkins
