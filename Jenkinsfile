pipeline {
    agent any

   environment {
        GITHUB_PAT = credentials('github_pat')
        PR_BRANCH = "env.GHPRB_ACTUAL_COMMIT_BRANCH"
    }

    stages {
        stage('Checkout') {
            steps {
                script {
                    def payload = readJSON text: env.PAYLOAD
                    def gitHash = payload.pull_request.head.sha
                    def forkRepo = payload.pull_request.head.repo.clone_url
                }


                    // Checkout the pull request branch
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
            steps{
                script{
                    String commitMessage = sh(script: 'git log -1 --pretty=%B', returnStdout: true).trim();
                    '''
                        echo "Commit Message: ${commitMessage}"
                    '''
                }
                
            }
        }

        stage('Build') {
            steps {
                script {
                echo "Building the code"
                } 
            }
        }
        stage('Notify') {
            steps {
                script{
                    def gitStatusPostUrl = "https://api.github.com/repos/your-github-org/your-repo/statuses/${env.GIT_COMMIT}"
                    def buildUrl = "${env.BUILD_URL}"
                    echo "Posting status to GitHub: ${gitStatusPostUrl}"
                    echo "Build URL: ${buildUrl}"
                    def payload = """
                    {
                        "state": "success",
                        "target_url": "${buildUrl}",
                        "description": "Jenkins build passed",
                        "context": "Jenkins CI"
                    }
                    """
                    withCredentials([string(credentialsId: 'github_pat', variable: 'GITHUB_PAT')]) {
                        sh """
                        curl -X POST -u your-github-org:${GITHUB_PAT} -H "Content-Type: application/json" -d '${payload}' ${gitStatusPostUrl}
                        """
                    }
                }
            }
        }

        stage ('Cleanup') {
            steps {
                echo "Cleaning up the code"
            }
        }

    
    }
}
