terraform {
  required_version = ">= 1.4.6"
  required_providers {
    alicloud = {
      source  = "aliyun/alicloud"
      version = "1.200.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "3.2.1"
    }
  }
}

resource "alicloud_vpc" "vpc" {
  depends_on = [
    null_resource.naming_parameter_validation
  ]
}

resource "null_resource" "naming_parameter_validation" {
  triggers = {
    name = ""
  }
}
