module "mgc_ssh_keys" {
  source         = "github.com/terraform-mgc-modules/mgc-ssh-keys?ref=v2.0.0"
  ssh_key_value  = var.ssh_key_value
  mgc_api_key    = var.mgc_api_key
  mgc_key_id     = var.mgc_key_id
  mgc_key_secret = var.mgc_key_secret
  ssh_key_name   = var.ssh_key_name

}
