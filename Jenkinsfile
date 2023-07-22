pipeline {
    agent any
     environment {
    DOCKERHUB_CREDENTIALS = credentials('docker')
    }
    stages {
        stage('Compile and Clean') {
            steps {

                sh "/opt/apache-maven-3.6.3/bin/mvn clean compile"
            }
        }
        stage('Test') {
            steps {
               sh '/opt/apache-maven-3.6.3/bin/mvn test'

            }

             post {
                always {
                    junit allowEmptyResults: true, testResults: 'target/surefire-reports/*.xml'
                }
            }
        }

        stage('deploy') {
            steps {
                sh"/opt/apache-maven-3.6.3/bin/mvn dependency:tree"
                sh "/opt/apache-maven-3.6.3/bin/mvn package"
            }
        }


        stage('Build Docker image'){
            steps {
                sh "docker build -t anvbhaskar/docker_jenkins_pipeline:${BUILD_NUMBER} ."
            }
        }

      stage('Login') {
      steps {
        sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
      }
    }

 stage('Docker*'){
            steps {
                sh "docker tag anvbhaskar/docker_jenkins_pipeline:${BUILD_NUMBER} emihamza/hamza:${BUILD_NUMBER}"

            }
        }

        stage('Docker Push'){
            steps {
                sh "docker push emihamza/hamza:${BUILD_NUMBER}"

            }
        }

       stage('Deploy') {
    steps {
        sh "docker run -itd -p 8099:8080 emihamza/hamza:${BUILD_NUMBER}"
    

    }
}


        stage('Archving') {
            steps {
                 archiveArtifacts '**/target/*.jar'
            }
        }
    }
}
