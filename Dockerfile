FROM openjdk:8-jdk-alpine
VOLUME /tmp
ARG JAR_FILE=target/*.jar
ADD target/Inventory-Management-0.0.1-SNAPSHOT.jar Inventory-Management-0.0.1-SNAPSHOT.jar
ENTRYPOINT ["java","-jar","/Inventory-Management-0.0.1-SNAPSHOT.jar"]
