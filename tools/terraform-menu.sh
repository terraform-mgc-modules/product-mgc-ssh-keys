#!/bin/bash
# Script menu interativo para gerenciar o projeto Terraform
# Uso: ./terraform-menu.sh

set -euo pipefail

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Prints a message to the terminal in the specified color.
#
# Arguments:
#
# * color: ANSI color code to use for the message.
# * message: The text to display.
#
# Outputs:
#
# * The message printed to STDOUT in the chosen color, followed by a reset to default color.
#
# Example:
#
# ```bash
# print_color "$GREEN" "Operation successful."
# ```
print_color() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${NC}"
}

# Verificar se estamos no diretório correto
if [ ! -f "../main.tf" ]; then
    print_color $RED "❌ Execute este script a partir da pasta tools/"
    print_color $YELLOW "📋 Uso: cd tools && ./terraform-menu.sh"
    exit 1
fi

# Voltar para o diretório raiz do projeto
cd ..

# Verificar se o arquivo .env existe
if [ ! -f .env ]; then
    print_color $RED "❌ Arquivo .env não encontrado!"
    print_color $YELLOW "📋 Copie o .env.example para .env e configure as variáveis"
    exit 1
fi

# Loads environment variables from the .env file into the current shell session.
#
# This function exports all variables defined in the .env file, making them available to subsequent commands in the script.
#
# Globals:
#
# * .env file in the current directory must exist and be readable.
#
# Example:
#
# ```bash
# load_env
# echo "$MY_ENV_VAR" # Variable from .env is now available
# ```
load_env() {
    print_color $BLUE "🔧 Carregando variáveis do arquivo .env..."
    set -a
    source .env
    set +a
}

# Displays the main interactive menu for Terraform project management.
#
# Outputs:
#
# * Prints a colored menu with options for running Terraform commands, testing connectivity, viewing documentation, or exiting.
#
# Example:
#
# ```bash
# show_menu
# # (Displays the interactive menu in the terminal)
# ```
show_menu() {
    clear
    print_color $GREEN "🚀 TERRAFORM SSH KEYS - MAGALU CLOUD"
    print_color $GREEN "===================================="
    echo ""
    print_color $YELLOW "Escolha uma opção:"
    echo "1) 📋 Terraform Plan (visualizar mudanças)"
    echo "2) 🚀 Terraform Apply (aplicar mudanças)"
    echo "3) 💥 Terraform Destroy (destruir recursos)"
    echo "4) 🔍 Terraform Show (mostrar estado atual)"
    echo "5) 📊 Terraform Output (mostrar outputs)"
    echo "6) 🧪 Testar conectividade R2"
    echo "7) 📚 Mostrar documentação"
    echo "0) 🚪 Sair"
    echo ""
}

# ```
run_terraform() {
    local cmd=$1
    load_env
    print_color $BLUE "▶️  Executando: terraform $cmd"
    terraform $cmd
}

# Loop principal
while true; do
    show_menu
    read -p "Digite sua escolha [0-7]: " choice
    
    case $choice in
        1)
            print_color $YELLOW "📋 Executando Terraform Plan..."
            run_terraform "plan"
            ;;
        2)
            print_color $YELLOW "🚀 Executando Terraform Apply..."
            echo ""
            print_color $RED "⚠️  ATENÇÃO: Isso criará recursos reais na Magalu Cloud!"
            read -p "Tem certeza? (y/N): " confirm
            if [[ $confirm =~ ^[Yy]$ ]]; then
                run_terraform "apply"
            else
                print_color $YELLOW "❌ Operação cancelada."
            fi
            ;;
        3)
            print_color $YELLOW "💥 Executando Terraform Destroy..."
            echo ""
            print_color $RED "⚠️  ATENÇÃO: Isso DESTRUIRÁ todos os recursos criados!"
            read -p "Tem certeza? (y/N): " confirm
            if [[ $confirm =~ ^[Yy]$ ]]; then
                run_terraform "destroy"
            else
                print_color $YELLOW "❌ Operação cancelada."
            fi
            ;;
        4)
            print_color $YELLOW "🔍 Mostrando estado atual..."
            load_env
            terraform show
            ;;
        5)
            print_color $YELLOW "📊 Mostrando outputs..."
            load_env
            terraform output
            ;;
        6)
            print_color $YELLOW "🧪 Testando conectividade R2..."
            load_env
            ./tools/test-r2-backend.sh
            ;;
        7)
            print_color $YELLOW "📚 Documentação disponível:"
            echo "• README principal: README.md"
            echo "• Scripts: tools/README.md"
            echo "• Configuração R2: docs/R2-READY-CHECK.md"
            echo "• Documentação: docs/README.md"
            ;;
        0)
            print_color $GREEN "👋 Até logo!"
            exit 0
            ;;
        *)
            print_color $RED "❌ Opção inválida. Tente novamente."
            ;;
    esac
    
    echo ""
    read -p "Pressione Enter para continuar..."
done
