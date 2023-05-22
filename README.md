
## Spring Boot Point Of Sales System
http://localhost:8080/


## Introduction
Spring Boot Point Of Sales System- A multi tier system that allows a business owner to create and maintain a list of products they sell, a list of their customers and also generate sales and purchase orders for the customer and business owner. 


## Prérequis:
- Jenkins installé et configuré sur votre machine
- Un environnement de développement Java avec Maven installé
- Accès à un compte Docker Hub pour publier l'image Docker
- Les plugins Jenkins suivants doivent être installés :
   Pipeline
   JUnit
   Docker
## Configuration:
- Copiez le contenu du pipeline Jenkins dans votre pipeline Jenkins existant ou créez un nouveau pipeline à partir de zéro et copiez-y le contenu.
- Mettez à jour les étapes de votre pipeline en fonction de votre application Java et de vos besoins de déploiement.
- Assurez-vous que les plugins Jenkins nécessaires sont installés et configurés sur votre instance Jenkins.
- Assurez-vous que les informations d'identification Docker Hub sont correctement configurées dans Jenkins pour que le pipeline puisse publier l'image Docker.
## Utilisation:
- Exécutez le pipeline Jenkins en appuyant sur "Build Now".
- Le pipeline compilera, testera, packagera et déploieravotre application Java.
- Consultez les résultats de chaque étape pour vous assurer que tout s'est bien passé.
- Si l'étape "Build Docker image" est réussie, une image Docker sera créée et étiquetée avec le numéro de version du pipeline.
- Si l'étape "Docker Push" est réussie, l'image Docker sera publiée sur Docker Hub.
- L'étape "Deploy" démarrera l'application Docker sur un port spécifique pour que vous puissiez y accéder et vérifier que tout fonctionne correctement.
- L'étape "Archving" archivera les artefacts de construction de l'application.
## Avertissement:
- Assurez-vous que les informations d'identification Docker Hub sont correctement configurées et stockées en toute sécurité dans Jenkins pour éviter tout accès non autorisé.
- Assurez-vous que le port utilisé dans l'étape "Deploy" est disponible et n'est pas utilisé par une autre application.
- Vérifiez que chaque étape fonctionne correctement avant de passer à l'étape suivante pour vous assurer que tout se passe bien.


## Tech/framework used: 

Spring Boot,Java,Maven,H2,Bootstrap,Jenkins,Docker,Docker_jenkins_pipeline 
## Port
http://localhost:8099/




![image](https://github.com/HAMZAemi/maven_springboot/assets/95679729/330367f5-cf2e-45a1-9c79-fe319bddca06)



![image](https://github.com/HAMZAemi/maven_springboot/assets/95679729/cfaab460-cf4f-42ae-9516-a7f817fe7c12)
