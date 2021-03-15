# These are the variables required for the networking submodule to function
# properly and do not have any defaults set because this submodule should never
# be called from anything else expect the main module where values for all these
# variables will always be passed in
variable id {
  description = "Randomly generated value used to produce unique names for everything to prevent collisions and visually link resources together"
  type        = string
}
variable allow {
  description = "List of permitted IP subnets"
  type        = list(string)
}
variable project {
  description = "Project string to differentiate and associate resources"
}