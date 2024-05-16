locals {
  now = timestamp()
}

resource "random_string" "random" {
  length  = 6
  special = false
  lower   = true
  upper   = false
}

resource "azurerm_storage_account" "bastion" {
  name                     = "stbastionrecording${random_string.random.result}"
  resource_group_name      = azurerm_resource_group.main.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  blob_properties {
    cors_rule {
      allowed_headers    = [""]
      allowed_methods    = ["GET"]
      allowed_origins    = ["https://${azurerm_bastion_host.bastion.dns_name}"]
      exposed_headers    = [""]
      max_age_in_seconds = 86400
    }
  }
}

resource "azurerm_storage_container" "bastion" {
  name                  = "bastion-redord"
  storage_account_name  = azurerm_storage_account.bastion.name
  container_access_type = "private"
}

data "azurerm_storage_account_blob_container_sas" "bastion" {
  connection_string = azurerm_storage_account.bastion.primary_connection_string
  container_name    = azurerm_storage_container.bastion.name
  https_only        = true

  start  = timeadd(local.now, "-1h")
  expiry = timeadd(local.now, "720h")

  permissions {
    read   = true
    add    = false
    create = true
    write  = true
    delete = false
    list   = true
  }
}

output "bastion_blob_sas_url" {
  value     = "${azurerm_storage_container.bastion.id}${data.azurerm_storage_account_blob_container_sas.bastion.sas}"
  sensitive = true
}
