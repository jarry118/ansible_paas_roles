#!/bin/bash
while true
do
    if [ `ps -ef|grep mysqld|grep -v grep | wc -l` -ne 0 ];then
      echo "mysql is ok"
      sleep 5
        else
        service keepalived stop
    fi
  sleep 5
done