variable "vpc_cidr" {
  type = string
  default = "10.0.0.0/16"
}

variable "ami_id" {
  type = string
  default = "ami-09eb4311cbaecf89d"
  description = "ubuntu 20.04"
}