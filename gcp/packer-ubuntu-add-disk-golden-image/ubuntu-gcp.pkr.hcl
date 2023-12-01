locals {
  source_image_family = lookup(var.platform_arch_type_mapping, var.platform_arch_type, "ubuntu-2204-lts-arm64")
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
  tags = merge({"arch_type" = "${var.platform_arch_type}"}, var.additional_tags)
}


source "googlecompute" "ubuntu" {
  image_name          = "ubuntu-gcp-${var.os_version}-${var.platform_arch_type}-{{timestamp}}"
  image_description   = "Ubuntu 22-04 ubuntu-gcp-${var.os_version}-${var.platform_arch_type}-{{timestamp}}"
  project_id          = var.project_id
  source_image_family = local.source_image_family
  ssh_username        = "ubuntu"
  labels              = local.tags
  zone                = var.zone
  network             = var.network
  subnetwork          = var.subnetwork
  disk_size           = var.disk_size

}

build {
  sources = ["source.googlecompute.ubuntu"]

  provisioner "shell" {
    inline = [
      "echo Installing Updates",
      "sudo apt-get update",
      "sudo apt-get upgrade -y"
    ]
  }

  # Install supporting tools
  provisioner "shell" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y ubuntu-drivers-common",
      "sudo ubuntu-drivers autoinstall",
      "sudo su -c  \"echo 'deb https://packages.cloud.google.com/apt google-compute-engine-focal-stable main' > /etc/apt/sources.list.d/google-compute-engine.list\"",
      "curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add - ",
      "sudo apt-get update",
      "sudo apt -y install google-osconfig-agent",
      "sudo apt -y install xfsprogs"
    ]
  }

  # Install the Server Protection agent on your server to protect against malware, dangerous file types, websites, and malicious network traffic
  provisioner "shell" {
  inline = ["gsutil cp gs://YOUR_BUCKET/pkgs/security/OS_AGENT.deb /tmp", "sudo dpkg -i /tmp/OS_AGENT.deb"
  }

  provisioner "shell" {
  inline = [
  "curl -o /tmp/add-google-cloud-ops-agent-repo.sh https://dl.google.com/cloudagents/add-google-cloud-ops-agent-repo.sh",
  "sudo chmod +x /tmp/add-google-cloud-ops-agent-repo.sh",
  "sudo bash add-google-cloud-ops-agent-repo.sh --also-install"
  ]
  }

}
