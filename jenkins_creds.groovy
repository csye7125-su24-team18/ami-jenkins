import jenkins.model.*
import hudson.util.Secret
import com.cloudbees.plugins.credentials.*
import com.cloudbees.plugins.credentials.domains.*
import com.cloudbees.plugins.credentials.impl.*
import com.cloudbees.jenkins.plugins.sshcredentials.impl.BasicSSHUserPrivateKey

// Get environment variables
def readFileContent(filePath) {
    new File(filePath).text.trim()
}

// Define file paths
// def githubPrivateKeyFilePath = '/etc/jenkins/github_ssh_key'
def dockerUserNameFilePath = '/etc/jenkins/dockerUsername'
def dockerPasswordFilePath = '/etc/jenkins/dockerPassword'
def githubPATFilePath = '/etc/jenkins/github_pat'
def githubUsernameFilePath = '/etc/jenkins/github_username'
// Read the GitHub SSH private key from the file
// def GITHUB_SSH_PRIVATE_KEY = readFileContent(githubPrivateKeyFilePath)
def githubPAT = readFileContent(githubPATFilePath)
def githubUsername = readFileContent(githubUsernameFilePath)

def dockerUsername = readFileContent(dockerUserNameFilePath)
def dockerPassword = readFileContent(dockerPasswordFilePath)
println("Docker Username: ${dockerUsername}")
println("Docker Username: ${dockerPassword}")
def jenkins = Jenkins.instance
def domain = Domain.global()

if (dockerUsername == null || dockerUsername.trim().isEmpty()) {
    throw new IllegalArgumentException("DOCKER_USERNAME environment variable is not set")
}

if (dockerPassword == null || dockerPassword.trim().isEmpty()) {
    throw new IllegalArgumentException("DOCKER_PASSWORD environment variable is not set")
}

// def githubSshCredentials = new BasicSSHUserPrivateKey(
//     CredentialsScope.GLOBAL,
//     "github_credentials",
//     "git",
//     new BasicSSHUserPrivateKey.DirectEntryPrivateKeySource(GITHUB_SSH_PRIVATE_KEY),
//     "",
//     "GitHub SSH private key"
// )

// Docker credentials
def dockerCredentials = new UsernamePasswordCredentialsImpl(
    CredentialsScope.GLOBAL,
    "dockerhub-credentials",
    "Docker credentials for Jenkins",
    dockerUsername,
    dockerPassword
)

// def Git_PAT_STR = new StringCredentialsImpl(
//     CredentialsScope.GLOBAL,
//     "git_string",
//     "GitHub Personal Access Token",
//     Secret.fromString(githubPAT)
// )

def GITHUB_USER_PASS = new UsernamePasswordCredentialsImpl(
    CredentialsScope.GLOBAL,
    "github_pat",
    "Github pat and username credentials for Jenkins",
    githubUsername,
    githubPAT
)



def credentialsStore = jenkins.getExtensionList('com.cloudbees.plugins.credentials.SystemCredentialsProvider')[0].getStore()
credentialsStore.addCredentials(domain, githubSshCredentials)
credentialsStore.addCredentials(domain, dockerCredentials)
credentialsStore.addCredentials(domain, Git_PAT_STR)
credentialsStore.addCredentials(domain, GITHUB_USER_PASS)

jenkins.save()
                     