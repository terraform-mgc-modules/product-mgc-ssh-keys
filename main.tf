module "magalu_kubernetes_cluster" {
  source = "github.com/terraform-mgc-modules/mgc-ssh-keys?ref=v2.0.0"
  name   = var.ssh_key_name
  key    = var.ssh_key_value

}
