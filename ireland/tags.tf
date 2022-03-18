module "tagging" {
  source = "../../modules/tagging/"
}

locals {
  cluster_name = "bloomreach-cluster"
  dev-tags = {
    "Environment" = module.tagging.dev-tags.dev
    "Company"     = module.tagging.dev-tags.company
    "Cost"        = module.tagging.dev-tags.cost
    "Interviewee" = module.tagging.dev-tags.interviewee
  }
}