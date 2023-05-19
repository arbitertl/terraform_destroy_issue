# Disclaimer:
# 1. Source code was minimized by removing all parts not impacting issue reproduction
# 2. One resource module.ali_vpc.alicloud_vpc.vpc was removed from state so issue can be reproduced offline without Alibaba Cloud account

# Scenario: First destroy failed to destroy module.ali_vpc.alicloud_vpc.vpc due to Alibaba CLoud specific issues (which are happening frequently). This is second execution of destroy, after failure. First destroy is not triggering this validation. 

# To reproduce:
# 1. Ensure all files are present: terraform.tfstate, main.tf, modules/ali_rds/main.tf and modules/ali_vpc/main.tf
# 2. terraform init
# 3. terraform destroy

terraform {
  required_version = ">= 1.4.6"
  required_providers {
    alicloud = {
      source  = "aliyun/alicloud"
      version = "1.200.0"
    }
  }
}

provider "alicloud" {}

locals {
  db_datasource = join(",", [module.ali_rds[0].connection_string, module.ali_rds[0].port])
}

module "ali_vpc" {
  source = "./modules/ali_vpc"
}

# Observation 1: if this module doesn't have count it works
module "ali_rds" {
  count      = 1
  depends_on = [module.ali_vpc]
  source     = "./modules/ali_rds"
}

# Observation 2: this also works if we replace module.ali_rds and locals with:
# resource "alicloud_db_instance" "rds" {
#   count            = var.enable_rds ? 1 : 0
#   depends_on       = [module.ali_vpc]
#   engine           = ""
#   engine_version   = ""
#   instance_storage = 0
#   instance_type    = ""
# }

# locals {
#   db_datasource = join(",", [alicloud_db_instance.rds[0].connection_string, alicloud_db_instance.rds[0].port])
# }


# Observation 3: this also works if output is commented out
output "db_datasource" {
  value = local.db_datasource
}
