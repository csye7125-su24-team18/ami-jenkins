import jenkins.model.*
import hudson.model.*
import javaposse.jobdsl.plugin.ExecuteDslScripts

def jobDslScript = '''
  multibranchPipelineJob('ami-jenkins') {
    branchSources {
        github {
            id('github')
            scanCredentialsId('github_pat')
            repoOwner('csye7125-su24-team18')
            repository('ami-jenkins')
            traits {
                branchDiscoverTrait {
                    strategy {
                        allBranches()
                    }
                }
                forkPullRequestDiscoveryTrait {
                    strategy {
                        forkPullRequestDiscoveryTrait {
                            trust(class: 'org.jenkinsci.plugins.github_branch_source.ForkPullRequestDiscoveryTrait$TrustContributors')
                        }
                    }
                }
            }
        }
    }
    factory {
        workingStrategy {
            $class: 'by-jenkinsfile'
            scriptPath('Jenkinsfile')
        }
    }
    triggers {
        githubPullRequest {
            admissibleUpstreamBranches()
            token('token')
        }
    }
}
'''


def jobManagement = new javaposse.jobdsl.plugin.JenkinsJobManagement(System.out, [:], new File('.'))
new javaposse.jobdsl.dsl.DslScriptLoader(jobManagement).runScript(jobDslScript)
