FROM openjdk:8

VOLUME /tmp
ARG JAR_FILE
ENV JAVA_OPTS=
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 8005
COPY docker-entrypoint.sh /usr/local/bin/entrypoint.sh
COPY ./scripts/* /scripts/
COPY ${JAR_FILE} app.jar
