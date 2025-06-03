#!/bin/zsh

# Script para verificar e configurar o bucket Cloudflare R2 para Terraform

set -e

echo "🪣 Verificador de Bucket Cloudflare R2 - Terraform Backend"
echo ""

# Verificar se as credenciais estão configuradas
if [ -z "$AWS_ACCESS_KEY_ID" ] || [ -z "$AWS_SECRET_ACCESS_KEY" ]; then
    echo "❌ Credenciais R2 não configuradas!"
    echo ""
    echo "Configure as variáveis de ambiente:"
    echo "export AWS_ACCESS_KEY_ID='seu-r2-access-key-id'"
    echo "export AWS_SECRET_ACCESS_KEY='seu-r2-secret-access-key'"
    echo ""
    echo "Ou carregue o arquivo .env:"
    echo "source .env"
    exit 1
fi

# Verificar se aws-cli está instalado
if ! command -v aws &> /dev/null; then
    echo "❌ AWS CLI não encontrado!"
    echo ""
    echo "Instale o AWS CLI:"
    echo "# Ubuntu/Debian:"
    echo "sudo apt update && sudo apt install awscli"
    echo ""
    echo "# macOS:"
    echo "brew install awscli"
    echo ""
    echo "# Ou via pip:"
    echo "pip install awscli"
    exit 1
fi

echo "✅ AWS CLI encontrado: $(aws --version)"

# Configurar endpoint do Cloudflare R2
BUCKET_NAME="nataliagranato"
ENDPOINT="https://4839c9636a58fa9490bbe3d2e686ad98.r2.cloudflarestorage.com"
REGION="auto"

echo ""
echo "🔧 Configurações:"
echo "   Bucket: $BUCKET_NAME"
echo "   Endpoint: $ENDPOINT"
echo "   Região: $REGION"
echo ""

# Verificar se o bucket já existe
echo "🔍 Verificando se o bucket '$BUCKET_NAME' existe..."

aws s3api head-bucket \
    --bucket "$BUCKET_NAME" \
    --endpoint-url "$ENDPOINT" 2>/dev/null

if [ $? -eq 0 ]; then
    echo "✅ Bucket '$BUCKET_NAME' existe e está acessível!"
    echo ""
    echo "📝 Configuração do backend no versions.tf está correta:"
    echo "   bucket = \"$BUCKET_NAME\""
    echo "   endpoint = \"$ENDPOINT\""
    echo ""
    echo "🚀 Você pode executar:"
    echo "   terraform init -upgrade"
    echo "   terraform plan"
else
    echo "❌ Bucket '$BUCKET_NAME' não existe, não está acessível, ou há erro nas credenciais."
    echo ""
    echo "📋 Para resolver:"
    echo "1. Verifique se o bucket existe no painel do Cloudflare R2"
    echo "2. Verifique se as credenciais R2 estão corretas"
    echo "3. Verifique se as credenciais têm permissão para acessar o bucket"
    echo ""
    echo "💡 Para criar o bucket via API da Cloudflare:"
    echo "   curl -X POST \"https://api.cloudflare.com/client/v4/accounts/YOUR_ACCOUNT_ID/r2/buckets\" \\"
    echo "        -H \"Authorization: Bearer YOUR_API_TOKEN\" \\"
    echo "        -H \"Content-Type: application/json\" \\"
    echo "        -d '{\"name\": \"$BUCKET_NAME\"}'"
    exit 1
fi

echo "🎯 Próximos passos:"
echo "1. Execute: terraform init -upgrade"
echo "2. Execute: terraform plan"
echo "3. Execute: terraform apply"
echo ""
echo "✨ Backend Cloudflare R2 configurado corretamente!"
