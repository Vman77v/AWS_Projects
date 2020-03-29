variable "product_line" {
  type        = string
  default     = "personal-tools"
}

variable "team_name" {
  type        = string
  default     = "vince-home"
}

variable "app_name" {
  type        = string
  default     = "personal-tools"
}

variable "app_environment" {
  type        = string
  default     = "development"
}

variable "app_env" {
  type        = string
  default     = "Dev"
}

variable "role_arns" {
  type    = map(string)
  default = {
    Dev   = "arn:aws:iam::726168248740:role/ReleaseManagementRole"
  }
}

variable "aws_region" {
  type = string
  default = "us-west-2"
}

locals {

  common_tags = {
    repository  = "AWS_Projects"
    env         = var.app_env
    environment = var.app_environment
    name       = var.app_name
    terraform   = "true"
  }
}