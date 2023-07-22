pipeline {
   agent any
   environment {
      HARBOR_USERNAME = 'admin'
      HARBOR_PASSWORD = 'Harbor12345'
      DOCKER_REGISTRY = '192.99.35.61'
      IMAGE_NAME = "library"
      IMAGE_TAG = "latest"
      SERVER_USERNAME = 'root'
      SERVER_PASSWORD = 'hamza'
      SERVER_IP = '192.99.35.69'
      DOCKER_IMAGE_NAME = "my-hamza-image"
      DOCKER_IMAGE_TAG = "latest"
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
   //   stage('deploy to nexus') {
     //    steps {
     //       sh"/opt/apache-maven-3.6.3/bin/mvn dependency:tree"
     //       sh "/opt/apache-maven-3.6.3/bin/mvn package"
     //       sh '/opt/apache-maven-3.6.3/bin/mvn clean deploy '
     //    }
    //  }
      stage('Build and push to harbor') {
         steps {
            script {
               sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ." // Construire l'image Docker
               sh "docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${DOCKER_REGISTRY}/${IMAGE_NAME}/repository:${IMAGE_TAG}" // Ajouter une étiquette à l'image Docker

               withCredentials([usernamePassword(credentialsId: 'stage', usernameVariable: 'HARBOR_USERNAME', passwordVariable: 'HARBOR_PASSWORD')]) {
                 sh "echo ${HARBOR_PASSWORD} | docker login --username ${HARBOR_USERNAME} --password-stdin ${DOCKER_REGISTRY}" // Se connecter au référentiel Harbor avec les informations d'identification
                  sh "docker push ${DOCKER_REGISTRY}/${IMAGE_NAME}/repository:${IMAGE_TAG}" // Pousser l'image Docker vers le référentiel Harbor
               }
            }
         }
      }
  stage('Deploy Docker Container on Server') {
  steps {
    // Stop and remove any existing container with the same name
    sh "sshpass -p ${SERVER_PASSWORD} ssh ${SERVER_USERNAME}@${SERVER_IP} 'docker stop my_container || true'"
    sh "sshpass -p ${SERVER_PASSWORD} ssh ${SERVER_USERNAME}@${SERVER_IP} 'docker rm my_container || true'"

    // Login to Harbor on the server and pull the Docker image
    withCredentials([usernamePassword(credentialsId: 'stage', usernameVariable: 'HARBOR_USERNAME', passwordVariable: 'HARBOR_PASSWORD')]) {
      sh "sshpass -p ${SERVER_PASSWORD} ssh ${SERVER_USERNAME}@${SERVER_IP} 'echo ${HARBOR_PASSWORD} | docker login --username admin --password-stdin http://192.99.35.61'"
    }
    sh "sshpass -p ${SERVER_PASSWORD} ssh ${SERVER_USERNAME}@${SERVER_IP} 'docker pull ${DOCKER_REGISTRY}/${IMAGE_NAME}/repository:${IMAGE_TAG}'"

    // Run the Docker container on the server
    sh "sshpass -p ${SERVER_PASSWORD} ssh ${SERVER_USERNAME}@${SERVER_IP} 'docker run -d -p 8085:8080 --name my_container ${DOCKER_REGISTRY}/${IMAGE_NAME}/repository:${IMAGE_TAG}'"
  }
}
   }
}
