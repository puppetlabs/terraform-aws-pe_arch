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
}

# Instance module called from a dynamic source dependent on deploying 
# architecture
module "instances" {
  source             = "./modules/instances"
  vpc_id             = module.networking.vpc_id
  subnet_ids         = module.networking.subnet_ids
  security_group_ids = module.networking.security_group_ids
  id                 = random_id.deployment.hex
  user               = var.user
  ssh_key            = var.ssh_key
  private_key        = var.private_key
  compiler_count     = var.compiler_count
  instance_image     = var.instance_image
  project            = var.project
  architecture       = var.architecture
}
