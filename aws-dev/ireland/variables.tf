variable "region" {
  default     = "eu-west-1"
  description = "AWS Ireland region"
}

variable "alarm_namespace" {
  description = "The namespace in which all alarms are set up."
  default     = "Account"
}
