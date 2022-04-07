variable "project" {
  description = "The name of the PE deployment project to tag resources with"
  type        = string
  default     = "pecdm"
}
variable "user" {
  description = "Default instance user name that will used for SSH operations"
  type        = string
  default     = "ec2-user"
}
variable "ssh_key" {
  description = "Location on disk of the SSH public key to be used for instance SSH access"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}
variable "region" {
  description = "AWS region that'll be targeted for infrastructure deployment"
  type        = string
  default     = "us-west-2"
}
variable "compiler_count" {
  description = "The quantity of compilers that are provisioned behind a load balancer"
  type        = number
  default     = 1
}
variable "node_count" {
  description = "The quantity of nodes that are deployed within the environment for testing"
  type        = number
  default     = 0
}
# If you provision from Marketplace then you might need to accept the AWS EULA
# for the AMI product used, default comes directly from AlmaLinux and no
# additional steps are required
variable "instance_image" {
  description = "The AMI name pattern to use when deploying new cloud instances"
  type        = string
  default     = "764336703387/AlmaLinux OS 8*"
}
variable "stack_name" {
  description = "A tag to group individual PE deployments within each project together"
  type        = string
  default     = "puppet-enterprise"
}
variable "architecture" {
  description = "Which of the supported PE architectures modules to provision infrastructure for"
  type        = string
  default     = "large"
}
variable "firewall_allow" {
  description = "List of permitted IP addresses, all entries must be provided in CIDR Subnet Mask Notation"
  type        = list(string)
  default     = []
}
variable "replica" {
  description = "To provision instances required for the deploying a primary server replica"
  type        = bool
  default     = false
}
variable "cluster_profile" {
  description = "Which cluster profile to use for defining provisioned instance sizes"
  type        = string
  default     = "development"

  validation {
    condition     = contains(["production", "development", "user"], var.cluster_profile)
    error_message = "The cluster profile selection must match one of production, development, or user."
  }
}