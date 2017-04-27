def builders = [:]

def parseConfig(data) {
    // readJSON returns a non-serializable object, which we need to
    // iterate over and store into a new list because pipelines require
    // serializable data.
    configs = []
    for (el in data) {
        configs << el
    }
    return configs
}

stage("Build Configs") {
    node {
        checkout scm
        configs = parseConfig(readJSON(file: 'config.json'))
        for (config in configs) {
            def name = config["tag"]
            def path = config["path"]
            def base_image = config["base_image"]
            def build_args = ""
            for (build_arg in config["build_args"]) {
                build_args += "--build-arg $build_arg"
            }
            if (env.BRANCH_NAME == 'master') {
                tag = "-t $name"
            } else {
                tag = ''
            }
            builders[name] = {
                node("docker") {
                        stage("Checkout") {
                            checkout scm
                        }
                        stage("Build") {
                            sh "docker build --pull $tag $path $build_args"
                        }
                        if (env.BRANCH_NAME == 'master') {
                            stage("Publish") {
                                docker.withRegistry('', 'dockerhub-credentials') {
                                    image = docker.image(name)
                                    image.push()
                                }
                            }
                        }
                }
            }
        }
    }
}

parallel builders

stage("Prune") {
    node("docker") {
        sh "docker image prune -f"
    }
}
