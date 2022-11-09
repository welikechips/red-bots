variable "region" {
  type        = string
  description = "The region where the instances are built."
}
variable "master_ami_id" {
  type        = string
  description = "The id of the machine image (AMI) to use for the master server."
}

variable "master_instance_type" {
  type        = string
  description = "Instance type for the master instance."
}

variable "bot_ami_id" {
  type        = string
  description = "The id of the machine image (AMI) to use for the bot servers."
}

variable "bot_instance_type" {
  type        = string
  description = "Instance type for the bot instances."
}

variable "_count" {
  default = 2
}

variable "env" {
  type = string
}

variable "subnet" {
  type        = string
  description = "The local subnet for the instances"
}

variable "availability_zones" {
  type = list
}

variable "spot_type" {
  type        = string
  description = "The spot type (persistent, one-time)"
}