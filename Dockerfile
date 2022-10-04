FROM openjdk:20-ea-17-jdk-slim-buster as build
ARG JAR_FILE=target/*.jar
COPY ${JAR_FILE} /tmp/app.jar

FROM openjdk:20-ea-17-jdk-slim-buster
EXPOSE 8080
RUN set -x && \
    addgroup --system pipeline && adduser --system k8s-pipeline --group pipeline
COPY --from=build ${JAR_FILE} /home/k8s-pipeline/app.jar
USER k8s-pipeline
ENTRYPOINT ["java","-jar","/home/k8s-pipeline/app.jar"]