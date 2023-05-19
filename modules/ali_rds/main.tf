terraform {
  required_version = ">= 1.4.6"
  required_providers {
    alicloud = {
      source  = "aliyun/alicloud"
      version = "1.200.0"
    }
  }
}

resource "alicloud_db_instance" "rds" {
  engine           = ""
  engine_version   = ""
  instance_storage = 0
  instance_type    = ""
}

output "connection_string" {
  value = alicloud_db_instance.rds.connection_string
}

output "port" {
  value = alicloud_db_instance.rds.port
}
