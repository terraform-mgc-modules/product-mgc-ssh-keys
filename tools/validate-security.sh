#!/bin/bash
# Script para validar workflows e configurações de segurança
# Uso: ./validate-security.sh

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
    print_color $YELLOW "📋 Uso: cd tools && ./validate-security.sh"
    exit 1
fi

cd ..

print_color $GREEN "🛡️  VALIDAÇÃO DE SEGURANÇA E WORKFLOWS"
print_color $GREEN "====================================="
echo ""

# 1. Verificar se workflows existem
print_color $BLUE "📋 Verificando workflows..."
workflows=(
    ".github/workflows/terraform.yml"
    ".github/workflows/terrascan.yml"
    ".github/workflows/trivy.yml"
    ".github/workflows/dependency-review.yml"
)

for workflow in "${workflows[@]}"; do
    if [ -f "$workflow" ]; then
        print_color $GREEN "✅ $workflow"
    else
        print_color $RED "❌ $workflow não encontrado"
    fi
done

echo ""

# 2. Verificar formato dos workflows
print_color $BLUE "🔍 Validando sintaxe YAML dos workflows..."
for workflow in "${workflows[@]}"; do
    if [ -f "$workflow" ]; then
        if command -v yamllint >/dev/null 2>&1; then
            if yamllint "$workflow" >/dev/null 2>&1; then
                print_color $GREEN "✅ $workflow - sintaxe válida"
            else
                print_color $YELLOW "⚠️  $workflow - avisos de sintaxe"
                yamllint "$workflow" || true
            fi
        else
            print_color $YELLOW "⚠️  yamllint não instalado - pulando validação YAML"
            break
        fi
    fi
done

echo ""

# 3. Verificar se Terraform está válido
print_color $BLUE "🔧 Validando configuração Terraform..."
if command -v terraform >/dev/null 2>&1; then
    # Carregar variáveis se existir .env
    if [ -f .env ]; then
        print_color $BLUE "🔧 Carregando variáveis do .env..."
        set -a
        source .env
        set +a
    fi
    
    if terraform fmt -check=true -diff=true >/dev/null 2>&1; then
        print_color $GREEN "✅ Terraform format OK"
    else
        print_color $YELLOW "⚠️  Terraform format - arquivos precisam de formatação"
        terraform fmt -check=true -diff=true || true
    fi
    
    if terraform validate >/dev/null 2>&1; then
        print_color $GREEN "✅ Terraform validate OK"
    else
        print_color $RED "❌ Terraform validate falhou"
        terraform validate || true
    fi
else
    print_color $YELLOW "⚠️  Terraform não instalado - pulando validação"
fi

echo ""

# 4. Verificar se dependências de segurança estão disponíveis
print_color $BLUE "🔍 Verificando ferramentas de segurança..."
security_tools=(
    "trivy:https://github.com/aquasecurity/trivy"
    "terrascan:https://github.com/tenable/terrascan"
    "yamllint:pip install yamllint"
)

for tool_info in "${security_tools[@]}"; do
    tool=$(echo "$tool_info" | cut -d: -f1)
    install_info=$(echo "$tool_info" | cut -d: -f2-)
    
    if command -v "$tool" >/dev/null 2>&1; then
        print_color $GREEN "✅ $tool instalado"
    else
        print_color $YELLOW "⚠️  $tool não instalado - $install_info"
    fi
done

echo ""

# 5. Verificar permissões dos workflows
print_color $BLUE "🔒 Verificando permissões de segurança dos workflows..."
for workflow in "${workflows[@]}"; do
    if [ -f "$workflow" ]; then
        if grep -q "permissions:" "$workflow"; then
            print_color $GREEN "✅ $workflow - permissões definidas"
        else
            print_color $YELLOW "⚠️  $workflow - permissões não definidas"
        fi
    fi
done

echo ""

# 6. Verificar se há secrets hardcoded
print_color $BLUE "🔍 Verificando se há secrets hardcoded..."
secret_patterns=(
    "password"
    "secret"
    "token"
    "key.*="
    "api.*key"
)

found_secrets=false
for pattern in "${secret_patterns[@]}"; do
    if grep -r -i --exclude-dir=.git --exclude="*.md" --exclude="validate-security.sh" "$pattern" . >/dev/null 2>&1; then
        if ! $found_secrets; then
            print_color $YELLOW "⚠️  Possíveis secrets encontrados:"
            found_secrets=true
        fi
        grep -r -i --exclude-dir=.git --exclude="*.md" --exclude="validate-security.sh" "$pattern" . | head -5
    fi
done

if ! $found_secrets; then
    print_color $GREEN "✅ Nenhum secret hardcoded encontrado"
fi

echo ""

# 7. Verificar .gitignore
print_color $BLUE "📋 Verificando .gitignore..."
gitignore_patterns=(
    "*.tfstate"
    "*.tfvars"
    ".env"
    ".terraform"
)

for pattern in "${gitignore_patterns[@]}"; do
    if grep -q "$pattern" .gitignore >/dev/null 2>&1; then
        print_color $GREEN "✅ .gitignore inclui $pattern"
    else
        print_color $YELLOW "⚠️  .gitignore não inclui $pattern"
    fi
done

echo ""
print_color $GREEN "🎉 Validação de segurança concluída!"
print_color $BLUE "📖 Para mais informações sobre workflows: .github/workflows/README.md"
