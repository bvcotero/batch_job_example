#!/bin/bash

echo "DEPLOYING THE BATCH SERVICE INFRASTRUCTURE"

cd infrastructure/dev/batch_service

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

echo "Consumatum est..."