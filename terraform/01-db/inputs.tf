data "terraform_remote_state" "network" {
  backend = "s3"

  config = {
    bucket                      = "pewty-tfstate"
    key                         = "env:/${terraform.workspace}/infrastructure/terraform/00-network.tfstate"
    region                      = "fr-par"
    endpoint                    = "https://s3.fr-par.scw.cloud"
    skip_credentials_validation = true
    skip_region_validation      = true
  }
}