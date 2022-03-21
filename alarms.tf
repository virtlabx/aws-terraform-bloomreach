module "sns_topic" {
  source         = "./modules/sns"
  sns_topic_name = "bloomreach-dev-interviews-terraform-ayaelawdan-sns"
  tags           = merge({ Name = "bloomreach-dev-interviews-terraform-ayaelawdan-sns" }, local.dev-tags)
}

resource "aws_cloudwatch_log_group" "cloudtrail_events" {
  name              = "bloomreach-dev-interviews-terraform-ayaelawdan-cloudtrail-events"
  retention_in_days = "545"
}

resource "aws_cloudwatch_log_metric_filter" "no_mfa_console_signin" {
  name           = "NoMFAConsoleSignin"
  pattern        = "{ ($.eventName = \"ConsoleLogin\") && ($.additionalEventData.MFAUsed != \"Yes\") }"
  log_group_name = aws_cloudwatch_log_group.cloudtrail_events.name
  metric_transformation {
    name      = "NoMFAConsoleSignin"
    namespace = var.alarm_namespace
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "no_mfa_console_signin" {
  alarm_name                = "NoMFAConsoleSignin"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = aws_cloudwatch_log_metric_filter.no_mfa_console_signin.id
  namespace                 = var.alarm_namespace
  period                    = "300"
  statistic                 = "Sum"
  threshold                 = "1"
  alarm_description         = "Monitoring for single-factor console logins will increase visibility into accounts that are not protected by MFA."
  alarm_actions             = [local.alarm_sns_topic]
  treat_missing_data        = "notBreaching"
  insufficient_data_actions = []
  tags                      = module.tagging.dev-tags
}