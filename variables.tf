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

variable "api_end_point_domain" {
  type        = string
  description = "The api endpoint domain"
}

variable "api_key" {
  type        = string
  description = "The api key to the endpoint"
}

variable "api_bot_guid" {
  type        = string
  description = "The bot guid"
}

variable "api_end_point_security_group_id" {
  type        = string
  description = "Security group to attach master redirector to allow ingress to api"
}

variable "red_bots_port_22_ssh_access_cidrs" {
  type        = list
  description = "The ip address cidrs you are using to access master and bots."
}

variable "red_bots_master_redirector_access_cidrs" {
  type        = list
  description = "The ip address cidrs you are using to access master redirector."
}

variable "server_name" {
  type = string
  description = "The ssl cert server name"
}

variable "contact_email" {
  type = string
  description = "contact email for certbot renewals"
}

variable "hosted_zone_id" {
  type = string
  description = "The hosted zone id for the redirector server"
}