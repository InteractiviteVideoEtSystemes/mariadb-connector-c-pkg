def VERSION = ''
def PROJET = ''
def DESTDIR = ''
def SLACKALREADYSENT = false
import hudson.model.*
import jenkins.model.*
import hudson.tasks.test.AbstractTestResultAction

pipeline {
  agent any
  stages {
    stage('Build RPM') {
      steps {
        sh "./install.ksh rpm nosign"
      }
    }
 
    stage('Install packages') {
      steps {
        sh "sudo yum remove -y MariaDB-devel MariaDB-shared"
        sh "sudo yum localinstall -y MariaDB-develi*.rpm MariaDB-shared*.rpm"
      }
    }
 
  stage('E-mail and archive') {
    when {
      buildingTag()
    }
    steps {
      slackSuccessInstalled()
      emailext(attachmentsPattern: 'vrn.html', body: 'Livraison de <strong>mariadb-connector-c $BRANCH_NAME</strong> : <br/><br/>       Lien GIT : <a href="http://git.ives.fr/plateformes/mariadb-connector-c/tree/$BRANCH_NAME">http://git.ives.fr/plateformes/kamailioconf/tree/$BRANCH_NAME</a><br/><br/> Lien du Build : <a href="$RUN_DISPLAY_URL">$RUN_DISPLAY_URL</a>       <br/><br/>       Cordialement,<br/>       Jenkins', mimeType: 'text/html', replyTo: 'devplateforme@ives.fr', subject: '[mariadb-connector-c] Livraison $BRANCH_NAME', recipientProviders: [requestor()], to: "jenkins@ives.fr")
      archiveArtifacts(artifacts: '*.rpm,vrn.html', onlyIfSuccessful: true)
      script{
        SLACKALREADYSENT=true
      }
    }
  }
}
  post {
     failure {
         script{
                slackFail("An error occured")
          }
    }
    success {
        script{
            if(!SLACKALREADYSENT){
                slackSuccess()
            }
        }
    }
  }
}

void slackFail(e)
{
  slackSend(message: ":x: *BUILD FAIL mariadb-connector-c $BRANCH_NAME* : ```${e}``` \n\n Lien du Build : <$RUN_DISPLAY_URL|JENKINS-#$BUILD_NUMBER> \n Cordialement, Jenkins", baseUrl: 'https://ives-workspace.slack.com/services/hooks/jenkins-ci/', channel: 'jenkins', color: 'danger', teamDomain: 'ives-workspace.slack.com', token: 'gcwQATpI47iPCfTcPCcdR4ZR')
}

void slackSuccess()
{
  slackSend(message: ":white_check_mark:  *BUILD SUCCESS mariadb-connector-c $BRANCH_NAME* : \n\n Lien du Build : <$RUN_DISPLAY_URL|JENKINS-#$BUILD_NUMBER> \n \n Cordialement, Jenkins", baseUrl: 'https://ives-workspace.slack.com/services/hooks/jenkins-ci/', channel: 'jenkins', color: 'good', teamDomain: 'ives-workspace.slack.com', token: 'gcwQATpI47iPCfTcPCcdR4ZR')
}

void slackSuccessInstalled()
{
  slackSend(message: ":white_check_mark: *BUILD SUCCESS mariadb-connector-c $BRANCH_NAME* : \n\n Lien du Build : <$RUN_DISPLAY_URL|JENKINS-#$BUILD_NUMBER> \n \n Cordialement, Jenkins", baseUrl: 'https://ives-workspace.slack.com/services/hooks/jenkins-ci/', channel: 'jenkins', color: 'good', teamDomain: 'ives-workspace.slack.com', token: 'gcwQATpI47iPCfTcPCcdR4ZR')
}
