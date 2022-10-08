FROM alpine:3.16.2

RUN set -x && \
    apk update && \
    apk add ca-certificates && \
    update-ca-certificates && \
    apk add --update coreutils && rm -rf /var/cache/apk/ && \
    apk add --update openjdk11 tzdata curl unzip bash && \
    rm -rf /var/cache/apk/*

EXPOSE 8080
ARG JAR_FILE=target/*.jar
ADD ${JAR_FILE} app.jar
ENTRYPOINT ["java","-jar","/app.jar"]

