#!/bin/bash
( for Percent in {1..100}; do
  echo "XXX"
  echo "Percent: ${Percent}%"
  echo "XXX"
  echo $Percent
  sleep 0.2
done ) | dialog --clear --gauge "Gauge" 8 50 0
