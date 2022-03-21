variable "sns_topic_name" {
  description = "sns topic name"
  type        = string
  default     = ""
}

variable "tags" {
  description = "tags for sns topic"
  type        = map
  default     = {}
}

variable "subscriptions" {
  description = "a key value pair of subscriptions key being the protocol and value being the end point of the subscription"
  type        = map
  default     = {}
}