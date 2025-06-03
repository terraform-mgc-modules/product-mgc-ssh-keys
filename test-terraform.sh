#!/bin/bash

# Script para testar a configuração do Terraform localmente
# Executa terraform init com as configurações necessárias para Magalu Cloud

set -e

echo "🔧 Testando configuração do Terraform para Magalu Cloud"
echo ""

# Verificar se o arquivo .env existe
if [ ! -f .env ]; then
    echo "❌ Arquivo .env não encontrado!"
    echo "   Execute: cp .env.example .env"
    echo "   E configure suas credenciais no arquivo .env"
    exit 1
fi

echo "✅ Arquivo .env encontrado"

# Carregar variáveis de ambiente
echo "📋 Carregando variáveis de ambiente..."
source .env

# Verificar se as variáveis essenciais estão definidas
if [ -z "$AWS_ACCESS_KEY_ID" ] || [ -z "$AWS_SECRET_ACCESS_KEY" ]; then
    echo "❌ Credenciais AWS não configuradas!"
    echo "   Verifique AWS_ACCESS_KEY_ID e AWS_SECRET_ACCESS_KEY no arquivo .env"
    exit 1
fi

if [ -z "$TF_VAR_mgc_api_key" ]; then
    echo "❌ MGC API Key não configurada!"
    echo "   Verifique TF_VAR_mgc_api_key no arquivo .env"
    exit 1
fi

echo "✅ Variáveis de ambiente carregadas"

# Executar terraform init
echo "🚀 Executando terraform init..."
terraform init -upgrade

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Terraform init executado com sucesso!"
    echo ""
    echo "📋 Próximos passos:"
    echo "   terraform plan    # Para ver o que será criado"
    echo "   terraform apply   # Para aplicar as mudanças"
else
    echo ""
    echo "❌ Erro no terraform init"
    echo "   Verifique suas credenciais e a configuração do backend"
fi
