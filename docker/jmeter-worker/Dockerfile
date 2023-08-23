FROM gcr.io/omnisend-ops/kangal-jmeter-base:5.6

ENV SSL_DISABLED false

EXPOSE 1099 50000

COPY jmeter.properties /opt/apache-jmeter-5.6/bin/

ENTRYPOINT "$JMETER_HOME/bin/jmeter-server" "-Dserver.rmi.localport=50000" "-Dserver_port=1099" "-Dserver.rmi.ssl.disable=$SSL_DISABLED"
