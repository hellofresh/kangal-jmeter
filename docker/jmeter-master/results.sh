#!/bin/bash

# Input CSV file name
input_file="agg_results.csv"

# Output CSV file name
output_file="test_results.csv"

# Check if the input file exists
if [ ! -f "$input_file" ]; then
  echo "Input file not found: $input_file"
  exit 1
fi

# Initialize variables to store request_name, total_response_time, and request_count
current_request=""
total_response_time=0
max_response_time=0
request_count=0

# Process the input file line by line
while IFS=, read -r response_time request_name; do
  # Check if request_name contains "sents" or "clicks"
  if [[ "$request_name" =~ sents|clicks ]]; then
    # Check if request_name has changed
    if [ "$request_name" != "$current_request" ]; then
      if [ "$request_count" -gt 0 ]; then
        # Calculate average_response_time and max_response_time
        average_response_time=$(echo "scale=2; $total_response_time / $request_count" | bc)
        echo "$current_request, $average_response_time, $max_response_time" >> "$output_file"
      fi

      # Reset variables for the new request
      current_request="$request_name"
      total_response_time=0
      max_response_time=0
      request_count=0
    fi

    # Update total_response_time and max_response_time
    total_response_time=$(echo "$total_response_time + $response_time" | bc)
    if [ "$response_time" -gt "$max_response_time" ]; then
      max_response_time="$response_time"
    fi

    # Increment request_count
    request_count=$((request_count + 1))
  fi
done < "$input_file"

# Calculate and write the last request's statistics
if [ "$request_count" -gt 0 ]; then
  average_response_time=$(echo "scale=2; $total_response_time / $request_count" | bc)
  echo "$current_request, $average_response_time, $max_response_time" | tr -d '"' >> "$output_file"
fi

echo "Output written to $output_file"
