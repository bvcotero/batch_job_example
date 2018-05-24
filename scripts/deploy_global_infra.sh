#!/bin/bash

echo "DEPLOYING THE GLOBAL INFRASTRUCTURE"

cd infrastructure/dev/global

echo "INITIALIZING TERRAFORM"
terraform init

if [ "$?" -ne 0 ]; then
   exit 1
fi

echo "CREATING INFRASTRUCTURE DEPLOYMENT PLAN"
terraform plan -out terraformplan.out

if [ "$?" -ne 0] ; then
   exit 1
fi

echo "DEPLOYING THE INFRASTRUCTURE PLAN"
terraform apply terraformplan.out

if [ "$?" -ne 0 ]; then
   exit 1
fi

rm -rf terraformplan.out

# EXPORT THE ECR REPO NAME AND URL

echo "Consumatum est..."
