terraform {
  backend "azurerm" {
    resource_group_name  = "terraform"
    storage_account_name = "terraformtozeaufchdnfx4f"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}

provider "azurerm" {
  // Uses the Azure CLI token (or env vars) unless managed identity is used
  features {}
  alias   = "backend"
  use_msi = false
}

variable "backend_key_vault_id" {
  description = "Name of the key vault containing the tenant-id, client-id and client-secret."
  type        = string
  default     = "/subscriptions/2d31be49-d959-4415-bb65-8aec2c90ba62/resourceGroups/terraform/providers/Microsoft.KeyVault/vaults/terraformtozeaufchdnfx4f"
  // `az keyvault list --resource-group terraform -state --query "[0].id" --output tsv`
}

data "azurerm_key_vault_secret" "backend_tenant_id" {
  provider     = azurerm.backend
  key_vault_id = var.backend_key_vault_id
  name         = "tenant-id"
}

data "azurerm_key_vault_secret" "backend_client_id" {
  provider     = azurerm.backend
  key_vault_id = var.backend_key_vault_id
  name         = "app-id"
}

data "azurerm_key_vault_secret" "backend_client_secret" {
  provider     = azurerm.backend
  key_vault_id = var.backend_key_vault_id
  name         = "client-secret"
}
