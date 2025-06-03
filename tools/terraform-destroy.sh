#!/bin/bash
# Script para executar terraform destroy com variáveis configuradas
# Uso: ./terraform-destroy.sh

set -e  # Parar em caso de erro

# Verificar se estamos no diretório correto
if [ ! -f "../main.tf" ]; then
    echo "❌ Execute este script a partir da pasta tools/"
    echo "📋 Uso: cd tools && ./terraform-destroy.sh"
    exit 1
fi

# Voltar para o diretório raiz do projeto
cd ..

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

echo "💥 Executando terraform destroy..."
echo "⚠️  ATENÇÃO: Isso irá destruir todos os recursos criados!"
terraform destroy
