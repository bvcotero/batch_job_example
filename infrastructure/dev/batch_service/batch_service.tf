
resource "aws_batch_compute_environment" "batch_service" {
  compute_environment_name = "${var.role}_${var.app}_${var.region}_${var.env}-${var.user}"
  compute_resources {
    ec2_key_pair  = "sar-devops-team"
    instance_role = "${data.aws_iam_instance_profile.instance_profile.arn}"
    instance_type = [
      "m3"
    ]
    max_vcpus          = 3
    min_vcpus          = 1
    desired_vcpus      = 1
    security_group_ids = [
      "${data.aws_security_group.batch_sg.id}"
    ]
    subnets  = ["${data.aws_subnet_ids.private.ids}"]
    type     = "EC2"
    image_id = "${data.aws_ami.amazon-ecs.id}"
    tags    = "${module.tags.tags_merged}"
  }

  service_role = "${data.aws_iam_role.batch_service_role.arn}"
  type = "MANAGED"

#  depends_on = ["aws_iam_role_policy_attachment.aws_batch_service_role"]
}

resource "aws_batch_job_queue" "batch_service_wos" {
  name = "batch-${var.app}-job-queue-${var.user}"
  state = "ENABLED"
  priority = 1
  compute_environments = ["${aws_batch_compute_environment.batch_service.arn}"]
}

resource "aws_batch_job_definition" "hello_world" {
  name = "batch_wos_job_definition"
  type = "container"
  container_properties = <<CONTAINER_PROPERTIES
{
  "command":["ls"],
  "image": "${data.aws_ecr_repository.unzip_repo.repository_url}",
  "memory": 512,
  "vcpus": 1
}
CONTAINER_PROPERTIES
}

#resource "aws_batch_job_definition" "hello_world" {
#  name = "batch_wos_job_definition"
#  type = "container"
#  container_properties = <<CONTAINER_PROPERTIES
#{
#  "command":["ls"],
#  "image": "${data.aws_ecr_repository.hello_world_repo.repository_url}",
#  "memory": 512,
#  "vcpus": 1
#}
#CONTAINER_PROPERTIES
#}

