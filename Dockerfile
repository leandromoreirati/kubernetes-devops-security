FROM openjdk:20-ea-17-jdk-slim-buster as build
ARG JAR_FILE=target/*.jar
COPY ${JAR_FILE} /tmp/app.jar

FROM openjdk:20-ea-17-jdk-slim-buster
RUN set -x && \
    apk update && \
    apk add ca-certificates && \
    update-ca-certificates && \
    apk add --update coreutils && rm -rf /var/cache/apk/ && \
    apk add --update openjdk11 tzdata curl unzip bash && \
    addgroup -S pipeline && adduser -S -G pipeline k8s-pipeline && \
    rm -rf /var/cache/apk/*r
EXPOSE 8080

ARG JAR_FILE=target/*.jar

COPY --from=build /tmp/app.jar /home/k8s-pipeline/app.jar

USER k8s-pipeline

ENTRYPOINT ["java","-jar","/home/k8s-pipeline/app.jar"]