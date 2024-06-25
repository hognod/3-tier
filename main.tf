module "infra" {
  source = "./infra"

  vpc_cidr = var.vpc_cidr
}