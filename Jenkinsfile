pipeline {
   agent any
   environment {
      HARBOR_USERNAME = 'admin'
      HARBOR_PASSWORD = 'Harbor12345'
      DOCKER_REGISTRY = '192.99.35.61'
      IMAGE_NAME = "library"
      IMAGE_TAG = "latest"
      SERVER_USERNAME = 'root'
      SERVER_PASSWORD = 'A76fQ7fRxJFcg8TH'
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
    stage('deploy to nexus') {
        steps {
           sh"/opt/apache-maven-3.6.3/bin/mvn dependency:tree"
           sh "/opt/apache-maven-3.6.3/bin/mvn package"
     //       sh '/opt/apache-maven-3.6.3/bin/mvn clean deploy '
        }
     }
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
    sshagent(credentials: ['${hamzapri}']) {
        sh ' ssh root@192.99.35.69 "echo ${HARBOR_PASSWORD} | docker login --username admin --password-stdin http://192.99.35.61"'
        sh ' ssh root@192.99.35.69 "docker stop mycontainer || true"'
        sh ' ssh root@192.99.35.69 "docker rm mycontainer || true"'
        sh ' ssh root@192.99.35.69 "docker pull ${DOCKER_REGISTRY}/${IMAGE_NAME}/repository:${IMAGE_TAG}"'
        sh ' ssh root@192.99.35.69 "docker run -d -p 8084:8080 --name mycontainer ${DOCKER_REGISTRY}/${IMAGE_NAME}/repository:${IMAGE_TAG}"'
     }
  }
}
   }
}
