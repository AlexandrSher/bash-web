#!/bin/bash
## This line specifies that the script is written in the bash scripting language.

## This script is a basic web server that listens on port 8080 and responds to HTTP requests.
## The stop_server function is used to gracefully shut down the server when the user presses Ctrl+C.
## The handle_request function processes each incoming HTTP request, extracts the requested URL,
## executes the request and captures the output, calculates the content length of the output,
## creates an HTTP response header, and writes the response header to a file. Finally,
## the server starts listening on the specified port and passes incoming requests to the handle_request function.

# Set the port number that the web server will listen on
PORT=8080

# Add logging function for create logs with timestamp
function logging() {
  d=$(date "+%Y-%m-%d %H:%M:%S")
  echo "[${d}] $@"
}

# Function to stop the server
## This function defines how the server will be stopped when the user presses Ctrl+C. It prints a message to the console and exits the script.
stop_server() {
  logging "Stopping server..."
  rm -f response
  exit
}

# Register the signal trap
## This line registers the stop_server function to be called when the user presses Ctrl+C.
trap stop_server SIGINT

# Function to handle incoming HTTP requests
handle_request() {
  while read -r line; do
    logging "$line"

    trline=`echo "$line" | tr -d '[\r\n]'`

    # If the line is empty, break the loop
    [ -z "$trline" ] && break

    # Use regex to match the HTTP request line
    # If the line matches the regex, extract the request URL
    # normal space is url encoded as %20 but you can use + also (old approach)
    (echo "$trline" | grep -Eq '(.*?)\s(.*?)\sHTTP.*?') && REQUEST=$(echo $trline | sed 's/\///g' | awk '{print $2}' | sed 's/\%20/ /g')
  done
  
  # Execute the request and capture the output
  if check_comand=`$REQUEST 2>&1`; then
    output=$check_comand
    HTTP_RESPONSE_CODE="HTTP/1.1 200 OK"
  else
    output=`echo $check_comand | sed 's/.\/web.sh: line 49: //g'`
    HTTP_RESPONSE_CODE="HTTP/1.1 404 Not Found"
  fi
  logging $output
  
  # Calculate the content length of the output
  content_length=$(echo $output | wc -c)
  
  # Create the HTTP response header
  RESPONSE="$HTTP_RESPONSE_CODE\r\nContent-Type: text/plain\r\nContent-Length: $content_length\r\n\r\n$output"

  # Write the response header to a file
  echo -e $RESPONSE > response
}

# Remove any existing response file and create a named pipe
rm -f response
mkfifo response

# Start the web server
while :; do
  # Use netcat to listen on the specified port and pass incoming requests to the handle_request function
  cat response | nc -lp $PORT | handle_request
done
