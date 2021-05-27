ARG VERSION="latest"
FROM hellofresh/kangal-jmeter:$VERSION

ARG JMETER_VERSION=5.4.1

ENV SSL_DISABLED false
ENV WORKER_SVC_NAME jmeter-worker
ENV TESTS_DIR /tests
ENV SLEEP 5
ENV USE_WORKERS false

RUN apt-get update && \
    apt-get --quiet --yes install awscli

COPY mysql-connector-java-5.1.47-bin.jar /opt/apache-jmeter-$JMETER-VERSION/lib/
COPY jmeter.properties /opt/apache-jmeter-$JMETER_VERSION/bin/
COPY launcher.sh /

ENTRYPOINT ["/launcher.sh"]
