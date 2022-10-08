FROM alpine:3.16.2 as build
RUN set -x && \
    apk update && \
    apk add ca-certificates && \
    update-ca-certificates && \
    apk add --update coreutils && rm -rf /var/cache/apk/ && \
    apk add --update openjdk11 tzdata curl unzip bash && \
    addgroup -S pipeline && adduser -S -G pipeline k8s-pipeline && \
    rm -rf /var/cache/apk/*r
#COPY ${JAR_FILE} /tmp/app.jar
EXPOSE 8080
ARG JAR_FILE=target/*.jar
#COPY --from=build /tmp/app.jar /home/k8s-pipeline/app.jar
COPY ${JAR_FILE} /home/k8s-pipeline/app.jar
USER k8s-pipeline
ENTRYPOINT ["java","-jar","/home/k8s-pipeline/app.jar"]

