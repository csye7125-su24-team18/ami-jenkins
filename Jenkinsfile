pipeline {
    agent any

    environment {
        GITHUB_SSH_PRIVATE_KEY = credentials('github_credentials')
        GITHUB_PAT = credentials('github_pat')
    }

    stages {
        stage('Checkout') {
            steps {
                script {
                    String payload = "${payload}"
                    def jsonObject = readJSON text: payload
                    String gitHash = "${jsonObject.pull_request.head.sha}"
                    String buildUrl = "${BUILD_URL}"
                    String gitStatusPostUrl = "https://api.github.com/repos/csye7125-su24-team18/ami-jenkins/statuses/${gitHash}?access_token=${GITHUB_PAT}"
                    String forkRepo = "${jsonObject.pull_request.head.repo.clone_url}"
                }

                checkout([
                    $class: 'GitSCM',
                    branches: [[name: gitHash]],
                    doGenerateSubmoduleConfigurations: false,
                    extensions: [],
                    submoduleCfg: [],
                    userRemoteConfigs: [[
                        url: forkRepo
                    ]]
                ])
            }
        }

        stage('Check Commit Message') {
            steps {
                conventionalCommitChecker commitTypes: [
                    'feat', 'fix', 'docs', 'style', 'refactor', 'test', 'chore', 'revert'
                ]
            }
        }

        stage('Approve') {
            steps {
                script {
                    sh """
                        curl -X POST -H "Content-Type: application/json" -d '{"state":"success", "target_url":"${buildUrl}", "description":"Build Success", "context":"build/job"}' "${gitStatusPostUrl}"
                    """
                }
            }
        }
    }
}
