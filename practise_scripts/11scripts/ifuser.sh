#!/bin/bash

UserName=user1

if id $UserName &> /dev/null; then
  echo "$UserName exists."
fi

