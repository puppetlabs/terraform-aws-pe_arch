variable id {}
variable project {}
variable "allow" {
  description = "List of permitted IP subnets"
  type        = list(string)
}