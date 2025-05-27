terraform {
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
