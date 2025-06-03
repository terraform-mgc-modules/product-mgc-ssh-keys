# Terraform SSH Keys Management - Magalu Cloud

Este projeto configura e gerencia chaves SSH na Magalu Cloud usando Terraform com CI/CD via GitHub Actions.

## 🏗️ Estrutura do Projeto

```
product-mgc-ssh-keys/
├── .github/
│   └── workflows/
│       └── terraform.yml      # Pipeline CI/CD
├── tools/                     # Scripts utilitários
│   ├── README.md              # Documentação dos scripts
│   ├── terraform-plan.sh      # Script para terraform plan
│   ├── terraform-apply.sh     # Script para terraform apply
│   ├── terraform-destroy.sh   # Script para terraform destroy
│   ├── setup-terraform-vars.sh # Script avançado com parâmetros
│   └── test-r2-backend.sh     # Teste de conectividade R2
├── docs/                      # Documentação adicional
│   ├── README.md              # Índice da documentação
│   └── R2-READY-CHECK.md      # Guia de configuração R2
├── main.tf                    # Configuração principal
├── variables.tf               # Definição de variáveis
├── versions.tf                # Providers e backend (Cloudflare R2)
├── outputs.tf                 # Outputs do Terraform
├── terraform.tfvars           # Configurações de variáveis
├── terraform.tfvars.example   # Exemplo de configurações
├── .env.example               # Exemplo de variáveis de ambiente
└── README.md                  # Este arquivo
```

## 🔧 Pré-requisitos

1. **Conta na Magalu Cloud** com acesso às APIs
2. **Repositório GitHub** para hospedar o código
3. **Bucket no Cloudflare R2** para armazenar o state do Terraform

## ⚙️ Configuração

### 1. Secrets do GitHub

Configure os seguintes secrets no seu repositório GitHub (Settings → Secrets and variables → Actions):

| Secret Name           | Descrição                                      | Exemplo                      |
| --------------------- | ---------------------------------------------- | ---------------------------- |
| `MGC_API_KEY`         | API Key da Magalu Cloud                        | `your-api-key-here`          |
| `MGC_KEY_ID`          | Access Key ID para Object Storage              | `your-access-key-id`         |
| `MGC_KEY_SECRET`      | Secret Access Key para Object Storage          | `your-secret-access-key`     |
| `SSH_KEY_VALUE`       | Conteúdo da chave SSH pública                  | `ssh-rsa AAAAB3NzaC1yc2E...` |
| `R2_ACCESS_KEY`       | Access Key ID do Cloudflare R2                 | `your-r2-access-key`         |
| `R2_ACCESS_SECRET`    | Secret Access Key do Cloudflare R2             | `your-r2-secret-key`         |
| `CLOUDFLARE_API_TOKEN`| API Token do Cloudflare (para provider opcional)| `your-cloudflare-api-token`  |

