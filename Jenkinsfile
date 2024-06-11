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
                    // Ensure PR_BRANCH is available
                    def prBranch = env.PR_BRANCH
                    if (!prBranch) {
                        error("GHPRB_ACTUAL_COMMIT_BRANCH environment variable not set. Make sure this job is triggered by a pull request event.")
                    }

                    // Checkout the pull request branch
                    checkout([
                        $class: 'GitSCM',
                        branches: [[name: prBranch]],
                        doGenerateSubmoduleConfigurations: false,
                        extensions: [[$class: 'CleanBeforeCheckout'], [$class: 'PruneStaleBranch']],
                        submoduleCfg: [],
                        userRemoteConfigs: [[
                            credentialsId: 'github_pat',
                            url: 'https://github.com/csye7125-su24-team18/ami-jenkins.git'
                        ]]
                    ])
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
