resource "aws_sns_topic" "topic" {
  name = var.sns_topic_name
  tags = length(var.tags) > 0 ? var.tags : null
}

resource "aws_sns_topic_subscription" "topic_subscriptions" {
  for_each = var.subscriptions
  topic_arn = aws_sns_topic.topic.arn
  protocol  = each.key
  endpoint  = each.value
}

output "sns_topic_arn" {
  value = aws_sns_topic.topic.arn
}