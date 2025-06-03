# Outputs para o módulo de chaves SSH da Magalu Cloud

output "ssh_key_name" {
  description = "Nome da chave SSH criada"
  value       = module.mgc_ssh_keys.ssh_key_name
}

output "ssh_key_value" {
  description = "Valor da chave SSH criada"
  value       = module.mgc_ssh_keys.ssh_key_value
  sensitive   = true
}
