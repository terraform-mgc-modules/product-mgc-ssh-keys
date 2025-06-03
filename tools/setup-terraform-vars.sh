#!/bin/bash
# Script para carregar variáveis do .env e executar Terraform
# Uso: ./setup-terraform-vars.sh [plan|apply|destroy]

set -e  # Parar em caso de erro

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
    "TF_VAR_mgc_api_key"
    "TF_VAR_mgc_key_id" 
    "TF_VAR_mgc_key_secret"
    "TF_VAR_ssh_key_value"
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

echo "🎉 Todas as variáveis estão configuradas!"

# Executar comando terraform
cmd=${1:-plan}
case $cmd in
    "plan")
        echo "📋 Executando terraform plan..."
        terraform plan
        ;;
    "apply")
        echo "🚀 Executando terraform apply..."
        terraform apply
        ;;
    "destroy")
        echo "💥 Executando terraform destroy..."
        terraform destroy
        ;;
    *)
        echo "❌ Comando inválido: $cmd"
        echo "📋 Uso: $0 [plan|apply|destroy]"
        exit 1
        ;;
esac
