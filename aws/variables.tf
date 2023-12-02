variable "aws_region" {
  type        = string
  description = "The AWS region."
  default = "us-east-1"
}

variable "image_name_tag" {
  type        = string
  default = "ubuntu-image"
}

variable "ebs_root_vol_size" {
  type        = number
  default = 30
}

variable "image_receipe_version" {
  type = string
  default = "0.0.4"
}

variable "ec2_iam_role_name" {
  type        = string
  description = "The EC2's IAM role name."
  default = "ami-pipeline-imagebuilder"
}


variable "enabled_rules" {
  type        = list(string)
  description = <<-DOC
    A list of AWS Inspector rules that should run on a periodic basis.

    Valid values are `cve`, `cis`, `nr`, `sbp` which map to the appropriate [Inspector rule arns by region](https://docs.aws.amazon.com/inspector/latest/userguide/inspector_rules-arns.html).
  DOC
  default = ["cve","cis","nr","sbp"]
}

variable "hidsversions" {
  type        = string
  default = "hidsversions-versions-arm64.deb"
}
