FROM openjdk:17-jdk-slim

# Install Dockerize (pour attendre que Eureka soit dispo)
ENV DOCKERIZE_VERSION v0.7.0
RUN apt-get update && apt-get install -y wget curl \
    && wget -O dockerize.tar.gz https://github.com/jwilder/dockerize/releases/download/${DOCKERIZE_VERSION}/dockerize-linux-amd64-${DOCKERIZE_VERSION}.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize.tar.gz \
    && rm dockerize.tar.gz

# Copier le JAR dans l'image
COPY target/spring-petclinic-customers-service-3.0.2.jar app.jar

# Lancer l'application avec Dockerize qui attend Eureka
ENTRYPOINT ["dockerize", "-wait=tcp://discovery-server:8761", "-timeout=60s", "--", "java", "-jar", "app.jar"]
#df