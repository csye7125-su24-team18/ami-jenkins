pipeline {
    agent any

    environment {
       GITHUB_SSH_PRIVATE_KEY = credentials('github_credentials')
       GITHUB_PAT = credentials('github_pat')
    }

    stages {
        stage('Checkout') {
            steps {
                checkout([
                    $class: 'GitSCM',
                    branches: [[name: "refs/pull/${env.CHANGE_ID}/head"]],
                    doGenerateSubmoduleConfigurations: false,
                    extensions: [[$class: 'PruneStaleBranch']],
                    submoduleCfg: [],
                    userRemoteConfigs: [[
                        credentialsId: 'github_pat',
                        url: 'https://github.com/csye7125-su24-team18/ami-jenkins.git'
                    ]]
                ])

                script {
                    String payload = "${payload}"
                    def jsonObject = readJSON text: payload
                    String gitHash = "${jsonObject.pull_request.head.sha}"
                    String buildUrl = "${BUILD_URL}"
                    String gitStatusPostUrl = "https://${GITHUB_PAT}@api.github.com/repos/csye7125-su24-team18/ami-jenkins/statuses/${gitHash}"
                }
            }
            
            stage('Check Commit Message') {
                steps {
                    conventionalCommitChecker commitTypes: [
                        'feat', 'fix', 'docs', 'style', 'refactor', 'test', 'chore', 'revert'
                    ]
                }
            }   

            stage('Approve'){
                steps{
                        sh """
                        curl -X POST -H "application/json" -d '{"state":"success", "target_url":"${buildUrl}", "description":"Build Success", "context":"build/job"}' "${gitStatusPostUrl}"
                        """

                }
            }
        }
    }
}    
