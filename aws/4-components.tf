resource "aws_imagebuilder_component" "devops-build" {
  name       = "${var.image_name_tag}-component"
  platform   = "Linux"
  version    = "1.0.1"
  #uri        = "s3://${var.aws_s3_bucket}/files/ubuntu-hids-agent-linux.yml"
  data = yamlencode({
    phases = [{
      name = "build"
      steps = [{
        name = "CurrentKernelRelease"
        action = "ExecuteBash"
        inputs = {
          commands = ["uname -r"]
        }},
        {
        name      = "UpdateOS"
        onFailure = "UpdateOS"
        },
        {
        name = "ubuntu-22-lts"
        action = "ExecuteBash"
        inputs = { 
          commands = ["sudo apt update", "sudo apt upgrade -y", "sudo apt install -y linux-aws"]
        }}
      ]
      }]
      schemaVersion = 1.0
      })
}

resource "aws_imagebuilder_component" "devops-hidc" {
  name       = "${var.image_name_tag}-hidc"
  platform   = "Linux"
  version    = "1.0.3"
  #uri        = "s3://${var.aws_s3_bucket}/files/ubuntu-hids-agent-linux.yml"
  data = yamlencode({
    phases = [{
      name = "build"
      steps = [{
        name = "S3Download"
        action = "S3Download"
        inputs = [{
          destination = "/tmp/{{ hidcversions }}",
          source = "s3://ami-pipeline-devops-ami-pipeline/binaries/{{ hidcversions }}"
        }]},
        {
        action = "ExecuteBash"
        name      = "Install"
        onFailure = "Continue"
        inputs = {
          commands = [
            "dpkg -i /tmp/{{ hidcversions }}"
          ]
        }
      }
    ]
    }]
    schemaVersion = 1.0
    parameters = [{
    hidcversions = {
    type = "string"
    description = "HIDC Agent version to install"
    }}]
  })
}
