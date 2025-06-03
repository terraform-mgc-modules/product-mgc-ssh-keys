# Terraform SSH Keys Management - Magalu Cloud

Este projeto configura e gerencia chaves SSH na Magalu Cloud usando Terraform com CI/CD via GitHub Actions.

## 🏗️ Estrutura do Projeto

```
product-mgc-ssh-keys/
├── .github/
│   └── workflows/
│       └── terraform.yml      # Pipeline CI/CD
├── main.tf                    # Configuração principal
├── variables.tf               # Definição de variáveis
├── versions.tf                # Providers e backend
├── outputs.tf                 # Outputs (se houver)
└── README.md                  # Este arquivo
```

## 🔧 Pré-requisitos

1. **Conta na Magalu Cloud** com acesso às APIs
2. **Repositório GitHub** para hospedar o código
3. **Bucket S3 na Magalu Cloud** para armazenar o state do Terraform

## ⚙️ Configuração

### 1. Secrets do GitHub

Configure os seguintes secrets no seu repositório GitHub (Settings → Secrets and variables → Actions):

| Secret Name      | Descrição                             | Exemplo                      |
| ---------------- | ------------------------------------- | ---------------------------- |
| `MGC_API_KEY`    | API Key da Magalu Cloud               | `your-api-key-here`          |
| `MGC_KEY_ID`     | Access Key ID para Object Storage     | `your-access-key-id`         |
| `MGC_KEY_SECRET` | Secret Access Key para Object Storage | `your-secret-access-key`     |
| `SSH_KEY_VALUE`  | Conteúdo da chave SSH pública         | `ssh-rsa AAAAB3NzaC1yc2E...` |

### 2. Backend S3 (Object Storage)

No arquivo `versions.tf`, atualize o nome do bucket:

```hcl
terraform {
  backend "s3" {
    bucket   = "SEU-BUCKET-TERRAFORM-STATE"  # ← Altere aqui
    key      = "ssh-keys/terraform.tfstate"
    region   = "br-se1"
    endpoint = "https://s3.br-se1.magaluobjects.com"
    # ... outras configurações
  }
}
```

### 3. Configuração Local (Opcional)

Para executar localmente, crie um arquivo `terraform.tfvars`:

```hcl
ssh_key_value    = "ssh-rsa AAAAB3NzaC1yc2E..."
ssh_key_name     = "minha-chave-ssh"
mgc_api_key      = "your-api-key"
mgc_key_id       = "your-access-key-id"
mgc_key_secret   = "your-secret-access-key"
```

⚠️ **IMPORTANTE**: Nunca commite o arquivo `terraform.tfvars` com dados sensíveis!

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

# 3. Execute os comandos Terraform
terraform init
terraform plan
terraform apply
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
8. **Apply**: Aplica as mudanças (apenas na branch main)

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

### Erro de autenticação no backend S3
```
Error: Failed to get existing workspaces: S3 bucket does not exist
```
**Solução**: Verifique se o bucket existe e se as credenciais `MGC_KEY_ID` e `MGC_KEY_SECRET` estão corretas.

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

## Como usar este template

1. Clique em `Use this template` no GitHub.
2. Siga as instruções para criar seu novo repositório.
3. Adapte os workflows conforme as necessidades do seu projeto.

## Contato

Para dúvidas ou reporte de vulnerabilidades, consulte o [SECURITY.md](SECURITY.md).

---

Feito com ❤️ por [Natália Granato](https://github.com/nataliagranato).
