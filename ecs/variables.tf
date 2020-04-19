variable "region" {
  type        = string
  description = "AWS Region"
}

variable "vpc_cidr_block" {
  type        = string
  description = "VPC CIDR block"
}

variable "subnet" {
  type        = map
  description = "Subnets properties"
}

variable "allow_from" {
  type        = string
  description = "Allow SSH from this range"
  default     = "0.0.0.0/0"
}
