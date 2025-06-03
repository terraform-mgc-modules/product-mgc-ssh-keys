#!/bin/bash
# Script de inicialização rápida do projeto
# Uso: ./quick-start.sh

set -e

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Função para imprimir com cores
print_color() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${NC}"
}

# Verificar se estamos no diretório correto
if [ ! -f "../main.tf" ]; then
    print_color $RED "❌ Execute este script a partir da pasta tools/"
    print_color $YELLOW "📋 Uso: cd tools && ./quick-start.sh"
    exit 1
fi

# Voltar para o diretório raiz do projeto
cd ..

print_color $GREEN "🚀 QUICK START - TERRAFORM SSH KEYS"
print_color $GREEN "==================================="
echo ""

# Verificar se .env existe
if [ ! -f .env ]; then
    print_color $YELLOW "📋 Configurando arquivo de ambiente..."
    if [ -f .env.example ]; then
        cp .env.example .env
        print_color $GREEN "✅ Arquivo .env criado a partir do .env.example"
        print_color $YELLOW "⚠️  IMPORTANTE: Edite o arquivo .env com suas credenciais reais!"
        echo ""
        print_color $BLUE "Variáveis que você precisa configurar:"
        echo "• R2_ACCESS_KEY"
        echo "• R2_ACCESS_SECRET" 
        echo "• MGC_API_KEY"
        echo "• MGC_KEY_ID"
        echo "• MGC_KEY_SECRET"
        echo "• SSH_KEY_VALUE"
        echo "• CLOUDFLARE_API_TOKEN"
        echo ""
        read -p "Pressione Enter após configurar o arquivo .env..."
    else
        print_color $RED "❌ Arquivo .env.example não encontrado!"
        print_color $YELLOW "ℹ️  Crie manualmente o arquivo .env seguindo o modelo disponível na documentação do projeto ou baixe o .env.example do repositório."
        exit 1
    fi
else
    print_color $GREEN "✅ Arquivo .env já existe"
fi

# Verificar se terraform está inicializado
if [ ! -d .terraform ]; then
    print_color $YELLOW "🔧 Inicializando Terraform..."
    set -a
    source .env
    set +a
    terraform init
    print_color $GREEN "✅ Terraform inicializado com sucesso!"
else
    print_color $GREEN "✅ Terraform já está inicializado"
fi

echo ""
print_color $GREEN "🎉 Projeto configurado com sucesso!"
echo ""
print_color $YELLOW "📚 Próximos passos:"
echo "1. Execute: cd tools && ./terraform-menu.sh (Menu interativo)"
echo "2. Ou execute: cd tools && ./terraform-plan.sh (Apenas plan)"
echo ""
print_color $BLUE "📖 Documentação disponível:"
echo "• README principal: README.md"
echo "• Scripts: tools/README.md" 
echo "• Configuração R2: docs/R2-READY-CHECK.md"
echo ""

# Oferecer para executar o menu
read -p "Deseja abrir o menu interativo agora? (y/N): " confirm
if [[ $confirm =~ ^[Yy]$ ]]; then
    ./tools/terraform-menu.sh
fi
