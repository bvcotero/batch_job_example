#!/bin/bash

echo "DEPLOYING THE BATCH SERVICE INFRASTRUCTURE"
echo ""
echo "CREATING LAMBDA ZIP PACKAGE"

cd function
mkdir lib
pip install -r requirements.txt -t ./lib/
cd lib and zip -r ../batch_job_scheduler.zip *
cd .. and zip -9 batch_job_scheduler.zip ./main.py

echo "RUN TERRAFORM"

cd ../infrstructure/dev/job_scheduler

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