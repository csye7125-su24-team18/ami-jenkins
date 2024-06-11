pipeline {
    agent any

   environment {
        GITHUB_PAT = credentials('github_pat')
        GIT_STRING = credentials('git_string')
        NEXT_VERSION = nextVersion()
        PREVIOUS_VERSION = previousVersion()
    }

    stages {
        
        

        stage('Check Commit Message') {
            steps{
                script{
                    String commitMessage = sh(script: 'git log -1 --pretty=%B', returnStdout: true).trim();
                    sh'''
                        echo "Commit Message: ${commitMessage}"
                        echo "next version = ${NEXT_VERSION}"
                        echo "previous version = ${PREVIOUS_VERSION}"
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
                    // def gitStatusPostUrl = "https://${GITHUB_PAT}:x-oauth-basic@api.github.com/csye7125-su24-team18/ami-jenkins/statuses/${env.GIT_COMMIT}"
                    def gitStatusPostUrl = "https://api.github.com/repos/csye7125-su24-team18/ami-jenkins/statuses/${env.GIT_COMMIT}"
                    def buildUrl = "https://jenkins.poojacloud24.pw"
                    sh'''
                        echo "Posting status to GitHub: ${gitStatusPostUrl}"
                        echo "Build URL: ${buildUrl}"
                    '''
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
                    withCredentials([string(credentialsId: 'git_string', variable: 'GIT_STRING')]) {
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
