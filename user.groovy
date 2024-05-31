#!groovy

import jenkins.model.*
import hudson.security.*
import hudson.security.FullControlOnceLoggedInAuthorizationStrategy

def instance = Jenkins.getInstance()
println "--> creating local user 'demo'"
def hudsonRealm = new HudsonPrivateSecurityRealm(false)
hudsonRealm.createAccount('demo', 'demo')
instance.setSecurityRealm(hudsonRealm)
def strategy = new FullControlOnceLoggedInAuthorizationStrategy()
instance.setAuthorizationStrategy(strategy)
instance.save()
