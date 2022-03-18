locals {
  env_dev_tag_value      = "Dev"
  company_tag_value      = "Bloomreach"
  cost_dev_tag_value     = "Interviews"
  interviewee_tag_value  = "Aya-Elawdan"
}

output "dev-tags" {
  value = {
    dev         = local.env_dev_tag_value
    company     = local.company_tag_value
    cost        = local.cost_dev_tag_value
    interviewee = local.interviewee_tag_value
  }
}