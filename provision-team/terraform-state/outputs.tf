output "resources_prefix" {
  value = local.resources_prefix
}
output "location" {
  value = azurerm_resource_group.resource_group.location
}
output "resource_group_name" {
  value = azurerm_resource_group.resource_group.name
}
output "storage_account_name" {
  value = azurerm_storage_account.storage_account.name
}
output "storage_account_access_key" {
  value     = azurerm_storage_account.storage_account.primary_access_key
  sensitive = true
}
output "storage_container_name" {
  value = azurerm_storage_container.storage_container.name
}