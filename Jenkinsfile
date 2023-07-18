pipeline {
   agent any
   environment {
      HARBOR_USERNAME = 'admin'
      HARBOR_PASSWORD = 'stage'
      DOCKER_REGISTRY = '192.99.35.69'
      IMAGE_NAME = "library"
      IMAGE_TAG = "latest"
   }
   stages {
      stage('Compile and Clean') {
         steps {
            sh "mvn clean compile"
         }
      }
      stage('Test') {
         steps {
            sh 'mvn test'
         }
         post {
            always {
               junit allowEmptyResults: true, testResults: 'target/surefire-reports/*.xml'
            }
         }
      }
        stage('deploy') {
            steps {
                sh"mvn dependency:tree"
                sh "mvn package"
              sh 'mvn clean deploy '

            }
        }
     
      stage('Build') {
         steps {
            script {
               sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ." // Construire l'image Docker
               sh "docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${DOCKER_REGISTRY}/${IMAGE_NAME}/repository:${IMAGE_TAG}" // Ajouter une étiquette à l'image Docker
            }
         }
      }
      stage('Push') {
         steps {
            script {
               withCredentials([usernamePassword(credentialsId: 'stage', usernameVariable: 'HARBOR_USERNAME', passwordVariable: 'HARBOR_PASSWORD')]) {
                  sh "docker login ${DOCKER_REGISTRY} -u ${HARBOR_USERNAME} -p ${HARBOR_PASSWORD}" // Se connecter au référentiel Harbor avec les informations d'identification
                  sh "docker push ${DOCKER_REGISTRY}/${IMAGE_NAME}/repository:${IMAGE_TAG}" // Pousser l'image Docker vers le référentiel Harbor
               }
            }
         }
      }
   }
}
