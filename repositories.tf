module "grail-service-app" {
  source = "./modules/ecr-repository"
  name   = "bloomreach-ecr-repository"
  tags   = merge({ Name = "bloomreach-ecr-repository" }, local.dev-tags)
}