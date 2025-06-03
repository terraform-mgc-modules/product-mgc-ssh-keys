# Terraform SSH Keys Management - Magalu Cloud

Este projeto configura e gerencia chaves SSH na Magalu Cloud usando Terraform com CI/CD via GitHub Actions.

---

```mermaid
sequenceDiagram
    participant Usuário
    participant Script (.sh)
    participant Terraform
    participant Cloudflare R2
    participant Magalu Cloud

    Usuário->>Script (.sh): Executa quick-start.sh ou terraform-menu.sh
    Script (.sh)->>Script (.sh): Verifica .env e inicializa variáveis
    Script (.sh)->>Terraform: Executa init/plan/apply/destroy
    Terraform->>Cloudflare R2: Armazena/recupera estado remoto via backend S3 customizado
    Terraform->>Magalu Cloud: Gerencia chaves SSH via provider MGC
    Terraform->>Usuário: Retorna outputs e logs
```

```mermaid
sequenceDiagram
    participant GitHub Actions
    participant Usuário
    participant Terraform
    participant Cloudflare R2
    participant Magalu Cloud

    Usuário->>GitHub Actions: Dispara workflow (push ou manual apply/destroy)
    GitHub Actions->>Terraform: Executa comandos com variáveis de ambiente
    Terraform->>Cloudflare R2: Lê/escreve estado remoto
    Terraform->>Magalu Cloud: Cria/gerencia chaves SSH
    Terraform->>GitHub Actions: Outputs e status
```

---


## 🔧 Pré-requisitos

1. **Conta na Magalu Cloud** com acesso às credenciais de APIs.
2. **Bucket no Cloudflare R2** para armazenar o state do Terraform e credenciais da Cloudflare.
3. **Secrets adicionadas** para utilização do Github Actions.

## Requirements

| Name                                                                         | Version |
| ---------------------------------------------------------------------------- | ------- |
| <a name="requirement_cloudflare"></a> [cloudflare](#requirement\_cloudflare) | ~> 4    |
| <a name="requirement_local"></a> [local](#requirement\_local)                | 2.5.2   |
| <a name="requirement_mgc"></a> [mgc](#requirement\_mgc)                      | 0.33.0  |

## Providers

No providers.

## Modules

| Name                                                                         | Source                                        | Version |
| ---------------------------------------------------------------------------- | --------------------------------------------- | ------- |
| <a name="module_mgc_ssh_keys"></a> [mgc\_ssh\_keys](#module\_mgc\_ssh\_keys) | github.com/terraform-mgc-modules/mgc-ssh-keys | v2.0.0  |

## Resources

No resources.

## Inputs

| Name                                                                                                  | Description                   | Type     | Default                              | Required |
| ----------------------------------------------------------------------------------------------------- | ----------------------------- | -------- | ------------------------------------ | :------: |
| <a name="input_cloudflare_account_id"></a> [cloudflare\_account\_id](#input\_cloudflare\_account\_id) | ID da conta Cloudflare        | `string` | `"4839c9636a58fa9490bbe3d2e686ad98"` |    no    |
| <a name="input_cloudflare_api_token"></a> [cloudflare\_api\_token](#input\_cloudflare\_api\_token)    | Token de API da Cloudflare    | `string` | n/a                                  |   yes    |
| <a name="input_mgc_api_key"></a> [mgc\_api\_key](#input\_mgc\_api\_key)                               | API Key para autenticação     | `string` | n/a                                  |   yes    |
| <a name="input_mgc_key_id"></a> [mgc\_key\_id](#input\_mgc\_key\_id)                                  | ID da chave do objeto         | `string` | n/a                                  |   yes    |
| <a name="input_mgc_key_secret"></a> [mgc\_key\_secret](#input\_mgc\_key\_secret)                      | Segredo da chave do objeto    | `string` | n/a                                  |   yes    |
| <a name="input_r2_access_key"></a> [r2\_access\_key](#input\_r2\_access\_key)                         | ID da chave de acesso R2      | `string` | n/a                                  |   yes    |
| <a name="input_r2_access_secret"></a> [r2\_access\_secret](#input\_r2\_access\_secret)                | Segredo da chave de acesso R2 | `string` | n/a                                  |   yes    |
| <a name="input_ssh_key_name"></a> [ssh\_key\_name](#input\_ssh\_key\_name)                            | Nome da chave SSH             | `string` | `"nataliagranatodeassis"`            |    no    |
| <a name="input_ssh_key_value"></a> [ssh\_key\_value](#input\_ssh\_key\_value)                         | Valor da chave SSH            | `string` | n/a                                  |   yes    |

## Outputs

| Name                                                                            | Description               |
| ------------------------------------------------------------------------------- | ------------------------- |
| <a name="output_ssh_key_name"></a> [ssh\_key\_name](#output\_ssh\_key\_name)    | Nome da chave SSH criada  |
| <a name="output_ssh_key_value"></a> [ssh\_key\_value](#output\_ssh\_key\_value) | Valor da chave SSH criada |




## Contato

Para dúvidas ou reporte de vulnerabilidades, consulte o [SECURITY.md](SECURITY.md).

---