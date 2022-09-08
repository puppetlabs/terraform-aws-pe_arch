# Terraform setup stuff, required providers, where they are sourced from, and
# the provider's configuration requirements.
terraform {
  required_providers {
    hiera5 = {
      source  = "sbitio/hiera5"
      version = "0.2.7"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "3.32.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.1.0"
    }
  }
}

# Sets the variables that'll be interpolated to determine where variables are
# located in the hierarchy
provider "hiera5" {
  scope = {
    architecture = var.architecture
    replica      = var.replica
    profile      = var.cluster_profile
  }
}

provider "aws" {
  region  = var.region
}

# hiera lookups
data "hiera5" "server_count" {
  key = "server_count"
}
data "hiera5" "database_count" {
  key = "database_count"
}

data "hiera5_bool" "has_compilers" {
  key = "has_compilers"
}

data "hiera5" "compiler_type" {
  key = "compiler_instance_type"
}
data "hiera5" "primary_type" {
  key = "primary_instance_type"
}
data "hiera5" "database_type" {
  key = "database_instance_type"
}

data "hiera5" "compiler_disk" {
  key = "compiler_disk_size"
}
data "hiera5" "primary_disk" {
  key = "primary_disk_size"
}
data "hiera5" "database_disk" {
  key = "database_disk_size"
}

# Prevent name collisions when multiple PE deployments are provisioned within
# the same AWS account
resource "random_id" "deployment" {
  byte_length = 3
}

# Repeated and computed values used by component modules
locals {
  allowed            = concat(["10.128.0.0/9"], var.firewall_allow)
  compiler_count     = data.hiera5_bool.has_compilers.value ? var.compiler_count : 0
  id                 = random_id.deployment.hex
  has_lb             = var.disable_lb ? false : data.hiera5_bool.has_compilers.value ? true : false
  image_list         = split("/", var.instance_image)
  image_owner        = local.image_list[0]
  image_pattern      = local.image_list[1]
  image_product_code = try(local.image_list[2], null)
  create_network     = var.subnet == null ? true : false
}

# Contain all the networking configuration for readability
module "networking" {
  source    = "./modules/networking"
  id        = local.id
  project   = var.project
  allow     = local.allowed
  to_create = local.create_network
  subnet    = var.subnet
}

# Contain all the loadbalancer configuration for readability
module "loadbalancer" {
  source             = "./modules/loadbalancer"
  id                 = local.id
  vpc_id             = module.networking.vpc_id
  ports              = ["8140", "8142"]
  security_group_ids = module.networking.security_group_ids
  subnet_ids         = module.networking.subnet_ids
  project            = var.project
  region             = var.region
  instances          = module.instances.compilers
  has_lb             = local.has_lb
  compiler_count     = local.compiler_count
  lb_ip_mode         = var.lb_ip_mode
}

# Contain all the instances configuration for readability
# 
module "instances" {
  source             = "./modules/instances"
  vpc_id             = module.networking.vpc_id
  subnet_ids         = module.networking.subnet_ids
  security_group_ids = module.networking.security_group_ids
  id                 = local.id
  user               = var.user
  ssh_key            = var.ssh_key
  compiler_count     = local.compiler_count
  node_count         = var.node_count
  instance_image     = local.image_pattern
  image_owner        = local.image_owner
  image_product_code = local.image_product_code
  tags               = var.tags
  project            = var.project
  server_count       = data.hiera5.server_count.value
  database_count     = data.hiera5.database_count.value
  compiler_type      = data.hiera5.compiler_type.value
  primary_type       = data.hiera5.primary_type.value
  database_type      = data.hiera5.database_type.value
  compiler_disk      = data.hiera5.compiler_disk.value
  primary_disk       = data.hiera5.primary_disk.value
  database_disk      = data.hiera5.database_disk.value
  domain_name        = var.domain_name
}