> **Importante:** Nunca exponha esses secrets em código, logs ou arquivos versionados. Mantenha-os apenas no GitHub Secrets.
>
> - [Magalu Cloud Console](https://console.magalu.cloud/) — para obter as credenciais da Magalu Cloud
> - [Cloudflare Dashboard](https://dash.cloudflare.com/) — para acessar o R2 e gerar as credenciais

### 2. Backend Cloudflare R2

No arquivo `versions.tf`, configure o backend S3 apontando para o endpoint do Cloudflare R2:

```hcl
terraform {
  backend "s3" {
    bucket   = "SEU-BUCKET-R2"  # ← Altere aqui para o nome do bucket no R2
    key      = "ssh-keys/terraform.tfstate"
    region   = "auto"           # Cloudflare R2 não exige região específica
    endpoint = "https://<accountid>.r2.cloudflarestorage.com" # endpoint R2
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    force_path_style            = true
  }
}
```

> **Dica:** Consulte o painel do Cloudflare R2 para obter o endpoint correto do seu bucket/account.

### 3. Configuração Local (Opcional)

Para executar localmente, crie um arquivo `terraform.tfvars`:

```hcl
ssh_key_value    = "ssh-rsa AAAAB3NzaC1yc2E..."
ssh_key_name     = "minha-chave-ssh"
mgc_api_key      = "your-api-key"
r2_access_key    = "your-r2-access-key"
r2_access_secret = "your-r2-secret-key"
```

⚠️ **IMPORTANTE**: Nunca commite o arquivo `terraform.tfvars` com dados sensíveis!

## 🛠️ Scripts Utilitários

O projeto inclui scripts na pasta `tools/` para facilitar o uso do Terraform:

### Início Rápido (Novos Usuários)

```bash
# Configuração automática (uma vez)
cd tools && ./quick-start.sh
```

### Execução Rápida

```bash
# Menu interativo (recomendado)
cd tools && ./terraform-menu.sh

# Ou comandos específicos:
cd tools && ./terraform-plan.sh    # terraform plan
cd tools && ./terraform-apply.sh   # terraform apply
cd tools && ./terraform-destroy.sh # terraform destroy
cd tools && ./test-r2-backend.sh   # testar R2
```

### Script Avançado

```bash
cd tools
./setup-terraform-vars.sh plan    # terraform plan
./setup-terraform-vars.sh apply   # terraform apply
./setup-terraform-vars.sh destroy # terraform destroy
```

📖 **Para mais detalhes sobre os scripts, consulte:** `tools/README.md`

## 🚀 Como Usar

### Execução via GitHub Actions (Recomendado)

O pipeline é executado automaticamente quando:
- Você faz push para a branch `main`
- Você abre um Pull Request para a branch `main`

### Execução Local

```bash
# 1. Clone o repositório
git clone <seu-repositorio>
cd product-mgc-ssh-keys

# 2. Configure as variáveis de ambiente
export TF_VAR_mgc_api_key="your-api-key"
export TF_VAR_mgc_key_id="your-access-key-id"
export TF_VAR_mgc_key_secret="your-secret-access-key"
export TF_VAR_ssh_key_value="ssh-rsa AAAAB3NzaC1yc2E..."

# Para o backend S3
export AWS_ACCESS_KEY_ID="your-access-key-id"
export AWS_SECRET_ACCESS_KEY="your-secret-access-key"

# Para o backend Cloudflare R2
export R2_ACCESS_KEY="your-r2-access-key"
export R2_ACCESS_SECRET="your-r2-secret-secret"
```

## 🔄 Pipeline CI/CD

O pipeline GitHub Actions executa os seguintes passos:

1. **Checkout**: Baixa o código do repositório
2. **Setup Terraform**: Instala o Terraform v1.9.3
3. **Init**: Inicializa o Terraform com backend remoto
4. **Format**: Verifica formatação do código
5. **Validate**: Valida a sintaxe dos arquivos
6. **Test**: Executa testes do Terraform (se configurados)
7. **Plan**: Gera o plano de execução
8. **Apply/Destroy**: Deve ser acionado manualmente via GitHub Actions (workflow_dispatch), escolhendo a ação desejada (`apply` ou `destroy`). Não é mais executado automaticamente na branch main.

> **Importante:** Para aplicar ou destruir mudanças, acesse a aba "Actions" no GitHub, selecione o workflow Terraform e clique em "Run workflow", escolhendo a ação desejada.

## 📋 Variáveis

| Variável         | Tipo   | Descrição                             | Padrão              |
| ---------------- | ------ | ------------------------------------- | ------------------- |
| `ssh_key_value`  | string | Conteúdo da chave SSH pública         | -                   |
| `ssh_key_name`   | string | Nome para identificar a chave SSH     | "terraform-ssh-key" |
| `mgc_api_key`    | string | API Key da Magalu Cloud               | -                   |
| `mgc_key_id`     | string | Access Key ID para Object Storage     | -                   |
| `mgc_key_secret` | string | Secret Access Key para Object Storage | -                   |

## 🔐 Segurança

- **Secrets**: Todas as informações sensíveis são armazenadas como GitHub Secrets
- **State Remoto**: O state do Terraform é armazenado de forma segura no Object Storage da Magalu Cloud
- **Credenciais**: As credenciais nunca são expostas nos logs do GitHub Actions

## 🐛 Troubleshooting

### Erro de autenticação no backend R2/S3
```
Error: Failed to get existing workspaces: S3 bucket does not exist
```
**Solução**: Verifique se o bucket existe no Cloudflare R2 e se as credenciais `R2_ACCESS_KEY` e `R2_ACCESS_SECRET` estão corretas.

### Erro de permissão no backend
```
Error: AccessDenied: Access Denied
```
**Solução**: Confirme se o usuário configurado tem permissão de leitura e escrita no bucket do R2.

### Erro de endpoint ou rede
```
Error: dial tcp: lookup <endpoint> no such host
```
**Solução**: Verifique se o endpoint do R2 está correto e se não há bloqueio de rede/firewall.

### Erro no provider MGC
```
Error: Invalid API key
```
**Solução**: Verifique se o secret `MGC_API_KEY` está configurado corretamente.

### Chave SSH inválida
```
Error: Invalid SSH key format
```
**Solução**: Verifique se o `SSH_KEY_VALUE` contém uma chave SSH pública válida (formato: `ssh-rsa AAAAB3...` ou `ssh-ed25519 AAAAC3...`).

### Erro de variável obrigatória não definida
```
Error: Missing required argument
```
**Solução**: Certifique-se de que todas as variáveis obrigatórias estão definidas no arquivo `terraform.tfvars` ou como secrets no GitHub.

### Erro de credenciais ausentes no pipeline
```
Error: No valid credential sources found
```
**Solução**: Confirme se os secrets `R2_ACCESS_KEY` e `R2_ACCESS_SECRET` estão cadastrados corretamente no GitHub e se o workflow está usando os nomes corretos.

### Erro de permissão negada ao executar scripts
```
./tools/terraform-apply.sh: Permission denied
```
**Solução**: Dê permissão de execução ao script com `chmod +x tools/terraform-apply.sh`.

## 📚 Documentação Adicional

- [Terraform MGC Provider](https://registry.terraform.io/providers/magalucloud/mgc/latest/docs)
- [Magalu Cloud API Documentation](https://docs.magalu.cloud/)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)

## 🤝 Contribuição

1. Fork o projeto
2. Crie uma branch para sua feature (`git checkout -b feature/nova-feature`)
3. Commit suas mudanças (`git commit -am 'Adiciona nova feature'`)
4. Push para a branch (`git push origin feature/nova-feature`)
5. Abra um Pull Request

## Workflows e Soluções de Segurança

### 1. Terraform Format, Validate, and Test
- **Arquivo:** `.github/workflows/terraform.yml`
- **Função:** Formata, valida e executa testes em código Terraform a cada push ou pull request.
- **Segurança:** Utiliza o bloco `permissions` para garantir acesso mínimo (`contents: read`).

### 2. Checkov Security Scan
- **Arquivo:** `.github/workflows/checkov.yml`
- **Função:** Executa o [Checkov](https://www.checkov.io/) para análise estática de segurança em código IaC (Infrastructure as Code), gerando relatórios SARIF.
- **Segurança:** Detecta más práticas, configurações inseguras e vulnerabilidades em arquivos Terraform.

### 3. Trivy SBOM & Vulnerability Scan
- **Arquivo:** `.github/workflows/trivy.yml`
- **Função:** Gera SBOM (Software Bill of Materials) e faz varredura de vulnerabilidades em dependências e imagens, integrando resultados ao GitHub Dependency Graph.
- **Segurança:** Ajuda a identificar componentes vulneráveis presentes no projeto.

### 4. Scorecard Supply-chain Security
- **Arquivo:** `.github/workflows/scorecard.yml`
- **Função:** Usa o [OSSF Scorecard](https://github.com/ossf/scorecard) para avaliar práticas de segurança da cadeia de suprimentos do repositório.
- **Segurança:** Analisa branch protection, dependabot, workflows, tokens, entre outros.

### 5. OSV-Scanner
- **Arquivo:** `.github/workflows/osv-scanner.yml`
- **Função:** Executa o [OSV-Scanner](https://osv.dev/) para identificar vulnerabilidades conhecidas em dependências.
- **Segurança:** Automatiza a checagem contínua de vulnerabilidades em bibliotecas e módulos.

### 6. Dependency Review
- **Arquivo:** `.github/workflows/dependency-review.yml`
- **Função:** Bloqueia PRs que introduzem dependências vulneráveis conhecidas, usando o GitHub Dependency Review Action.
- **Segurança:** Garante que novas dependências estejam livres de vulnerabilidades conhecidas.

### 7. CodeQL Analysis (opcional)
- **Arquivo:** (não incluído por padrão)
- **Função:** Executa análise estática de segurança aprofundada com CodeQL para identificar vulnerabilidades no código.
- **Segurança:** Detecta padrões de código problemáticos que podem levar a vulnerabilidades, com base em queries mantidas pela comunidade e pelo GitHub.
- **Observação:** O uso do CodeQL é recomendado e está documentado em [SECURITY.md](SECURITY.md), mas o workflow não está incluído por padrão neste template. Para habilitar, utilize a opção "Configure CodeQL" na aba "Security" do GitHub ou adicione manualmente o workflow sugerido pela plataforma.

## Outras Práticas de Segurança

- **Dependabot:** Atualizações automáticas de dependências.
- **Política de Segurança:** Veja [SECURITY.md](SECURITY.md) para detalhes sobre reporte de vulnerabilidades e práticas adotadas.
- **Code of Conduct:** Ambiente colaborativo e respeitoso ([CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md)).


## Contato

Para dúvidas ou reporte de vulnerabilidades, consulte o [SECURITY.md](SECURITY.md).

---
