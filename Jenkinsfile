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
      stage('deploy to nexus') {
         steps {
            sh"/opt/apache-maven-3.6.3/bin/mvn dependency:tree"
            sh "/opt/apache-maven-3.6.3/bin/mvn package"
            sh '/opt/apache-maven-3.6.3/bin/mvn clean deploy '
         }
      }
      stage('Build Docker Image') {
         steps {
            sh "docker build -t ${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG} ."
         }
      }
      stage('Push Docker Image to Server') {
         steps {
            // Save the Docker image as a tar file
            sh "docker save ${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG} > ${DOCKER_IMAGE_NAME}-${DOCKER_IMAGE_TAG}.tar"

            // Transfer the Docker image tar file to the server
            sh "sshpass -p ${SERVER_PASSWORD} scp ${DOCKER_IMAGE_NAME}-${DOCKER_IMAGE_TAG}.tar ${SERVER_USERNAME}@${SERVER_IP}:~"

            // Load the Docker image on the server
            sh "sshpass -p ${SERVER_PASSWORD} ssh ${SERVER_USERNAME}@${SERVER_IP} 'docker load < ${DOCKER_IMAGE_NAME}-${DOCKER_IMAGE_TAG}.tar'"

            // Remove the Docker image tar file from the Jenkins agent
            sh "rm ${DOCKER_IMAGE_NAME}-${DOCKER_IMAGE_TAG}.tar"
         }
      }
      stage('Run Docker Container on Server') {
         steps {
            // Stop and remove any existing container with the same name
            sh "sshpass -p ${SERVER_PASSWORD} ssh ${SERVER_USERNAME}@${SERVER_IP} 'docker stop my_container || true'"
            sh "sshpass -p ${SERVER_PASSWORD} ssh ${SERVER_USERNAME}@${SERVER_IP} 'docker rm my_container || true'"

            // Run the Docker container on the server
            sh "sshpass -p ${SERVER_PASSWORD} ssh ${SERVER_USERNAME}@${SERVER_IP} 'docker run -d -p 8088:8080 --name my_container ${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG}'"

            // Get the IP address of the server
            sh "SERVER_IP=\$(sshpass -p ${SERVER_PASSWORD} ssh ${SERVER_USERNAME}@${SERVER_IP} 'hostname -I | cut -d\" \" -f1')"

            // Generate a link to the application
            script {
               def appUrl = "http://${SERVER_IP}:8088/myapp"
               echo "Application URL: ${appUrl}"
            }
         }
      }
   }
}
