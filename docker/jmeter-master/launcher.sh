#!/bin/bash

#variables 
JMETER_METRIC_URL="http://localhost:9270/metrics"
PUSHGATEWAY_HOST=${PUSHGATEWAY_HOST:-"https://pushgateway.omnisend.io:9091"}
PUSHGATEWAY_JOB_NAME=${PUSHGATEWAY_JOB_NAME:-"loadtest"}
PUSHGATEWAY_SEND_METRICS_SECONDS=${PUSHGATEWAY_SEND_METRICS_SECONDS:-"10"}

run_jmeter_test() {
  FILE=$1
  [[ "$USE_WORKERS" == "true" ]] && WORKER_OPTS="-R $(getent ahostsv4 "$WORKER_SVC_NAME" | cut -d ' ' -f 1 | sort -u | paste --serial --delimiters ',')"
  echo "=== Running JMeter load generator ==="

  "$JMETER_HOME"/bin/jmeter.sh -n -t "$FILE" -l results.csv -e -o /results/ -Jserver.rmi.ssl.disable="$SSL_DISABLED" "$WORKER_OPTS" >>output.log 2>&1 &

  echo "Checking output.log"
  while true; do
    echo "=== Waiting JMeter to finish ==="
    cat output.log
    if grep "end of run" ./output.log; then
      echo "=== Jmeter is finished! ==="
      cp results.csv /results/results.csv
      if [[ -n "${REPORT_PRESIGNED_URL}" ]]; then
        echo "=== Saving report to Object storage ==="
        tar -C /results -cf results.tar .
        curl -X PUT -H "Content-Type: application/x-tar" -T results.tar -L "${REPORT_PRESIGNED_URL}"
      elif [[ -n "${AWS_BUCKET_NAME}" ]]; then
        echo "WARNING: Using AWS credentials to upload reports is deprecated. Kangal upgrade is recommended."
        echo "=== Trying to send report to ${AWS_BUCKET_NAME}/${LOADTEST_NAME} endpoint ${AWS_ENDPOINT_URL} ==="
        cp /results/index.html /results/main.html
        aws s3 cp --recursive /results s3://"${AWS_BUCKET_NAME}"/"${LOADTEST_NAME}"/ --endpoint-url https://"${AWS_ENDPOINT_URL}"
      fi
      exit 0
    fi
    if JMETER_ERROR=$(grep "ERROR" ./output.log); then
      echo "=== We got an error while running JMeter, exiting 1 ==="
      echo "$JMETER_ERROR"
      cp ./output.log /results/output.log
      exit 1
    fi
	if [[ ! "$PUSHGATEWAY_HOST" -eq "false" ]]; then
		echo "send metrics from JMETER_METRIC_URL $JMETER_METRIC_URL to PUSHGATEWAY $PUSHGATEWAY_HOST/metrics/job/$PUSHGATEWAY_JOB_NAME/instance/$HOSTNAME"
		curl -s $JMETER_METRIC_URL | curl --data-binary @- $PUSHGATEWAY_HOST/metrics/job/$PUSHGATEWAY_JOB_NAME/instance/$HOSTNAME
	else
		echo "INFO: pushgateway use is disabled."
	fi
	sleep $PUSHGATEWAY_SEND_METRICS_SECONDS
  done
}

while :; do
  if find /tests/ -mindepth 1 -print -quit 2>/dev/null | grep -q .; then
    for test in /tests/*.jmx; do
      echo "=== Starting test for $test configuration ==="
      if [[ -e "$test" ]]; then
        run_jmeter_test "$test"
      fi
    done
    break
  fi
  sleep "$SLEEP"
done
