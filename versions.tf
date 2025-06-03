terraform {
  backend "s3" {
    bucket = "granato-hcl"
    key    = "ssh-keys/terraform.tfstate"
    region = "br-se1"

    endpoints = {
      s3 = "https://s3.br-se1.magaluobjects.com"
    }

    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    force_path_style            = true
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
  }
}

provider "mgc" {
  api_key = var.mgc_api_key
}
