
variable "tf_region"                 { default = "us-west-2" }
variable "aws-region"                { }

variable "application-name"          { }
variable "env"                       { }
variable "role"                      { }
variable "user"                      { }

variable "bucket"                    { }
variable "snapshots_key"             { }
variable "job_input"                 { }
variable "job_output"                { }

variable "lambda_role_policy_tmpl"      { }
variable "lambda_execution_policy_tmpl" { }
variable "lambda_batch_policy_tmpl"     { }
variable "lambda_function_zip_file"     { }

variable "default_tags" {
  type = "map"

  default = {
    "Name"                = "batch_service"
    "tr:appFamily"        = "batch_service_dev"
    "tr:appName"          = "wos"
    "tr:environment-type" = "dev"
    "tr:Role"             = "batch_service"
    "tr:created-by"       = "6047692"
  }
}
