FROM openjdk:8
ADD target/Inventory-Management-0.0.1-SNAPSHOT.jar Inventory-Management-0.0.1-SNAPSHOT.jar
ENTRYPOINT ["java","-jar","/Inventory-Management-0.0.1-SNAPSHOT.jar"]