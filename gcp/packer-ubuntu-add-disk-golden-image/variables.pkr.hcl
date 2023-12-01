variable "project_id" {
  type    = string
  default = "stg-security-prj"
}

variable "zone" {
  type    = string
  default = "asia-northeeast1-a"
}

variable "os_version" {
  type    = string
  default = "22-04-lts"
}

variable "platform_arch_type" {
  description = "Set this value to choose AMD or ARM based instances"
  type    = string
  default = "x86-64"
  validation {
  condition = contains(["x86-64", "arm64"], var.platform_arch_type)
  error_message = "Valid values for var: platform_arch_type are ("x86-64", "arm64")"
  }
}

variable "platform_arch_type_mapping" {
  description = "Set this value to choose AMD or ARM based instances"
  type    = string
  default = {
  "x86-64" = "ubuntu-2204-lts"
  "arm64" = "ubuntu-2204-lts-arm64"

}


variable "additional_tags" {
  type = map(string)
  default = {
    "environment" = "Stg"
    "os_version"  = "Ubuntu-22-04"
    "release"     = "lts"
    "created-by"  = "packer"
  }
}

variable "network" {
  type    = string
  default = "projects/PROJECT_ID/global/networks/NAME_VPC_NETWORK"
}

variable "subnetwork" {
  type    = string
  default = "projects/PROJECT_ID/regions/REGION/subnetworks/NAME_SUBNET"
}

variable "disk_size" {
  type    = number
  default = 20
}
