FROM node:7.9-slim

ENV HUBOT_IRC_SERVER irc.freenode.net
ENV HUBOT_IRC_ROOMS #cryptography-dev
ENV HUBOT_IRC_NICK PyCA_Hubot
ENV HUBOT_GITHUB_REPO pyca/cryptography
ENV HUBOT_GITHUB_ISSUE_LINK_IGNORE_USERS github|hubot|cryptojenkins
ENV HUBOT_GITHUB_TOKEN PASS_THIS_AT_RUNTIME

RUN groupadd -g 501 hubot
RUN useradd -m -u 501 -g 501 hubot

RUN mkdir -p /home/hubot/.config/configstore
RUN mkdir /home/hubot/bot
RUN chown -R hubot:hubot /home/hubot

USER hubot
WORKDIR /home/hubot/bot

COPY ["data/package.json", "data/external-scripts.json", "data/Procfile", "/home/hubot/bot/"]
COPY ["data/scripts/", "/home/hubot/bot/scripts"]
COPY ["data/bin/", "/home/hubot/bot/bin"]

RUN npm install

CMD ["bin/hubot"]
