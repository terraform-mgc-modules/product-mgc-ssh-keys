# Scripts de Ferramentas

Esta pasta contém scripts utilitários para facilitar o gerenciamento do projeto Terraform.

## Scripts Disponíveis

### `quick-start.sh` 🎯 (Para novos usuários)
Script de inicialização rápida que configura automaticamente o projeto.

```bash
cd tools
./quick-start.sh
```

Este script:
- Cria o arquivo `.env` se não existir
- Executa `terraform init` automaticamente
- Oferece acesso direto ao menu interativo
- Mostra próximos passos e documentação

### `terraform-menu.sh` ⭐ (Recomendado)
Script interativo com menu para facilitar todas as operações do Terraform.

```bash
cd tools
./terraform-menu.sh
```

Este script oferece um menu com opções para:
- Terraform Plan
- Terraform Apply  
- Terraform Destroy
- Terraform Show
- Terraform Output
- Teste de conectividade R2
- Acesso à documentação

### `terraform-plan.sh`
Executa `terraform plan` com todas as variáveis de ambiente configuradas automaticamente.

```bash
cd tools
./terraform-plan.sh
```

### `terraform-apply.sh`
Executa `terraform apply` com todas as variáveis de ambiente configuradas automaticamente.

```bash
cd tools
./terraform-apply.sh
```

### `terraform-destroy.sh`
Executa `terraform destroy` com todas as variáveis de ambiente configuradas automaticamente.

```bash
cd tools
./terraform-destroy.sh
```

### `setup-terraform-vars.sh`
Script mais avançado que permite executar qualquer comando do Terraform com variáveis configuradas.

```bash
cd tools
./setup-terraform-vars.sh plan   # Para terraform plan
./setup-terraform-vars.sh apply  # Para terraform apply
./setup-terraform-vars.sh destroy # Para terraform destroy
```

### `test-r2-backend.sh`
Testa a conectividade com o bucket R2 da Cloudflare.

```bash
cd tools
./test-r2-backend.sh
```

### `validate-security.sh`
Valida workflows de segurança, configurações e detecta possíveis problemas.

```bash
cd tools
./validate-security.sh
```

Este script verifica:
- Existência e sintaxe dos workflows
- Configuração do Terraform
- Ferramentas de segurança instaladas
- Permissões dos workflows
- Secrets hardcoded
- Configuração do .gitignore

## Pré-requisitos

Todos os scripts requerem que o arquivo `.env` esteja configurado no diretório raiz do projeto com as seguintes variáveis:

- `R2_ACCESS_KEY_ID`
- `R2_SECRET_ACCESS_KEY`
- `MGC_API_KEY`
- `MGC_KEY_ID`
- `MGC_KEY_SECRET`
- `SSH_KEY_VALUE`
- `CLOUDFLARE_API_TOKEN`

Copie o arquivo `.env.example` para `.env` e preencha com seus valores reais:

```bash
cp .env.example .env
# Edite o arquivo .env com seus valores
```

## Estrutura do Projeto

```
project-mgc-ssh-keys/
├── tools/           # Scripts utilitários (esta pasta)
├── docs/            # Documentação adicional
├── main.tf          # Configuração principal do Terraform
├── variables.tf     # Definições de variáveis
├── versions.tf      # Configuração de providers e backend
├── outputs.tf       # Outputs do Terraform
├── .env.example     # Exemplo de arquivo de ambiente
└── terraform.tfvars # Configurações de variáveis
```
