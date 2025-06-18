variable "region" {
  default = "us-east-2"
}

variable "owner" {
  default = "ahmad"
}

variable "vpc-cidr" {
  default = "10.0.0.0/16"
}

variable "subnet-cidr" {
  default = "10.0.1.0/24"
}

variable "all-traffic-cidr" {
  default = "0.0.0.0/0"
}