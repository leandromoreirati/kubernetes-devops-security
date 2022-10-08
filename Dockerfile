FROM alpine:3.16.2 as build
ARG JAR_FILE=target/*.jar
COPY ${JAR_FILE} /tmp/app.jar

FROM alpine:3.16.2
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
RUN set -x && \
    addgroup --system pipeline && useradd -r -G pipeline k8s-pipeline
COPY --from=build /tmp/app.jar /home/k8s-pipeline/app.jar
USER k8s-pipeline
ENTRYPOINT ["java","-jar","/home/k8s-pipeline/app.jar"]