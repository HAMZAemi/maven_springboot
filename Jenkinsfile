pipeline {
    agent any
    environment {
        HARBOR_USERNAME = 'admin'
        HARBOR_PASSWORD = 'Stage2023'
        HARBOR_REGISTRY = '192.99.35.61'
        HARBOR_PROJECT = 'centos1/exosdata'
        IMAGE_NAME = "${HARBOR_REGISTRY}/${HARBOR_PROJECT}/image:${BUILD_NUMBER}"
        DOCKER_CONFIG = "${WORKSPACE}/.docker"
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
        stage('Build and Deploy Docker image to Harbor') {
            steps {
                sh "/opt/apache-maven-3.6.3/bin/mvn package"
                sh "docker build -t ${IMAGE_NAME} ."
                sh "docker tag ${IMAGE_NAME} anvbhaskar/docker_jenkins_pipeline:${BUILD_NUMBER} "
                sh "echo ${HARBOR_PASSWORD} > ${DOCKER_CONFIG}/password && chmod 0600 ${DOCKER_CONFIG}/password"
                sh "docker login --username ${HARBOR_USERNAME} --password-file ${DOCKER_CONFIG}/password ${HARBOR_REGISTRY}"
                sh "docker tag anvbhaskar/docker_jenkins_pipeline:${BUILD_NUMBER} ${HARBOR_REGISTRY}/${HARBOR_PROJECT}/image:${BUILD_NUMBER}"
                sh "docker push --disable-legacy-registry ${HARBOR_REGISTRY}/${HARBOR_PROJECT}/image:${BUILD_NUMBER}"
            }
            post {
                always {
                    archiveArtifacts '**/target/*.jar'
                }
            }
        }
    }
}
