#!/bin/bash

run_jmeter_test() {
  FILE=$1
  [[ "$USE_WORKERS" == "true" ]] && WORKER_OPTS="-R $(getent ahostsv4 "$WORKER_SVC_NAME" | cut -d ' ' -f 1 | sort -u | paste --serial --delimiters ',')"
  echo "=== Running JMeter load generator ==="

  "$JMETER_HOME"/bin/jmeter.sh -n -t "$FILE" -l results.csv -e -o /results/ -Jserver.rmi.ssl.disable="$SSL_DISABLED" "$WORKER_OPTS" >>output.log 2>&1 &

  echo "TESTING ECHO-0"
  env

  url="$REPORT_PRESIGNED_URL"
  TEST_NAME=$(echo "$url" | awk -F'/' '{print $(NF-1)}')

  echo "Checking output.log"
  while true; do
    echo "=== Waiting JMeter to finish ==="
    cat output.log
    if grep "end of run" ./output.log; then
      echo "=== Jmeter is finished! ==="
	  sh results.sh
      cp results.csv /results/results.csv
      cp test_results.csv /results/test_results.csv
	  cp summary_report.csv /results/summary_report.csv
      if [[ -n "${REPORT_PRESIGNED_URL}" ]]; then
        echo "=== Saving report to Object storage ==="
        tar -C /results -cf results-${TEST_NAME}.tar .
        # curl -X PUT -H "Content-Type: application/x-tar" -T results.tar -L "${REPORT_PRESIGNED_URL}"
        ls -la
        curl --form file="@results-${TEST_NAME}.tar" "gcs-uploader.kangal.svc.cluster.local/upload"
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
    sleep 10
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
