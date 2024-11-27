variable "aws_region" {
  description = "This will define the aws region"
  type = string
  default = "us-east-1"
}

variable "ami_id" {
  description = "This is the AMI id for Ubuntu"
  type = string
  default = "ami-005fc0f236362e99f"
}

variable "store_tag" {
  description = "This is the default group name for store application"
  type = string
  default = "Store_App"
}

variable "store_tag_mon" {
  description = "This is the default group name for store application"
  type = string
  default = "Store_App_Monitoring"
}