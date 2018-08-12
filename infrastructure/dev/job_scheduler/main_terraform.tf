# -------------------------------------------------
#       CREATING POLICIES AND ROLES FOR
#                 LAMBDA f(x)
# -------------------------------------------------

# File that contains the policy for Lambda to access S3 resources

data "template_file" "lambda_policy" {
    template = "${file("${var.lambda_role_policy_tmpl}")}"
    vars {
        source_bucket_name = "${var.bucket}${var.snapshots_key}${var.job_input}"
        target_bucket_name = "${var.bucket}${var.snapshots_key}${var.job_output}"
    }
}

data "template_file" "lambda_execution" {
    template = "${file("${var.lambda_execution_policy_tmpl}")}"
}

data "template_file" "lambda_batch_policy" {
    template = "${file("${var.lambda_batch_policy_tmpl}")}"
}

module "iam_lambda" {
   source = "./modules/iam"

   app_name              = "${var.application-name}"
   role                  = "${var.role}"
   env                   = "${var.env}"
   user                  = "${var.user}"

   policy_file           = "${data.template_file.lambda_policy.rendered}"
   batch_policy_file     = "${data.template_file.lambda_batch_policy.rendered}"
   execution_policy_file = "${data.template_file.lambda_execution.rendered}"
}

# ------------------------------------------------
#              CREATES LAMBDA f(X)
# ------------------------------------------------

module "lambda_function" {
  source = "./modules/lambda"

  zip_file      = "${var.lambda_function_zip_file}"
  app-name      = "${var.role}_${var.application-name}_${var.env}-${var.user}"
  role          = "${module.iam_lambda.execution_role_arn}"
  handler       = "main.entrypoint"
  runtime       = "python2.7"
  tags          = "${module.tags.tags_merged}"
}

resource "aws_lambda_alias" "dev_alias" {
    name             = "${var.application-name}_dev_alias"
    description      = "An alias for the dev environment lambda"
    function_name    = "${module.lambda_function.lambda_function_arn}"
    function_version = "$LATEST"
}

resource "aws_lambda_permission" "allow_bucket" {
    statement_id = "AllowExecutionFromS3Bucket"
    action = "lambda:InvokeFunction"
    function_name = "${aws_lambda_alias.dev_alias.arn}"
    principal = "s3.amazonaws.com"
    source_arn = "${data.aws_s3_bucket.snapshots.arn}"
}

resource "aws_s3_bucket_notification" "bucket_notification" {
    bucket = "${data.aws_s3_bucket.snapshots.id}"
    lambda_function {
        lambda_function_arn = "${aws_lambda_alias.dev_alias.arn}"
        events = ["s3:ObjectCreated:*"]
        filter_prefix = "${var.snapshots_key}${var.job_input}/"
        filter_suffix = "zip"
    }
}

output "lambda_function_arn" { value = "${module.lambda_function.lambda_function_arn}" }
output "execution_role_arn" { value = "${module.iam_lambda.execution_role_arn}" }
output "execution_policy" { value = "${module.iam_lambda.exec_pol}" }
output "lambda_dev_alias" { value = "${aws_lambda_alias.dev_alias.arn}" }
