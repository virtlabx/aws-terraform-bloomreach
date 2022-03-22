module "bloomreach-simple-app-repository" {
  source = "./modules/ecr-repository"
  name   = "bloomreach-simple-app"
  tags   = merge({ Name = "bloomreach-simple-app" }, local.dev-tags)
}
