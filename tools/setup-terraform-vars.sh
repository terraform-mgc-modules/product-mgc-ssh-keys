#!/bin/bash
# Script para carregar variáveis do .env e executar Terraform
# Uso: ./setup-terraform-vars.sh [plan|apply|destroy]

set -e  # Parar em caso de erro

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$script_dir/.."

# Verificar se o arquivo .env existe
if [ ! -f .env ]; then
    echo "❌ Arquivo .env não encontrado!"
    echo "📋 Copie o .env.example para .env e configure as variáveis"
    exit 1
fi

# Carregar variáveis do .env
echo "🔧 Carregando variáveis do arquivo .env..."
set -a  # Exportar automaticamente todas as variáveis
source .env
set +a

# Verificar se todas as variáveis necessárias estão definidas
echo "🔍 Verificando variáveis..."
required_vars=(
    "MGC_API_KEY"
    "MGC_KEY_ID"
    "MGC_KEY_SECRET"
    "SSH_KEY_VALUE"
    "AWS_ACCESS_KEY_ID"
    "AWS_SECRET_ACCESS_KEY"
)

for var in "${required_vars[@]}"; do
    if [ -z "${!var}" ]; then
        echo "❌ Variável $var não está definida!"
        exit 1
    fi
    echo "✅ $var está configurada"
done

# Exportar variáveis para o Terraform
export TF_VAR_mgc_api_key="$MGC_API_KEY"
export TF_VAR_mgc_key_id="$MGC_KEY_ID"
export TF_VAR_mgc_key_secret="$MGC_KEY_SECRET"
export TF_VAR_ssh_key_value="$SSH_KEY_VALUE"

echo "🎉 Todas as variáveis estão configuradas!"

# Verificar se o Terraform está instalado
if ! command -v terraform >/dev/null 2>&1; then
    echo "❌ Terraform não encontrado! Instale o Terraform e adicione ao PATH."
    exit 1
fi

# Executar comando terraform
cmd=${1:-plan}
case $cmd in
    "plan")
        echo "📋 Executando terraform plan..."
        terraform plan
        ;;
    "apply")
        echo "🚀 Executando terraform apply..."
        terraform apply -auto-approve
        ;;
    "destroy")
        echo "💥 Executando terraform destroy..."
        terraform destroy -auto-approve
        ;;
    *)
        echo "❌ Comando inválido: $cmd"
        echo "📋 Uso: $0 [plan|apply|destroy]"
        exit 1
        ;;
esac
