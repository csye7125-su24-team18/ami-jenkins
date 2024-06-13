import jenkins.model.*
import hudson.model.*
import javaposse.jobdsl.plugin.ExecuteDslScripts

def jobDslScript = '''
multibranchPipelineJob('helm') {
    branchSources {
        github {
            id('helm-pipeline')
            scanCredentialsId('github_pat')
            repoOwner('csye7125-su24-team18')
            repository('helm-webapp-cve-processor')
            configure { node ->
                   <triggers>
                    <com.igalg.jenkins.plugins.mswt.trigger.ComputedFolderWebHookTrigger plugin="multibranch-scan-webhook-trigger@1.0.11">
                      <spec></spec>
                      <token>webapp</token>
                    </com.igalg.jenkins.plugins.mswt.trigger.ComputedFolderWebHookTrigger>
                  </triggers>
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
