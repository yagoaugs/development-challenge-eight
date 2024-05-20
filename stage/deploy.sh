#!/bin/bash
tar -xvf stage.tar
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin $AWS_REGISTRY_URL
docker-compose up -d