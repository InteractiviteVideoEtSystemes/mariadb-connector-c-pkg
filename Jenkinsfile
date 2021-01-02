def VERSION = ''
def PROJET = ''
def DESTDIR = ''
def SLACKALREADYSENT = false
import hudson.model.*
import jenkins.model.*
import hudson.tasks.test.AbstractTestResultAction

pipeline {
  agent none
  stages {
    stage('BuildAndInstall') {
      matrix {
        agent { label "${NODELABEL}" }
        axes {
           axis {
               name 'NODELABEL'
               values 'centos6', 'centos7'
           }
	}
	stages {
	   stage('Build RPM') { 

               steps {
	           sh """
                   if ! type cmake
	           then
	              sudo yum install -y cmake
                   fi
                   ./install.ksh rpm nosign
	           """
              }
           }
 
           stage('Install packages') {
               when {
                   buildingTag()
               }
               steps {
	           sh """
                   sudo yum remove -y MariaDB-devel MariaDB-shared mysql
                   sudo yum localinstall -y MariaDB-devel*.rpm MariaDB-shared*.rpm
	           """
               }
           }
 
           stage('archive') {
               when {
                   buildingTag()
               }
               steps {
                   archiveArtifacts(artifacts: '*.rpm,vrn.html', onlyIfSuccessful: true)
               }
           }
        } // stages 
        post {
	   failure {
              script {
	        notifFail("Failed to build RPM on ${NODELABEL}")
              }
           }
        }
      } // matrix
    } // stage('BuildAndInstall')
  } // stages
  post {
    success {
        script{
           notifSuccess()
        }
    }
  }
}

void notifFail(e)
{
  office365ConnectorSend(message: "💔:  *BUILD FAIL asteriskv $BRANCH_NAME* : \n\n Lien du Build : <RUN_DISPLAY_URL|JENKINS-#$BUILD_NUMBER> \n \n Cordialement, Jenkins", status: 'Success', webhookUrl: 'https://outlook.office.com/webhook/a8d2a9bb-d91a-48b9-8774-a1907c4bce10@dda7df9a-8948-410e-8cd6-c830a3370b09/JenkinsCI/1c7e9437aaad42a8a2407afabdbfc096/37c3465b-9ab9-4181-8220-d38b79c27fe3', color:'00ff00')

}

void notifSuccess()
{
  office365ConnectorSend(message: "✅:  *BUILD SUCCESS asteriskv $BRANCH_NAME* : \n\n Lien du Build  <$RUN_DISPLAY_URL|JENKINS-#$BUILD_NUMBER> \n \n Cordialement, Jenkins", status: 'Success', webhookUrl: 'https://outlook.office.com/webhook/a8d2a9bb-d91a-48b9-8774-a1907c4bce10@dda7df9a-8948-410e-8cd6-c830a3370b09/JenkinsCI/1c7e9437aaad42a8a2407afabdbfc096/37c3465b-9ab9-4181-8220-d38b79c27fe3', color:'00ff00')
}

void notifSuccessInstalled()
{
  office365ConnectorSend(message: "✅:  *BUILD SUCCESS asteriskv $BRANCH_NAME* : \n\n Lien du Build : $RUN_DISPLAY_URL|JENKINS-#$BUILD_NUMBER> \n \n Cordialement, Jenkins", status: 'Success', webhookUrl: 'https://outlook.office.com/webhook/a8d2a9bb-d91a-48b9-8774-a1907c4bce10@dda7df9a-8948-410e-8cd6-c830a3370b09/JenkinsCI/1c7e9437aaad42a8a2407afabdbfc096/37c3465b-9ab9-4181-8220-d38b79c27fe3', color:'00ff00')
}
