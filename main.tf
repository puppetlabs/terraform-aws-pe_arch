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
  subnet_id          = module.networking.subnet_id
  project            = var.project
  # network    = module.networking.network_link
  # subnetwork = module.networking.subnetwork_link
  region = var.region
  # zones     = var.zones
  instances = module.instances.compilers
}

# Instance module called from a dynamic source dependent on deploying 
# architecture
module "instances" {
  source             = "./modules/instances"
  vpc_id             = module.networking.vpc_id
  subnet_id          = module.networking.subnet_id
  security_group_ids = module.networking.security_group_ids
  id                 = random_id.deployment.hex
  # network        = module.networking.network_link
  # subnetwork     = module.networking.subnetwork_link
  # zones          = var.zones
  user           = var.user
  ssh_key        = var.ssh_key
  private_key    = var.private_key
  compiler_count = var.compiler_count
  ami_name       = var.ami_name
  project        = var.project
  architecture   = var.architecture
}
