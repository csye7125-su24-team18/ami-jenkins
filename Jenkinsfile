pipeline {
    agent any

    environment {
        GITHUB_PAT = credentials('github_pat')
    }

    stages {
        stage('Checkout') {
            steps {
                script {
                    // Ensure CHANGE_URL and CHANGE_ID are available
                    def prUrl = env.CHANGE_URL
                    def prId = env.CHANGE_ID
                    if (!prUrl || !prId) {
                        error("CHANGE_URL or CHANGE_ID environment variable not set. Make sure this job is triggered by a pull request event.")
                    }
                     echo "Pull Request URL: ${prUrl}"
                    // Checkout the pull request from the forked repository
                    checkout([
                        $class: 'GitSCM',
                        branches: [[name: "refs/pull/${prId}/head"]],
                        doGenerateSubmoduleConfigurations: false,
                        extensions: [[$class: 'CleanBeforeCheckout']], // Clean workspace before checkout
                        submoduleCfg: [],
                        userRemoteConfigs: [[
                            credentialsId: 'github_pat',
                            url: "${prUrl}.git"
                        ]]
                    ])
                }
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
