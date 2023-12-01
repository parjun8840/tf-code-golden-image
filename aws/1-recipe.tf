resource "aws_imagebuilder_image" "devops-image-x86" {
  distribution_configuration_arn   = aws_imagebuilder_distribution_configuration.devops-dist-config.arn
  image_recipe_arn                 = aws_imagebuilder_image_recipe.devops-recipe.arn
  infrastructure_configuration_arn = aws_imagebuilder_infrastructure_configuration.devops-infra-config.arn

}

resource "aws_imagebuilder_image_recipe" "devops-recipe" {
  block_device_mapping {
    device_name = "/dev/sda1"

    ebs {
      delete_on_termination = true
      volume_size           = var.ebs_root_vol_size
      volume_type           = "gp3"
    }
  }

  component {
    component_arn = aws_imagebuilder_component.devops-build.arn
  }

  name         = "${var.ami_name_tag}-recipe"
  parent_image = "arn:${data.aws_partition.current.partition}:imagebuilder:${data.aws_region.current.name}:aws:image/ubuntu-22-lts-arm64/x.x.x"
  version      = var.image_receipe_version

  lifecycle {
    create_before_destroy = false
  }

  tags = {
    "Name" = "${var.ami_name_tag}-recipe"
  }
}
