variable "mgc_api_key" {
  type        = string
  sensitive   = true
  description = "API Key para autenticação"
}

variable "mgc_key_id" {
  type        = string
  sensitive   = true
  description = "ID da chave do objeto"
}

variable "mgc_key_secret" {
  type        = string
  sensitive   = true
  description = "Segredo da chave do objeto"
}

variable "ssh_key_name" {
  description = "Nome da chave SSH"
  type        = string
  default     = "nataliagranatodeassis"
}

variable "ssh_key_value" {
  description = "Valor da chave SSH"
  type        = string
  sensitive   = true
}
