import jenkins.model.*
import hudson.util.Secret
import com.cloudbees.plugins.credentials.*
import com.cloudbees.plugins.credentials.domains.*
import com.cloudbees.plugins.credentials.impl.*
import com.cloudbees.jenkins.plugins.sshcredentials.impl.BasicSSHUserPrivateKey

def loadEnv(String path) {
    def env = [:]
    new File(path).eachLine { line ->
        def parts = line.split('=')
        if (parts.length == 2) {
            env[parts[0]] = parts[1]
        }
    }
    return env
}

def env = loadEnv('~/tmp/jenkins_env.sh')

def jenkins = Jenkins.instance
def domain = Domain.global()

def githubPrivateKey = env['GITHUB_SSH_PRIVATE_KEY']
def dockerUsername = env['DOCKER_USERNAME']
def dockerPassword = env['DOCKER_PASSWORD']

if (githubPrivateKey == null || githubPrivateKey.trim().isEmpty()) {
    throw new IllegalArgumentException("GITHUB_SSH_PRIVATE_KEY environment variable is not set")
}

if (dockerUsername == null || dockerUsername.trim().isEmpty()) {
    throw new IllegalArgumentException("DOCKER_USERNAME environment variable is not set")
}

if (dockerPassword == null || dockerPassword.trim().isEmpty()) {
    throw new IllegalArgumentException("DOCKER_PASSWORD environment variable is not set")
}
// GitHub SSH credentials
def githubSshCredentials = new BasicSSHUserPrivateKey(
    CredentialsScope.GLOBAL,
    "github_credentials",
    "git",
    new BasicSSHUserPrivateKey.DirectEntryPrivateKeySource(System.getenv("GITHUB_SSH_PRIVATE_KEY")),
    "",
    "GitHub SSH private key"
)

// Docker credentials
def dockerCredentials = new UsernamePasswordCredentialsImpl(
    CredentialsScope.GLOBAL,
    "dockerhub-credentials",
    "Docker credentials for Jenkins",
    System.getenv("DOCKER_USERNAME"),
    System.getenv("DOCKER_PASSWORD")
)

def credentialsStore = jenkins.getExtensionList('com.cloudbees.plugins.credentials.SystemCredentialsProvider')[0].getStore()
credentialsStore.addCredentials(domain, githubSshCredentials)
credentialsStore.addCredentials(domain, dockerCredentials)

jenkins.save()
