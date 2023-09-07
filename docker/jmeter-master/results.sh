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

# Use Python to parse and process the CSV file
python3 <<EOF
import csv

input_file = "$input_file"
output_file = "$output_file"

# Initialize variables to store request_name, total_response_time, and request_count
current_request = ""
total_response_time = 0
max_response_time = 0
request_count = 0

with open(input_file, 'r') as csvfile, open(output_file, 'w', newline='') as output_csvfile:
    reader = csv.reader(csvfile)
    writer = csv.writer(output_csvfile)
    writer.writerow(["request_name", "average_response_time", "max_response_time"])
    
    for row in reader:
        response_time = int(row[0])
        request_name = row[1].strip('"')
        
        if "Sents" in request_name or "Clicks" in request_name:
            if request_name != current_request:
                if request_count > 0:
                    average_response_time = total_response_time / request_count
                    writer.writerow([current_request, "{:.2f}".format(average_response_time), max_response_time])
                
                current_request = request_name
                total_response_time = 0
                max_response_time = 0
                request_count = 0
            
            total_response_time += response_time
            max_response_time = max(max_response_time, response_time)
            request_count += 1
    
    if request_count > 0:
        average_response_time = total_response_time / request_count
        writer.writerow([current_request, "{:.2f}".format(average_response_time), max_response_time])
    
print("Output written to", output_file)
EOF
