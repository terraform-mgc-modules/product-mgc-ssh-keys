#!/bin/bash

# Script de configuração inicial para o projeto Terraform SSH Keys - Magalu Cloud
# Este script ajuda a configurar o ambiente local rapidamente

set -e

echo "🚀 Configuração inicial do projeto Terraform SSH Keys - Magalu Cloud"
echo ""

# Verificar se o Terraform está instalado
if ! command -v terraform &> /dev/null; then
    echo "❌ Terraform não encontrado. Por favor, instale o Terraform primeiro."
    echo "   Veja: https://learn.hashicorp.com/tutorials/terraform/install-cli"
    exit 1
fi

echo "✅ Terraform encontrado: $(terraform version -json | jq -r '.terraform_version')"

# Criar arquivo .env se não existir
if [ ! -f .env ]; then
    echo "📝 Criando arquivo .env a partir do exemplo..."
    cp .env.example .env
    echo "✅ Arquivo .env criado. Por favor, edite-o com suas credenciais:"
    echo "   nano .env"
    echo ""
else
    echo "ℹ️  Arquivo .env já existe"
fi

# Criar arquivo terraform.tfvars se não existir
if [ ! -f terraform.tfvars ]; then
    echo "📝 Criando arquivo terraform.tfvars a partir do exemplo..."
    cp terraform.tfvars.example terraform.tfvars
    echo "✅ Arquivo terraform.tfvars criado. Por favor, edite-o com suas credenciais:"
    echo "   nano terraform.tfvars"
    echo ""
else
    echo "ℹ️  Arquivo terraform.tfvars já existe"
fi

echo "📋 Próximos passos:"
echo ""
echo "1. Configure suas credenciais:"
echo "   - Edite o arquivo .env com suas credenciais da Magalu Cloud"
echo "   - OU edite o arquivo terraform.tfvars"
echo ""
echo "2. Configure o backend S3:"
echo "   - Edite o arquivo versions.tf"
echo "   - Altere 'your-terraform-state-bucket' para o nome do seu bucket"
echo ""
echo "3. Configure os GitHub Secrets (para CI/CD):"
echo "   - MGC_API_KEY"
echo "   - MGC_KEY_ID" 
echo "   - MGC_KEY_SECRET"
echo "   - SSH_KEY_VALUE"
echo ""
echo "4. Execute o Terraform:"
echo "   source .env  # ou use terraform.tfvars"
echo "   terraform init"
echo "   terraform plan"
echo "   terraform apply"
echo ""
echo "🔗 Documentação completa no README.md"
echo ""
echo "✨ Setup inicial concluído!"
