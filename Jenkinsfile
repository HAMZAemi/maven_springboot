pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                sh 'mvn -B -DskipTests clean package'
            }
        }
        stage('Test') {
            steps {
                sh 'mvn test'
            }
            post {
                always {
                    junit 'target/surefire-reports/*.xml'
                }
            }
        }
        stage('Deliver') {
            steps {
                sh 'mvn package'
            }
        }
          stage('Build Docker image'){
                    steps {
                        sh 'docker build -t anvbhaskar/docker_jenkins_pipeline:${BUILD_NUMBER} .'
                    }
                }
    }
}