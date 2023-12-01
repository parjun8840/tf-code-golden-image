resource "aws_imagebuilder_distribution_configuration" "devops-dist-config" {
  name = "${var.ami_name_tag}-dist-config"

  distribution {
    ami_distribution_configuration {

      ami_tags = {
        team = "devops"
      }

      name = "${var.ami_name_tag}-{{ imagebuilder:buildDate }}"

      launch_permission {
        # user_ids = ["123456789012"]
      }
    }
    region = var.aws_region
  }
}
