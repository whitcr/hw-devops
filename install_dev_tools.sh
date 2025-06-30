#!/bin/bash

if ! command -v docker &> /dev/null; then
  sudo apt update
  sudo apt install -y docker.io
else
  echo "Docker installed"
fi

if ! command -v docker-compose &> /dev/null; then
  sudo apt install -y docker-compose
else
  echo "Docker Compose installed"
fi

if ! command -v python3 &> /dev/null; then
  sudo apt install -y python3
else
  echo "Python installed"
fi

if ! command -v pip3 &> /dev/null; then
  sudo apt install -y python3-pip
else
  echo "pip installed"
fi

if ! python3 -m django --version &> /dev/null; then
  pip3 install django
else
  echo "Django installed"
fi
