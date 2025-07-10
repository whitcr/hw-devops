variable "cluster_name" {
  type = string
}

variable "cluster_role_arn" {
  type = string
}

variable "private_subnets" {
  type = list(string)
}
