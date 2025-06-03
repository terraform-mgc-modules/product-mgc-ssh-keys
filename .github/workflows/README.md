# Workflows de Segurança e CI/CD

Esta pasta contém workflows automatizados do GitHub Actions para garantir qualidade, segurança e conformidade do código.

## 🔄 Workflows de CI/CD

### `terraform.yml`
- **Função**: Pipeline principal do Terraform
- **Triggers**: Push e Pull Requests
- **Ações**: Init, Format, Validate, Plan, Apply

## 🔒 Workflows de Segurança

### `terrascan.yml`
- **Função**: Análise de segurança de infraestrutura com Terrascan
- **Triggers**: Push para main/develop, Pull Requests
- **Output**: Relatórios SARIF para GitHub Security tab
- **Políticas**: AWS security policies

### `scorecard.yml` 
- **Função**: Avalia práticas de segurança da cadeia de suprimentos
- **Triggers**: Push para main, schedule semanal
- **Análise**: Branch protection, dependabot, workflows, tokens
- **Framework**: OSSF Scorecard

### `osv-scanner.yml`
- **Função**: Detecção de vulnerabilidades conhecidas
- **Triggers**: Push, PR, schedule diário
- **Base**: OSV (Open Source Vulnerabilities) database

### `trivy.yml`
- **Função**: Geração de SBOM e análise de vulnerabilidades
- **Output**: Dependency Graph integration
- **Triggers**: Push para main

### `dependency-review.yml`
- **Função**: Bloqueia PRs com dependências vulneráveis
- **Triggers**: Pull Requests
- **Ação**: Falha se vulnerabilidades são introduzidas

## 📋 Workflows de Gestão

### `dependabot.yml`
- **Função**: Configuração do Dependabot para atualizações automáticas
- **Escopo**: GitHub Actions, Terraform

### `issue.yml`
- **Função**: Automação de gestão de issues
- **Triggers**: Abertura/fechamento de issues

## 🛡️ Permissões de Segurança

Todos os workflows seguem o princípio de menor privilégio:

```yaml
permissions:
  contents: read           # Ler código
  security-events: write   # Escrever eventos de segurança (SARIF)
  actions: read           # Ler ações do workflow
```

## 🔧 Configuração

### Secrets Necessários

Para funcionamento completo dos workflows, configure os seguintes secrets:

| Secret                 | Uso                 | Workflows     |
| ---------------------- | ------------------- | ------------- |
| `USER_TOKEN`           | Trivy SBOM upload   | trivy.yml     |
| `R2_ACCESS_KEY_ID`     | Backend Terraform   | terraform.yml |
| `R2_SECRET_ACCESS_KEY` | Backend Terraform   | terraform.yml |
| `MGC_API_KEY`          | Provider MGC        | terraform.yml |
| `MGC_KEY_ID`           | Provider MGC        | terraform.yml |
| `MGC_KEY_SECRET`       | Provider MGC        | terraform.yml |
| `SSH_KEY_VALUE`        | SSH Key creation    | terraform.yml |
| `CLOUDFLARE_API_TOKEN` | Cloudflare provider | terraform.yml |

### Branch Protection

Recomenda-se configurar branch protection rules para `main`:

- Require pull request reviews
- Require status checks to pass
- Include administrators
- Restrict pushes

## 📈 Monitoramento

Os resultados dos workflows de segurança são visíveis em:

- **Security tab**: Relatórios SARIF (Terrascan, Scorecard)
- **Dependency Graph**: Vulnerabilidades e dependências
- **Actions tab**: Logs de execução
- **Pull Requests**: Checks obrigatórios

## 🔄 Atualizações

Os workflows são mantidos atualizados automaticamente via Dependabot. Versões específicas são fixadas por segurança usando commit SHAs.

### Versões Atuais

- `actions/checkout`: v4.2.2
- `github/codeql-action/upload-sarif`: v3.28.15
- `hashicorp/setup-terraform`: v3
- `aquasecurity/trivy-action`: v0.30.0
- `google/osv-scanner-action`: v2.0.2
