resource "aws_inspector_resource_group" "inspector" {
  tags {
    Name = "Build instance for devops-recipe"
    Ec2ImageBuildArn = "arn:aws:imagebuilder:us-east-1:123456789:image/devops-recipe/0.0.4/3"
  }
}

resource "aws_inspector_assessment_target" "inspector" {
  name               = "$local.name}-${var.image_name_tag}-target"
  resource_group_arn = "${aws_inspector_resource_group.inspector.arn}"
}

resource "aws_inspector_assessment_template" "inspector" {
  name       = "$local.name}-${var.image_name_tag}-template"
  target_arn = "${aws_inspector_assessment_target.inspector.arn}"
  duration   = 3600

  rules_package_arns = local.rules_package_arns
}
