provider "azurerm" {
  version = "~> 2.11.0"
  features {}

  subscription_id = "2d31be49-d959-4415-bb65-8aec2c90ba62"

  tenant_id     = data.azurerm_key_vault_secret.backend_tenant_id.value
  client_id     = data.azurerm_key_vault_secret.backend_client_id.value
  client_secret = data.azurerm_key_vault_secret.backend_client_secret.value
}

provider "null" {
  version = "~> 2.1"
}

provider "random" {
  version = "~> 2.2"
}
