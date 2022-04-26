# These are the variables required for the networking submodule to function
# properly and do not have any defaults set because this submodule should never
# be called from anything else expect the main module where values for all these
# variables will always be passed in
variable id {
  description = "Randomly generated value used to produce unique names for everything"
  type        = string
}
variable allow {
  description = "List of permitted IP subnets"
  type        = list(string)
}
variable project {
  description = "The name of the PE deployment project to tag resources with"
}
variable "to_create" {
  description = "If the networks should be created"
  type        = bool
  default     = true
}
variable "subnet" {
  description = "List of existing subnets to deploy to as opposed to creating them"
  type        = list(string)
  default     = []
}