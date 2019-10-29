data "azurerm_key_vault" "terraform_vault" {
  name                = var.keyvault_name
  resource_group_name = var.keyvault_rg
}

data "azurerm_key_vault_secret" "ssh_public_key" {
  name         = "ClePubliqueSSH"    # must looks like "ssh-rsa AAAABxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx email@domaine.name"
  key_vault_id = data.azurerm_key_vault.terraform_vault.id
}

data "azurerm_key_vault_secret" "spn_id" {
  name         = "spn-id"
  key_vault_id = data.azurerm_key_vault.terraform_vault.id
}
data "azurerm_key_vault_secret" "spn_secret" {
  name         = "spn-secret"
  key_vault_id = data.azurerm_key_vault.terraform_vault.id
}

data "azurerm_key_vault_secret" "windows_admin_password" {
  name         = "windows-admin-password"
  key_vault_id = data.azurerm_key_vault.terraform_vault.id
}
