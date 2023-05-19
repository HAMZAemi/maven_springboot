pipeline {
    agent any
     environment {
    DOCKERHUB_CREDENTIALS = credentials('Dockerhub')
    }
    stages {
        stage('Compile and Clean') {
            steps {

                sh "mvn clean compile"
            }
        }
        stage('Test') {
            steps {
                sh "mvn test site"
            }

             post {
                always {
                    junit allowEmptyResults: true, testResults: 'target/surefire-reports/*.xml'
                }
            }
        }

        stage('deploy') {
            steps {
                sh "mvn package"
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
                sh "docker tag anvbhaskar/docker_jenkins_pipeline:${BUILD_NUMBER} hamzaemi/hamza_el:${BUILD_NUMBER}"

            }
        }

        stage('Docker Push'){
            steps {
                sh "docker push hamzaemi/hamza_el:${BUILD_NUMBER}"
            }
        }

       stage('Deploy') {
    steps {
        sh "docker run -p 8084:8080 hamzaemi/hamza_el:${BUILD_NUMBER}"
    }
}


        stage('Archving') {
            steps {
                 archiveArtifacts '**/target/*.jar'
            }
        }
    }
}
