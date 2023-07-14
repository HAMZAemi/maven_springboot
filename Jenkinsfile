pipeline {
    agent any
     environment {
        DOCKERHUB_CREDENTIALS = credentials('stage')
        HARBOR_USERNAME = credentials('admin')
        HARBOR_PASSWORD = credentials('Stage2023')
        HARBOR_REGISTRY = 'http://192.99.35.61'
        HARBOR_PROJECT = 'centos1/exosdata'
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
stage('Build Docker image to Harbor') {
            steps {
                sh "docker build -t ${HARBOR_REGISTRY}/${HARBOR_PROJECT}/IMAGE:${BUILD_NUMBER} ."
            }
        }
        stage('Push Docker image to Harbor') {
            steps {
                sh "echo ${HARBOR_PASSWORD} | docker login -u ${HARBOR_USERNAME} --password-stdin ${HARBOR_REGISTRY}"
                sh "docker push ${HARBOR_REGISTRY}/${HARBOR_PROJECT}/IMAGE:${BUILD_NUMBER}"
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
        sh "docker run -itd -p 8099:8080 hamzaemi/hamza_el:${BUILD_NUMBER}"
    

    }
}


        stage('Archving') {
            steps {
                 archiveArtifacts '**/target/*.jar'
            }
        }
    }
}
