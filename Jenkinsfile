pipeline {
    agent none

    environment {
        GITHUB_PAT = credentials('github_pat')
    }

    stages {
        stage('Checkout') {
            agent {
                node {
                    label 'linux'
                }
            }
            steps {
                checkout([
                    $class: 'GitSCM',
                    branches: scm.branches,
                    doGenerateSubmoduleConfigurations: false,
                    extensions: [[$class: 'PruneStaleBranch']],
                    submoduleCfg: [],
                    userRemoteConfigs: [[
                        credentialsId: 'github_pat',
                        url: 'git@github.com:csye7125-su24-team18/ami-jenkins.git'
                    ]]
                ])
            }
        }

        stage('Check Commit Message') {
            agent {
                node {
                    label 'linux'
                }
            }
            steps {
                conventionalCommitChecker commitTypes: [
                    'feat', 'fix', 'docs', 'style', 'refactor', 'test', 'chore', 'revert'
                ]
            }
        }

        stage('Build') {
            agent {
                node {
                    label 'linux'
                }
            }
            steps {
               echo 'testing'
            }
        }


    
    }
}
