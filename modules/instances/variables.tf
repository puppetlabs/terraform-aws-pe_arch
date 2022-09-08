# These are the variables required for the instances submodule to function
# properly and are duplicated highly from the main module but instead do not
# have any defaults set because this submodule should never by called from
# anything else expect the main module where values for all these variables will
# always be passed in
variable "user" {
  description = "Default instance user name that will used for SSH operations"
  type        = string
}
variable "ssh_key" {
  description = "Location on disk of the SSH public key to be used for instance SSH access"
  type        = string
}
variable "compiler_count" {
  description = "The quantity of compilers that are provisioned behind a load balancer"
  type        = number
}
variable "server_count" {
  description = "The quantity of server nodes which are provisioned for the stack"
  type        = number
}
variable "database_count" {
  description = "The quantity of database nodes which are provisioned for the stack"
  type        = number
}
variable "id" {
  description = "Randomly generated value used to produce unique names for everything"
  type        = string
}
variable "vpc_id" {
  description = "Randomly generated value used to produce unique names for everything"
}
variable "subnet_ids" {
  description = "AWS subnet ids that are provided by the networking module"
}
variable "security_group_ids" {
  description = "AWS security groups ids that are provided by the networking module"
}
variable "project" {
  description = "The name of the PE deployment project to tag resources with"
  type        = string
}
variable "instance_image" {
  description = "The AMI name pattern to use when provisioning cloud instances"
  type        = string
}
variable "image_owner" {
  description = "The owner ID of the desired AMI to use for provisioned cloud instances"
  type        = string
}
variable "image_product_code" {
  description = "The product code of desired AMI when sourcing from the AWS Marketplace"
  type        = string
  default     = null
}
variable "tags" {
  description = "A map of tags to apply to provisioned resources"
  type        = map
}
variable "node_count" {
  description = "The quantity of nodes that are deployed within the environment for testing"
  type        = number
}
variable "compiler_type" {
  description = "Instance type of compilers"
  type        = string
}
variable "primary_type" {
  description = "Instance type of primary and replica"
  type        = string
}
variable "database_type" {
  description = "Instance type of PuppetDB database and replica"
  type        = string
}
variable "compiler_disk" {
  description = "Instance disk size of compilers"
  type        = string
}
variable "primary_disk" {
  description = "Instance disk size of primary and replica"
  type        = string
}
variable "database_disk" {
  description = "Instance disk size of PuppetDB database and replica"
  type        = string
}
variable "domain_name" {
  description = "Custom domain to use for internalDNS"
  type        = string
  default     = null
}