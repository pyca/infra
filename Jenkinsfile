import groovy.json.JsonSlurperClassic

def builders = [:]

@NonCPS
def jsonParse(json) {
    new groovy.json.JsonSlurperClassic().parseText(json)
}

stage("Build Configs") {
    node {
        checkout scm
        configs = jsonParse(readFile('config.json'))
        for (x in configs) {
            def name = x["tag"]
            def path = x["path"]
            def base_image = x["base_image"]
            def build_args = ""
            for (build_arg in x["build_args"]) {
                build_args += "--build-arg $build_arg"
            }
            println builders
            builders[name] = {
                node("docker") {
                        stage("Checkout") {
                            checkout scm
                        }
                        stage("Build") {
                            sh "docker build --pull -t $name $path $build_args"
                        }
                        stage("Publish") {
                            echo "todo"
                        }
                }
            }
        }
    }
}

parallel builders

stage("Prune") {
    node("docker") {
        sh "docker system prune -f"
    }
}
