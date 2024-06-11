pipeline {
    agent any

    environment {
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
                    String gitStatusPostUrl = "https://${GITHUB_PAT}@api.github.com/repos/csye7125-su24-team18/ami-jenkins/statuses/${gitHash}"
                }
                sh """
                    git checkout ${gitHash}
                """

               
            }
        }

        stage('Run Validation Tests') {
            steps {
                // Add your validation test commands here
                sh 'echo "Running validation tests..."'
                // Example: sh 'make test'
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
                    // Extract necessary information for GitHub status update
                    def buildUrl = env.BUILD_URL
                    def gitHash = sh(script: 'git rev-parse HEAD', returnStdout: true).trim()
                    def gitStatusPostUrl = "https://api.github.com/repos/csye7125-su24-team18/ami-jenkins/statuses/${gitHash}"

                    // Post the build status to GitHub
                    sh """
                    curl -X POST -H "Authorization: token ${GITHUB_PAT}" -H "Content-Type: application/json" \
                    -d '{"state":"success", "target_url":"${buildUrl}", "description":"Build Success", "context":"build/job"}' \
                    ${gitStatusPostUrl}
                    """
                }
            }
        }
    }
}
