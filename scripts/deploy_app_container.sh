#!/bin/bash

cd docker/fn-unzip2s3
eval $(aws ecr get-login --no-include-email --region us-west-2 | sed 's|https://||')
printenv

echo "BUILDING IMAGE AND PUSHING IT TO ECR REPOSITORY"

docker build -t $ECR_REPO_NAME .
docker tag $ECR_REPO_NAME:latest $ECR_REPO_URL:latest
docker push $ECR_REPO_URL:latest

echo "Consumatum est..."