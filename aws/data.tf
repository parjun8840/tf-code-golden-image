data "aws_region" "current" {}
data "aws_partition" "current" {}

data "aws_subnet" "this" {
  filter {
    name   = "tag:Name"
    values = ["public-1a"]
  }
}

data "aws_security_group" "this" {
  filter {
    name   = "tag:Name"
    values = ["sec-group"]
  }
}
