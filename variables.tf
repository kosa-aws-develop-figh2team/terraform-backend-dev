variable "aws_access_key" {
  description = "AWS Access Key"
  type        = string
  sensitive   = true
}

variable "aws_secret_key" {
  description = "AWS Secret Access Key"
  type        = string
  sensitive   = true
}

variable "aws_region" {
  description = "AWS region"
  default     = "ap-northeast-2"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "public_subnet_cidr_a" {
  default = "172.30.10.0/24"
}
variable "public_subnet_cidr_c" {
  default = "172.30.11.0/24"
}
variable "private_subnet_cidr_a" {
  default = "172.30.20.0/24"
}
variable "private_subnet_cidr_c" {
  default = "172.30.21.0/24"
}


variable "db_username" {
  type = string
}
variable "db_password" {
  sensitive = true
}
variable "db_name" {
  type = string
}
# variable "rds_endpoint" {
#   type = string
# }

variable "key_pair_name" {
  description = "EC2 접속용 키페어 이름"
  type        = string
}

variable "dynamodb_table_name" {
  description = "DynamoDB 테이블 이름"
  type        = string
}

variable "environment" {
  description = "배포 환경 이름"
  type        = string
}
