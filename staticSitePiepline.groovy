import jenkins.model.*
import hudson.model.*
import javaposse.jobdsl.plugin.ExecuteDslScripts

def jobDslScript = '''
pipelineJob("GitHub-Jenkinsfile") {
    definition {
        cpsScm {
            scm {
                git {
                    remote {
                        url("https://github.com/csye7125-su24-team18/static-site.git")
                        credentials("github_pat")
                    }
                    branch("main")
                    extensions {
                        cleanAfterCheckout()
                    }
                }
            }
            scriptPath("Jenkinsfile")
        }
    }
    triggers {
        githubPush()
    }
}
'''

def jobManagement = new javaposse.jobdsl.plugin.JenkinsJobManagement(System.out, [:], new File('.'))
new javaposse.jobdsl.dsl.DslScriptLoader(jobManagement).runScript(jobDslScript)
