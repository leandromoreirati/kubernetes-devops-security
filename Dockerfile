FROM openjdk:20-ea-17-jdk-slim-buster as build
ARG JAR_FILE=target/*.jar
COPY ${JAR_FILE} /tmp/app.jar

FROM openjdk:20-ea-17-jdk-slim-buster
EXPOSE 8080
ARG JAR_FILE=target/*.jar
RUN set -x && \
    addgroup --system pipeline && useradd -r -G pipeline k8s-pipeline
COPY --from=build /tmp/app.jar /home/k8s-pipeline/app.jar
USER k8s-pipeline
ENTRYPOINT ["java","-jar","/home/k8s-pipeline/app.jar"]