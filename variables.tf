variable "vpc_config" {
  description = "Contains the VPC configuration. Specifically the CIDR block and name of the VPC which is required."
  type = object({
    cidr_block = string
    name       = string
  })

  validation {
    condition     = can(cidrnetmask(var.vpc_config.cidr_block))
    error_message = "The cidr_block config option must contain a valid CIDR block."
  }
}

variable "subnet_config" {
  description = <<EOT
  Accepts a map of objects that define the subnet configuration. Each object must contain the following:
  - cidr_block: The CIDR block for the subnet.
  - public: A boolean indicating if the subnet is public or private. Defaults to false.
  - az: The availability zone for the subnet. This is required.
  EOT
  type = map(object({
    cidr_block = string
    public     = optional(bool, false)
    az         = string
  }))

  validation {
    condition = alltrue([
      for config in values(var.subnet_config) : can(cidrnetmask(config.cidr_block))
    ])
    error_message = "The CIDR_block config option must contain a valid CIDR block."
  }
}