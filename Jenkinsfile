pipeline {
    agent none

    environment {
        GITHUB_PAT = credentials('github_pat')
    }

    stages {
        stage('Checkout') {
            
            steps {
                script{
                    String payload = "${payload}"
                    def jsonObject = readJSON text: payload
                    String gitHash = "${jsonObject.pull_request.head.sha}"
                    String buildUrl = "${jsonObject.pull_request.html_url}"
                    echo "Git Hash: ${gitHash}"
                    echo "Checking out the code"
                    '''
                    git checkout ${gitHash}

                    '''
                }
            }
        }

        stage('Check Commit Message') {
            steps{
                String commitMessage = sh(script: 'git log -1 --pretty=%B', returnStdout: true).trim();
                echo "Commit Message: ${commitMessage}"
            }
        }

        stage('Build') {
            steps {
                echo "Building the code"
                
            }
        }

        stage ('Cleanup') {
            steps {
                echo "Cleaning up the code"
            }
        }

    
    }
}
