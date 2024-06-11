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
                    String gitStatusPostUrl = "https://${GITHUB_PAT}:x-oauth-basic@api.github.com/repos/csye7125-su24-team18/ami-jenkins/statuses/${gitHash}"

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
                echo "Building the code"
                
            }
        }
        stage('Notify') {
            steps {
                sh '''
                curl -X POST -H "application/json" -d '{"state":"success", "target_url":"${buildUrl}", "description":"Build Success", "context":"build/job"}' "${gitStatusPostUrl}"
                '''
            }
        }

        stage ('Cleanup') {
            steps {
                echo "Cleaning up the code"
            }
        }

    
    }
}
