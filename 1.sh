#!/bin/bash

PORT=8080

stop_server() {
  echo "Stopping server..."
  exit
}

trap stop_server SIGINT

while :; do
  response='Hello'
  length=$(echo $response | wc -c)
  HTTP_RESPONSE_CODE="HTTP/1.1 200 OK"
  # enable interpret backslash escapes for echo
  echo -e "$HTTP_RESPONSE_CODE\r\nContent-Length: $length\r\n\r\n$response" | nc -lp 8080
done
