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


variable "r2_access_key" {
  type        = string
  sensitive   = true
  description = "ID da chave de acesso R2"
}

variable "r2_access_secret" {
  type        = string
  sensitive   = true
  description = "Segredo da chave de acesso R2"
}

variable "cloudflare_account_id" {
  description = "ID da conta Cloudflare"
  type        = string
  default     = "4839c9636a58fa9490bbe3d2e686ad98"

}


variable "cloudflare_api_token" {
  description = "Token de API da Cloudflare"
  type        = string
  sensitive   = true

}
