ARG JMETER_VERSION
FROM hellofresh/kangal-jmeter:$JMETER_VERSION

ENV SSL_DISABLED false

EXPOSE 1099 50000

ENTRYPOINT "$JMETER_HOME/bin/jmeter-server" "-Dserver.rmi.localport=50000" "-Dserver_port=1099" "-Dserver.rmi.ssl.disable=$SSL_DISABLED"
