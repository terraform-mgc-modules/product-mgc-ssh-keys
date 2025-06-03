# Outputs para o módulo de chaves SSH da Magalu Cloud

output "ssh_key_id" {
  description = "ID da chave SSH criada"
  value       = module.mgc_ssh_keys.ssh_key_id
}

output "ssh_key_name" {
  description = "Nome da chave SSH criada"
  value       = module.mgc_ssh_keys.ssh_key_name
}

output "ssh_key_fingerprint" {
  description = "Fingerprint da chave SSH"
  value       = module.mgc_ssh_keys.ssh_key_fingerprint
  sensitive   = true
}
