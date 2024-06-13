import jenkins.model.*
import hudson.model.*
import javaposse.jobdsl.plugin.ExecuteDslScripts

def jobDslScript = '''
multibranchPipelineJob('helm') {
    branchSources {
        github {
        id('helm-pipeline')
        scanCredentialsId('github_pat')
        repoOwner('cyse7125-su24-team18')
        repository('helm-webapp-cve-processor.git')
        configure { node ->
                node / traits / 'org.jenkinsci.plugins.github__branch__source.BranchDiscoveryTrait' {}
                node / traits / 'org.jenkinsci.plugins.github__branch__source.WebhookRegistrationTrait' {
                    webhookEvents()
                    token('helm')
                }
            }
        }
    }
    
    orphanedItemStrategy {
        discardOldItems {
        numToKeep(-1)
        daysToKeep(-1)
        }
    }
}
'''

def jobManagement = new javaposse.jobdsl.plugin.JenkinsJobManagement(System.out, [:], new File('.'))
new javaposse.jobdsl.dsl.DslScriptLoader(jobManagement).runScript(jobDslScript)
