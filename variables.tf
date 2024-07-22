variable "vpc_cidr" {
  type = string
  default = "10.0.0.0/16"
}

variable "ami_id" {
  type = string
  default = "ami-09eb4311cbaecf89d"
  description = "ubuntu 20.04"
}

variable "hosted_zone_name" {
  type = string
  default = "ddimtech.click"
}

variable "db_name" {
  type = string
  default = "test-database"
}

variable "db_user" {
  type = string
  default = "test-user"
}

variable "db_user_password" {
  type = string
  default = "test-password"
}