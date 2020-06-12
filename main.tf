# The module makes repeated use of the try() function so requires a very recent
# release of Terraform 0.12
terraform {
  required_version = ">= 0.12.20"
}

provider "aws" {
  version = "~> 2.0"
  region  = var.region
}

# It is intended that multiple deployments can be launched easily without
# name colliding
resource "random_id" "deployment" {
  byte_length = 3
}

# Contain all the networking configuration in a module for readability
module "networking" {
  source  = "./modules/networking"
  id      = random_id.deployment.hex
  project = var.project
  allow   = var.firewall_allow
}

# Contain all the loadbalancer configuration in a module for readability
module "loadbalancer" {
  source             = "./modules/loadbalancer"
  id                 = random_id.deployment.hex
  ports              = ["8140", "8142"]
  security_group_ids = module.networking.security_group_ids
  subnet_ids         = module.networking.subnet_ids
  project            = var.project
  region             = var.region
  instances          = module.instances.compilers
  architecture       = var.architecture
}

# Contain all the instances configuration in a module for readability
# 
# NOTE: you will need to add your private key corresponding to `ssh_key` 
# to the ssh agent like so:
# $ eval $(ssh-agent)
# $ ssh-add
module "instances" {
  source             = "./modules/instances"
  vpc_id             = module.networking.vpc_id
  subnet_ids         = module.networking.subnet_ids
  security_group_ids = module.networking.security_group_ids
  id                 = random_id.deployment.hex
  user               = var.user
  ssh_key            = var.ssh_key
  compiler_count     = var.compiler_count
  node_count         = var.node_count
  instance_image     = var.instance_image
  project            = var.project
  architecture       = var.architecture
}
