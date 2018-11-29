#!/bin/bash

while getopts s:u:c:f option
do
  case "${option}"
    in
    s) ACTION="setup";;
    u) ACTION="update";;
    c) ACTION="clean";;
    f) ACTION="force";;
  esac
done

echo $ACTION

case "$ACTION" in
  setup)
    # Clone AEM Stack
    echo "Would run the setup action"
    ;;
  update)
    echo "Would run the update action"
    ;;
esac
