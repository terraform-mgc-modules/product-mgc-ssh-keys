terraform {
  backend "s3" {
    bucket                      = "nataliagranato"
    key                         = "mgc-ssh-keys/terraform.tfstate"
    region                      = "auto"
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true
    use_path_style              = true

    endpoints = {
      s3 = "https://4839c9636a58fa9490bbe3d2e686ad98.r2.cloudflarestorage.com"
    }

    # As credenciais serão fornecidas via variáveis de ambiente:
    # AWS_ACCESS_KEY_ID e AWS_SECRET_ACCESS_KEY
  }

  required_providers {
    mgc = {
      source  = "magalucloud/mgc"
      version = "0.33.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.5.2"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4"
    }
  }
}

provider "mgc" {
  api_key = var.mgc_api_key
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}
