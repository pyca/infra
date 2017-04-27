The PyCA infrastructure requires a variety of credentials to function. This will be more extensively documented in the (near) future.

### Hubot

The pyca/hubot container runs as a docker service in a docker swarm. This gives it access to docker secrets. `docker secret create HUBOT_GITHUB_TOKEN /file/containing/token` can add these credentials.
