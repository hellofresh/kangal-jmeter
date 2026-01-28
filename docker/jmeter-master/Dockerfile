ARG JMETER_VERSION
FROM hellofresh/kangal-jmeter:$JMETER_VERSION

ARG JMETER_VERSION

ENV SSL_DISABLED=false
ENV WORKER_SVC_NAME=jmeter-worker
ENV TESTS_DIR=/tests
ENV SLEEP=5
ENV USE_WORKERS=false

# Prevent interactive prompts during build
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
  curl \
  unzip \
  && curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
  && unzip awscliv2.zip \
  && ./aws/install \
  && rm -rf awscliv2.zip ./aws \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

COPY mysql-connector-java-5.1.47-bin.jar /opt/apache-jmeter-$JMETER_VERSION/lib/
COPY jmeter.properties /opt/apache-jmeter-$JMETER_VERSION/bin/
COPY launcher.sh /

ENTRYPOINT ["/launcher.sh"]
