FROM openjdk:11-jre-slim
LABEL maintainer="team-platform@hellofresh.com"

ARG JMETER_VERSION
ENV JMETER_VERSION 5.6
ENV JMETER_HOME /opt/apache-jmeter-$JMETER_VERSION
ENV PATH $JMETER_HOME/bin:$PATH
ENV HEAP -Xms2g -Xmx2g -XX:MaxMetaspaceSize=256m

RUN apt-get clean \
 && apt-get update \
 && apt-get install --quiet --yes --no-install-recommends \
    curl vim procps \
 && rm -rf /var/lib/apt/lists/*

RUN curl -o /opt/apache-jmeter-$JMETER_VERSION.tgz \
    https://archive.apache.org/dist/jmeter/binaries/apache-jmeter-$JMETER_VERSION.tgz -L \
 && tar -xzf /opt/apache-jmeter-$JMETER_VERSION.tgz --directory /opt \
 && rm /opt/apache-jmeter-$JMETER_VERSION.tgz \
 && curl -o /opt/apache-jmeter-$JMETER_VERSION/lib/ext/plugins-manager.jar -L \
    https://jmeter-plugins.org/get/ \
 && curl -o /opt/apache-jmeter-$JMETER_VERSION/lib/cmdrunner-2.3.jar -L \
    https://search.maven.org/remotecontent?filepath=kg/apc/cmdrunner/2.3/cmdrunner-2.3.jar \
 && curl -o /opt/apache-jmeter-$JMETER_VERSION/lib/ext/jmeter-prometheus-plugin-0.7.1.jar -L \
    https://github.com/johrstrom/jmeter-prometheus-plugin/releases/download/0.7.1/jmeter-prometheus-plugin-0.7.1.jar \
 && curl -o /opt/apache-jmeter-$JMETER_VERSION/lib/postgresql-42.5.1.jar -L \
    https://jdbc.postgresql.org/download/postgresql-42.5.1.jar \
 && rm /opt/apache-jmeter-$JMETER_VERSION/lib/mongo-java-driver-*.jar \
 && curl -o /opt/apache-jmeter-$JMETER_VERSION/lib/mongo-java-driver-3.12.11.jar -L \
    https://search.maven.org/remotecontent?filepath=org/mongodb/mongo-java-driver/3.12.11/mongo-java-driver-3.12.11.jar \
 && java -cp /opt/apache-jmeter-$JMETER_VERSION/lib/ext/plugins-manager.jar \
    org.jmeterplugins.repository.PluginManagerCMDInstaller \
 && PluginsManagerCMD.sh install jpgc-fifo,jpgc-functions,jpgc-tst=2.5,jpgc-casutg=2.6,jpgc-autostop=0.2

WORKDIR /opt/apache-jmeter-$JMETER_VERSION

COPY log4j2.xml /opt/apache-jmeter-$JMETER_VERSION
COPY rmi_keystore.jks /opt/apache-jmeter-$JMETER_VERSION/bin
COPY commons-csv-1.10.0.jar /opt/apache-jmeter-$JMETER_VERSION/lib
COPY rmi_keystore.jks /opt/apache-jmeter-$JMETER_VERSION