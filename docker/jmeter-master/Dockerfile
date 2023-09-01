FROM gcr.io/omnisend-ops/kangal-jmeter-base:5.6

ENV SSL_DISABLED false
ENV WORKER_SVC_NAME jmeter-worker
ENV TESTS_DIR /tests
ENV SLEEP 5
ENV USE_WORKERS false

RUN apt-get update && \
    apt-get --quiet --yes install awscli && \
    apt-get --quiet --yes install gnupg 

# RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
#     curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg add - && \
#     apt-get update -y && \
#     apt-get --quiet --yes install google-cloud-cli

COPY mysql-connector-java-5.1.47-bin.jar /opt/apache-jmeter-5.6/lib/
COPY jmeter.properties /opt/apache-jmeter-5.6/bin/
COPY launcher.sh /
COPY results.sh /opt/apache-jmeter-5.6/

ENTRYPOINT ["/launcher.sh"]
