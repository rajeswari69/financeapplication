pipeline {
   agent any
     tools {
         jdk 'JAVA_HOME'
         maven 'M2_HOME'
         terraform 'T2_HOME'
     }
environment {

       DOCKERHUB_CREDENTIALS= credentials('dockerhubcredentials')

    }
     stages {
        stage('checkout the project') {
           steps {
               git branch: 'main', url: 'https://github.com/rajeswari69/financeapplication.git'
           }
        }
        stage('package the application') {
           steps {
               sh 'mvn clean package'
           }
        }
        stage('publish HTML report') {
           steps {
              publishHTML([allowMissing: false, alwaysLinkToLastBuild: false, keepAll: false, reportDir: '/var/lib/jenkins/workspace/Bankingapplication/target/surefire-reports', reportFiles: 'index.html', reportName: 'HTML Report', reportTitles: '', useWrapperFileDirectly: true])
          }
        }
        stage('Build the docker image') {
           steps {
              sh 'docker build -t rajeswari123/bankingproject .'
           }

        }
      stage('Docker Login') {
steps {

           sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'

        }

      }
      stage ('Configure Deployserver with Terraform') {
            steps {
                sh 'chmod 700 mykey.pem'
                sh 'terraform init'
                sh 'terraform validate'
                sh 'terraform apply --auto-approve'
                }
            }

      }
}

