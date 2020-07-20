ARG version="latest"
FROM hellofreshtech/kangal-jmeter:$version

ARG JMETER_VERSION=5.0

ENV SSL_DISABLED false

EXPOSE 1099 50000

ENTRYPOINT "$JMETER_HOME/bin/jmeter-server" "-Dserver.rmi.localport=50000" "-Dserver_port=1099" "-Dserver.rmi.ssl.disable=$SSL_DISABLED"
