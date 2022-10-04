FROM openjdk:20-ea-17-jdk as build
ARG JAR_FILE=target/*.jar
COPY ${JAR_FILE} /tmp/app.jar

FROM openjdk:20-ea-17-jdk
EXPOSE 8080
RUN set -x && \
    addgroup -S pipeline && adduser -S k8s-pipeline -G pipeline && \
    apt-gte update && \
    apt-get upgrade -y
COPY --from=build ${JAR_FILE} /home/k8s-pipeline/app.jar
USER k8s-pipeline
ENTRYPOINT ["java","-jar","/home/k8s-pipeline/app.jar"]