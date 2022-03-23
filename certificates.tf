resource "aws_acm_certificate" "jenkins_vault_bloomreach_certificate" {
  domain_name               = "jenkins-vault-bloomreach.com"
  validation_method         = "NONE"
  subject_alternative_names = ["*.jenkins-vault-bloomreach.com"]
  tags                      = merge({ Name = "jenkins-vault-bloomreach" }, local.dev-tags)
}