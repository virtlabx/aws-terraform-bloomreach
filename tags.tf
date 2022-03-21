module "tagging" {
  source = "./modules/tagging"
}

locals {
  cluster_name    = "bloomreach-cluster"
  alarm_sns_topic = module.sns_topic.sns_topic_arn
  dev-tags = {
    "Environment" = module.tagging.dev-tags.dev
    "Company"     = module.tagging.dev-tags.company
    "Cost"        = module.tagging.dev-tags.cost
    "Interviewee" = module.tagging.dev-tags.interviewee
  }
}