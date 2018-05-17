data "aws_ami" "amazon-ecs" {
  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }
  filter {
    name   = "name"
    values = ["amzn-ami-2017.09.l-amazon-ecs-optimized"]
  }
}

output "ecs_optimized_ami_id" {
  value = "${data.aws_ami.amazon-ecs.id}"
}
