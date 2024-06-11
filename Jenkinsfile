pipeline {
    agent any

   environment {
        GITHUB_PAT = credentials('github_pat')
    }

    stages {
        
        

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
                    def gitStatusPostUrl = "https://api.github.com/repos/csye7125-su24-team18/ami-jenkins/statuses/${env.GIT_COMMIT}"
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
                        curl -X POST -u ${GITHUB_PAT} -H "Content-Type: application/json" -d '${payload}' ${gitStatusPostUrl}
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
