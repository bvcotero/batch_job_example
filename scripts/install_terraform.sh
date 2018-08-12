#!/bin/bash

echo "Checking that terraform is installed"
which terraform

if [ "$?" -eq 1 ]; then
   echo "Terraform is not installed...installing"
   curl -o terraform.zip https://releases.hashicorp.com/terraform/0.11.7/terraform_0.11.7_linux_amd64.zip
   unzip terraform.zip
   sudo mv terraform /bin/terraform
   rm -rf terraform.zip 
   echo ""
   echo "Terraform has been installed"
fi

echo "Consummatum est..."