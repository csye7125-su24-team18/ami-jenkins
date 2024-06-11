import jenkins.model.*
import hudson.model.*
import javaposse.jobdsl.plugin.ExecuteDslScripts

def jobDslScript = '''
multibranchPipelineJob('ami-jenkins') {
  branchSources {
    github {
      scanCredentialsId('github_pat')
      repoOwner('csye7125-su24-team18')
      repository('ami-jenkins')
      configuredByScanCommand('https://github.com/csye7125-su24-team18/ami-jenkins.git')
      configure { node ->
        node / sources / data / 'jenkins.branch.BranchSource' / source / traits 
          'com.cg.plugin.github.webhook.GHWebHookTrait' {
            events('PUSH')
            dispositions('SKIP_DISABLED')
          }
      }
    }
  }
  factory {
    workingStrategy {
      $class: 'by-jenkinsfile'
      scriptPath('Jenkinsfile')
    }
    triggers {
      scanByWebHook {
        triggerToken('token')
      }
    }
  }
}
'''

def jobManagement = new javaposse.jobdsl.plugin.JenkinsJobManagement(System.out, [:], new File('.'))
new javaposse.jobdsl.dsl.DslScriptLoader(jobManagement).runScript(jobDslScript)
