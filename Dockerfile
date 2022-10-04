FROM adoptopenjdk/openjdk8:alpine-slim as builder
ARG JAR_FILE=target/*.jar

FROM adoptopenjdk/openjdk8:alpine-slim as build
EXPOSE 8080
RUN addgroup -S pipeline && adduser -S k8s-pipeline -G pipeline
COPY ${JAR_FILE} /home/k8s-pipeline/app.jar
USER k8s-pipeline
ENTRYPOINT ["java","-jar","/home/k8s-pipeline/app.jar"]