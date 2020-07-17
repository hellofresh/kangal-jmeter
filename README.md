# Kangal-JMeter
<p align="center">  
<img src="./kangal_logo.svg" height="100">
<img src="./hellofresh.svg" height="100">
</p>

Kangal-JMeter is a set of docker images specifically configured for [Kangal](https://github.com/hellofresh/kangal)

Based on these images Kangal creates JMeter-worker and JMeter-master pods automatically for every new load-test.

## Kangal-JMeter specific features

### JMeter configuration
Kangal-JMeter base docker image is build together with JMeter plugin-manager and the following plugins:
- jpgc-fifo - used for [Inter-Thread Communication](https://jmeter-plugins.org/wiki/InterThreadCommunication/)
- jpgc-functions - used for [Custom JMeter Functions](https://jmeter-plugins.org/wiki/Functions/)
- jpgc-tst=2.5 - [Throughput Shaping Timer](https://jmeter-plugins.org/wiki/ThroughputShapingTimer/)
- jpgc-casutg=2.6 - [Concurrency Thread Group](https://jmeter-plugins.org/wiki/ConcurrencyThreadGroup/#Concurrency-Thread-Group)
- cmdrunner-2.2 - JMeter specific [Command Line Tool](https://jmeter-plugins.org/wiki/JMeterPluginsCMD/#JMeterPluginsCMD-Command-Line-Tool)
- postgresql-42.2.5 [JDBC driver for working with PostgreSQL](https://jdbc.postgresql.org/download.html) used to send requests directly from JMeter to DB

JMeter-worker and JMeter-master are built from a base image with a few environment variable additions.

### RMI keys
Kangal-JMeter base image has RMI keys injected to provide secure connection between master and worker pods.

### Logging for Java app
Logging configuration in log4j2.xml is added to base image to support logging.

## Starting JMeter with launcher script
Launcher.sh script runs in JMeter-master container, and it starts JMeter application in a container as soon as `test.jmx` file is added to the container.

### Saving JMeter report to AWS S3 bucket
JMeter automatically creates a test report after the successful test run.
Launcher.sh uploads the report to S3 bucket. 
JMeter-master docker image contains environment variables for connecting to AWS.
- AWS_DEFAULT_REGION
- ENV AWS_ENDPOINT_URL
- ENV AWS_BUCKET_NAME
Kangal initialises these variables when creating JMeter-master pods for every new test. 