variable "region" {
  type        = string
  description = "AWS Region"
}

variable "role_arn" {
  type        = string
  description = "Assume IAM Role"
}

variable "cidr_block" {
  type        = string
  description = "VPC CIDR Block"
}

variable "default_tags" {
  type        = map(string)
  description = "Tagging used for AWS resource"
}

variable "public_subnet_count" {
  type        = number
  description = "Total number of public subnets to create"
}

variable "private_subnet_count" {
  type        = number
  description = "Total number of private subnets to create"
  default     = 2
}

variable "instance_type" {
  type        = string
  description = "Instance type for Amazon EC2 instance"
}

variable "generated_key_name" {
  type        = string
  description = "Key-pair generated for Amazon EC2 instance"
}

variable "health_check" {
  type        = map(string)
  description = "Health check for EC2 load balancer target group"
}
