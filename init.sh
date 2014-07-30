#!/bin/sh

service sshd start

#Redis Config
#
service redis start
if [ -z "$REDIS_MASTER_PORT_6379_TCP_ADDR" ]; then
  echo "REDIS_MASTER_PORT_6379_TCP_ADDR not defined. Did you run with -link?";
else
  redis-cli slaveof $REDIS_MASTER_PORT_6379_TCP_ADDR 6379
fi

#Sentinel Config
#
if [ -z "$SENTINEL_QUORUM" ]; then
  QUORUM=1
else
  numeric_check=`echo $SENTINEL_QUORUM | awk '/[^0-9]/ {print}'`
  if [[ ! -z $numeric_check ]]; then
    echo "SENTINEL_QUORUM is must be specified numeric"
    exit 1
  fi
  QUORUM=$SENTINEL_QUORUM
fi

if [ -z "$REDIS_MASTER_PORT_6379_TCP_ADDR" ]; then
  echo "REDIS_MASTER_PORT_6379_TCP_ADDR not defined. Did you run with -link?";
  sed -i -e "s/^sentinel monitor.*/sentinel monitor mymaster `ip -f inet addr show eth0 | awk '/inet/{ print $2}' | cut -d'/' -f1` 6379 $QUORUM/g" /etc/redis-sentinel.conf
else
  sed -i -e "s/^sentinel monitor.*/sentinel monitor mymaster $REDIS_MASTER_PORT_6379_TCP_ADDR 6379 $QUORUM/g" /etc/redis-sentinel.conf
fi
service redis-sentinel start

while [[ true ]]; do
  /bin/bash
done
