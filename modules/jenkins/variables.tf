variable "cluster_name" {
  description = "Назва Kubernetes кластера"
  type        = string
}
variable "oidc_provider_arn" {
  description = "ARN провайдера OIDC"
  type        = string
}

variable "oidc_provider_url" {
  description = "URL провайдера OIDC"
  type        = string
}
