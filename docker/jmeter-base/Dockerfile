FROM openjdk:11-jre-slim
LABEL maintainer="team-platform@hellofresh.com"

ARG JMETER_VERSION

ENV JMETER_HOME /opt/apache-jmeter-$JMETER_VERSION
ENV PATH $JMETER_HOME/bin:$PATH
ENV HEAP -Xms2g -Xmx2g -XX:MaxMetaspaceSize=256m

RUN apt-get clean \
 && apt-get update \
 && apt-get --quiet --yes install \
    curl \
    vim \
    procps
RUN cd /opt \
 && curl https://archive.apache.org/dist/jmeter/binaries/apache-jmeter-$JMETER_VERSION.tgz -L \
    --output apache-jmeter-$JMETER_VERSION.tgz \
    --silent \
 && tar -xzf apache-jmeter-$JMETER_VERSION.tgz \
 && rm apache-jmeter-$JMETER_VERSION.tgz \
 && curl -o /opt/apache-jmeter-$JMETER_VERSION/lib/ext/plugins-manager.jar -L \
    https://jmeter-plugins.org/get/ \
 && curl -o /opt/apache-jmeter-$JMETER_VERSION/lib/cmdrunner-2.2.jar -L \
    http://search.maven.org/remotecontent?filepath=kg/apc/cmdrunner/2.2/cmdrunner-2.2.jar \
 && curl -o /opt/apache-jmeter-$JMETER_VERSION/lib/postgresql-42.2.5.jar -L \
    https://jdbc.postgresql.org/download/postgresql-42.2.5.jar \
 && java -cp /opt/apache-jmeter-$JMETER_VERSION/lib/ext/plugins-manager.jar \
    org.jmeterplugins.repository.PluginManagerCMDInstaller \
 && PluginsManagerCMD.sh install jpgc-fifo,jpgc-functions,jpgc-tst=2.5,jpgc-casutg=2.6

WORKDIR /opt/apache-jmeter-$JMETER_VERSION

COPY log4j2.xml /opt/apache-jmeter-$JMETER_VERSION
COPY rmi_keystore.jks /opt/apache-jmeter-$JMETER_VERSION/bin
COPY rmi_keystore.jks /opt/apache-jmeter-$JMETER_VERSION
