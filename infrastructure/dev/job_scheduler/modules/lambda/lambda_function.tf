# ------------------------------------------------
#              CREATES LAMBDA f(X)
# ------------------------------------------------

variable "zip_file"          { }
variable "app-name"          { }

variable "handler"           { }
variable "runtime"           { }
variable "role"              { }

variable "tags"              { type = "map" }


# Creates lambda function with a zip file containing code  

resource "aws_lambda_function" "lambda" {
    filename         = "${var.zip_file}"
    function_name    = "${var.app-name}-function"
    role             = "${var.role}"
    handler          = "${var.handler}"
    runtime          = "${var.runtime}"
    tags             = "${var.tags}"
    source_code_hash = "${base64sha256(file("${var.zip_file}"))}"
}

output "lambda_function_arn" { value = "${aws_lambda_function.lambda.arn}" }
