resource "aws_imagebuilder_image_pipeline" "devops-pipeline" {
  name                             = "${var.ami_name_tag}-pipeline"
  status                           = "ENABLED"
  description                      = "Creates an AMI."
  image_recipe_arn                 = aws_imagebuilder_image_recipe.devops-recipe.arn
  infrastructure_configuration_arn = aws_imagebuilder_infrastructure_configuration.devops-infra-config.arn
  distribution_configuration_arn   = aws_imagebuilder_distribution_configuration.devops-dist-config.arn

  schedule {
    schedule_expression = "cron(0 10 ? * tue)"
    # This cron expressions states every Tuesday at 10 AM.
    pipeline_execution_start_condition = "EXPRESSION_MATCH_AND_DEPENDENCY_UPDATES_AVAILABLE"
  }

  image_scanning_configuration {
    image_scanning_enabled = true
  }

  # Test the image after build
  image_tests_configuration {
    image_tests_enabled = true
    timeout_minutes     = 60
  }

  tags = {
    "Name" = "${var.ami_name_tag}-pipeline"
  }

  depends_on = [
    aws_imagebuilder_image_recipe.devops-recipe,
    aws_imagebuilder_infrastructure_configuration.devops-infra-config
  ]
}
