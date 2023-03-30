#!/bin/bash

PORT=8080

stop_server() {
  echo "Stopping server..."
  exit
}

trap stop_server SIGINT

handle_request() {
  while read -r line; do
    trline=`echo "$line" | tr -d '[\r\n]'`
    [ -z "$trline" ] && break
    (echo "$trline" | grep -Eq '(.*?)\s(.*?)\sHTTP.*?') && REQUEST=$(echo $trline | sed 's/\///g' | awk '{print $2}')
  done

  HTTP_RESPONSE_CODE="HTTP/1.1 200 OK"
  
  content_length=$(echo $REQUEST | wc -c)
  RESPONSE="$HTTP_RESPONSE_CODE\r\nContent-Type: text/plain\r\nContent-Length: $content_length\r\n\r\n$REQUEST"
  echo -e $RESPONSE > response
}

rm -f response
mkfifo response

while :; do
  cat response | nc -lp $PORT | handle_request
done
