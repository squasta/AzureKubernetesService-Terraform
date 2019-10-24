###################################################################################
# Option 1 de remote Backend : utiliser Terraform Cloud Remote State Management
# https://www.hashicorp.com/blog/introducing-terraform-cloud-remote-state-management
# créer son compte ici : https://app.terraform.io/session
####################################################################################
# Using a single workspace in Terraform Cloud Remote State / Terraform Enterprise
# terraform {
#   backend "remote" {
#     hostname = "app.terraform.io"
#     organization = "Insert here your organization name"
#     token = "Insert here your Token"
#     workspaces {
#       name = "deploiementVM-AKS"
#     }
#   }
# }


###################################################################################
# Option 2 de remote Backend : utiliser un Compte de stockage Azure
# ref : https://www.terraform.io/docs/backends/types/azurerm.html
####################################################################################
# créer au préalable un compte de stockage avec un container dans la région de déploiement
# activer l'option Secure transfer required pour forcer l'usage de TLS
# créer un container privé nommé terraform-state
# data "terraform_remote_state" "Terra-Backend-Stan1" {
#    backend = "azure"
#    config {
#        storage_account_name = "mettre ici le nom du compte de stockage"
#        container_name = "terraform-state"
#        key = "prod.terraform.tfstate"
#    }
# }