#!/bin/bash

# Check if IP address is provided
if [ -z "$1" ]; then
    echo "用法: ssh2spiders.sh <IP地址>"
    exit 1
fi

# SSH with predefined key and user
ssh -i ~/.ssh/pems/scrapy_key.pem ubuntu@"$1"
