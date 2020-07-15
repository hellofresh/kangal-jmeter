ARG VERSION
FROM platformhellofresh/kangal-jmeter:base

ARG JMETER_VERSION=5.0

ENV SSL_DISABLED false
ENV WORKER_SVC_NAME jmeter-worker
ENV TESTS_DIR /tests
ENV SLEEP 5
ENV USE_WORKERS false

ENV AWS_DEFAULT_REGION ""
ENV AWS_ENDPOINT_URL ""
ENV AWS_BUCKET_NAME ""

RUN apt-get update && \
    apt-get --quiet --yes install awscli

ADD mysql-connector-java-5.1.47-bin.jar /opt/apache-jmeter-5.0/lib/
ADD launcher.sh /

ENTRYPOINT ["/launcher.sh"]
