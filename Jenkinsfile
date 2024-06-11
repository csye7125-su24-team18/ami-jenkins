pipeline {
    agent none

    environment {
        GITHUB_PAT = credentials('github_pat')
    }

    stages {
        stage('Checkout') {
            
            steps {
                script{
                    checkout([
                    $class: 'GitSCM',
                    branches: scm.branches,
                    doGenerateSubmoduleConfigurations: false,
                    extensions: [[$class: 'PruneStaleBranch']],
                    submoduleCfg: [],
                    userRemoteConfigs: [[
                        credentialsId: 'github_credentials',
                        url: 'git@github.com:your-github-org/your-repo.git'
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
