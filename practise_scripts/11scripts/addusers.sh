#!/bin/bash

for I in {1..10}; do
  useradd user$I;
  echo user$I | passwd --stdin user$I
done
